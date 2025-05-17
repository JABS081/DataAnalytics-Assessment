-- Assessment_Q2.sql
-- Question: Transaction Frequency Analysis
-- Objective: Classify customers into frequency bands based on monthly transaction counts
-- Author: JABS

WITH monthly_tx AS (
  SELECT 
    owner_id,
    DATE_TRUNC('month', created_at) AS tx_month,
    COUNT(*) AS tx_count
  FROM transactions_transaction
  GROUP BY owner_id, DATE_TRUNC('month', created_at)
),
customer_avg AS (
  SELECT 
    owner_id,
    AVG(tx_count) AS avg_tx_per_month
  FROM monthly_tx
  GROUP BY owner_id
),
frequency_segment AS (
  SELECT 
    owner_id,
    CASE 
      WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
      WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
      ELSE 'Low Frequency'
    END AS frequency_category
  FROM customer_avg
)
SELECT 
  frequency_category,
  COUNT(*) AS customer_count,
  ROUND(AVG(avg_tx_per_month), 1) AS avg_transactions_per_month
FROM customer_avg
JOIN frequency_segment USING (owner_id)
GROUP BY frequency_category
ORDER BY customer_count DESC;
