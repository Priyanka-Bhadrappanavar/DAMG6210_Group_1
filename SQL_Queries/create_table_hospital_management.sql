USE FINAL_HOS_MNG;
GO

IF OBJECT_ID('dbo.Payment_PaymentMethod', 'U') IS NOT NULL
    DROP TABLE dbo.Payment_PaymentMethod;
GO

IF OBJECT_ID('dbo.PaymentMethod', 'U') IS NOT NULL
    DROP TABLE dbo.PaymentMethod;
GO

IF OBJECT_ID('dbo.Payment', 'U') IS NOT NULL
    DROP TABLE dbo.Payment;
GO

IF OBJECT_ID('dbo.Notification', 'U') IS NOT NULL
    DROP TABLE dbo.Notification;
GO

IF OBJECT_ID('dbo.Emergency_Case', 'U') IS NOT NULL
    DROP TABLE dbo.Emergency_Case;
GO

IF OBJECT_ID('dbo.Diagnosis', 'U') IS NOT NULL
    DROP TABLE dbo.Diagnosis;
GO

IF OBJECT_ID('dbo.Prescription', 'U') IS NOT NULL
    DROP TABLE dbo.Prescription;
GO

IF OBJECT_ID('dbo.Appointment', 'U') IS NOT NULL
    DROP TABLE dbo.Appointment;
GO

IF OBJECT_ID('dbo.Doctor_Specialization', 'U') IS NOT NULL
    DROP TABLE dbo.Doctor_Specialization;
GO

IF OBJECT_ID('dbo.Schedule', 'U') IS NOT NULL
    DROP TABLE dbo.Schedule;
GO

IF OBJECT_ID('dbo.Medical_Record', 'U') IS NOT NULL
    DROP TABLE dbo.Medical_Record;
GO

IF OBJECT_ID('dbo.Doctor', 'U') IS NOT NULL
    DROP TABLE dbo.Doctor;
GO

IF OBJECT_ID('dbo.Specialization', 'U') IS NOT NULL
    DROP TABLE dbo.Specialization;
GO

IF OBJECT_ID('dbo.Admin', 'U') IS NOT NULL
    DROP TABLE dbo.Admin;
GO

IF OBJECT_ID('dbo.Patient', 'U') IS NOT NULL
    DROP TABLE dbo.Patient;
GO

IF OBJECT_ID('dbo.Department', 'U') IS NOT NULL
    DROP TABLE dbo.Department;
GO

CREATE TABLE Specialization (
    Specialization_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Specialization_Name VARCHAR(255) NOT NULL
);

CREATE TABLE Department (
    Department_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Name VARCHAR(255) NOT NULL,
    Description TEXT
);

CREATE TABLE Doctor (
    Doctor_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
    Department_ID INT NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Contact VARCHAR(20) UNIQUE,
    Availability VARCHAR(50),
    CHECK (LEN(Contact) = 10 OR LEN(Contact) = 12),
    FOREIGN KEY (Department_ID) REFERENCES Department(Department_ID)
);

CREATE TABLE Schedule (
    Schedule_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Doctor_ID INT NOT NULL,
    Date DATE NOT NULL,
    Start_time TIME NOT NULL,
    End_time TIME NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')), 
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID),
);

CREATE TABLE Doctor_Specialization (
    Specialization_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    PRIMARY KEY (Specialization_ID, Doctor_ID),
    FOREIGN KEY (Specialization_ID) REFERENCES Specialization(Specialization_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID)
);

CREATE TABLE Admin (
    Admin_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    PermissionLevel INT NOT NULL,
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    Role VARCHAR(255),
    Contact VARCHAR(20) UNIQUE,
    Email VARCHAR(255) UNIQUE,
    CHECK (LEN(Contact) = 10 OR LEN(Contact) = 12)
);

CREATE TABLE Patient (
    Patient_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    FirstName VARCHAR(255) NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    DOB DATE,
    Contact VARCHAR(20) UNIQUE,
    Email VARCHAR(255) UNIQUE,
    CHECK (LEN(Contact) = 10 OR LEN(Contact) = 12)
);

CREATE TABLE Appointment (
    Appointment_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    AdminID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Patient_ID INT NOT NULL,
    Date DATE NOT NULL,
    Time TIME NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Scheduled', 'Completed', 'Cancelled')), 
    EmergencyFlag BIT,
    FOREIGN KEY (AdminID) REFERENCES Admin(Admin_ID),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctor(Doctor_ID),
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    CHECK (Date >= GETDATE())
);

CREATE TABLE Notification (
    Notification_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Appointment_ID INT NOT NULL,
    Type VARCHAR(255),
    Sent_time DATETIME,
    Status VARCHAR(50),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID)
);

CREATE TABLE Medical_Record (
    Medical_History_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Patient_ID INT NOT NULL,
    Test_results TEXT,
    Date DATE,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID)
);

CREATE TABLE Emergency_Case (
    Emergency_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Medical_History_ID INT NOT NULL,
    Assigned_Doctor_ID INT NOT NULL,
    Assigned_Admin_ID INT NOT NULL,
    Prescription TEXT,
    Test_results TEXT,
    Date DATE,
    FOREIGN KEY (Medical_History_ID) REFERENCES Medical_Record(Medical_History_ID),
    FOREIGN KEY (Assigned_Doctor_ID) REFERENCES Doctor(Doctor_ID),
    FOREIGN KEY (Assigned_Admin_ID) REFERENCES Admin(Admin_ID),
    CHECK (Date <= GETDATE())
);

CREATE TABLE Payment (
    Payment_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Patient_ID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL CHECK (Amount > 0),  
    Payment_status VARCHAR(50) CHECK (Payment_status IN ('Pending', 'Completed', 'Failed')), 
    Payment_type VARCHAR(50),
    Appointment_ID INT,
    Emergency_ID INT,
    FOREIGN KEY (Patient_ID) REFERENCES Patient(Patient_ID),
    FOREIGN KEY (Appointment_ID) REFERENCES Appointment(Appointment_ID),
    FOREIGN KEY (Emergency_ID) REFERENCES Emergency_Case(Emergency_ID)
);

CREATE TABLE Diagnosis (
    Diagnosis_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Medical_History_ID INT NOT NULL,
    Diagnosis_description TEXT,
    FOREIGN KEY (Medical_History_ID) REFERENCES Medical_Record(Medical_History_ID)
);

CREATE TABLE Prescription (
    Prescription_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  
    Medical_History_ID INT NOT NULL,
    Medication_name VARCHAR(255),
    Dosage VARCHAR(255),
    Direction TEXT,
    FOREIGN KEY (Medical_History_ID) REFERENCES Medical_Record(Medical_History_ID)
);

CREATE TABLE PaymentMethod (
    PaymentMethod_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,
    MethodName VARCHAR(255) NOT NULL
);

CREATE TABLE Payment_PaymentMethod (
    PaymentMethod_ID INT NOT NULL,
    Payment_ID INT NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (PaymentMethod_ID, Payment_ID),
    FOREIGN KEY (PaymentMethod_ID) REFERENCES PaymentMethod(PaymentMethod_ID),
    FOREIGN KEY (Payment_ID) REFERENCES Payment(Payment_ID)
);
