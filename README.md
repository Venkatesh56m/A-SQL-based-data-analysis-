# A-SQL-based-data-analysis-
A SQL-based data analysis project for exploring and analyzing a retail sales dataset. Includes data cleaning, transformations, KPIs, shift-based orders, top customers, monthly trends, and more using advanced SQL queries like CTEs, window functions, and aggregations.


# 🛍️ Retail Sales SQL Analysis Project

This project (`sql_project_p1`) uses PostgreSQL to explore, clean, and analyze a retail sales dataset. The goal is to derive actionable insights such as sales trends, customer behavior, and category performance using SQL.

---

## 📦 Dataset Overview

The dataset includes:
- Transaction ID
- Date & Time of Sale
- Customer demographics
- Product categories
- Sales metrics (quantity, price, cogs, total sale)

---

## 🧼 Data Cleaning Steps
- Handled null values with `COALESCE()` and subqueries.
- Recalculated missing `cogs` and `total_sale` fields.
- Standardized missing categories and sale time.

---

## 📊 Key Analysis Performed

1. 📅 Sales on specific dates
2. 👚 High-quantity clothing sales in Nov 2022
3. 📈 Total sales by category
4. 👵 Avg age of "Beauty" category buyers
5. 💰 High-value transactions (`>1000`)
6. 🧍‍♂️ Transactions by gender per category
7. 📆 Monthly sales and ranking best months
8. 🏆 Top 5 highest spending customers
9. 🛒 Unique customers by category
10. 🕰️ Shift-based order analysis (Morning, Afternoon, Evening)

---

## ⚙️ Technologies Used

- PostgreSQL
- SQL window functions (`RANK()`)
- CTEs (`WITH`)
- Aggregations (`SUM`, `AVG`, `COUNT`)
- Date/time functions (`EXTRACT`, `TO_CHAR`)

---

## 💡 How to Use

1. Create the database:
    ```sql
    CREATE DATABASE sql_project_p1;
    ```

2. Create and populate `retail_sales` table.

3. Run the queries in a PostgreSQL-compatible environment like:
   - pgAdmin
   - DBeaver
   - Azure Data Studio

---

## 📂 Extras

To get current system hour:
```sql
SELECT EXTRACT(HOUR FROM CURRENT_TIME);
