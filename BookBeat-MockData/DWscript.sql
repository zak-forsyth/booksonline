USE [DataWarehouse-demozak]
GO
/****** Object:  StoredProcedure [dbo].[sp_resetStagingTable]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP PROCEDURE [dbo].[sp_resetStagingTable]
GO
/****** Object:  StoredProcedure [dbo].[sp_enrichStagedWeatherData]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP PROCEDURE [dbo].[sp_enrichStagedWeatherData]
GO
/****** Object:  StoredProcedure [dbo].[sp_addStagingRecordsToProduction]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP PROCEDURE [dbo].[sp_addStagingRecordsToProduction]
GO
/****** Object:  Index [ClusteredIndex_5c4a955d80154c5885c43781b2050c8a]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP INDEX [ClusteredIndex_5c4a955d80154c5885c43781b2050c8a] ON [staging].[factWaterSupplyMeasurements]
GO
/****** Object:  Index [ClusteredIndex_d32b4dc02bbb44a88ed3e3b47d47d81a]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP INDEX [ClusteredIndex_d32b4dc02bbb44a88ed3e3b47d47d81a] ON [staging].[factDroughtMeasurements]
GO
/****** Object:  Index [ClusteredIndex_8acb0d9c894b40d5bef2718976b86cca]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP INDEX [ClusteredIndex_8acb0d9c894b40d5bef2718976b86cca] ON [dbo].[factWeatherMeasurements]
GO
/****** Object:  Index [ClusteredIndex_7fbe18fdf1ea448cbf7d4f4f50863bee]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP INDEX [ClusteredIndex_7fbe18fdf1ea448cbf7d4f4f50863bee] ON [dbo].[factWaterUsageMeasurements]
GO
/****** Object:  Index [ClusteredIndex_40aab7376c2e4eb09129637cce8b827c]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP INDEX [ClusteredIndex_40aab7376c2e4eb09129637cce8b827c] ON [dbo].[factWaterSupplyMeasurements]
GO
/****** Object:  Index [ClusteredIndex_683c6509b7a74b09945a8b613bfdcf06]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP INDEX [ClusteredIndex_683c6509b7a74b09945a8b613bfdcf06] ON [dbo].[factDroughtMeasurements]
GO
/****** Object:  Table [staging].[factWaterSupplyMeasurements]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [staging].[factWaterSupplyMeasurements]
GO
/****** Object:  Table [staging].[factDroughtMeasurements]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [staging].[factDroughtMeasurements]
GO
/****** Object:  Table [dbo].[factWeatherMeasurements]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[factWeatherMeasurements]
GO
/****** Object:  Table [dbo].[factWaterUsageMeasurements]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[factWaterUsageMeasurements]
GO
/****** Object:  Table [dbo].[factWaterSupplyMeasurements]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[factWaterSupplyMeasurements]
GO
/****** Object:  Table [dbo].[factDroughtMeasurements]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[factDroughtMeasurements]
GO
/****** Object:  Table [dbo].[dimWeatherObservationTypes]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWeatherObservationTypes]
GO
/****** Object:  Table [dbo].[dimWeatherObservationSources]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWeatherObservationSources]
GO
/****** Object:  Table [dbo].[dimWeatherObservationSites]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWeatherObservationSites]
GO
/****** Object:  Table [dbo].[dimWaterWithdrawalCategories]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWaterWithdrawalCategories]
GO
/****** Object:  Table [dbo].[dimWaterUsagePopulationInfo]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWaterUsagePopulationInfo]
GO
/****** Object:  Table [dbo].[dimWaterSupplySiteTypes]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWaterSupplySiteTypes]
GO
/****** Object:  Table [dbo].[dimWaterSupplySiteInfo]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWaterSupplySiteInfo]
GO
/****** Object:  Table [dbo].[dimWaterReadingTypes]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimWaterReadingTypes]
GO
/****** Object:  Table [dbo].[dimUSFIPSCodes]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimUSFIPSCodes]
GO
/****** Object:  Table [dbo].[dimReportingAgencyInfo]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimReportingAgencyInfo]
GO
/****** Object:  Table [dbo].[dimDates]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP TABLE [dbo].[dimDates]
GO
/****** Object:  Schema [sysdiag]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP SCHEMA [sysdiag]
GO
/****** Object:  Schema [staging]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP SCHEMA [staging]
GO

DECLARE @RoleName sysname
set @RoleName = N'largerc'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#8d9be00327b640f18016e9404c15cc45]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#8d9be00327b640f18016e9404c15cc45]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#8d9be00327b640f18016e9404c15cc45] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#8d9be00327b640f18016e9404c15cc45]
END
/****** Object:  DatabaseRole [largerc]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [largerc]
GO

DECLARE @RoleName sysname
set @RoleName = N'mediumrc'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#ade322e73ec6450e82ef800032588ad7]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#ade322e73ec6450e82ef800032588ad7]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#ade322e73ec6450e82ef800032588ad7] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#ade322e73ec6450e82ef800032588ad7]
END
/****** Object:  DatabaseRole [mediumrc]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [mediumrc]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc10'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#e851e8017a4049758873bd04d0fa3eb6]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#e851e8017a4049758873bd04d0fa3eb6]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#e851e8017a4049758873bd04d0fa3eb6] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#e851e8017a4049758873bd04d0fa3eb6]
END
/****** Object:  DatabaseRole [staticrc10]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc10]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc20'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#8e9bbea77d0c4de3b064d33a43efbe36]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#8e9bbea77d0c4de3b064d33a43efbe36]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#8e9bbea77d0c4de3b064d33a43efbe36] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#8e9bbea77d0c4de3b064d33a43efbe36]
END
/****** Object:  DatabaseRole [staticrc20]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc20]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc30'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#1b2bd78db13b4ebc9d36e3b60c326d1c]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#1b2bd78db13b4ebc9d36e3b60c326d1c]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#1b2bd78db13b4ebc9d36e3b60c326d1c] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#1b2bd78db13b4ebc9d36e3b60c326d1c]
END
/****** Object:  DatabaseRole [staticrc30]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc30]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc40'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#b3c6ee60fd1f4f80bffed60e9933267c]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#b3c6ee60fd1f4f80bffed60e9933267c]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#b3c6ee60fd1f4f80bffed60e9933267c] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#b3c6ee60fd1f4f80bffed60e9933267c]
END
/****** Object:  DatabaseRole [staticrc40]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc40]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc50'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#190db0588878464db8b6a1878ec7a4c0]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#190db0588878464db8b6a1878ec7a4c0]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#190db0588878464db8b6a1878ec7a4c0] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#190db0588878464db8b6a1878ec7a4c0]
END
/****** Object:  DatabaseRole [staticrc50]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc50]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc60'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#02786176450441338774d35a28cdccc5]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#02786176450441338774d35a28cdccc5]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#02786176450441338774d35a28cdccc5] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#02786176450441338774d35a28cdccc5]
END
/****** Object:  DatabaseRole [staticrc60]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc60]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc70'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#76457450f16b496c96ddf3a7ce513329]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#76457450f16b496c96ddf3a7ce513329]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#76457450f16b496c96ddf3a7ce513329] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#76457450f16b496c96ddf3a7ce513329]
END
/****** Object:  DatabaseRole [staticrc70]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc70]
GO

DECLARE @RoleName sysname
set @RoleName = N'staticrc80'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#1a473cb6edf243acbf9bdd2a58855f04]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#1a473cb6edf243acbf9bdd2a58855f04]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#1a473cb6edf243acbf9bdd2a58855f04] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#1a473cb6edf243acbf9bdd2a58855f04]
END
/****** Object:  DatabaseRole [staticrc80]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [staticrc80]
GO

DECLARE @RoleName sysname
set @RoleName = N'xlargerc'

IF @RoleName <> N'public' and (select is_fixed_role from sys.database_principals where name = @RoleName) = 0
BEGIN
    CREATE TABLE [#384a47dd269046f19d77647a9f256179]
    WITH( DISTRIBUTION = ROUND_ROBIN )
    AS
    SELECT  ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Sequence, [name],
           'exec sp_droprolemember @rolename=['+ @RoleName +'], @membername='  +QUOTENAME([name]) AS sql_code
    from sys.database_principals 
    where principal_id in ( 
            select member_principal_id
            from sys.database_role_members
            where role_principal_id in (
                select principal_id
                FROM sys.database_principals where [name] = @RoleName AND type = 'R'));

    DECLARE @nbr_statements INT = (SELECT COUNT(*) FROM [#384a47dd269046f19d77647a9f256179]), @i INT = 1;
    WHILE   @i <= @nbr_statements
    BEGIN
        DECLARE @sql_code NVARCHAR(4000) = (SELECT sql_code FROM [#384a47dd269046f19d77647a9f256179] WHERE Sequence = @i);
        EXEC    sp_executesql @sql_code;
        SET     @i +=1;
    END
    DROP TABLE [#384a47dd269046f19d77647a9f256179]
END
/****** Object:  DatabaseRole [xlargerc]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP ROLE [xlargerc]
GO
USE [master]
GO
/****** Object:  Database [DataWarehouse-demozak]    Script Date: 2/13/2019 9:50:58 AM ******/
DROP DATABASE [DataWarehouse-demozak]
GO
/****** Object:  Database [DataWarehouse-demozak]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE DATABASE [DataWarehouse-demozak]
GO
ALTER DATABASE [DataWarehouse-demozak] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DataWarehouse-demozak].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DataWarehouse-demozak] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET ARITHABORT OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET AUTO_UPDATE_STATISTICS OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [DataWarehouse-demozak] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DataWarehouse-demozak] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DataWarehouse-demozak] SET  MULTI_USER 
GO
ALTER DATABASE [DataWarehouse-demozak] SET DB_CHAINING OFF 
GO
USE [DataWarehouse-demozak]
GO
/****** Object:  DatabaseRole [xlargerc]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [xlargerc]
GO
/****** Object:  DatabaseRole [staticrc80]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc80]
GO
/****** Object:  DatabaseRole [staticrc70]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc70]
GO
/****** Object:  DatabaseRole [staticrc60]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc60]
GO
/****** Object:  DatabaseRole [staticrc50]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc50]
GO
/****** Object:  DatabaseRole [staticrc40]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc40]
GO
/****** Object:  DatabaseRole [staticrc30]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc30]
GO
/****** Object:  DatabaseRole [staticrc20]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc20]
GO
/****** Object:  DatabaseRole [staticrc10]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [staticrc10]
GO
/****** Object:  DatabaseRole [mediumrc]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [mediumrc]
GO
/****** Object:  DatabaseRole [largerc]    Script Date: 2/13/2019 9:50:58 AM ******/
CREATE ROLE [largerc]
GO
/****** Object:  Schema [staging]    Script Date: 2/13/2019 9:50:59 AM ******/
CREATE SCHEMA [staging]
GO
/****** Object:  Schema [sysdiag]    Script Date: 2/13/2019 9:50:59 AM ******/
CREATE SCHEMA [sysdiag]
GO
