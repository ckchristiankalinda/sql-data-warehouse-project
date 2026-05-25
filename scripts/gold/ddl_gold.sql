-- =========================================================
-- GOLD LAYER: BUSINESS INTELLIGENCE LAYER (STAR SCHEMA)
-- =========================================================
-- PURPOSE:
-- This layer provides business-ready data models (dimensions & fact tables)
-- for reporting and analytics tools such as Power BI or Tableau.

-- DESCRIPTION:
-- - Builds dimensional model (Star Schema)
-- - Integrates cleaned Silver layer data
-- - Creates business-friendly views
-- - Optimized for analytics and reporting performance

-- WHY:
-- The Gold layer represents the final consumption layer
-- where data is structured for decision-making and KPI analysis.

-- AUTHOR: MUTIA KALINDA Christian
-- PROJECT: SQL Data Warehouse (CRM + ERP Integration)
-- =========================================================
-- =========================================================
-- GOLD VIEW: DIM_CUSTOMERS
-- =========================================================
-- PURPOSE:
-- This view builds the customer dimension for analytics.

-- DESCRIPTION:
-- Combines CRM and ERP customer data into a single unified view:
-- - Customer personal information
-- - Geographic information
-- - Demographics (gender, birthdate)
-- - Business attributes

-- BUSINESS VALUE:
-- Enables customer segmentation, profiling, and KPI reporting.

-- DATA SOURCES:
-- - silver.crm_cust_info
-- - silver.erp_cust_az12
-- - silver.erp_loc_a101
-- =========================================================

CREATE VIEW gold.dim_customers AS
SELECT 

    -- Surrogate key for analytics usage
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,

    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,

    -- Geographic enrichment
    lo.cntry AS country,

    ci.cst_marital_status AS marital_status,

    -- Gender resolution logic:
    -- Priority: CRM value → fallback to ERP → default 'n/a'
    CASE 
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(la.gen, 'n/a')
    END AS gender,

    la.bdate AS birthdate,
    ci.cst_create_date AS create_date

FROM silver.crm_cust_info ci

-- Enrich with ERP demographic data
LEFT JOIN silver.erp_cust_az12 la
    ON ci.cst_key = la.cid

-- Enrich with location data
LEFT JOIN silver.erp_loc_a101 lo
    ON ci.cst_key = lo.cid;

-- =========================================================
-- GOLD VIEW: DIM_PRODUCTS
-- =========================================================
-- PURPOSE:
-- This view builds the product dimension table.

-- DESCRIPTION:
-- Standardizes product information and enriches it with:
-- - Category hierarchy (category, subcategory)
-- - Product lifecycle (active products only)
-- - Pricing and cost data

-- BUSINESS VALUE:
-- Supports product performance analysis and sales reporting.

-- DATA SOURCES:
-- - silver.crm_prd_info
-- - silver.erp_px_cat_g1v2
-- =========================================================

CREATE VIEW gold.dim_products AS
SELECT  

    -- Surrogate key for BI usage
    ROW_NUMBER() OVER (ORDER BY pr.prd_start_dt, pr.prd_key) AS product_key,

    pr.prd_id AS product_id,
    pr.prd_key AS product_number,
    pr.prd_nm AS product_name,

    pr.cat_id AS category_id,

    -- Category enrichment from ERP reference table
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,

    pr.prd_cost AS cost,
    pr.prd_line AS product_line,
    pr.prd_start_dt AS start_date

FROM silver.crm_prd_info pr

LEFT JOIN silver.erp_px_cat_g1v2 pc
    ON pr.cat_id = pc.id

-- Only keep active products (no historical versions)
WHERE pr.prd_end_dt IS NULL;

-- =========================================================
-- GOLD VIEW: FACT_SALES
-- =========================================================
-- PURPOSE:
-- This fact table stores transactional sales data.

-- DESCRIPTION:
-- Central table of the star schema containing measurable events:
-- - Sales transactions
-- - Quantity sold
-- - Pricing information
-- - Order lifecycle dates

-- BUSINESS VALUE:
-- Used for KPI calculation such as:
-- - Total revenue
-- - Sales performance by customer/product
-- - Time-based analysis

-- DATA SOURCES:
-- - silver.crm_sales_details
-- - gold.dim_products
-- - gold.dim_customers
-- =========================================================

CREATE VIEW gold.fact_sales AS
SELECT 

    sl.sls_ord_num AS order_number,

    -- Foreign keys to dimensions
    pr.product_key,
    cu.customer_key,

    -- Order lifecycle
    sl.sls_order_dt AS order_date,
    sl.sls_ship_dt AS shipping_date,
    sl.sls_due_dt AS due_date,

    -- Business metrics
    sl.sls_sales AS sales_amount,
    sl.sls_quantity AS quantity,
    sl.sls_price AS price

FROM silver.crm_sales_details sl

-- Link to product dimension
LEFT JOIN gold.dim_products pr
    ON sl.sls_prd_key = pr.product_number

-- Link to customer dimension
LEFT JOIN gold.dim_customers cu
    ON sl.sls_cust_id = cu.customer_id;
