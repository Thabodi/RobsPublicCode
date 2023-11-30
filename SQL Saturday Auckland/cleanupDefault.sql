/*
Cleanup the objects used in the Encryption Demos
*/


--Restore Adventureworks and drop index
USE [master]
ALTER DATABASE [AdventureWorks2017] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [AdventureWorks2017] FROM  DISK = N'C:\SQL\SQLBackups\SQLSAT\AdventureWorks2017.bak' WITH  FILE = 1,  MOVE N'AdventureWorks2017' TO N'C:\SQL\SQLData\AdventureWorks2017.mdf',  MOVE N'AdventureWorks2017_log' TO N'C:\SQL\SQLLogs\AdventureWorks2017_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [AdventureWorks2017] SET MULTI_USER
GO
USE [AdventureWorks2017]
DROP INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode] ON [Person].[Address]
GO
USE [master]
GO
DROP CERTIFICATE RobsBackupCert
GO
DROP CERTIFICATE RobsTDECert
GO



select * from sys.certificates
GO
/*
SELECT db_name(database_id), encryption_state,   percent_complete, key_algorithm, key_length
FROM sys.dm_database_encryption_keys
WHERE db_name(database_id) not in('tempdb')

ALTER DATABASE DSLAdmin SET ENCRYPTION OFF
GO
USE DSLAdmin
GO
Drop Database Encryption Key
GO
DROP MASTER KEY
*/