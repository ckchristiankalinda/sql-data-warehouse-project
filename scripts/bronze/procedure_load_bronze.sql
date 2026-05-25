-- =========================================================
-- BRONZE LAYER: DATA LOADING STORED PROCEDURE
-- Procedure Name: bronze.load_bronze
-- =========================================================
-- PURPOSE:
-- This stored procedure loads raw data from CSV files
-- into the Bronze layer tables of the Data Warehouse.

-- DESCRIPTION:
-- - Performs full reload (TRUNCATE + BULK INSERT)
-- - Loads CRM and ERP source data
-- - Tracks execution time for each table and full batch
-- - Provides logging using PRINT statements

-- WHY:
-- The Bronze layer is the raw ingestion layer.
-- It preserves source data exactly as received before any transformation.

-- DATA SOURCES:
-- CRM:
--   - cust_info.csv
--   - prd_info.csv
--   - sales_details.csv
--
-- ERP:
--   - LOC_A101.csv
--   - CUST_AZ12.csv
--   - PX_CAT_G1V2.csv

-- FEATURES:
-- - Full table refresh (no incremental load)
-- - Performance monitoring per table
-- - Error handling using TRY...CATCH
-- - Batch execution timing

-- AUTHOR: MUTIA KALINDA Christian
-- PROJECT: SQL Data Warehouse (CRM + ERP Integration)
-- =========================================================


CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    -- =====================================================
    -- VARIABLES FOR PERFORMANCE TRACKING
    -- =====================================================
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '==================================================';
        PRINT 'STARTING BRONZE LAYER DATA LOAD';
        PRINT '==================================================';

        -- =====================================================
        -- CRM TABLES LOADING
        -- =====================================================

        PRINT '>>> Loading CRM Tables';

        -- -------------------------------
        -- CRM CUSTOMER INFO
        -- -------------------------------
        PRINT 'Truncating: bronze.crm_cust_info';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_cust_info;

        PRINT 'Inserting data into: bronze.crm_cust_info';

        BULK INSERT bronze.crm_cust_info
        FROM 'datasets/source_crm/cust_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'Load duration (crm_cust_info): ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
              + ' seconds';

        PRINT '--------------------------------------------------';


        -- -------------------------------
        -- CRM PRODUCT INFO
        -- -------------------------------
        PRINT 'Truncating: bronze.crm_prd_info';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT 'Inserting data into: bronze.crm_prd_info';

        BULK INSERT bronze.crm_prd_info
        FROM 'datasets/source_crm/prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'Load duration (crm_prd_info): ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
              + ' seconds';

        PRINT '--------------------------------------------------';


        -- -------------------------------
        -- CRM SALES DETAILS
        -- -------------------------------
        PRINT 'Truncating: bronze.crm_sales_details';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.crm_sales_details;

        BULK INSERT bronze.crm_sales_details
        FROM 'datasets/source_crm/sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'Load duration (crm_sales_details): ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
              + ' seconds';

        PRINT '--------------------------------------------------';


        -- =====================================================
        -- ERP TABLES LOADING
        -- =====================================================

        PRINT '>>> Loading ERP Tables';

        -- -------------------------------
        -- ERP LOCATION TABLE
        -- -------------------------------
        PRINT 'Truncating: bronze.erp_loc_a101';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.erp_loc_a101;

        BULK INSERT bronze.erp_loc_a101
        FROM 'datasets/source_crm/LOC_A101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'Load duration (erp_loc_a101): ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
              + ' seconds';

        PRINT '--------------------------------------------------';


        -- -------------------------------
        -- ERP CUSTOMER TABLE
        -- -------------------------------
        PRINT 'Truncating: bronze.erp_cust_az12';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.erp_cust_az12;

        BULK INSERT bronze.erp_cust_az12
        FROM 'datasets/source_crm/CUST_AZ12.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'Load duration (erp_cust_az12): ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
              + ' seconds';

        PRINT '--------------------------------------------------';


        -- -------------------------------
        -- ERP PRODUCT CATEGORY TABLE
        -- -------------------------------
        PRINT 'Truncating: bronze.erp_px_cat_g1v2';
        SET @start_time = GETDATE();

        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'datasets/source_crm/PX_CAT_G1V2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            TABLOCK
        );

        SET @end_time = GETDATE();

        PRINT 'Load duration (erp_px_cat_g1v2): ' 
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) 
              + ' seconds';

        PRINT '--------------------------------------------------';


        -- =====================================================
        -- FINAL SUMMARY
        -- =====================================================

        SET @batch_end_time = GETDATE();

        PRINT '==================================================';
        PRINT 'BRONZE LAYER LOADING COMPLETED SUCCESSFULLY';
        PRINT 'TOTAL DURATION: ' 
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) 
              + ' seconds';
        PRINT '==================================================';

    END TRY

    BEGIN CATCH

        PRINT '==================================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LAYER LOADING';
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==================================================';

    END CATCH

END;
