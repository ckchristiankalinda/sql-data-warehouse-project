# 🏗️ SQL Data Warehouse Project (CRM + ERP Integration)

## 📊 Overview
This project implements a complete **Data Warehouse solution using SQL Server**.

It integrates CRM and ERP datasets into a structured, analytics-ready model following a **Medallion Architecture (Bronze, Silver, Gold layers)**.

---

## 🧱 Architecture (Medallion Design)

### 🥉 Bronze Layer (Raw Data)
- Raw ingestion of CRM and ERP datasets using BULK INSERT
- No transformations applied
- Data is stored exactly as received from source systems

### 🥈 Silver Layer (Cleaned & Standardized Data)
- Data cleaning and transformation
- Handling NULL values and inconsistencies
- Removing duplicates
- Standardizing formats (text, dates, categories)
- Preparing data for analytical modeling

### 🥇 Gold Layer (Business / Analytics Layer)
- Star schema design (Fact & Dimension model)
- Business-ready datasets for reporting
- Optimized for BI tools (Power BI / Tableau)

---

## 📂 Project Structure

- `sql/bronze` → raw data ingestion scripts  
- `sql/silver` → data cleaning and transformation scripts  
- `sql/gold` → star schema (fact & dimension views)  
- `data/` → source datasets (CRM & ERP)  
- `docs/` → project documentation and architecture  

---

## ⚙️ Technologies Used
- SQL Server (T-SQL)
- Data Warehousing Concepts
- ETL Pipelines
- Star Schema Data Modeling
- Window Functions (ROW_NUMBER, LEAD)
- Data Cleaning & Transformation Techniques

---

## 🔄 ETL Process

1. **Extract** → Load CRM & ERP raw CSV files  
2. **Load (Bronze Layer)** → Store raw data without transformation  
3. **Transform (Silver Layer)** → Clean, standardize, and deduplicate data  
4. **Model (Gold Layer)** → Build dimensional model (facts & dimensions)  
5. **Consume** → Use in BI dashboards and reporting

---

## 📊 Key Features

- End-to-end ETL pipeline implementation  
- Data cleaning and deduplication logic  
- Medallion architecture (Bronze / Silver / Gold)  
- Star schema design (Fact & Dimension tables)  
- Business-ready analytics model  
- Data quality handling (NULLs, inconsistencies, standardization)

---


## 📁 Data Sources

- CRM dataset: customers and sales information  
- ERP dataset: products, categories, and operational data  

---

## 📚 Documentation

Full project documentation is available in the `/docs` folder:

- 📌 Architecture → `docs/architecture.md`  
- 📌 Data Dictionary → `docs/data_dictionary.md`  
- 📌 ETL Process → `docs/etl_process.md`  
- 📌 Data Quality Rules → `docs/data_quality_rules.md`  

---

🚀 Business Value

This project enables:

- Sales performance analysis
- Customer segmentation
- Product profitability analysis
- KPI dashboards and reporting

## 👤 Author
**Mutia Kalinda Christian**  
Data Engineering Portfolio Project
