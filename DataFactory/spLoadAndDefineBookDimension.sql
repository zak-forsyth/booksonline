BEGIN TRY
    --if procedure does not exist, create a simple version that the ALTER will replace.  if it does exist, the BEGIN CATCH will eliminate any error message or batch stoppage
    EXEC('CREATE PROC [labsdim].[LoadAndDefineBookDimension] @dStart [datetime],@dEnd [datetime] AS BEGIN Select 1 As Col1 END')
END TRY BEGIN CATCH END CATCH
GO

ALTER PROC [labsdim].[LoadAndDefineBookDimension] @dStart [datetime], @dEnd [datetime] AS
BEGIN

DECLARE @StartOfCore [datetime]
DECLARE @StartOfDim [datetime]
DECLARE @EndOfCore [datetime]
DECLARE @EndOfDim [datetime]

/* 1. Start By Creating New Keys 
	- Only define new keys, one technical key per Business Keys. Used in order to mitigate business key reuse or same as
	- Also used to enable composite business keys as single key
*/ 
--Start Process Timing
SET @StartOfCore = @dStart

--Start Key Generation
INSERT INTO [labscore].[BookKey] (BookId, Src, InsertDttm)
SELECT bb1.[BookId], 'BB.Books', @dStart
FROM
(
select distinct [Id] as [BookId]
from [labshist].[BooksBooks] WHERE @dStart BETWEEN DwhValidFrom AND DwhValidTo
) bb1
LEFT OUTER JOIN [labscore].[BookKey] bk1 ON bk1.[BookId] = bb1.[BookId]
where bk1.[BookId] IS NULL
GROUP BY bb1.[BookId]

--End Process Timing
SET @EndOfCore = @dStart


/* 2. Define Dimension 
	--Full Recreate of Dimension every Load. Uses USerKey for consistency.
	--Using historyhandling techniques per default as last known value
	--Specific columns has ORIGINAL values.
	--Some columns has previous value handling as well
*/


--Start Process Timing
SET @StartOfDim = @dStart


--2a. Drop backup table
IF object_id('labsdim.x_Book_Dim_Bkp') is not null
	DROP TABLE [labsdim].[x_Book_Dim_Bkp]


--2b Load new data into temporary table- THIS STEP INCLUDES ALL LOGIC
IF object_id('labsdim.x_Book_Dim_Load') is not null
	DROP TABLE [labsdim].[x_Book_Dim_Load]


CREATE TABLE [labsdim].[x_Book_Dim_Load]
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
as
with cte_source as
(
SELECT
       bk1.[BookKey]
	  ,bb1.[Id] as [BookId]
	  ,bb1.[Title] as [TitleInService]
	  ,bb1.[Grade] as [AverageGrade]
	  ,@dStart AS LastUpdateDttm
	  ,bb1.DwhValidFrom as BooksBooks_DwhValidFrom
	  ,bb1.DwhValidTo as BooksBooks_DwhValidTo

--select count(*)
FROM [labshist].[BooksBooks] bb1

      INNER JOIN [labscore].[BookKey] bk1 ON bk1.[BookId] = bb1.[Id]
)

-- Rows that have changed from existing dim.Book.
select tgt.[BookKey]
      ,COALESCE(src.[BookId], tgt.[BookId]) AS [BookId]
	  ,COALESCE(src.[TitleInService], tgt.[TitleInService]) AS [TitleInService]
	  ,COALESCE(src.[AverageGrade], tgt.[AverageGrade]) AS [AverageGrade]
	  ,CASE WHEN src.[BookId] IS NOT NULL THEN @dStart ELSE tgt.[LastUpdateDttm] END AS [LastUpdateDttm] 	--Last touched date
FROM [labsdim].[Book] tgt
LEFT OUTER JOIN cte_source src ON src.[BookId] = tgt.[BookId]
AND @dStart BETWEEN src.BooksBooks_DwhValidFrom AND src.BooksBooks_DwhValidTo

UNION ALL

-- New rows.
SELECT src.[BookKey]
      ,src.[BookId]
	  ,src.[TitleInService]
	  ,src.[AverageGrade]
      ,src.[LastUpdateDttm]
from cte_source src
where @dStart BETWEEN src.BooksBooks_DwhValidFrom AND src.BooksBooks_DwhValidTo
	AND src.BookKey NOT IN --Check So That Only NEW RECORDS Go Through This Pass!
	(
		SELECT BookKey FROM [labsdim].[Book]
	)
	

--2c. Rename Actual Dimension into Backup Table
RENAME OBJECT [labsdim].[Book] TO [x_Book_Dim_Bkp]
--2d. Activate New Dimension as Current Dimension
RENAME OBJECT [labsdim].[x_Book_Dim_Load] TO [Book]


--End process timing
SET @EndOfDim = @dStart

END
GO

GRANT EXECUTE ON [labsdim].[LoadAndDefineBookDimension] TO dwloaduser
GO