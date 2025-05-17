```sql
‎/*
‎   Question 1 – High‑Value Customers with Multiple Products
‎   -------------------------------------------------------
‎   • Identify customers who have **at least one funded savings plan** (is_regular_sa = 1)
‎     and **at least one funded investment plan** (is_a_fund = 1).
‎   • Display the number of each product type per customer and the customer’s
‎     **total deposits** across all savings transactions.
‎   • Sort the list by total deposits, highest first.
‎   NOTE:  All monetary amounts are stored in **kobo**; we divide by 100 to show naira.
‎*/
‎WITH savings_plans AS (
‎    SELECT owner_id,
‎           COUNT(*)                AS savings_count
‎    FROM   plans_plan
‎    WHERE  is_regular_sa = 1
‎      AND  confirmed_amount > 0
‎    GROUP  BY owner_id
‎),
‎investment_plans AS (
‎    SELECT owner_id,
‎           COUNT(*)                AS investment_count
‎    FROM   plans_plan
‎    WHERE  is_a_fund = 1
‎      AND  confirmed_amount > 0
‎    GROUP  BY owner_id
‎),
‎total_deposits AS (
‎    SELECT owner_id,
‎           SUM(confirmed_amount) / 100.0  AS total_deposits -- in naira
‎    FROM   savings_savingsaccount
‎    GROUP  BY owner_id
‎)
‎SELECT   u.id                                   AS owner_id,
‎         CONCAT(u.first_name, ' ', u.last_name) AS name,
‎         s.savings_count,
‎         i.investment_count,
‎         COALESCE(d.total_deposits, 0)          AS total_deposits
‎FROM     users_customuser   u
‎JOIN     savings_plans      s  ON s.owner_id = u.id
‎JOIN     investment_plans   i  ON i.owner_id = u.id
‎LEFT JOIN total_deposits    d  ON d.owner_id = u.id
‎ORDER BY total_deposits DESC;
‎```
