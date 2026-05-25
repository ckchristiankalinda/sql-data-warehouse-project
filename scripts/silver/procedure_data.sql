-- =========================================================
-- SILVER LAYER: DATA CLEANING & TRANSFORMATION PROCEDURE
-- Procedure Name: silver.load_silver
-- =========================================================
-- PURPOSE:
-- This stored procedure transforms raw data from the Bronze layer
-- into cleaned and standardized datasets in the Silver layer.

-- DESCRIPTION:
-- - Removes duplicates using ROW_NUMBER()
-- - Standardizes text values (TRIM, UPPER, CASE mapping)
-- - Handles missing and inconsistent values
-- - Applies business-friendly formatting
-- - Prepares data for analytical modeling (Gold layer)

-- WHY:
-- The Silver layer ensures data quality, consistency,
-- and usability before building analytics models.

-- DATA SOURCES:
-- - bronze.crm_cust_info
-- - bronze.crm_prd_info
-- - bronze.erp_cust_az12

-- KEY TRANSFORMATIONS:
-- ✔ Deduplication of customers
-- ✔ Gender standardization
-- ✔ Marital status mapping
-- ✔ Product category decoding
-- ✔ Date corrections and validation
-- ✔ Null handling

-- AUTHOR: MUTIA KALINDA Christian
-- PROJECT: SQL Data Warehouse (CRM + ERP Integration)
-- =========================================================


CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    -- =====================================================
    -- PERFORMANCE TRACKING VARIABLES
    -- =====================================================
    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '==================================================';
        PRINT 'STARTING SILVER LAYER TRANSFORMATION';
        PRINT '==================================================';


        -- =====================================================
        -- CRM DATA PROCESSING
        -- =====================================================
        PRINT '----------------------------------------------';
        PRINT 'PROCESSING CRM TABLES';
        PRINT '----------------------------------------------';


        -- -------------------------------
        -- CUSTOMER INFORMATION CLEANING
        -- -------------------------------
        PRINT 'Truncating: silver.crm_cust_info';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.crm_cust_info;

        PRINT 'Inserting cleaned data into silver.crm_cust_info';

        INSERT INTO silver.crm_cust_info (
            cst_id,
            cst_key,
            cst_firstname,
            cst_lastname,
            cst_gndr,
            cst_marital_status,
            cst_create_date
        )

        SELECT
            cst_id,
            cst_key,
            TRIM(cst_firstname) AS cst_firstname,
            TRIM(cst_lastname) AS cst_lastname,

            -- Gender standardization
            CASE
                WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
                WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
                ELSE 'n/a'
            END AS cst_gndr,

            -- Marital status standardization
            CASE
                WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
                WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
                ELSE 'n/a'
            END AS cst_marital_status,

            cst_create_date

        FROM (
            -- Deduplication logic: keeps latest record per customer
            SELECT *,
                   ROW_NUMBER() OVER (
                       PARTITION BY cst_id
                       ORDER BY cst_create_date DESC
                   ) AS rn
            FROM bronze.crm_cust_info
            WHERE cst_id IS NOT NULL
        ) t
        WHERE rn = 1;

        SET @end_time = GETDATE();

        PRINT 'Load duration (crm_cust_info): '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------------------------';


        -- =====================================================
        -- PRODUCT INFORMATION PROCESSING
        -- =====================================================
        PRINT 'Truncating: silver.crm_prd_info';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.crm_prd_info;

        PRINT 'Inserting cleaned data into silver.crm_prd_info';

        INSERT INTO silver.crm_prd_info (
            prd_id,
            cat_id,
            prd_key,
            prd_nm,
            prd_cost,
            prd_line,
            prd_start_dt,
            prd_end_dt
        )

        SELECT
            prd_id,

            -- Category extraction from product key
            REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,

            SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
            prd_nm,

            -- Handle missing costs
            ISNULL(prd_cost, 0) AS prd_cost,

            -- Product line standardization
            CASE
                WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
                WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
                WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
                WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
                ELSE 'n/a'
            END AS prd_line,

            CAST(prd_start_dt AS DATE) AS prd_start_dt,

            -- Calculate product validity period
            CAST(
                LEAD(prd_start_dt) OVER (
                    PARTITION BY prd_key
                    ORDER BY prd_start_dt
                ) - 1 AS DATE
            ) AS prd_end_dt

        FROM bronze.crm_prd_info;

        SET @end_time = GETDATE();

        PRINT 'Load duration (crm_prd_info): '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------------------------';


        -- =====================================================
        -- ERP DATA PROCESSING
        -- =====================================================
        PRINT 'PROCESSING ERP TABLES';
        PRINT '----------------------------------------------';


        -- -------------------------------
        -- CUSTOMER ERP TABLE CLEANING
        -- -------------------------------
        PRINT 'Truncating: silver.erp_cust_az12';
        SET @start_time = GETDATE();

        TRUNCATE TABLE silver.erp_cust_az12;

        PRINT 'Inserting cleaned data into silver.erp_cust_az12';

        INSERT INTO silver.erp_cust_az12 (
            cid,
            bdate,
            gen
        )

        SELECT

            -- Clean customer ID prefix issue
            CASE
                WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
                ELSE cid
            END AS cid,

            -- Fix future birthdates (data quality issue)
            CASE
                WHEN bdate > GETDATE() THEN NULL
                ELSE bdate
            END AS bdate,

            -- Gender normalization
            CASE
                WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
                WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
                ELSE 'n/a'
            END AS gen

        FROM bronze.erp_cust_az12;

        SET @end_time = GETDATE();

        PRINT 'Load duration (erp_cust_az12): '
              + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR)
              + ' seconds';

        PRINT '----------------------------------------------';


        -- =====================================================
        -- FINAL SUMMARY
        -- =====================================================
        SET @batch_end_time = GETDATE();

        PRINT '==================================================';
        PRINT 'SILVER LAYER LOADING COMPLETED SUCCESSFULLY';
        PRINT 'TOTAL DURATION: '
              + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '==================================================';

    END TRY

    BEGIN CATCH

        PRINT '==================================================';
        PRINT 'ERROR OCCURRED DURING SILVER LAYER LOADING';
        PRINT 'ERROR MESSAGE: ' + ERROR_MESSAGE();
        PRINT 'ERROR NUMBER: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'ERROR STATE: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '==================================================';

    END CATCH

END;
