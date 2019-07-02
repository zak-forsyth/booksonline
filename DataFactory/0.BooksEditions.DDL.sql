IF not exists( select * from sys.schemas where name = 'labsstg' ) 
	exec('CREATE SCHEMA [labsstg]')
GO

IF not exists( select * from sys.schemas where name = 'labshist' ) 
	exec('CREATE SCHEMA [labshist]')
GO

IF not exists( select * from sys.external_file_formats where name = 'eff_orc' ) 
	exec('CREATE EXTERNAL FILE FORMAT [eff_orc] WITH (FORMAT_TYPE = ORC, DATA_COMPRESSION = N''org.apache.hadoop.io.compress.SnappyCodec'')')
GO

--är jag en tabell?
IF object_id('labsstg.BooksEditions') is not null and exists (select * from internal.TableDeploys where SchemaName = 'labsstg' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' and ObjectVersion < 1.100)
	DROP TABLE [labsstg].[BooksEditions] 
GO

--är jag en external tabell?
IF object_id('labsstg.BooksEditions') is not null and exists (select * from internal.TableDeploys where SchemaName = 'labsstg' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' and ObjectVersion = 1.100)
	DROP EXTERNAL TABLE [labsstg].[BooksEditions] 
GO

--#Version 1.100
IF object_id('labsstg.BooksEditions') is null
	CREATE EXTERNAL TABLE [labsstg].[BooksEditions]
	(
		[Id] [int] NOT NULL,
		[Title] [nvarchar](4000) NULL,
		[Isbn] [nvarchar](4000) NOT NULL,
		[Cover] [nvarchar](4000) NULL,
		[Publisher] [nvarchar](4000) NULL,
		[PublishDate] [datetime2](7) NULL,
		[Language] [int] NOT NULL,
		[CreatedAt] [datetime2](7) NULL,
		[ModifiedAt] [datetime2](7) NULL,
		[DeletedAt] [datetime2](7) NULL,
		[Book_Id] [int] NULL,
		[ContentType] [int] NOT NULL,
		[Pages] [bigint] NULL,
		[Duration] [bigint] NULL,
		[BookBeatPublishDate] [datetime2](7) NULL,
		[BookBeatViewDate] [datetime2](7) NULL,
		[BookBeatUnpublishDate] [datetime2](7) NULL,
		[SerializedApprovals] [nvarchar](4000) NULL,
		[SerializedMarketRights] [nvarchar](4000) NULL,
		[SerializedCopyrightOwners] [nvarchar](4000) NULL
	)
	WITH
		(
			LOCATION='/BackEnd/Books/Editions/Latest/'
		,   DATA_SOURCE = eds_devbbdatalakestore
		,   FILE_FORMAT = eff_orc
		,   REJECT_TYPE = VALUE
		,   REJECT_VALUE = 0
		)

GO


IF not exists (select 1 from internal.TableDeploys where SchemaName = 'labsstg' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' )
	INSERT INTO internal.TableDeploys (SchemaName, ObjectName, ObjectType, ObjectVersion, LastUpdateDttm, Comment) SELECT 'labsstg' As SchemaName, 'BooksEditions' As ObjectName, 'USER_TABLE' As ObjectType, 1.00 As ObjectVersion, GetDate() AS LastUpdateDttm, 'Initial version' As comment 
GO

IF exists (select 1 from internal.TableDeploys where SchemaName = 'labsstg' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' and ObjectVersion < 1.100)
	UPDATE internal.TableDeploys set ObjectVersion = 1.100 , LastUpdateDttm = GetDate(), comment = 'Changed to External Stage table' where SchemaName = 'labsstg' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' 
GO

 
--HIST
IF object_id('labshist.BooksEditions') is not null And exists (select 1 from internal.TableDeploys where SchemaName = 'labshist' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' and ObjectVersion < 1.100)
	RENAME OBJECT [labshist].[BooksEditions] TO [BooksEditions_Deploy_Hist_Bkp]
GO

 --#Version 1.100
IF object_id('labshist.BooksEditions') is null 
	CREATE TABLE [labshist].[BooksEditions]
	(
		[Id] [int] NOT NULL,
		[Title] [nvarchar](255) NULL,
		[Isbn] [nvarchar](50) NOT NULL,
		[Cover] [nvarchar](255) NULL,
		[Publisher] [nvarchar](255) NULL,
		[PublishDate] [datetimeoffset](7) NULL,
		[Language] [int] NOT NULL,
		[CreatedAt] [datetimeoffset](7) NULL,
		[ModifiedAt] [datetimeoffset](7) NULL,
		[DeletedAt] [datetimeoffset](7) NULL,
		[Book_Id] [int] NULL,
		[ContentType] [int] NOT NULL,
		[Pages] [int] NULL,
		[Duration] [int] NULL,
		[BookBeatPublishDate] [datetimeoffset](7) NULL,
		[BookBeatViewDate] [datetimeoffset](7) NULL,
		[BookBeatUnpublishDate] [datetimeoffset](7) NULL,
		[SerializedApprovals] [nvarchar](4000) NULL,
		[SerializedMarketRights] [nvarchar](4000) NULL,
		[SerializedCopyrightOwners] [nvarchar](4000) NULL,
		[DwhValidFrom] [datetime] NOT NULL,
		[DwhValidTo] [datetime] NULL,
		[DwhLastUpdateInd] [int] NOT NULL
	)
	WITH
	(
		DISTRIBUTION = HASH ( [Isbn] ),
		CLUSTERED COLUMNSTORE INDEX
	)

GO

IF object_id('labshist.BooksEditions_Deploy_Hist_Bkp') is not null 
	INSERT INTO [labshist].[BooksEditions] 
	SELECT [Id],
		[Title],
		[Isbn],
		[Cover],
		[Publisher],
		[PublishDate],
		[Language],
		[CreatedAt],
		[ModifiedAt],
		[DeletedAt],
		[Book_Id],
		[ContentType],
		[Pages],
		[Duration],
		[BookBeatPublishDate],
		[BookBeatViewDate],
		[BookBeatUnpublishDate],
		[SerializedApprovals],
		[SerializedMarketRights],
		null as [SerializedCopyrightOwners],
		[DwhValidFrom],
		[DwhValidTo],
		[DwhLastUpdateInd]
	 FROM [labshist].[BooksEditions_Deploy_Hist_Bkp]
GO

IF object_id('labshist.BooksEditions_Deploy_Hist_Bkp') is not null and ((select count(*) from [labshist].[BooksEditions]) > 0 or (select count(*) from [labshist].[BooksEditions_Deploy_Hist_Bkp]) = 0)
	DROP TABLE [labshist].[BooksEditions_Deploy_Hist_Bkp]
GO

 
IF not exists (select 1 from internal.TableDeploys where SchemaName = 'labshist' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' )
	INSERT INTO internal.TableDeploys (ObjectVersion, LastUpdateDttm, comment, SchemaName, ObjectName, ObjectType ) SELECT 1.000 , GetDate(), 'Initial Version', 'labshist', 'BooksEditions' , 'USER_TABLE' 
GO

IF exists (select 1 from internal.TableDeploys where SchemaName = 'labshist' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' and ObjectVersion < 1.100) 
	UPDATE internal.TableDeploys set ObjectVersion = 1.100 , LastUpdateDttm = GetDate(), comment = 'Added Description, ShortDescription, SerializedCopyrightOwners' where SchemaName = 'labshist' and ObjectName = 'BooksEditions' and ObjectType = 'USER_TABLE' 
GO

--CORE
IF not exists( select * from sys.schemas where name = 'labscore' ) 
	exec('CREATE SCHEMA [labscore]')
GO

IF object_id('labscore.BooksEditions') is not null
	DROP VIEW [labscore].[BooksEditions]
GO

EXEC [labscore].[DefineCurrentView] @ViewNm = 'BooksEditions'
GO
