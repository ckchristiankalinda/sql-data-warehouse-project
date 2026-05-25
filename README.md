# Data Warehouse Project

## 📊 Overview
This project is a complete Data Warehouse solution built using SQL.  
It includes data ingestion, transformation, and analytics-ready gold layer.

## 🏗️ Architecture
The project follows a medallion architecture:

- Bronze Layer: raw data ingestion
- Silver Layer: cleaned and transformed data
- Gold Layer: analytics-ready views

## 📂 Project Structure
/sql → all SQL scripts (DDL, ETL, views)
/data → raw datasets used in the project
/docs → documentation and schema

## ⚙️ Technologies Used
- SQL Server 
- T-SQL
- Data modeling
- ETL processes

## 🔄 ETL Process
1. Load raw CSV files into staging tables
2. Clean and transform data (Silver layer)
3. Create business-ready views (Gold layer)

## 📊 Key Features
- Customer dimension modeling
- Sales fact table
- Data cleaning (null handling, duplicates removal)
- Star schema design

## 📁 Source Datasets
- CRM dataset
- ERP dataset

## 🚀 How to run
1. Run scripts in /sql/ddl
2. Load data using /sql/etl scripts
3. Create views from /sql/views

## 👤 Author
MUTIA KALINDA Christian
