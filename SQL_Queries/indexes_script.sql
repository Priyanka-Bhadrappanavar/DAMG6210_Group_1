-- Drop indexes if they exist

IF EXISTS (SELECT * FROM sys.indexes 
           WHERE name = 'IX_Patient_Contact' 
           AND object_id = OBJECT_ID('Patient'))
    DROP INDEX IX_Patient_Contact ON Patient;
GO

IF EXISTS (SELECT * FROM sys.indexes 
           WHERE name = 'IX_Doctor_Contact' 
           AND object_id = OBJECT_ID('Doctor'))
    DROP INDEX IX_Doctor_Contact ON Doctor;
GO

IF EXISTS (SELECT * FROM sys.indexes 
           WHERE name = 'IX_Appointment_Date' 
           AND object_id = OBJECT_ID('Appointment'))
    DROP INDEX IX_Appointment_Date ON Appointment;
GO

-- Creating Non-Clustered Index on Patient(Contact)
CREATE NONCLUSTERED INDEX IX_Patient_Contact
ON Patient (Contact);
GO

-- Creating Non-Clustered Index on Doctor(LastName)
-- Here we assume that the LastName column exists in the Doctor table and is useful for query performance.
CREATE NONCLUSTERED INDEX IX_Doctor_Contact
ON Doctor (LastName);
GO

-- Creating Non-Clustered Index on Appointment(Date)
CREATE NONCLUSTERED INDEX IX_Appointment_Date
ON Appointment (Date);
GO

-- STATS OF NON CLUSTERED INDEX USAGE
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT name, object_id, index_id, type_desc
FROM sys.indexes
WHERE object_id = OBJECT_ID('Patient');

SELECT OBJECT_NAME(s.object_id) AS TableName,
       i.name AS IndexName,
       s.user_seeks, s.user_scans, s.user_lookups, s.user_updates
FROM sys.dm_db_index_usage_stats s
JOIN sys.indexes i
  ON s.object_id = i.object_id AND s.index_id = i.index_id
WHERE OBJECTPROPERTY(s.object_id, 'IsUserTable') = 1;
