USE FINAL_HOS_MNG;
GO

INSERT INTO Specialization (Specialization_Name) VALUES
('Cardiologist'),
('Dermatologist'),
('Orthopedist'),
('Pediatrician'),
('Neurologist'),
('Oncologist'),
('ENT Specialist'),
('Ophthalmologist'),
('Urologist'),
('Endocrinologist'),
('Gastroenterologist'),
('Rheumatologist'),
('Psychiatrist'),
('Gynecologist'),
('Radiologist');

INSERT INTO Department (Name, Description) VALUES
('Cardiology', 'Deals with heart-related issues'),
('Dermatology', 'Deals with skin-related issues'),
('Orthopedics', 'Deals with bone and joint-related issues'),
('Pediatrics', 'Deals with children''s health'),
('Neurology', 'Deals with nervous system-related issues'),
('Oncology', 'Deals with cancer treatment'),
('ENT', 'Deals with ear, nose, and throat issues'),
('Ophthalmology', 'Deals with eye-related issues'),
('Urology', 'Deals with urinary system issues'),
('Endocrinology', 'Deals with hormonal disorders'),
('Gastroenterology', 'Deals with digestive system issues'),
('Rheumatology', 'Deals with joint and autoimmune disorders'),
('Psychiatry', 'Deals with mental health issues'),
('Gynecology', 'Deals with female reproductive health'),
('Radiology', 'Deals with medical imaging');


INSERT INTO Doctor (Department_ID, FirstName, LastName, Contact, Availability) VALUES
(1, 'John', 'Doe', '123-456-7890', 'Mon-Fri'),
(2, 'Jane', 'Smith', '987-654-3210', 'Tue-Sat'),
(3, 'Robert', 'Jones', '555-123-4567', 'Mon-Wed'),
(4, 'Emily', 'Brown', '111-222-3333', 'Thu-Sun'),
(5, 'Michael', 'Davis', '444-555-6666', 'Mon-Fri'),
(6, 'Ashley', 'Wilson', '777-888-9999', 'Tue-Sat'),
(7, 'David', 'Garcia', '123-789-4560', 'Mon-Wed'),
(8, 'Jennifer', 'Rodriguez', '987-321-6540', 'Thu-Sun'),
(9, 'Christopher', 'Martinez', '555-678-1234', 'Mon-Fri'),
(10, 'Jessica', 'Anderson', '111-444-7777', 'Tue-Sat'),
(11, 'Olivia', 'Taylor', '555-678-2345', 'Mon-Fri'),
(12, 'Ethan', 'Walker', '123-987-6543', 'Tue-Sat'),
(13, 'Sophia', 'Miller', '555-234-9876', 'Mon-Wed'),
(14, 'James', 'Davis', '111-333-7777', 'Thu-Sun'),
(15, 'Benjamin', 'Clark', '444-777-5555', 'Mon-Fri');

INSERT INTO Schedule (Doctor_ID, Date, Start_time, End_time, Status) VALUES
(1, '2025-03-10', '09:00', '09:30', 'Completed'),
(2, '2025-03-10', '10:00', '10:30', 'Completed'),
(3, '2025-03-11', '11:00', '11:30', 'Completed'),
(1, '2025-03-11', '13:00', '13:30', 'Completed'),
(2, '2025-03-12', '14:00', '14:30', 'Completed'),
(3, '2025-03-12', '15:00', '15:30', 'Completed'),
(1, '2025-03-13', '09:00', '09:30', 'Completed'),
(2, '2025-03-13', '10:00', '10:30', 'Completed'),
(3, '2025-03-14', '11:00', '11:30', 'Completed'),
(1, '2025-03-14', '13:00', '13:30', 'Completed'),
(11, '2025-04-25', '08:30', '09:00', 'Scheduled'),
(12, '2025-04-26', '09:30', '10:00', 'Scheduled'),
(13, '2025-04-27', '11:00', '11:30', 'Scheduled'),
(14, '2025-04-28', '13:30', '14:00', 'Scheduled'),
(15, '2025-04-29', '14:30', '15:00', 'Scheduled');

INSERT INTO Doctor_Specialization (Specialization_ID, Doctor_ID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10),
(11, 11),
(12, 12),
(13, 13),
(14, 14),
(15, 15);


INSERT INTO Admin (PermissionLevel, FirstName, LastName, Role, Contact, Email) VALUES
(1, 'Sarah', 'Johnson', 'Administrator', '123-456-0000', 'sarah.j@email.com'),
(2, 'Tom', 'Williams', 'Manager', '987-654-0001', 'tom.w@email.com'),
(1, 'Linda', 'Brown', 'Administrator', '555-123-0002', 'linda.b@email.com'),
(2, 'Kevin', 'Miller', 'Manager', '111-222-0003', 'kevin.m@email.com'),
(1, 'Amy', 'Davis', 'Administrator', '444-555-0004', 'amy.d@email.com'),
(2, 'Ryan', 'Wilson', 'Manager', '777-888-0005', 'ryan.w@email.com'),
(1, 'Laura', 'Garcia', 'Administrator', '123-789-0006', 'laura.g@email.com'),
(2, 'Brian', 'Rodriguez', 'Manager', '987-321-0007', 'brian.r@email.com'),
(1, 'Melissa', 'Martinez', 'Administrator', '555-678-0008', 'melissa.m@email.com'),
(2, 'Eric', 'Anderson', 'Manager', '111-444-0009', 'eric.a@email.com'),
(1, 'Rachel', 'Adams', 'Administrator', '123-987-6542', 'rachel.a@email.com'),
(2, 'Lucas', 'Taylor', 'Manager', '555-321-8765', 'lucas.t@email.com');

INSERT INTO Patient (FirstName, LastName, DOB, Contact, Email) VALUES
('Karen', 'Hernandez', '1990-05-15', '123-456-1111', 'karen.h@email.com'),
('George', 'Lopez', '1985-12-20', '987-654-1112', 'george.l@email.com'),
('Michelle', 'Young', '1992-03-10', '555-123-1113', 'michelle.y@email.com'),
('Brandon', 'Hall', '1988-08-25', '111-222-1114', 'brandon.h@email.com'),
('Stephanie', 'Allen', '1995-01-05', '444-555-1115', 'stephanie.a@email.com'),
('Jose', 'Wright', '1983-06-30', '777-888-1116', 'jose.w@email.com'),
('Nicole', 'King', '1991-11-12', '123-789-1117', 'nicole.k@email.com'),
('Timothy', 'Scott', '1987-04-18', '987-321-1118', 'timothy.s@email.com'),
('Katherine', 'Green', '1994-09-01', '555-678-1119', 'katherine.g@email.com'),
('Billy', 'Baker', '1986-02-28', '111-444-1120', 'billy.b@email.com'),
('Liam', 'Martinez', '1989-06-10', '555-987-6543', 'liam.m@email.com'),
('Zoe', 'Wilson', '1990-02-12', '123-555-7890', 'zoe.w@email.com'),
('Mason', 'Moore', '1993-04-15', '555-444-2222', 'mason.m@email.com'),
('Ava', 'Jackson', '1987-08-07', '987-555-1111', 'ava.j@email.com'),
('Ella', 'White', '1994-11-20', '555-333-4444', 'ella.w@email.com');


INSERT INTO Appointment (AdminID, Doctor_ID, Patient_ID, Date, Time, Status, EmergencyFlag) VALUES
(1, 1, 1, '2025-03-15', '10:00', 'Completed', 0),
(2, 2, 2, '2025-03-16', '11:30', 'Completed', 0),
(1, 3, 3, '2025-03-17', '14:00', 'Completed', 1),
(2, 4, 4, '2025-03-18', '09:00', 'Completed', 0),
(1, 5, 5, '2025-03-19', '13:00', 'Completed', 0),
(2, 6, 6, '2025-03-20', '15:30', 'Completed', 1),
(1, 7, 7, '2025-03-21', '10:30', 'Completed', 0),
(2, 8, 8, '2025-03-22', '12:00', 'Completed', 0),
(1, 9, 9, '2025-03-23', '14:30', 'Completed', 1),
(2, 10, 10, '2025-03-24', '09:30', 'Completed', 0),
(2, 1, 10, '2025-03-30', '09:30', 'Completed', 0),
(1, 11, 1, '2025-04-26', '10:00', 'Scheduled', 0),
(2, 12, 2, '2025-04-27', '11:30', 'Scheduled', 0),
(1, 13, 3, '2025-04-28', '14:00', 'Scheduled', 0),
(2, 14, 4, '2025-04-29', '09:00', 'Scheduled', 0),
(1, 15, 5, '2025-04-30', '13:00', 'Scheduled', 0);


INSERT INTO Notification (Appointment_ID, Type, Sent_time, Status) VALUES
(1, 'Reminder', '2025-03-15 10:00', 'Sent'),
(2, 'Reminder', '2025-03-15 11:30', 'Sent'),
(3, 'Alert', '2025-03-16 14:00', 'Sent'),
(4, 'Reminder', '2025-03-17 09:00', 'Sent'),
(5, 'Reminder', '2025-03-18 13:00', 'Sent'),
(6, 'Alert', '2025-03-19 15:30', 'Sent'),
(7, 'Reminder', '2025-03-20 10:30', 'Sent'),
(8, 'Reminder', '2025-03-21 12:00', 'Sent'),
(9, 'Alert', '2025-03-22 14:30', 'Sent'),
(10, 'Reminder', '2025-03-23 09:30', 'Sent'),
(11, 'Reminder', '2025-04-19 10:00', 'Sent'),
(12, 'Alert', '2025-04-20 11:30', 'Sent'),
(13, 'Reminder', '2025-04-21 14:00', 'Sent'),
(14, 'Alert', '2025-04-22 09:00', 'Sent'),
(15, 'Reminder', '2025-04-23 13:00', 'Sent');

INSERT INTO Medical_Record (Patient_ID, Test_results, Date) VALUES
(1, 'Normal', '2025-03-01'),
(2, 'Elevated cholesterol', '2025-03-02'),
(3, 'Low iron', '2025-03-03'),
(4, 'Normal', '2025-03-04'),
(5, 'High blood pressure', '2025-03-05'),
(6, 'Normal', '2025-03-06'),
(7, 'Allergic reaction', '2025-03-07'),
(8, 'Normal', '2025-03-08'),
(9, 'Possible infection', '2025-03-09'),
(10, 'Normal', '2025-03-10'),
(11, 'Normal', '2025-03-10'),
(12, 'Elevated blood sugar', '2025-03-11'),
(13, 'Low vitamin D', '2025-03-12'),
(14, 'Normal', '2025-03-13'),
(15, 'Anemia', '2025-03-14');


INSERT INTO Emergency_Case (Medical_History_ID, Assigned_Doctor_ID, Assigned_Admin_ID, Prescription, Test_results, Date) VALUES
(1, 1, 1, 'Rest and fluids', 'Normal', '2025-03-10'),
(2, 2, 2, 'Medication for cholesterol', 'Elevated cholesterol', '2025-03-6'),
(3, 3, 1, 'Iron supplements', 'Low iron', '2025-03-7'),
(4, 4, 2, 'Rest and fluids', 'Normal', '2025-03-8'),
(5, 5, 1, 'Blood pressure medication', 'High blood pressure', '2025-03-9'),
(6, 6, 2, 'Rest and fluids', 'Normal', '2025-03-10'),
(7, 7, 1, 'Antihistamines', 'Allergic reaction', '2025-03-1'),
(8, 8, 2, 'Rest and fluids', 'Normal', '2025-03-2'),
(9, 9, 1, 'Antibiotics', 'Possible infection', '2025-03-3'),
(10, 10, 2, 'Rest and fluids', 'Normal', '2025-03-4'),
(11, 11, 1, 'Rest and fluids', 'Normal', '2025-03-15'),
(12, 12, 2, 'Medication for blood sugar', 'Elevated blood sugar', '2025-03-16'),
(13, 13, 1, 'Vitamin D supplements', 'Low vitamin D', '2025-03-17'),
(14, 14, 2, 'Rest and fluids', 'Normal', '2025-03-18'),
(15, 15, 1, 'Iron supplements', 'Anemia', '2025-03-19');


INSERT INTO Payment (Patient_ID, Amount, Payment_status, Payment_type, Appointment_ID, Emergency_ID) VALUES
(1, 100.00, 'Completed', 'Card', 1, 1),
(2, 150.00, 'Completed', 'Card', 2, 2),
(3, 200.00, 'Completed', 'Card', 3, 3),
(4, 100.00, 'Completed', 'Card', 4, 4),
(5, 150.00, 'Completed', 'Card', 5, 5),
(6, 200.00, 'Pending', 'Card', 6, 6),
(7, 100.00, 'Completed', 'Card', 7, 7),
(8, 150.00, 'Completed', 'Card', 8, 8),
(9, 200.00, 'Completed', 'Card', 9, 9),
(10, 100.00, 'Pending', 'Card', 10, 10),
(11, 120.00, 'Completed', 'Card', 11, 11),
(12, 180.00, 'Pending', 'Card', 12, 12),
(13, 160.00, 'Completed', 'Cash', 13, 13),
(14, 130.00, 'Completed', 'Insurance', 14, 14),
(15, 200.00, 'Pending', 'Card', 15, 15);

INSERT INTO Diagnosis (Medical_History_ID, Diagnosis_description) VALUES
(1, 'Healthy checkup'),
(2, 'High cholesterol levels'),
(3, 'Anemia'),
(4, 'Routine checkup'),
(5, 'Hypertension'),
(6, 'General wellness check'),
(7, 'Skin rash and itching'),
(8, 'Standard examination'),
(9, 'Bacterial infection'),
(10, 'Annual physical'),
(11, 'Healthy checkup'),
(12, 'Pre-diabetes'),
(13, 'Vitamin D deficiency'),
(14, 'Routine checkup'),
(15, 'Iron deficiency');

INSERT INTO Prescription (Medical_History_ID, Medication_name, Dosage, Direction) VALUES
(1, 'None', 'N/A', 'N/A'),
(2, 'Lipitor', '20mg', 'Once daily'),
(3, 'Iron supplements', '325mg', 'Twice daily'),
(4, 'None', 'N/A', 'N/A'),
(5, 'Amlodipine', '5mg', 'Once daily'),
(6, 'None', 'N/A', 'N/A'),
(7, 'Benadryl', '25mg', 'Every 6 hours'),
(8, 'None', 'N/A', 'N/A'),
(9, 'Amoxicillin', '500mg', 'Three times daily'),
(10, 'None', 'N/A', 'N/A'),
(11, 'None', 'N/A', 'N/A'),
(12, 'Metformin', '500mg', 'Once daily'),
(13, 'Vitamin D supplements', '1000 IU', 'Once daily'),
(14, 'None', 'N/A', 'N/A'),
(15, 'Iron supplements', '325mg', 'Once daily');

INSERT INTO PaymentMethod (MethodName) VALUES
('Card'),
('Cash'),
('Insurance'),
('Online Transfer'),
('Check'),
('Mobile Payment'),
('Health Savings Account'),
('Credit Card'),
('Debit Card'),
('Voucher'),
('Bank Transfer'),
('Cash on Delivery'),
('Gift Card'),
('Cryptocurrency'),
('Apple Pay');


INSERT INTO Payment_PaymentMethod (PaymentMethod_ID, Payment_ID, Amount) VALUES
(1, 1, 100.00),
(2, 2, 150.00),
(3, 3, 200.00),
(4, 4, 100.00),
(5, 5, 150.00),
(6, 6, 200.00),
(7, 7, 100.00),
(8, 8, 150.00),
(9, 9, 200.00),
(10, 10, 100.00),
(1, 11, 120.00),
(2, 12, 180.00),
(3, 13, 160.00),
(4, 14, 130.00),
(5, 15, 200.00);
