# Customer Churn Analysis (SQL)

## Overview
Analysis of customer churn patterns using SQL on the Telco Customer Churn dataset, 
identifying which customer segments are most likely to leave and why.

## Dataset
Source: [Telco Customer Churn](https://www.kaggle.com/datasets/blastchar/telco-customer-churn) (Kaggle)
7,043 customer records with contract type, tenure, charges, and churn status.

## Tools Used
MySQL (queries run via command line)

## Key Findings

1. **Contract type is the strongest churn driver.** Month-to-month customers churn 
at 42.71%, compared to just 11.27% for one-year contracts and only 2.83% for 
two-year contracts — a 15x difference between the least and most committed customers.

2. **New customers are the highest churn risk.** Customers in their first 12 months 
churn at 47.44%, dropping steadily to 9.51% for customers with 49+ months of tenure. 
Churn risk decreases the longer a customer stays.

3. **Contract type and tenure together compound risk.** A new customer on a 
month-to-month plan represents the highest-risk segment the business has, combining 
both major churn factors identified above.

## Recommendation
Prioritize converting month-to-month customers to annual contracts within their 
first 12 months, when churn risk is highest — for example, through onboarding 
incentives or discounted annual-plan offers targeted at new sign-ups.

## Data Cleaning Notes
- `TotalCharges` was loaded as VARCHAR due to blank values in ~11 rows 
(customers with 0 tenure) that would break a numeric column.
- The `Churn` column contained a hidden trailing carriage return (`\r`) caused 
by Windows-style line endings during CSV import, which silently broke 
`WHERE Churn = 'Yes'` comparisons. Fixed with:
```sql
  UPDATE customers SET Churn = TRIM(TRAILING '\r' FROM Churn);
```

## Files
- `queries.sql` — all SQL queries used in this analysis, including a window 
function ranking customers by charges within their contract group.
