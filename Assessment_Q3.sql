```sql
‎/*
‎   Question 3 – Account Inactivity Alert
‎   ------------------------------------
‎   • Flag accounts (savings OR investment plans) with **no inflow transactions in
‎     the past 365 days**.
‎   • Return last transaction date and days of inactivity.
‎   • `CURRENT_DATE` is used as the reference point.
‎*/
‎WITH last_tx AS (
‎    -- Savings accounts ------------------------------------------------------
‎    SELECT sa.id                                  AS plan_id,
‎           sa.owner_id,
‎           'Savings'                              AS type,
‎           MAX(sa.created_at)::date               AS last_transaction_date
‎    FROM   savings_savingsaccount   sa
‎    GROUP  BY sa.id, sa.owner_id
‎
‎    UNION ALL
‎
‎    -- Investment plans ------------------------------------------------------
‎    SELECT p.id                                   AS plan_id,
‎           p.owner_id,
‎           'Investment'                           AS type,
‎           MAX(p.updated_at)::date                AS last_transaction_date
‎    FROM   plans_plan               p
‎    WHERE  p.is_a_fund = 1
‎      AND  p.confirmed_amount > 0
‎    GROUP  BY p.id, p.owner_id
‎)
‎SELECT  plan_id,
‎        owner_id,
‎        type,
‎        last_transaction_date,
‎        (CURRENT_DATE - last_transaction_date) AS inactivity_days
‎FROM    last_tx
‎WHERE   CURRENT_DATE - last_transaction_date > 365
‎ORDER  BY inactivity_days DESC;
‎```
