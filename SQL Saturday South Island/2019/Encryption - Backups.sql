/*
Rob's Encryption Demo Scripts

*/

--Backup Encryption
--First create a master key
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SuperAwesomePassword2019!'
GO
--Check That Worked
SELECT * FROM master.sys.symmetric_keys
GO
--Create The Certificate
CREATE CERTIFICATE RobsBackupCert WITH SUBJECT = 'Encrypted Backup Certificate'
GO
--Check that worked
SELECT name, pvt_key_encryption_type_desc, subject, expiry_date,thumbprint,key_length FROM master.sys.certificates
GO
--Backup the Database Unsecurely
BACKUP DATABASE [AdventureWorks2017] TO DISK = N'C:\SQL\SQLBACKUPS\AdventureWorksINSECUREBackup.bak' WITH FORMAT, COMPRESSION
GO
--Backup the Database Securely
BACKUP DATABASE [AdventureWorks2017] TO DISK = N'C:\SQL\SQLBACKUPS\AdventureWorksSecureBackup.bak' 
WITH COMPRESSION, FORMAT, ENCRYPTION(ALGORITHM = AES_256, SERVER CERTIFICATE = [RobsBackupCert])
GO
--Now let's check out the headers
RESTORE HEADERONLY FROM DISK = N'C:\SQL\SQLBACKUPS\AdventureWorksINSECUREBackup.bak'
RESTORE HEADERONLY FROM DISK = N'C:\SQL\SQLBACKUPS\AdventureWorksSecureBackup.bak'
--Check Encryptor thumbprint against the certificate
SELECT name, thumbprint FROM sys.certificates
--MSDB Stores the same information
SELECT TOP 2 Database_name, type, backup_start_date,physical_device_name,bs.key_algorithm, bs.encryptor_thumbprint,bs.encryptor_type
FROM msdb.dbo.backupmediafamily BMF
INNER JOIN msdb.dbo.backupset BS on BMF.media_set_id=BS.media_set_id
WHERE type = 'D'
ORDER BY backup_start_date DESC

--Now Lets restore them
RESTORE DATABASE AdventureWorks_INSECURE_Restore 
FROM DISK = N'C:\SQL\SQLBACKUPS\AdventureWorksINSECUREBackup.bak'
WITH MOVE 'AdventureWorks2017' TO 'C:\SQL\SQLDATA\AdventureWorks2.mdf'
, MOVE 'AdventureWorks2017_log' TO 'C:\SQL\SQLLOGS\AdventureWorks2.ldf'

RESTORE DATABASE AdventureWorks_SECURE_Restore 
FROM DISK = N'C:\SQL\SQLBACKUPS\AdventureWorksSECUREBackup.bak'
WITH MOVE 'AdventureWorks2017' TO 'C:\SQL\SQLDATA\AdventureWorks3.mdf'
, MOVE 'AdventureWorks2017_log' TO 'C:\SQL\SQLLOGS\AdventureWorks3.ldf'

--Drop them so we can reuse files on the other side.
DROP DATABASE [AdventureWorks_INSECURE_Restore]
GO
DROP DATABASE [AdventureWorks_SECURE_Restore]
GO
--Now let's go restore them on another server.
--Doesn't work without certificate

BACKUP CERTIFICATE RobsBackupCert TO FILE = 'C:\SQL\SQLBACKUPS\RobsBackupCert.cer'
WITH PRIVATE KEY(FILE = 'C:\SQL\SQLBACKUPS\RobsBackupCert_Key.pvk',
ENCRYPTION BY PASSWORD = 'SuperHardPassword');

--Restore the certificate on the other server

--Requires a master key if it doesn't already have one.
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SuperAwesomePassword2019!'

CREATE CERTIFICATE RobsBackupCert 
FROM FILE = N'C:\SQL\SQLBACKUPS\RobsBackupCert.cer'
WITH PRIVATE KEY(FILE=N'C:\SQL\SQLBACKUPS\RobsBackupCert_Key.pvk', 
DECRYPTION BY PASSWORD = 'SuperHardPassword')


SELECT * FROM sys.certificates  







