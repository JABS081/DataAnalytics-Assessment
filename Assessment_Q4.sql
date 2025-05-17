```sql
‎/*
‎   Question 4 – Customer Lifetime Value (CLV) Estimation
‎   ----------------------------------------------------
‎   • Tenure = months between today and the user’s signup date.
‎   • Profit per transaction = 0.1 % of each transaction’s value.
‎   • CLV (simple model) = (total_transactions / tenure) * 12 * avg_profit_per_tx.
‎*/
‎WITH tx AS (
‎    SELECT owner_id,
‎           COUNT(*)                           AS total_transactions,
‎           AVG(confirmed_amount * 0.001)      AS avg_profit_per_tx -- 0.1 % of value
‎    FROM   savings_savingsaccount
‎    GROUP  BY owner_id
‎),
‎user_tenure AS (
‎    SELECT id                                 AS owner_id,
‎           CONCAT(first_name, ' ', last_name) AS name,
‎           DATE_PART('month', AGE(CURRENT_DATE, date_joined))
‎                                           ::int AS tenure_months
‎    FROM   users_customuser
‎)
‎SELECT  u.owner_id           AS customer_id,
‎        u.name,
‎        u.tenure_months,
‎        t.total_transactions,
‎        ROUND( (t.total_transactions / NULLIF(u.tenure_months, 1)) * 12 * t.avg_profit_per_tx,
‎               2)            AS estimated_clv
‎FROM    tx            t
‎JOIN    user_tenure   u  ON u.owner_id = t.owner_id
‎ORDER  BY estimated_clv DESC;
‎```
