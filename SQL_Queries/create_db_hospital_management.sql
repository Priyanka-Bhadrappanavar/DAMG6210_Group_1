IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'FINAL_HOS_MNG')
BEGIN
    CREATE DATABASE FINAL_HOS_MNG;
END
GO

USE FINAL_HOS_MNG;
GO