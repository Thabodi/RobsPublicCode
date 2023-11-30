import-module "sqlps" -DisableNameChecking

#Clean Up Primary Instance
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST -Query "ALTER DATABASE [AdventureWorks2017] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;DROP DATABASE [AdventureWorks2017]"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST -Query "RESTORE DATABASE [AdventureWorks2017] FROM  DISK = N'R:\SQLINSTANCE\SQLBackups\SQLSAT\AdventureWorks2017.bak' WITH  FILE = 1,  
MOVE N'AdventureWorks2017' TO N'R:\SQLINSTANCE\SQLData\AdventureWorks2017.mdf',  
MOVE N'AdventureWorks2017_log' TO N'R:\SQLINSTANCE\SQLLogs\AdventureWorks2017_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 5"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST -Query "USE [AdventureWorks2017];
DROP INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode] ON [Person].[Address]"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST -Query "DROP CERTIFICATE RobsBackupCert"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST -Query "DROP CERTIFICATE RobsTDECert"



#Clean Up Named Instance
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST2 -Query "ALTER DATABASE [AdventureWorks_INSECURE_Restore] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;DROP DATABASE [AdventureWorks_INSECURE_Restore]"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST2 -Query "ALTER DATABASE [AdventureWorks_SECURE_Restore] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;DROP DATABASE [AdventureWorks_SECURE_Restore]"
#invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST2 -Query "ALTER DATABASE [AdventureWorks2017] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;DROP DATABASE [AdventureWorks2017]"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST2 -Query "DROP CERTIFICATE RobsBackupCert"
invoke-sqlcmd -ServerInstance DS-LAPTOPROBD\ROBTEST2 -Query "DROP CERTIFICATE RobsTDECert"

#Remove Files
Remove-Item R:\SQLINSTANCE\SQLBackups\*.*