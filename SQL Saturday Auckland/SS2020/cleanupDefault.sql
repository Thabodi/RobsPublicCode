/*
Cleanup the objects used in the Encryption Demos
*/


--Restore Adventureworks and drop index
USE [master]
ALTER DATABASE [AdventureWorks2017] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [AdventureWorks2017] FROM  DISK = N'R:\SQLINSTANCE\SQLBACKUPS\SQLSAT\AdventureWorks2017.bak' WITH  FILE = 1,  MOVE N'AdventureWorks2017' TO N'R:\SQLINSTANCE\SQLDATA\AdventureWorks2017.mdf',  MOVE N'AdventureWorks2017_log' TO N'R:\SQLINSTANCE\SQLLOGS\AdventureWorks2017_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
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
