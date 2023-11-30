/*
Cleanup the objects used in the Encryption Demos
*/


--Restore Adventureworks and drop index
USE [master]
ALTER DATABASE [AdventureWorks2017] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
RESTORE DATABASE [AdventureWorks2017] FROM  DISK = N'C:\SQL\SQLBackups\AdventureWorks2017_master.bak' WITH  FILE = 1,  MOVE N'AdventureWorks2017' TO N'C:\SQL\SQLData\AdventureWorks2017.mdf',  MOVE N'AdventureWorks2017_log' TO N'C:\SQL\SQLLogs\AdventureWorks2017_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5
ALTER DATABASE [AdventureWorks2017] SET MULTI_USER
GO
GO
DROP CERTIFICATE RobsBackupCert
GO
DROP CERTIFICATE RobsTDECert
GO

select * from sys.certificates
GO

--Go delete the files in backup


