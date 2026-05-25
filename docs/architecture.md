# 🏗️ Data Warehouse Architecture

## Overview
This project follows a Medallion Architecture:

- Bronze → Raw data ingestion
- Silver → Data cleaning & transformation
- Gold → Business-ready analytics model

## Data Flow
CRM + ERP Sources → Bronze → Silver → Gold → BI Tools

## Layers Description

### Bronze Layer
Raw data loaded using BULK INSERT without transformation.

### Silver Layer
Data cleaning:
- Remove duplicates
- Standardize formats
- Handle missing values

### Gold Layer
Star schema:
- Dimensional model
- Fact table for analytics
