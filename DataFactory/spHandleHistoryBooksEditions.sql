BEGIN TRY
    --if procedure does not exist, create a simple version that the ALTER will replace.  if it does exist, the BEGIN CATCH will eliminate any error message or batch stoppage
    EXEC('CREATE PROC [labshist].[HandleHistoryBooksEditions] @SliceStart [datetime],@SliceEnd [datetime] AS BEGIN Select 1 As Col1 END')
END TRY BEGIN CATCH END CATCH
GO

ALTER PROC [labshist].[HandleHistoryBooksEditions] @SliceStart [datetime],@SliceEnd [datetime] AS
BEGIN

DECLARE @StartOfHist [datetime] 
DECLARE @EndOfHist [datetime] 

SET @StartOfHist = GetDate()


/* Load History */
--Drop old backup
IF object_id('labshist.z_BooksEditions_Bkp') is not null
	DROP TABLE [labshist].[z_BooksEditions_Bkp]

IF object_id('labshist.z_CurrentLoadBooksEditions') is not null
	DROP TABLE [labshist].[z_CurrentLoadBooksEditions]

--Delete posts from this date-slice (re-run slices)
DELETE FROM [labshist].[BooksEditions] WHERE DwhValidFrom = @SliceStart
-- Set DwhValidTo to future for this date-slice (re-run slices)
UPDATE [labshist].[BooksEditions] SET DwhValidTo = '9999-12-31 23:59:59' WHERE DwhValidTo = DATEADD(second, -1, @SliceStart)

--Create intimidiate storage of existing data
CREATE TABLE [labshist].[z_CurrentLoadBooksEditions]
WITH
(
	DISTRIBUTION = HASH ( [Id] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS 
SELECT *
FROM [labshist].[BooksEditions]

--Find Changes And New data from stage inkl deletes
INSERT INTO [labshist].[z_CurrentLoadBooksEditions]
--CHANGED AND NEW RECORDS
SELECT s.[Id]
      ,s.[Title]
	  ,s.[Isbn]
	  ,s.[Cover]
	  ,s.[Publisher]
	  ,s.[PublishDate]
	  ,s.[Language]
	  ,s.[CreatedAt]
	  ,s.[ModifiedAt]
	  ,s.[DeletedAt]
	  ,s.[Book_Id]
	  ,s.[ContentType]
	  ,s.[Pages]
	  ,s.[Duration]
	  ,s.[BookBeatPublishDate]
	  ,s.[BookBeatViewDate]
	  ,s.[BookBeatUnpublishDate]
	  ,s.[SerializedApprovals]
	  ,s.[SerializedMarketRights]
	  ,s.[SerializedCopyrightOwners]
	  ,@SliceStart AS DwhValidFrom
	  ,'9999-12-31 23:59:59' As DwhValidTo
	  ,1 As DwhLastUpdateInd
FROM [labsstg].[BooksEditions] s
LEFT OUTER JOIN [labshist].[BooksEditions] h
ON s.[Id] = h.[Id] AND @SliceStart BETWEEN h.DwhValidFrom AND h.DwhValidTo
--Check If Data Has Changed
WHERE (
    COALESCE(s.[Title],'') <> COALESCE(h.[Title],'') 
	OR COALESCE(s.[Isbn],'') <> COALESCE(h.[Isbn],'') 
	OR COALESCE(s.[Cover],'') <> COALESCE(h.[Cover],'') 
	OR COALESCE(s.[Publisher],'') <> COALESCE(h.[Publisher],'') 
	OR cast(COALESCE(s.[PublishDate],'1900-01-01') as datetime) <> cast(COALESCE(h.[PublishDate],'1900-01-01')  as datetime)
	OR COALESCE(s.[Language],-1) <> COALESCE(h.[Language],-1) 
	--OR COALESCE(s.[CreatedAt],'1900-01-01') <> COALESCE(h.[CreatedAt],'1900-01-01') 
	--OR COALESCE(s.[ModifiedAt],'1900-01-01') <> COALESCE(h.[ModifiedAt],'1900-01-01') 
	--OR COALESCE(s.[DeletedAt],'1900-01-01') <> COALESCE(h.[DeletedAt],'1900-01-01') 
	OR COALESCE(s.[Book_Id],-1) <> COALESCE(h.[Book_Id],-1) 
	OR COALESCE(s.[ContentType],-1) <> COALESCE(h.[ContentType],-1) 
	OR COALESCE(s.[Pages],-1) <> COALESCE(h.[Pages],-1) 
	OR COALESCE(s.[Duration],-1) <> COALESCE(h.[Duration],-1) 
	OR cast(COALESCE(s.[BookBeatPublishDate],'1900-01-01') as datetime) <> cast(COALESCE(h.[BookBeatPublishDate],'1900-01-01') as datetime) 
	OR cast(COALESCE(s.[BookBeatViewDate],'1900-01-01') as datetime) <> cast(COALESCE(h.[BookBeatViewDate],'1900-01-01') as datetime) 
	OR cast(COALESCE(s.[BookBeatUnpublishDate],'1900-01-01') as datetime) <> cast(COALESCE(h.[BookBeatUnpublishDate],'1900-01-01') as datetime)
	OR COALESCE(s.[SerializedApprovals],'') <> COALESCE(h.[SerializedApprovals],'') 
	OR COALESCE(s.[SerializedMarketRights],'') <> COALESCE(h.[SerializedMarketRights],'') 
	OR COALESCE(s.[SerializedCopyrightOwners],'') <> COALESCE(h.[SerializedCopyrightOwners],'') 
)


--DELETED RECORDS (NOTE can only be preformed on full loads)
UPDATE [labshist].[z_CurrentLoadBooksEditions]
SET DwhValidTo = DATEADD(second, -1, @SliceStart) 
WHERE [Id] IN (
	SELECT [h].[Id]
	FROM [labshist].[BooksEditions] h
	WHERE @SliceStart BETWEEN h.DwhValidFrom AND h.DwhValidTo
	AND h.[Id] NOT IN 
	(
		SELECT [Id] FROM [labsstg].[BooksEditions]
	)
	AND ((SELECT COUNT(*) AS nRows FROM [labsstg].[BooksEditions]) > (SELECT count(*)*0.8 AS n80percentRows FROM [labshist].[BooksEditions] h2 WHERE @SliceStart BETWEEN h2.DwhValidFrom AND h2.DwhValidTo))
)


IF object_id('labshist.z_NewHistoryBooksEditions') is not null
	DROP TABLE [labshist].[z_NewHistoryBooksEditions]

--Create New Historic Table
CREATE TABLE [labshist].[z_NewHistoryBooksEditions]
WITH
(
	DISTRIBUTION = HASH ( [Id] ),
	CLUSTERED COLUMNSTORE INDEX
)
AS 
SELECT t.[Id]
      ,t.[Title]
	  ,t.[Isbn]
	  ,t.[Cover]
	  ,t.[Publisher]
	  ,t.[PublishDate]
	  ,t.[Language]
	  ,t.[CreatedAt]
	  ,t.[ModifiedAt]
	  ,t.[DeletedAt]
	  ,t.[Book_Id]
	  ,t.[ContentType]
	  ,t.[Pages]
	  ,t.[Duration]
	  ,t.[BookBeatPublishDate]
	  ,t.[BookBeatViewDate]
	  ,t.[BookBeatUnpublishDate]
	  ,t.[SerializedApprovals]
	  ,t.[SerializedMarketRights]
	  ,t.[SerializedCopyrightOwners]
	  ,t.[DwhValidFrom]
	  ,CASE WHEN t.[LastRowInd] = 0 THEN t.[DwhLastValidFrom] ELSE t.[DwhValidTo] END AS [DwhValidTo]
	  ,t.[LastRowInd] As [DwhLastUpdateInd]
FROM
(
	SELECT t1.[Id]
		  ,t1.[Title]
		  ,t1.[Isbn]
		  ,t1.[Cover]
		  ,t1.[Publisher]
		  ,t1.[PublishDate]
		  ,t1.[Language]
		  ,t1.[CreatedAt]
		  ,t1.[ModifiedAt]
		  ,t1.[DeletedAt]
		  ,t1.[Book_Id]
		  ,t1.[ContentType]
		  ,t1.[Pages]
		  ,t1.[Duration]
		  ,t1.[BookBeatPublishDate]
		  ,t1.[BookBeatViewDate]
		  ,t1.[BookBeatUnpublishDate]
		  ,t1.[SerializedApprovals]
		  ,t1.[SerializedMarketRights]
		  ,t1.[SerializedCopyrightOwners]
		  ,t1.[DwhValidFrom]	
		  ,t1.[DwhValidTo]
		  ,t1.[DwhLastUpdateInd]
		  ,CASE WHEN ( ROW_NUMBER() OVER(PARTITION BY t1.[Id] ORDER BY t1.[DwhValidFrom] DESC) = 1 ) THEN 1 ELSE 0 END AS LastRowInd
		,MAX( DATEADD(second, -1, t1.[DwhValidFrom]) ) OVER(PARTITION BY t1.[Id] ORDER BY t1.[DwhValidFrom] ASC ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS DwhLastValidFrom
	FROM [labshist].[z_CurrentLoadBooksEditions] t1
) t


--Create Backup of Existing Table 
RENAME OBJECT labshist.BooksEditions TO z_BooksEditions_Bkp
--Make new history table existing!
RENAME OBJECT labshist.z_NewHistoryBooksEditions TO BooksEditions
--Drop intimidiate storage of existing data
IF object_id('labshist.z_CurrentLoadBooksEditions') is not null
	DROP TABLE labshist.z_CurrentLoadBooksEditions

SET @EndOfHist = GetDate()

/* Define Statistics */
DELETE FROM labsfact.LoadingStatistics WHERE DwTable = 'stg.BooksEditions' AND LoadingDt = CAST(@SliceStart AS DATE) AND LoadingTm = CAST(@SliceStart AS TIME)

INSERT INTO labsfact.LoadingStatistics
SELECT CAST(@SliceStart AS DATE), CAST(@SliceStart AS TIME), 'stg', Staged.DwTable, Staged.NbrOfRows, Versioned.NbrOfRows, @StartOfHist, @EndOfHist, GetDate()
FROM (SELECT 'stg.BooksEditions' AS DwTable, Count(*) As NbrOfRows FROM [labsstg].[BooksEditions]) AS Staged
LEFT OUTER JOIN (SELECT 'stg.BooksEditions' AS DwTable, Count(*) As NbrOfRows FROM [labshist].[BooksEditions] WHERE DwhValidFrom = @SliceStart) AS Versioned ON Versioned.DwTable=Staged.DwTable


END
GO

GRANT EXECUTE TO dwloaduser
GO

