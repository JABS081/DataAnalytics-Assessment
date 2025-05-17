-- Assessment_Q3.sql
-- Question: Account Inactivity Alert
-- Objective: Find savings and investment accounts with no deposit in the last 365 days
-- Author: JABS

WITH last_tx AS (
  SELECT 
    id AS plan_id,
    owner_id,
    'Savings' AS type,
    MAX(created_at) AS last_transaction_date
  FROM savings_savingsaccount
  WHERE is_regular_savings = 1
  GROUP BY id, owner_id

  UNION ALL

  SELECT 
    id AS plan_id,
    owner_id,
    'Investment' AS type,
    MAX(created_at) AS last_transaction_date
  FROM plans_plan
  WHERE is_a_fund = 1
  GROUP BY id, owner_id
)
SELECT 
  plan_id,
  owner_id,
  type,
  last_transaction_date,
  CURRENT_DATE - last_transaction_date AS inactivity_days
FROM last_tx
WHERE CURRENT_DATE - last_transaction_date > 365
ORDER BY inactivity_days DESC;
