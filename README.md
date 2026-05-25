# SQL Data Warehouse Project

## Overview

This project demonstrates the design and implementation of an end-to-end Data Warehouse solution using SQL Server.

The goal is to integrate raw CRM and ERP datasets, transform and clean the data through ETL processes, and build a structured analytical layer for business reporting.

The architecture follows a multi-layer approach:

Bronze → Silver → Gold

---

## Project Objectives

- Extract raw data from CRM and ERP systems
- Build ETL pipelines
- Clean and transform raw datasets
- Apply data quality checks
- Design dimensional models
- Create fact and dimension tables
- Prepare analytical-ready datasets

---

## Architecture

Data Sources:

CRM + ERP

Pipeline Flow:

CRM/ERP
↓
Bronze Layer
↓
Silver Layer
↓
Gold Layer

### Bronze Layer
Stores raw ingested data without modifications.

### Silver Layer
Performs:

- Data cleaning
- Duplicate removal
- Standardization
- Null handling
- Data validation

### Gold Layer
Contains business-ready data models:

- Fact tables
- Dimension tables
- Analytical datasets

---

## Project Structure

```text
datasets/
scripts/
   bronze/
   silver/
   gold/
docs/
README.md
```

## Technologies Used

- SQL Server
- T-SQL
- ETL concepts
- Data Warehousing
- Dimensional Modeling
- Window Functions
- CTEs

---

## Data Sources

Data originated from CRM and ERP systems.

---

## Skills Demonstrated

✔ Data Cleaning

✔ ETL Pipeline Design

✔ SQL Development

✔ Data Modeling

✔ Data Warehouse Architecture

✔ Data Quality Validation

✔ Analytical Thinking

---

## Future Improvements

- Pipeline automation
- Dashboard integration
- Incremental loading
- Performance optimization

---

## Author

MUTIA KALINDA Christian

Aspiring Data Analyst | SQL | ETL | Data Warehousing | Analytics
