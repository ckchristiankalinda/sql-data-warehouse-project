# 🧼 Data Quality Rules

## Rules applied in Silver Layer

### 1. Duplicates
- Removed using ROW_NUMBER() partitioning

### 2. Standardization
- Gender values normalized (M → Male, F → Female)
- Text fields trimmed and cleaned

### 3. Missing Values
- NULL values replaced with 'n/a' or default values

### 4. Date Validation
- Future birthdates replaced with NULL
