-- Customer Churn Analysis - SQL Queries
-- Dataset: Telco Customer Churn (Kaggle)
-- Tool: MySQL

-- Query 1: Overall churn rate
SELECT 
  Churn, 
  COUNT(*) AS total_customers,
  ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customers), 2) AS percentage
FROM customers
GROUP BY Churn;

-- Query 2: Churn rate by contract type
SELECT 
  Contract,
  COUNT(*) AS total,
  SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) AS churned,
  ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY Contract
ORDER BY churn_rate_pct DESC;

-- Query 3: Churn rate by tenure group
SELECT 
  CASE 
    WHEN tenure <= 12 THEN '0-12 months'
    WHEN tenure <= 24 THEN '13-24 months'
    WHEN tenure <= 48 THEN '25-48 months'
    ELSE '49+ months'
  END AS tenure_group,
  COUNT(*) AS total,
  ROUND(SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM customers
GROUP BY tenure_group
ORDER BY tenure_group;

-- Query 4: Average monthly charges, churned vs retained
SELECT 
  Churn,
  ROUND(AVG(MonthlyCharges), 2) AS avg_monthly_charge
FROM customers
GROUP BY Churn;

-- Query 5: Rank customers by monthly charges within their contract type (window function)
SELECT 
  Contract,
  MonthlyCharges,
  Churn,
  RANK() OVER (PARTITION BY Contract ORDER BY MonthlyCharges DESC) AS charge_rank_in_contract
FROM customers
ORDER BY Contract, charge_rank_in_contract
LIMIT 20;

-- Query 6: Compare each customer's charge to their contract group's average (window function)
SELECT 
  Contract,
  AVG(MonthlyCharges) OVER (PARTITION BY Contract) AS avg_charge_for_contract,
  MonthlyCharges,
  Churn
FROM customers
ORDER BY Contract
LIMIT 20;

-- Data cleaning note: TotalCharges was loaded as VARCHAR due to blank values
-- in ~11 rows (customers with tenure = 0). Churn column required trimming
-- a trailing carriage return character caused by Windows-style line endings:
-- UPDATE customers SET Churn = TRIM(TRAILING '\r' FROM Churn);
