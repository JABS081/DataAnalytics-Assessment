‎```sql
‎/*
‎   Question 2 – Transaction Frequency Analysis
‎   ------------------------------------------
‎   • Calculate the **average number of transactions per customer per month** using
‎     the savings_savingsaccount table (each row = one transaction).
‎   • Classify customers into frequency bands and aggregate the counts.
‎*/
‎WITH monthly_tx AS (
‎    SELECT owner_id,
‎           DATE_TRUNC('month', created_at)::date AS activity_month,
‎           COUNT(*)                             AS tx_count
‎    FROM   savings_savingsaccount
‎    GROUP  BY owner_id, activity_month
‎),
‎avg_tx AS (
‎    SELECT owner_id,
‎           AVG(tx_count)                        AS avg_tx_per_month
‎    FROM   monthly_tx
‎    GROUP BY owner_id
‎)
‎SELECT  CASE
‎            WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
‎            WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
‎            ELSE 'Low Frequency'
‎        END                                    AS frequency_category,
‎        COUNT(*)                               AS customer_count,
‎        ROUND(AVG(avg_tx_per_month), 1)        AS avg_transactions_per_month
‎FROM    avg_tx
‎GROUP  BY frequency_category
‎ORDER  BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
‎```
