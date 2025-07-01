import pandas as pd
import sqlite3
import os

# Define paths
file_path = "OnlineRetail.csv"
db_path = "retail.db"

# Check if file exists
if not os.path.exists(file_path):
    raise FileNotFoundError(f"{file_path} not found. Please place it in the same folder.")

# Load data
df = pd.read_csv(file_path, encoding='ISO-8859-1', parse_dates=['InvoiceDate'])


# Basic cleaning
df.dropna(subset=['CustomerID'], inplace=True)
df = df[df['Quantity'] > 0]
df = df[df['UnitPrice'] > 0]

# Create SQLite connection
conn = sqlite3.connect(db_path)

# Write to database
df.to_sql("sales", conn, if_exists="replace", index=False)
print("✅ Data written to SQLite database.")

# Run sample queries
queries = {
    "country_revenue.csv": """
        SELECT Country, ROUND(SUM(Quantity * UnitPrice), 2) AS TotalRevenue
        FROM sales
        GROUP BY Country
        ORDER BY TotalRevenue DESC
    """,
    "top_products.csv": """
        SELECT Description, SUM(Quantity) AS TotalSold
        FROM sales
        GROUP BY Description
        ORDER BY TotalSold DESC
        LIMIT 10
    """,
    "monthly_sales.csv": """
        SELECT 
    strftime('%Y-%m', InvoiceDate) AS Month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS MonthlyRevenue
    FROM sales
    WHERE InvoiceDate IS NOT NULL
    GROUP BY Month
    ORDER BY Month
    """
}

# Execute queries and export CSVs
for file_name, sql in queries.items():
    result = pd.read_sql_query(sql, conn)
    result.to_csv(file_name, index=False)
    print(f"✅ Saved {file_name}")

conn.close()
print("🎉 All tasks completed successfully.")

