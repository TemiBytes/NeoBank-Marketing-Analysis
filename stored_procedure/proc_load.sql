/*
============================================================
Stored Procedure: Load Data 
============================================================

Script Purpose:
  This stored procedure loads data into the 'neo' schema from external CSV files.
  It performs the following actions:
  - Truncates the tables before loading data.
  - Uses the BULK INSERT command to load data from CSV files to tables

Parameters:
  None.
  This stored procedure does not accept any parameters or return any values.

How to use this stored procedure:
    EXEC neo.load_bronze;

===================================================================

*/

CREATE OR ALTER PROCEDURE neo.load_bronze AS
BEGIN
    DECLARE -- variable declarations
        @start_time DATETIME2,
        @end_time DATETIME2,
        @batch_start_time DATETIME2,
        @batch_end_time DATETIME2
    BEGIN TRY
        SET @start_time = GETDATE();
        PRINT '========================================';
		PRINT 'Loading Bronze Layer';
		PRINT '=========================================';


        -- campaigns
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.campaigns....';
        TRUNCATE TABLE neo.campaigns;

        PRINT '>> Inserting Data into neo.campaigns'
        BULK INSERT neo.campaigns
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\campaigns.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'

         -- users
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.users....';
        TRUNCATE TABLE neo.users;

        PRINT '>> Inserting Data into neo.users'
        BULK INSERT neo.users
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\users.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'
        
        -- spend
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.spend....';
        TRUNCATE TABLE neo.spend;

        PRINT '>> Inserting Data into neo.spend'
        BULK INSERT neo.spend
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\spend.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'

        -- revenue
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.revenue....';
        TRUNCATE TABLE neo.revenue;

        PRINT '>> Inserting Data into neo.revenue'
        BULK INSERT neo.revenue
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\revenue.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'

        -- experiments
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.crm_experiments....';
        TRUNCATE TABLE neo.crm_experiments;

        PRINT '>> Inserting Data into neo.crm_experiments'
        BULK INSERT neo.crm_experiments
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\crm_experiments.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'

        -- events
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.events....';
        TRUNCATE TABLE neo.events;

        PRINT '>> Inserting Data into neo.events'
        BULK INSERT neo.events
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\events.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'

        -- referrals
        SET @start_time = GETDATE();
        PRINT '>>> Truncating Table neo.referrals....';
        TRUNCATE TABLE neo.referrals;

        PRINT '>> Inserting Data into neo.referrals'
        BULK INSERT neo.referrals
        FROM 'C:\Users\pc\Desktop\marketing analysis\5k_tech\datasets\referrals.csv'
        WITH(
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A',   -- handle LF files from VS Code
            CODEPAGE = '65001',       -- UTF-8
            TABLOCK
        );
        SET @end_time = GETDATE()
        PRINT '>> Load duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
        PRINT '>>> ----------------------------------------------'

    END TRY
    BEGIN CATCH
		PRINT '===============================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message:' + ERROR_MESSAGE();
		PRINT 'Error Number:' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error State:' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '===============================================================';
    END CATCH 
END
