/* 

Always Encrypted Demo

*/

SELECT TOP (1000) [AddressID]
      ,[AddressLine1]
      ,[City]
      ,[PostalCode]
  FROM [AdventureWorks2017].[Person].[Address]
  
--Let's go ahead and Encrypt Postal Code(random) and City(deterministic)
--Must be done with GUI

--Must be an administrator to put key in keystore
--BLOCKING operation

--Add to connection string and provided you have access to key you can read data.
--Column Encryption Setting = Enabled
--So best practice - remove key from Windows Key store

--Creating Index

--On City
USE [AdventureWorks2017]
CREATE NONCLUSTERED INDEX [NC_On_City] ON [Person].[Address](	[City] ASC) WITH (DATA_COMPRESSION=PAGE)
CREATE NONCLUSTERED INDEX [NC_On_City_NoCompress] ON [Person].[Address](	[City] ASC)
GO



--On Postal Code
USE [AdventureWorks2017]
CREATE NONCLUSTERED INDEX [NC_On_PostalCode] ON [Person].[Address](	[PostalCode] ASC) WITH (DATA_COMPRESSION=PAGE)
CREATE NONCLUSTERED INDEX [NC_On_PostalCode_NoCompress] ON [Person].[Address](	[PostalCode] ASC)
GO
--Won't let me do it!

--Check out the compression ratio
SELECT		s.name						AS SchemaName
		, OBJECT_NAME(o.OBJECT_ID)			AS TableName
		, ISNULL(i.name, 'HEAP')			AS IndexName
		, p.[rows]					AS [RowCnt]
		, p.data_compression_desc			AS CompressionType
		, au.type_desc					AS AllocType
		, au.total_pages*8 			AS TotalKBs
		, au.used_pages*8				AS UsedKBs
		, au.data_pages*8			AS DataKBs
FROM sys.indexes i
LEFT OUTER JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id
LEFT OUTER JOIN sys.filegroups f ON i.data_space_id = f.data_space_id
INNER JOIN sys.objects o ON i.object_id = o.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.schemas s ON o.schema_id =  s.schema_id
INNER JOIN sys.allocation_units au ON
CASE
WHEN au.[type] IN (1,3) THEN p.hobt_id
WHEN au.[type] = 2 THEN p.partition_id
END = au.container_id
WHERE o.is_ms_shipped <> 1 
and I.type>1
AND OBJECT_NAME(o.object_id) = 'Address'
and i.name Like 'NC_On_CITY%'

--INSERT DATA
INSERT INTO Person.[Address]([AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation], [rowguid])
Select TOP 1  [AddressLine1], [AddressLine2], 'Nelson', [StateProvinceID], '7011', [SpatialLocation], NEWID()
				FROM AdventureWorks2017.Person.Address






--Need to insert parameters
DECLARE @city nvarchar(30) = 'Nelson'
DECLARE @postcode nvarchar(15) = '7011'

INSERT INTO AdventureWorks2017.Person.[Address]( [AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode], [SpatialLocation], [rowguid])
Select TOP 1  [AddressLine1], [AddressLine2], @city, [StateProvinceID], @postcode, [SpatialLocation], NEWID()
				FROM AdventureWorks2017.Person.Address



				--Still doesn't work - because need to "Enable Parameterization for Always Encrypted" in query properties->Tools->Options->QueryExecution->Advanced - right at the bottom
				--AND the certificate
				--AND Column Encryption Setting = Enabled

				--Also note if you get the datatype wrong it will fail - even an nvarchar(10) vs nvarchar(5)

--SELECT STATEMENT
SELECT TOP (1000) [AddressID]
      ,[AddressLine1]
      ,[City]
      ,[PostalCode]
  FROM [AdventureWorks2017].[Person].[Address]
  WHERE City = 'Nelson'
  GO

  SELECT TOP (1000) [AddressID]
      ,[AddressLine1]
      ,[City]
      ,[PostalCode]
  FROM [AdventureWorks2017].[Person].[Address]
  WHERE PostalCode = '7011'
  GO


DECLARE @city nvarchar(30) = 'Nelson'
SELECT TOP (1000) [AddressID]
      ,[AddressLine1]
      ,[City]
      ,[PostalCode]
  FROM [AdventureWorks2017].[Person].[Address]
  WHERE City = @city

  --Can search on this column, because it's deterministic, but only on equality values.  ie can search for x=1 but not x>1







DECLARE @postcode nvarchar(15) = '98011'

SELECT TOP (1000) [AddressID]
      ,[AddressLine1]
      ,[City]
      ,[PostalCode]
  FROM [AdventureWorks2017].[Person].[Address]
  WHERE PostalCode=@postcode


  --Cannot Search at all on this column - because it's randomized.