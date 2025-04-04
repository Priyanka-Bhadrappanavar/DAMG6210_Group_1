USE FINAL_HOS_MNG;
GO
-- Stored Procedure 1: GetPatientDetails

DROP PROCEDURE IF EXISTS GetPatientDetails;
GO
CREATE PROCEDURE GetPatientDetails
    @PatientID INT,
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    BEGIN TRY
        SET @Message = NULL;

        IF NOT EXISTS (SELECT 1 FROM Patient WHERE Patient_ID = @PatientID)
        BEGIN
            SET @Message = 'Patient with the given PatientID not found.';
            RETURN;
        END

        SELECT FirstName, LastName, DOB, Contact, Email
        FROM Patient
        WHERE Patient_ID = @PatientID;
        SET @message = 'Data retrieved successfully';
    END TRY
    BEGIN CATCH
        SET @Message = 'Error occurred during retrieval: ' +  ERROR_MESSAGE();
    END CATCH
END
GO

-- Steps to run 
DECLARE @Message NVARCHAR(4000);
EXEC GetPatientDetails 
    @PatientID = 1, 
    @Message = @Message OUTPUT;
SELECT @Message AS Message;

GO

DECLARE @Message NVARCHAR(4000);
EXEC GetPatientDetails 
    @PatientID = NULL, 
    @Message = @Message OUTPUT;
SELECT @Message AS Message;


-- Stored Procedure 2: InsertNewAppointment

DROP PROCEDURE IF EXISTS InsertNewAppointment;
GO
CREATE PROCEDURE InsertNewAppointment
    @AdminID INT,
    @DoctorID INT,
    @PatientID INT,
    @Date DATE,
    @Time TIME,
    @Status VARCHAR(50),
    @EmergencyFlag BIT,
    @Appointment_ID INT OUTPUT,
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    -- Declare variables for error handling
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- -- Validate input parameters
        IF NOT EXISTS (SELECT 1 FROM Admin WHERE Admin_ID = @AdminID)
        BEGIN
            RAISERROR('Admin ID %d does not exist.', 16, 1, @AdminID);
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Doctor WHERE Doctor_ID = @DoctorID)
        BEGIN
            RAISERROR('Doctor ID %d does not exist.', 16, 1, @DoctorID);
            RETURN;
        END
        
        IF NOT EXISTS (SELECT 1 FROM Patient WHERE Patient_ID = @PatientID)
        BEGIN
            RAISERROR('Patient ID %d does not exist.', 16, 1, @PatientID);
            RETURN;
        END
        
        IF @Status NOT IN ('Scheduled', 'Completed', 'Cancelled')
        BEGIN
            RAISERROR('Invalid status value. Allowed values are: Scheduled, Completed, Cancelled.', 16, 1);
            RETURN;
        END
        
        -- Insert the new appointment
        INSERT INTO Appointment (AdminID, Doctor_ID, Patient_ID, Date, Time, Status, EmergencyFlag)
        VALUES (@AdminID, @DoctorID, @PatientID, @Date, @Time, @Status, @EmergencyFlag);

        -- Get the new Appointment_ID
        SET @Appointment_ID = SCOPE_IDENTITY();
        SET @message = 'Data inserted successfully';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;


        SET @Message = 'Error occurred during appointment insertion: ' + ERROR_MESSAGE();
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
    END CATCH
END
GO

-- Steps to run
-- For success insertion
DECLARE @Appointment_ID INT, @Message NVARCHAR(4000);
EXEC InsertNewAppointment 
    @AdminID = 1,               
    @DoctorID = 1,              
    @PatientID = 6,             
    @Date = '2025-04-17',      
    @Time = '10:30:00',       
    @Status = 'Scheduled',     
    @EmergencyFlag = 0,         
    @Appointment_ID = @Appointment_ID OUTPUT,
    @Message = @Message OUTPUT; 

SELECT @Appointment_ID AS NewAppointmentID, @Message AS Message;
GO

-- For error
DECLARE @Appointment_ID INT, @Message NVARCHAR(4000);
EXEC InsertNewAppointment 
    @AdminID = 1,               
    @DoctorID = 2,              
    @PatientID = 3,             
    @Date = '2025-04-17',      
    @Time = '10:30:00',       
    @Status = 'Coming',     
    @EmergencyFlag = 0,         
    @Appointment_ID = @Appointment_ID OUTPUT,
    @Message = @Message OUTPUT; 

SELECT @Appointment_ID AS NewAppointmentID, @Message AS Message;
SELECT * FROM Appointment;
GO
-- Run Trigger 1: PreventDuplicateAppointments then run this it gives error
DECLARE @Appointment_ID INT, @Message NVARCHAR(4000);
EXEC InsertNewAppointment 
    @AdminID = 1,               
    @DoctorID = 1,              
    @PatientID = 6,             
    @Date = '2025-04-17',      
    @Time = '10:30:00',       
    @Status = 'Scheduled',     
    @EmergencyFlag = 0,         
    @Appointment_ID = @Appointment_ID OUTPUT,
    @Message = @Message OUTPUT; 

SELECT @Appointment_ID AS NewAppointmentID, @Message AS Message;
SELECT * FROM Appointment;


-- Stored Procedure 3: Procedure to get the appointment details based on appointment id

DROP PROCEDURE IF EXISTS GetAppointmentDetails;
GO
CREATE PROCEDURE GetAppointmentDetails
    @Appointment_ID INT,
    @AppointmentDetails NVARCHAR(MAX) OUTPUT,
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Retrieve appointment details
        SELECT @AppointmentDetails = CONCAT(
            'Patient: ', P.FirstName, ' ', P.LastName,
            ', Date: ', A.Date, 
            ', Time: ', CONVERT(VARCHAR(8), A.Time, 108),
            ', Doctor: ', D.FirstName, ' ', D.LastName,
            ', Status: ', A.Status
        )
        FROM Appointment A
        JOIN Patient P ON A.Patient_ID = P.Patient_ID
        JOIN Doctor D ON A.Doctor_ID = D.Doctor_ID
        WHERE A.Appointment_ID = @Appointment_ID;
        
        IF @AppointmentDetails IS NULL
            SET @AppointmentDetails = 'Appointment not found';
        ELSE
            SET @AppointmentDetails = 'Appointment found: ' + @AppointmentDetails;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SET @Message = 'Error occurred during appointment retrieval: ' + ERROR_MESSAGE();
    END CATCH
END
GO
-- Steps to run
-- Success case
DECLARE @AppointmentDetails NVARCHAR(MAX), @Message NVARCHAR(4000);
EXEC GetAppointmentDetails 
    @Appointment_ID = 12, 
    @AppointmentDetails = @AppointmentDetails OUTPUT, 
    @Message = @Message OUTPUT;

SELECT @AppointmentDetails AS AppointmentInfo, @Message AS Message;
GO

-- Fail case
DECLARE @AppointmentDetails NVARCHAR(MAX), @Message NVARCHAR(4000);
EXEC GetAppointmentDetails 
    @Appointment_ID = 9999, 
    @AppointmentDetails = @AppointmentDetails OUTPUT, 
    @Message = @Message OUTPUT;

SELECT @AppointmentDetails AS AppointmentInfo, @Message AS Message;


-- Stored Procedure 4: UpdatePaymentStatus

DROP PROCEDURE IF EXISTS UpdatePaymentStatus;
GO
CREATE PROCEDURE UpdatePaymentStatus
    @PaymentID INT,
    @NewStatus VARCHAR(50),
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE Payment
        SET Payment_status = @NewStatus
        WHERE Payment_ID = @PaymentID;
        SET @Message = 'payment status update successful ';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        SET @Message = 'Error occurred during payment status update: ' + ERROR_MESSAGE();
    END CATCH
END
GO
 
-- Steps to run
-- success case
DECLARE @Message NVARCHAR(4000);
EXEC UpdatePaymentStatus 
    @PaymentID = 15, 
    @NewStatus = 'Completed',
    @Message = @Message OUTPUT;
SELECT @Message AS Message;
GO
DECLARE @Message NVARCHAR(4000);
EXEC UpdatePaymentStatus 
    @PaymentID = 15, 
    @NewStatus = 'yet_complet',
    @Message = @Message OUTPUT;
SELECT @Message AS Message;

-- Error case
--  Stored Procedure 5: Check availability of the doctor

DROP PROCEDURE IF EXISTS CheckDoctorAvailability;
GO
CREATE PROCEDURE CheckDoctorAvailability
    @Doctor_FullName VARCHAR(511), 
    @Appointment_Date DATE, 
    @Appointment_Time TIME,
    @IsAvailable BIT OUTPUT,
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Check if doctor is available
        IF EXISTS (
            SELECT 1 
            FROM Schedule s
            JOIN Doctor d ON s.Doctor_ID = d.Doctor_ID
            WHERE CONCAT(d.FirstName, ' ', d.LastName) = @Doctor_FullName 
            AND s.Date = @Appointment_Date 
            AND @Appointment_Time BETWEEN s.Start_time AND s.End_time
        )
        BEGIN
            SET @IsAvailable = 0;
        END
        ELSE
        BEGIN
            SET @IsAvailable = 1;
        END

        SET @message = 'Data retrived successfully';
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SET @Message = 'Error occurred during doctor availability check: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Steps to run
DECLARE @IsAvailable BIT, @Message NVARCHAR(4000);
EXEC CheckDoctorAvailability 
    @Doctor_FullName = 'John Doe', 
    @Appointment_Date = '2025-03-10', 
    @Appointment_Time = '09:45:00', 
    @IsAvailable = @IsAvailable OUTPUT,
    @Message = @Message OUTPUT;
SELECT @IsAvailable AS DoctorAvailability, @Message AS Message;
GO

DECLARE @IsAvailable BIT, @Message NVARCHAR(4000);
EXEC CheckDoctorAvailability 
    @Doctor_FullName = 'Robert Jones', 
    @Appointment_Date = '2025-03-11', 
    @Appointment_Time = '11:00:00', 
    @IsAvailable = @IsAvailable OUTPUT,
    @Message = @Message OUTPUT;
SELECT @IsAvailable AS DoctorAvailability, @Message AS Message;


--  Stored Procedure 6:  GetPaymentSummary

DROP PROCEDURE IF EXISTS GetPaymentSummary;
GO
CREATE PROCEDURE GetPaymentSummary
    @Patient_ID INT, 
    @TotalAmount DECIMAL(10, 2) OUTPUT,
    @Message NVARCHAR(4000) OUTPUT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

         -- Check if patient exists
        IF NOT EXISTS (SELECT 1 FROM Patient WHERE Patient_ID = @Patient_ID)
        BEGIN
            RAISERROR('Patient ID %d does not exist.', 16, 1, @Patient_ID);
        END

        SELECT @TotalAmount = SUM(Amount)
        FROM Payment
        WHERE Patient_ID = @Patient_ID;

        IF @TotalAmount IS NULL
            SET @TotalAmount = 0;

        SET @message = 'Data retrived successfully';

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;

        SET @Message = 'Error occurred during payment summary retrieval: ' + ERROR_MESSAGE();
    END CATCH
END
GO

-- Steps to run
-- Sucess case
DECLARE @TotalAmount DECIMAL(10, 2), @Message NVARCHAR(4000);
EXEC GetPaymentSummary 
    @Patient_ID = 9, 
    @TotalAmount = @TotalAmount OUTPUT, 
    @Message = @Message OUTPUT;

SELECT @TotalAmount AS TotalAmount, @Message AS Message;
GO
-- Error case
DECLARE @TotalAmount DECIMAL(10, 2), @Message NVARCHAR(4000);
EXEC GetPaymentSummary 
    @Patient_ID = 90, 
    @TotalAmount = @TotalAmount OUTPUT, 
    @Message = @Message OUTPUT;

SELECT @TotalAmount AS TotalAmount, @Message AS Message;

-- View 1: DoctorAppointmentSummary between certain dates

DROP VIEW IF EXISTS DoctorAppointmentSummary;
GO
CREATE VIEW DoctorAppointmentSummary AS
SELECT 
    D.FirstName + ' ' + D.LastName AS DoctorFullName,
    P.FirstName + ' ' + P.LastName AS PatientFullName,
    A.Date AS AppointmentDate,
    A.Time AS AppointmentTime,
    A.Status AS AppointmentStatus
FROM 
    Appointment A
JOIN Doctor D ON A.Doctor_ID = D.Doctor_ID
JOIN Patient P ON A.Patient_ID = P.Patient_ID;
GO

-- Steps to run
SELECT * 
FROM DoctorAppointmentSummary
WHERE DoctorFullName = 'John Doe'
AND AppointmentDate BETWEEN '2025-03-01' AND '2025-04-30';

GO
-- View 2: ViewPatientAppointments
DROP VIEW IF EXISTS ViewPatientAppointments;
GO
CREATE VIEW ViewPatientAppointments AS
SELECT P.FirstName, P.LastName, A.Date, A.Time, A.Status, A.EmergencyFlag
FROM Patient P
JOIN Appointment A ON P.Patient_ID = A.Patient_ID;
GO
-- Steps to run
select TOP 5 * from ViewPatientAppointments;

-- View 3: ViewPaymentSummary
DROP VIEW IF EXISTS ViewPaymentSummary;
GO
CREATE VIEW ViewPaymentSummary AS
SELECT P.FirstName, P.LastName, Pay.Amount, Pay.Payment_status
FROM Patient P
JOIN Payment Pay ON P.Patient_ID = Pay.Patient_ID;
GO
-- Steps to run
select * from ViewPaymentSummary;

-- View 4: MonthlyAppointmentSummary
DROP VIEW IF EXISTS  MonthlyAppointmentSummary;
GO
CREATE VIEW MonthlyAppointmentSummary AS
SELECT 
    D.FirstName + ' ' + D.LastName AS DoctorFullName,
    YEAR(A.Date) AS AppointmentYear,
    MONTH(A.Date) AS AppointmentMonth,
    COUNT(A.Appointment_ID) AS TotalAppointments
FROM 
    Appointment A
JOIN Doctor D ON A.Doctor_ID = D.Doctor_ID
GROUP BY 
    D.Doctor_ID, D.FirstName, D.LastName, YEAR(A.Date), MONTH(A.Date);
GO
-- Steps to run
SELECT * 
FROM MonthlyAppointmentSummary
WHERE DoctorFullName = 'John Doe' 
AND AppointmentYear = 2025
AND AppointmentMonth = 3;

-- View 5: EmergencyAppointments
DROP VIEW IF EXISTS EmergencyAppointments;
GO
CREATE VIEW EmergencyAppointments AS
SELECT 
    A.Appointment_ID,
    P.FirstName + ' ' + P.LastName AS PatientFullName,
    D.FirstName + ' ' + D.LastName AS DoctorFullName,
    A.Date AS AppointmentDate,
    A.Time AS AppointmentTime,
    A.Status AS AppointmentStatus
FROM 
    Appointment A
JOIN Patient P ON A.Patient_ID = P.Patient_ID
JOIN Doctor D ON A.Doctor_ID = D.Doctor_ID
WHERE A.EmergencyFlag = 1;
GO
-- Steps to run
SELECT * 
FROM EmergencyAppointments
WHERE AppointmentDate BETWEEN '2025-03-01' AND '2025-04-30';

-- User-Defined Function 1:GetDoctorSpecializations based on id
DROP FUNCTION IF EXISTS GetDoctorSpecializations;
GO
CREATE FUNCTION GetDoctorSpecializations(@DoctorID INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
    DECLARE @Specializations VARCHAR(MAX);
    
    SELECT @Specializations = STRING_AGG(S.Specialization_Name, ', ') 
    FROM Doctor_Specialization DS
    JOIN Specialization S ON DS.Specialization_ID = S.Specialization_ID
    WHERE DS.Doctor_ID = @DoctorID;
    
    RETURN @Specializations;
END
GO
-- Steps to run
SELECT dbo.GetDoctorSpecializations(1) AS DoctorSpecializations;

-- User-Defined Function 2: CalculateAge
DROP FUNCTION IF EXISTS  CalculateAge;
GO
CREATE FUNCTION CalculateAge(@DOB DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @DOB, GETDATE());
END
GO
-- Steps to run
SELECT dbo.CalculateAge('2000-04-30') AS CalculateAge;

-- User-Defined Function 3: GetAppointmentCount
DROP FUNCTION IF EXISTS GetAppointmentCount;
GO
CREATE FUNCTION GetAppointmentCount(@PatientID INT)
RETURNS INT
AS
BEGIN
    RETURN (SELECT COUNT(*) FROM Appointment WHERE Patient_ID = @PatientID);
END
GO
-- Steps to run
SELECT dbo.GetAppointmentCount(7) AS GetAppointmentCount;

-- User-Defined Function 4 : Check if a Patient Has an Active Appointment
DROP FUNCTION IF EXISTS HasActiveAppointment;
GO
CREATE FUNCTION dbo.HasActiveAppointment(@PatientID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @HasAppointment BIT;
    
    IF EXISTS (
        SELECT 1
        FROM Appointment A
        WHERE A.Patient_ID = @PatientID
          AND A.Status = 'Scheduled'
          AND A.Date = CAST(GETDATE() AS DATE)
    )
    BEGIN
        SET @HasAppointment = 1;
    END
    ELSE
    BEGIN
        SET @HasAppointment = 0;
    END
    
    RETURN @HasAppointment;
END
GO
-- Steps to run
SELECT dbo.HasActiveAppointment(10) AS HasActiveAppointment;

-- User-Defined Function 4 : GetLastMedicalRecord 
DROP FUNCTION IF EXISTS GetLastMedicalRecord
GO
CREATE FUNCTION dbo.GetLastMedicalRecord (@PatientID INT)
RETURNS NVARCHAR(500)
AS
BEGIN
    DECLARE @LastRecord NVARCHAR(500);

    SELECT TOP 1 
        @LastRecord = CONCAT(
            'Diagnosis: ', D.Diagnosis_description, 
            ', Medication: ', P.Medication_name, 
            ', Dosage: ', P.Dosage,
            ', Directions: ', P.Direction)
    FROM Medical_Record MR
    LEFT JOIN Diagnosis D ON MR.Medical_History_ID = D.Medical_History_ID
    LEFT JOIN Prescription P ON MR.Medical_History_ID = P.Medical_History_ID
    WHERE MR.Patient_ID = @PatientID
    ORDER BY MR.Date DESC;

    -- Return the result, or a default message if no records are found
    RETURN ISNULL(@LastRecord, 'No records found.');
END
GO
-- Steps to run
SELECT dbo.GetLastMedicalRecord(2) AS GetLastMedicalRecord;

-- User-Defined Function 5 : GetPatientCountForDoctor
DROP FUNCTION IF EXISTS  dbo.GetPatientCountForDoctor;
GO
CREATE FUNCTION dbo.GetPatientCountForDoctor (@DoctorID INT)
RETURNS INT
AS
BEGIN
    DECLARE @PatientCount INT;

    SELECT @PatientCount = COUNT(DISTINCT Patient_ID)
    FROM Appointment
    WHERE Doctor_ID = @DoctorID;

    RETURN @PatientCount;
END
GO
-- Steps to run
SELECT dbo.GetPatientCountForDoctor(1) AS GetPatientCountForDoctor;

-- Trigger 1: PreventDuplicateAppointments

DROP TRIGGER IF EXISTS PreventDuplicateAppointments;
GO
CREATE TRIGGER PreventDuplicateAppointments
ON Appointment
FOR INSERT
AS
BEGIN
    -- Check if a duplicate appointment exists for each inserted row
    IF EXISTS (
        SELECT 1
        FROM Appointment A
        JOIN inserted I
            ON A.Patient_ID = I.Patient_ID
            AND A.Doctor_ID = I.Doctor_ID
            AND A.Date = I.Date
            AND A.Time = I.Time -- Check both Date and Time
        WHERE A.Appointment_ID != I.Appointment_ID -- Ensure not comparing to the same row
    )
    BEGIN
        -- Raise an error if a duplicate is found
        RAISERROR ('Duplicate appointment found for the same patient, doctor, date, and time.', 16, 1);
        ROLLBACK TRANSACTION; -- Prevent insertion
    END
END;
GO
-- Steps to run
-- Try inserting an appointment then insert the same duplicate appointment
INSERT INTO Appointment (AdminID, Doctor_ID, Patient_ID, Date, Time, Status, EmergencyFlag)
VALUES (1, 1, 1, '2025-04-15', '10:00', 'Scheduled', 0); 
-- Try inserting duplicate appointments will be blocked with a message
INSERT INTO Appointment (AdminID, Doctor_ID, Patient_ID, Date, Time, Status, EmergencyFlag)
VALUES (1, 1, 1, '2025-04-15', '10:00', 'Scheduled', 0); 

-- Trigger 2: Audit_Payment upon payment status change record inserted into Audit payment table
DROP TABLE IF EXISTS Audit_Payment;
GO
CREATE TABLE Audit_Payment (
    Audit_ID INT IDENTITY PRIMARY KEY,
    Payment_ID INT,
    Old_Status VARCHAR(50),
    New_Status VARCHAR(50),
    Change_Date DATETIME DEFAULT GETDATE()
);
GO
DROP TRIGGER IF EXISTS trg_AuditPaymentUpdate;
GO
CREATE TRIGGER trg_AuditPaymentUpdate
ON Payment
FOR UPDATE
AS
BEGIN
    DECLARE @OldStatus VARCHAR(50), @NewStatus VARCHAR(50);
    
    SELECT @OldStatus = Payment_status FROM deleted;
    SELECT @NewStatus = Payment_status FROM inserted;
    
    IF @OldStatus <> @NewStatus
    BEGIN
        INSERT INTO Audit_Payment (Payment_ID, Old_Status, New_Status)
        SELECT Payment_ID, @OldStatus, @NewStatus FROM inserted;
    END
END;
GO
-- Steps to run
UPDATE Payment 
SET Payment_status = 'Completed'
WHERE Payment_ID = 10;

select * from payment;
select * from Audit_Payment;


-- Trigger 3: Trigger for inserting Notification upon Appointment creation
DROP TRIGGER IF EXISTS trg_InsertNotification;
GO
CREATE TRIGGER trg_InsertNotification
ON Appointment
FOR INSERT
AS
BEGIN
    DECLARE @Appointment_ID INT, @Patient_ID INT, @Doctor_ID INT, @Date DATE, @Time TIME, @AdminID INT;

    SELECT @Appointment_ID = Appointment_ID, @Patient_ID = Patient_ID, @Doctor_ID = Doctor_ID, 
           @Date = Date, @Time = Time, @AdminID = AdminID
    FROM inserted;

    INSERT INTO Notification (Appointment_ID, Type, Sent_time, Status)
    VALUES (@Appointment_ID, 'Alert', GETDATE(), 'Sent');
END;
GO
-- Steps to run
select * from appointment;
select * from notification;
GO
-- Insert a new appointment
INSERT INTO Appointment (AdminID, Doctor_ID, Patient_ID, Date, Time, Status, EmergencyFlag)
VALUES (1, 1, 1, '2025-04-18', '11:00:00', 'Scheduled', 0);
select * from appointment;
select * from notification;
-- Trigger 4: ValidateAppointmentDate
DROP TRIGGER IF EXISTS trg_ValidateAppointmentDate;
GO
CREATE TRIGGER trg_ValidateAppointmentDate
ON Appointment
FOR INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Check if any appointments have past dates (unless they're "Completed" or "Cancelled")
    IF EXISTS (
        SELECT 1
        FROM inserted
        WHERE Date < CAST(GETDATE() AS DATE)
        AND Status = 'Scheduled'
    )
    BEGIN
        RAISERROR('Cannot schedule appointments in the past.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- steps to run
-- Attempt to insert a new scheduled appointment with a past date
INSERT INTO Appointment (AdminID, Doctor_ID, Patient_ID, Date, Time, Status, EmergencyFlag)
VALUES (1, 1, 1, '2022-01-01', '11:00:00', 'Scheduled', 0);

-- Trigger 5: EnforcePaymentStatusFlow
DROP TRIGGER IF EXISTS trg_EnforcePaymentStatusFlow;
GO
CREATE TRIGGER trg_EnforcePaymentStatusFlow
ON Payment
FOR UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Cannot change status from "Completed" to "Pending"
    IF EXISTS (
        SELECT 1
        FROM deleted d
        JOIN inserted i ON d.Payment_ID = i.Payment_ID
        WHERE d.Payment_status = 'Completed'
        AND i.Payment_status = 'Pending'
    )
    BEGIN
        RAISERROR('Cannot change payment status from "Completed" to "Pending".', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

-- Steps to run
-- Attempt to update the payment status from "Completed" to "Pending"
UPDATE Payment
SET Payment_status = 'Pending'
WHERE Payment_ID = 1;
