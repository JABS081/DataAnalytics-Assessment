-- Assessment_Q1.sql
-- Question: High-Value Customers with Multiple Products
-- Objective: Identify customers with both a funded savings plan and an investment plan, sorted by total deposits
-- Author: JABS

-- Assumptions:
-- 1. Savings and investment plans are identified using is_regular_savings and is_a_fund respectively.
-- 2. confirmed_amount is in kobo and needs conversion to naira.
-- 3. owner_id links the plans to users.

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    ROUND(SUM(COALESCE(s.confirmed_amount, 0) + COALESCE(p.confirmed_amount, 0)) / 100.0, 2) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.is_regular_savings = 1 AND s.confirmed_amount > 0
LEFT JOIN plans_plan p ON p.owner_id = u.id AND p.is_a_fund = 1 AND p.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name
HAVING COUNT(DISTINCT s.id) > 0 AND COUNT(DISTINCT p.id) > 0
ORDER BY total_deposits DESC;
