-- Assessment_Q4.sql
-- Question: Customer Lifetime Value (CLV) Estimation
-- Objective: Estimate CLV using tenure and average transaction profit
-- Author: JABS

WITH customer_tx AS (
  SELECT 
    owner_id AS customer_id,
    COUNT(*) AS total_transactions,
    SUM(confirmed_amount) / 100.0 AS total_amount,
    AVG(confirmed_amount * 0.001 / 100.0) AS avg_profit_per_transaction
  FROM transactions_transaction
  GROUP BY owner_id
),
tenure_calc AS (
  SELECT 
    id AS customer_id,
    CONCAT(first_name, ' ', last_name) AS name,
    DATE_PART('month', AGE(CURRENT_DATE, date_joined)) AS tenure_months
  FROM users_customuser
),
clv_calc AS (
  SELECT 
    t.customer_id,
    tc.name,
    tc.tenure_months,
    t.total_transactions,
    ROUND((t.total_transactions / NULLIF(tc.tenure_months, 0)) * 12 * t.avg_profit_per_transaction, 2) AS estimated_clv
  FROM customer_tx t
  JOIN tenure_calc tc ON t.customer_id = tc.customer_id
)
SELECT *
FROM clv_calc
ORDER BY estimated_clv DESC;
