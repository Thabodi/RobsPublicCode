/*


T R A N S P A R E N T   D A T A   E N C R Y P T I O N   D E M O

*/
--Create The Certificate
USE MASTER
GO
CREATE CERTIFICATE AW_TDEcert WITH SUBJECT = 'Robs TDE Certificate'
GO
--Check that worked
select 
	name
	,pvt_key_encryption_type_desc
	,expiry_date
	,thumbprint
from
	master.sys.certificates
where 
	name not like '##%' 
--Note Expiry date and Thumbprint
GO

--Let's encrypt stuff
--Create Database Encryption Key
USE [AdventureWorks2017]
GO
CREATE DATABASE ENCRYPTION KEY WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE AW_TDEcert
GO
--Check It Out
SELECT DB_NAME(database_id) AS DatabaseName, encryption_state,
encryption_state_desc =
CASE encryption_state
         WHEN '0'  THEN  'No database encryption key present, no encryption'
         WHEN '1'  THEN  'Unencrypted'
         WHEN '2'  THEN  'Encryption in progress'
         WHEN '3'  THEN  'Encrypted'
         WHEN '4'  THEN  'Key change in progress'
         WHEN '5'  THEN  'Decryption in progress'
         WHEN '6'  THEN  'Protection change in progress (The certificate or asymmetric key that is encrypting the database encryption key is being changed.)'
         ELSE 'No Status'
         END
	, percent_complete
	, encryptor_thumbprint
	, encryptor_type  
FROM 
	sys.dm_database_encryption_keys


--Now we need to actually encrypt the database
ALTER DATABASE [AdventureWorks2017] SET ENCRYPTION ON
GO

--Check It Out Again
SELECT DB_NAME(database_id) AS DatabaseName, encryption_state,
encryption_state_desc =
CASE encryption_state
         WHEN '0'  THEN  'No database encryption key present, no encryption'
         WHEN '1'  THEN  'Unencrypted'
         WHEN '2'  THEN  'Encryption in progress'
         WHEN '3'  THEN  'Encrypted'
         WHEN '4'  THEN  'Key change in progress'
         WHEN '5'  THEN  'Decryption in progress'
         WHEN '6'  THEN  'Protection change in progress (The certificate or asymmetric key that is encrypting the database encryption key is being changed.)'
         ELSE 'No Status'
         END
	, percent_complete
	, encryptor_thumbprint
	, encryptor_type  
FROM 
	sys.dm_database_encryption_keys


	--TempDB also gets encrypted AND Remains Encrypted until there 
	--are no encrypted databases on the server and SQL Server is restarted.


--Prove it works - Detach the database
USE [master]
GO
ALTER DATABASE [AdventureWorks2017] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
EXEC master.dbo.sp_detach_db @dbname = N'AdventureWorks2017'
GO




--Reattach it to the same instance
USE [master]
GO
CREATE DATABASE [AdventureWorks2017] ON 
( FILENAME = N'C:\SQL\SQLDATA\AdventureWorks2017.mdf' ),
( FILENAME = N'C:\SQL\SQLLOGS\AdventureWorks2017_log.ldf' )
 FOR ATTACH
GO
ALTER DATABASE [AdventureWorks2017] SET MULTI_USER
GO

--Back it up and restore it
BACKUP DATABASE [AdventureWorks2017] TO  DISK = N'C:\SQL\SQLBACKUPS\AdventureWorks2017.bak' 
WITH NOFORMAT, INIT,  NAME = N'AdventureWorks2017-Full Database Backup for TDE demo', 
SKIP, NOREWIND, NOUNLOAD,  STATS = 10
GO

USE [master]
RESTORE DATABASE [AdventureWorks2017] FROM  DISK = N'C:\SQL\SQLBACKUPS\AdventureWorks2017.bak' 
WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 5
GO

--Now do the same again on the instance with no certificate



--Doesn't work without certificate

BACKUP CERTIFICATE AW_TDEcert TO FILE = 'C:\SQL\SQLBACKUPS\AW_TDEcert.cer'
WITH PRIVATE KEY(FILE = 'C:\SQL\SQLBACKUPS\AW_TDEcert_Key.pvk',
ENCRYPTION BY PASSWORD = 'SuperHardPassword');

--Restore the certificate on the other server

--Requires a master key if it doesn't already have one.
--CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'SuperAwesomePassword2019!'

CREATE CERTIFICATE AW_TDEcert
FROM FILE = N'C:\SQL\SQLBACKUPS\AW_TDEcert.cer'
WITH PRIVATE KEY(FILE=N'C:\SQL\SQLBACKUPS\AW_TDEcert_Key.pvk', 
DECRYPTION BY PASSWORD = 'SuperHardPassword')




