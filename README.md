‎# DataAnalytics-Assessment
‎
‎This repository contains comprehensive solutions to the **SQL Proficiency Assessment**. Each SQL script addresses a practical business question involving relational databases. This README provides deep-dive explanations, query logic, formula breakdowns, detailed output tables, use-case scenarios, and problem-solving documentation to demonstrate full SQL proficiency.
‎
‎Prepared by: **JABS**
‎Date: **May 17, 2025**
‎Time Zone: **Africa/Lagos**
‎
‎---
‎
‎## Repository Structure
‎
‎| File                | Question                                    |
‎| ------------------- | ------------------------------------------- |
‎| `Assessment_Q1.sql` | High-Value Customers with Multiple Products |
‎| `Assessment_Q2.sql` | Transaction Frequency Analysis              |
‎| `Assessment_Q3.sql` | Account Inactivity Alert                    |
‎| `Assessment_Q4.sql` | Customer Lifetime Value (CLV) Estimation    |
‎
‎---
‎
‎## General Assumptions
‎
‎1. **Currency Format** – All monetary values are stored in **kobo** (₦ × 100). Queries convert these to **naira** by dividing by 100.
‎2. **Timestamps** – Fields like `created_at` are used to calculate transaction dates and tenure.
‎3. **Active Accounts** – All listed accounts are assumed active unless otherwise stated.
‎4. **Plan Type Flags** –
‎
‎   * `is_regular_savings = 1` identifies savings plans.
‎   * `is_a_fund = 1` identifies investment plans.
‎5. **Data Cleaning** – NULL handling and formatting are considered in the queries to ensure consistent and readable outputs.
‎
‎---
‎
‎## Per-Question Explanations & Output Formats
‎
‎### 1. High-Value Customers with Multiple Products
‎
‎**Objective**: Identify customers who hold both at least one **funded savings plan** and one **funded investment plan**. Rank by **total deposits**.
‎
‎**Query Logic & Explanation**:
‎
‎* Use joins between `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
‎* Filter `is_regular_savings = 1` (for savings) and `is_a_fund = 1` (for investment).
‎* Use `GROUP BY owner_id` to aggregate counts.
‎* Use `COUNT(DISTINCT plan_id)` and `SUM(confirmed_amount) / 100` for accuracy.
‎* Use `HAVING` clause to restrict results to customers with both products.
‎* Sort by `total_deposits DESC`.
‎
‎**Formula**:
‎
‎```sql
‎SUM(savings.confirmed_amount) / 100 AS total_deposits
‎```
‎
‎**Display Table Example**:
‎
‎| owner\_id | name     | savings\_count | investment\_count | total\_deposits |
‎| --------- | -------- | -------------- | ----------------- | --------------- |
‎| 1001      | John Doe | 2              | 1                 | 15000.00        |
‎| 1003      | Jane Ali | 3              | 2                 | 13250.50        |
‎
‎---
‎
‎### 2. Transaction Frequency Analysis
‎
‎**Objective**: Group customers into frequency categories based on the **average number of transactions per month**.
‎
‎**Query Logic & Explanation**:
‎
‎* Use `DATE_TRUNC('month', created_at)` to group monthly.
‎* Count transactions per customer-month.
‎* Calculate the average using `AVG(transaction_count)`.
‎* Categorize frequency using `CASE`:
‎
‎  * High Frequency: ≥10 tx/month
‎  * Medium Frequency: 3–9 tx/month
‎  * Low Frequency: ≤2 tx/month
‎
‎**Formula**:
‎
‎```sql
‎CASE
‎  WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
‎  WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
‎  ELSE 'Low Frequency'
‎END
‎```
‎
‎**Display Table Example**:
‎
‎| frequency\_category | customer\_count | avg\_transactions\_per\_month |
‎| ------------------- | --------------- | ----------------------------- |
‎| High Frequency      | 250             | 15.2                          |
‎| Medium Frequency    | 1200            | 5.5                           |
‎| Low Frequency       | 600             | 1.9                           |
‎
‎---
‎
‎### 3. Account Inactivity Alert
‎
‎**Objective**: Identify accounts (savings or investment) that have had **no inflow transactions in the past 365 days**.
‎
‎**Query Logic & Explanation**:
‎
‎* Use `MAX(created_at)` to determine latest transaction date.
‎* Calculate days since last transaction using `CURRENT_DATE - last_transaction_date`.
‎* Use `HAVING inactivity_days > 365`.
‎* Join customer data for identification.
‎* Tag `type` as either `'Savings'` or `'Investment'` for output clarity.
‎
‎**Formula**:
‎
‎```sql
‎CURRENT_DATE - MAX(created_at) AS inactivity_days
‎```
‎
‎**Display Table Example**:
‎
‎| plan\_id | owner\_id | type       | last\_transaction\_date | inactivity\_days |
‎| -------- | --------- | ---------- | ----------------------- | ---------------- |
‎| 1001     | 305       | Savings    | 2023-08-10              | 400              |
‎| 1010     | 450       | Investment | 2023-01-12              | 480              |
‎
‎---
‎
‎### 4. Customer Lifetime Value (CLV) Estimation
‎
‎**Objective**: Estimate the **Customer Lifetime Value (CLV)** using account tenure and transaction profit.
‎
‎**Query Logic & Explanation**:
‎
‎* Calculate **tenure** in months: `DATE_PART('month', AGE(CURRENT_DATE, date_joined))`
‎* Sum of **total transactions** and inflows per customer.
‎* Calculate **profit per transaction** = `confirmed_amount * 0.001`
‎* Derive **CLV** using:
‎
‎```sql
‎(total_transactions / tenure_months) * 12 * avg_profit_per_transaction
‎```
‎
‎* CLV gives projected 12-month value based on behavior.
‎
‎**Display Table Example**:
‎
‎| customer\_id | name     | tenure\_months | total\_transactions | estimated\_clv |
‎| ------------ | -------- | -------------- | ------------------- | -------------- |
‎| 1001         | John Doe | 24             | 120                 | 600.00         |
‎| 1002         | Grace O. | 36             | 90                  | 300.00         |
‎
‎---
‎
‎## Challenges & Resolutions
‎
‎| Challenge                                                 | Resolution                                                                                                        |
‎| --------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
‎| **Incomplete Schema** – Missing exact column types/names. | Used inferred schema structure with conventional fields like `created_at`, `confirmed_amount`, and `date_joined`. |
‎| **Currency Denomination**                                 | Consistently normalized kobo to naira using `/ 100` and documented assumption.                                    |
‎| **Categorization Logic**                                  | Used robust `CASE` logic to prevent misclassification of frequency.                                               |
‎| **Plan Type Confusion**                                   | Clarified by using flags `is_regular_savings` and `is_a_fund`.                                                    |
‎| **Inactivity Overlap**                                    | Used UNION and explicit type fields to handle both plan types uniformly.                                          |
‎
‎---
‎
‎## Additional Notes
‎
‎* Queries are ANSI-SQL compliant.
‎* Scripts are fully independent and commented.
‎* Output formats are clearly structured for business reporting.
‎* Each query handles real-world nuances like NULLs, data formats, and monetary units.
‎
‎---
‎
‎**Prepared and submitted by:**
‎**Name:** JABS
‎**Date:** May 17, 2025
‎**Location:** Africa/Lagos
‎
