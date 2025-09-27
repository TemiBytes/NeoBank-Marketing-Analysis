/*

=======================================================================
Create Database and Schemas
=======================================================================

Script Purpose:
  This script creates a new database called 'NeoBank' after checking if it already exists.
  If the database exists, it is dropped and then recreated.
  Then the script goes ahead to set up a schema within the database

  
WARNING ⚠️

    Running this script will drop the entire 'neobank' database if it exists.
    As a result, all data in the database will be permanently deleted. So please proceed with caution 
    and ensure you have proper backups before running this script.

*/

-- create Database 'NeoBank'


USE master;
GO

-- Drop and recreate the 'NeoBank' database
IF EXISTS(SELECT 1 FROM sys.databases WHERE name='NeoBank')
BEGIN
   ALTER DATABASE NeoBank SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
   DROP DATABASE NeoBank;
END;
GO

-- create the 'NeoBank' database

CREATE DATABASE NeoBank;
GO

USE NeoBank;
GO

-- create Schema 'neo'

CREATE SCHEMA neo;
GO


