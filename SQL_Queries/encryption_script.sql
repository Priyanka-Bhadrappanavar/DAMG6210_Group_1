USE FINAL_HOS_MNG;
GO

-- Step 1: Create a Database Master Key (if it does not already exist)
IF NOT EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Mypassword123!';
END;
GO

-- Step 2: Create a Certificate (drop existing certificate first if exists)
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'DoctorContactCert')
    DROP CERTIFICATE DoctorContactCert;
GO

CREATE CERTIFICATE DoctorContactCert
WITH SUBJECT = 'Doctor Contact Encryption Certificate';
GO

-- Step 3: Create a Symmetric Key (drop existing symmetric key first if exists)
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'DoctorContactSymmetricKey')
    DROP SYMMETRIC KEY DoctorContactSymmetricKey;
GO

CREATE SYMMETRIC KEY DoctorContactSymmetricKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE DoctorContactCert;
GO

-- Drop the Check Constraint on the Contact column (if it exists)
ALTER TABLE Doctor DROP CONSTRAINT UQ_Doctor_Contact;
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'C' AND name = 'CK_Doctor_Contact_Length')
BEGIN
    ALTER TABLE Doctor DROP CONSTRAINT CK_Doctor_Contact_Length;
END;

go

-- Step 4: Alter the Doctor table with an encrypted Contact column
ALTER TABLE Doctor DROP COLUMN Contact;
ALTER TABLE Doctor ADD Contact VARBINARY(MAX);
GO

-- Step 5: Encrypt existing Contact data in the Doctor table using the symmetric key
OPEN SYMMETRIC KEY DoctorContactSymmetricKey DECRYPTION BY CERTIFICATE DoctorContactCert;

-- Encrypt existing doctor contact numbers
select * from doctor;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'123-456-7890')
WHERE Doctor_ID = 1;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'987-654-3210')
WHERE Doctor_ID = 2;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'555-123-4567')
WHERE Doctor_ID = 3;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'111-222-3333')
WHERE Doctor_ID = 4;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'444-555-6666')
WHERE Doctor_ID = 5;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'777-888-9999')
WHERE Doctor_ID = 6;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'123-789-4560')
WHERE Doctor_ID = 7;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'987-321-6540')
WHERE Doctor_ID = 8;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'555-678-1234')
WHERE Doctor_ID = 9;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'111-444-7777')
WHERE Doctor_ID = 10;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'555-678-2345')
WHERE Doctor_ID = 11;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'123-987-6543')
WHERE Doctor_ID = 12;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'555-234-9876')
WHERE Doctor_ID = 13;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'111-333-7777')
WHERE Doctor_ID = 14;

UPDATE Doctor
SET Contact = EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), N'444-777-5555')
WHERE Doctor_ID = 15;
GO

-- Step 6: Create a stored procedure to add a new doctor with encrypted contact info
DROP PROCEDURE IF EXISTS AddDoctor;
GO
CREATE PROCEDURE AddDoctor
    @Department_ID INT,
    @FirstName VARCHAR(255),
    @LastName VARCHAR(255),
    @Contact VARCHAR(20),
    @Availability VARCHAR(50)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Insert the new doctor with encrypted contact number
        INSERT INTO Doctor (Department_ID, FirstName, LastName, Contact, Availability)
        VALUES (
            @Department_ID,
            @FirstName,
            @LastName,
            EncryptByKey(KEY_GUID('DoctorContactSymmetricKey'), @Contact), -- Encrypt the contact number
            @Availability
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        -- Handle errors and rethrow them for debugging or logging purposes
        THROW;
    END CATCH;
END;
GO

-- Step 7: Example execution of AddDoctor stored procedure to add a new doctor
EXEC AddDoctor
    @Department_ID = 1, 
    @FirstName = 'David', 
    @LastName = 'Williams', 
    @Contact = '555-111-2222', 
    @Availability = 'Mon-Fri';
GO

-- Step 8: Decrypt the Contact field to display the original contact number
OPEN SYMMETRIC KEY DoctorContactSymmetricKey DECRYPTION BY CERTIFICATE DoctorContactCert;

select * from Doctor;
SELECT 
    Doctor_ID,
    FirstName,
    LastName,
    CONVERT(VARCHAR(20), DecryptByKey(Contact)) AS 'Decrypted_Contact',
    Availability
FROM 
    Doctor;
GO

-- Step 9: Drop the Symmetric Key
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = 'DoctorContactSymmetricKey')
BEGIN
    DROP SYMMETRIC KEY DoctorContactSymmetricKey;
END;
GO

-- Step 10: Drop the Certificate
IF EXISTS (SELECT * FROM sys.certificates WHERE name = 'DoctorContactCert')
BEGIN
    DROP CERTIFICATE DoctorContactCert;
END;
GO

-- Step 11: Drop the Database Master Key (optional)
IF EXISTS (SELECT * FROM sys.symmetric_keys WHERE name = '##MS_DatabaseMasterKey##')
BEGIN
    DROP MASTER KEY;
END;
GO

