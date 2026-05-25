# 🔄 ETL Process

## Step 1: Extract
Data is loaded from CSV files:
- CRM datasets
- ERP datasets

## Step 2: Load (Bronze Layer)
- Data is loaded using BULK INSERT
- No transformation applied

## Step 3: Transform (Silver Layer)
- Data cleaning
- Deduplication using ROW_NUMBER()
- Standardization of text fields
- Handling missing values

## Step 4: Business Model (Gold Layer)
- Star schema design
- Dimensional modeling
- Fact table creation
