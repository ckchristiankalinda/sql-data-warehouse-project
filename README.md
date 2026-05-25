# 🏗️ SQL Data Warehouse Project (CRM + ERP)

## 📊 Overview
This project implements a complete Data Warehouse solution using SQL Server.  
It integrates CRM and ERP datasets into a structured analytics-ready model.

The architecture follows a **Medallion Design (Bronze, Silver, Gold layers)**.

---

## 🧱 Architecture

### 🥉 Bronze Layer (Raw Data)
- Raw ingestion of CRM and ERP datasets
- No transformation applied

### 🥈 Silver Layer (Cleaned Data)
- Data cleaning (NULL handling, duplicates removal)
- Standardization of formats
- Data type corrections

### 🥇 Gold Layer (Business Layer)
- Star schema design
- Fact and dimension tables
- Analytics-ready views

---

## 📂 Project Structure

 → raw data ingestion scripts  
 → data cleaning and transformation  
 → star schema (facts & dimensions)  
 → reporting views  
 → source datasets (CRM & ERP)  
 → documentation and architecture  

---

## ⚙️ Technologies Used
- SQL Server (T-SQL)
- Data Modeling (Star Schema)
- ETL Pipelines
- Data Cleaning & Transformation

---

## 🔄 ETL Process

1. Load raw CRM & ERP data into Bronze tables  
2. Clean and transform data in Silver layer  
3. Build analytical model in Gold layer  
4. Create reporting views for dashboards  

---

## 📊 Key Features

- Customer dimension modeling  
- Product dimension modeling  
- Sales fact table  
- Data quality handling (NULLs, duplicates, formatting issues)  
- Separation of business logic (Gold layer)

---

## 📁 Source Data

- CRM dataset (customers, demographics)
- ERP dataset (sales, products, transactions)

## 📚 Documentation

Full project documentation is available in the `/docs` folder:

- Architecture → docs/architecture.md
- Data Dictionary → docs/data_dictionary.md
- ETL Process → docs/etl_process.md
- Data Quality Rules → docs/data_quality_rules.md

---

## 👤 Author
Data Engineering Project by MUTIA KALINDA Christian
