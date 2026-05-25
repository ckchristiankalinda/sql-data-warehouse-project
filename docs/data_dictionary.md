# 📊 Data Dictionary

## 🧍 Customers Table (dim_customers)

| Column | Description |
|--------|-------------|
| customer_key | Surrogate key for analytics |
| customer_id | Unique customer ID |
| first_name | Customer first name |
| last_name | Customer last name |
| country | Customer location |
| gender | Standardized gender |
| birthdate | Date of birth |

---

## 📦 Products Table (dim_products)

| Column | Description |
|--------|-------------|
| product_key | Surrogate key |
| product_id | Product identifier |
| product_name | Name of product |
| category | Product category |
| cost | Product cost |

---

## 💰 Fact Sales (fact_sales)

| Column | Description |
|--------|-------------|
| order_number | Unique order ID |
| product_key | Foreign key to product |
| customer_key | Foreign key to customer |
| sales_amount | Total sales value |
| quantity | Quantity sold |
