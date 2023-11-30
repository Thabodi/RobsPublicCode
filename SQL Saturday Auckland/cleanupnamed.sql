EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdventureWorks_INSECURE_Restore'
GO
EXEC msdb.dbo.sp_delete_database_backuphistory @database_name = N'AdventureWorks_SECURE_Restore'
GO
USE [master]
GO
DROP DATABASE [AdventureWorks_INSECURE_Restore]
GO
DROP DATABASE [AdventureWorks_SECURE_Restore]
GO
DROP DATABASE [AdventureWorks2017]
GO
DROP certificate RobsBackupCert
GO
DROP CERTIFICATE RobsTDECert
GO
select * from sys.certificates
GO
