/*
--Version 1.0 Initial version
*/
IF not exists( select * from sys.schemas where name = 'labsdim' ) 
	exec('CREATE SCHEMA [labsdim]')
GO


--STAGE
IF object_id('labsdim.Book') is not null and exists (select 1 from internal.TableDeploys where SchemaName = 'labsdim' and ObjectName = 'Book' and ObjectType = 'USER_TABLE' and ObjectVersion < 1.100)
	RENAME OBJECT [labsdim].[Book] TO [Book_Deploy_Dim_Bkp]
GO


IF object_id('labsdim.Book') is null 
    --version 1.000
	CREATE TABLE [labsdim].[Book]
(
	[BookKey] [int] NOT NULL,
	[BookId] [int] NOT NULL,
	[TitleInService] [nvarchar](4000) NULL,
	[AverageGrade] [float] NULL,
	[LastUpdateDttm] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED COLUMNSTORE INDEX
)
GO


--COPY TABLE BACK VERSION 1.0 COMPATIBLE DEFINTION
IF object_id('labsdim.Book_Deploy_Dim_Bkp') is not null and exists (select 1 from internal.TableDeploys where SchemaName = 'labsdim' and ObjectName = 'Book' and ObjectType = 'USER_TABLE' and ObjectVersion < 1.100)
	INSERT INTO [labsdim].[Book]
	SELECT * FROM [labsdim].[Book_Deploy_Dim_Bkp]
GO


IF object_id('labsdim.Book_Deploy_Dim_Bkp') is not null
	DROP TABLE [labsdim].[Book_Deploy_Dim_Bkp]
GO