# DataAnalytics‑Assessment

This repository contains **fully‑documented solutions** to the SQL Proficiency Assessment. Each script solves a realistic business question, while this README provides deep‑dive explanations, query logic, formula breakdowns, sample outputs, use‑case context, and troubleshooting notes—demonstrating complete SQL proficiency.

> **Prepared by :** **JABS**  |  **Date :** 17 May 2025  |  **Time Zone :** Africa/Lagos

---

## 📚 Table of Contents

* [Repository Structure](#repository-structure)
* [General Assumptions](#general-assumptions)
* [Per‑Question Explanations & Sample Outputs](#per‑question-explanations--sample-outputs)

  * [1 – High‑Value Customers with Multiple Products](#1-high‑value-customers-with-multiple-products)
  * [2 – Transaction Frequency Analysis](#2-transaction-frequency-analysis)
  * [3 – Account Inactivity Alert](#3-account-inactivity-alert)
  * [4 – Customer Lifetime Value (CLV) Estimation](#4-customer-lifetime-value-clv-estimation)
* [Challenges & Resolutions](#challenges--resolutions)
* [Additional Notes](#additional-notes)
* [Contributing & Feedback](#contributing--feedback)

---

## Repository Structure

| File                                       | Question                                    |
| ------------------------------------------ | ------------------------------------------- |
| [`Assessment_Q1.sql`](./Assessment_Q1.sql) | High‑Value Customers with Multiple Products |
| [`Assessment_Q2.sql`](./Assessment_Q2.sql) | Transaction Frequency Analysis              |
| [`Assessment_Q3.sql`](./Assessment_Q3.sql) | Account Inactivity Alert                    |
| [`Assessment_Q4.sql`](./Assessment_Q4.sql) | Customer Lifetime Value (CLV) Estimation    |

---

## General Assumptions

1. **Currency** — All monetary fields are stored in **kobo** (₦ × 100). Queries divide by 100 to present values in **naira**.
2. **Timestamps** — Columns such as `created_at` (transactions) and `date_joined` (users) are available for date arithmetic.
3. **Active Accounts** — Every account returned is assumed active unless explicitly filtered out.
4. **Plan Flags**
   • `is_regular_savings = 1` → savings plans
   • `is_a_fund = 1` → investment plans
5. **Data Hygiene** — Queries coalesce `NULL`s and format numbers for consistent, human‑readable output.

---

## Per‑Question Explanations & Sample Outputs

### 1 – High‑Value Customers with Multiple Products

**Objective** : list customers who hold **both** a funded savings plan **and** a funded investment plan, ranked by total deposits.

**Query Highlights**

* Join `users_customuser`, `savings_savingsaccount`, and `plans_plan`.
* Filter rows where `is_regular_savings = 1` **and** `is_a_fund = 1`.
* Aggregate per customer with `GROUP BY owner_id`.
* Compute:
  `COUNT(DISTINCT savings_id)` **and** `COUNT(DISTINCT investment_id)`
  `SUM(confirmed_amount)/100` → `total_deposits` (₦).
* `HAVING` ensures at least one of each product; sorted `DESC` by deposits.

```sql
-- key formula
SUM(savings.confirmed_amount) / 100 AS total_deposits
```

| owner\_id | name     | savings\_count | investment\_count | total\_deposits |
| --------: | -------- | -------------: | ----------------: | --------------: |
|      1001 | John Doe |              2 |                 1 |       15 000.00 |
|      1003 | Jane Ali |              3 |                 2 |       13 250.50 |

---

### 2 – Transaction Frequency Analysis

**Objective** : segment customers by **average monthly transaction count**.

**Logic**

1. `DATE_TRUNC('month', created_at)` → month bucket.
2. Count monthly tx per customer: `COUNT(*)`.
3. Average those counts: `AVG(tx_count)`.
4. Categorize via `CASE`.

```sql
CASE
  WHEN avg_tx_per_month >= 10 THEN 'High Frequency'
  WHEN avg_tx_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency'
  ELSE 'Low Frequency'
END AS frequency_category
```

| frequency\_category | customer\_count | avg\_transactions\_per\_month |
| ------------------- | --------------: | ----------------------------: |
| High Frequency      |             250 |                          15.2 |
| Medium Frequency    |           1 200 |                           5.5 |
| Low Frequency       |             600 |                           1.9 |

---

### 3 – Account Inactivity Alert

**Objective** : surface active accounts (savings or investment) with **no inflow in the last 365 days**.

```sql
CURRENT_DATE - MAX(created_at) AS inactivity_days
```

| plan\_id | owner\_id | type       | last\_transaction\_date | inactivity\_days |
| -------: | --------: | ---------- | ----------------------- | ---------------: |
|     1001 |       305 | Savings    | 2023‑08‑10              |              400 |
|     1010 |       450 | Investment | 2023‑01‑12              |              480 |

---

### 4 – Customer Lifetime Value (CLV) Estimation

**Objective** : estimate **CLV** using tenure and a profit rate of **0.1 %** per transaction.

```sql
(total_transactions / tenure_months) * 12 * avg_profit_per_transaction AS estimated_clv
```

| customer\_id | name     | tenure\_months | total\_transactions | estimated\_clv |
| -----------: | -------- | -------------: | ------------------: | -------------: |
|         1001 | John Doe |             24 |                 120 |         600.00 |
|         1002 | Grace O. |             36 |                  90 |         300.00 |

---

## Challenges & Resolutions

| Challenge                                                    | Resolution                                                                                                                |
| ------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------- |
| *Incomplete Schema* — column names/types not fully specified | Assumed conventional fields (`created_at`, `confirmed_amount`, `date_joined`) and explained assumptions in code comments. |
| *Currency in Kobo* — risk of misreporting                    | Standardised all value outputs by dividing by 100 and documenting the conversion.                                         |
| *Frequency Edge Cases*                                       | Used inclusive CASE ranges to avoid off‑by‑one misclassification.                                                         |
| *Plan Type Ambiguity*                                        | Utilised explicit boolean flags `is_regular_savings`, `is_a_fund` to separate savings vs. investment.                     |
| *Overlapping Inactivity*                                     | Combined savings & investment via `UNION ALL`, tagging each row with a `type` field.                                      |

---

## Additional Notes

* Queries follow ANSI‑SQL; minor tweaks adapt them to PostgreSQL/MySQL/SQLite.
* Each `.sql` file is self‑contained, idempotent, and heavily commented.
* Output formats align with stakeholder reporting needs.
* NULL handling, date arithmetic, and currency precision are explicitly managed.

---

## Contributing & Feedback

Have an idea, spotted an issue, or want to share feedback? **Open an Issue or pull request!**

1. Click the **Issues** tab or [start a new issue](https://github.com/Jabs081/DataAnalytics-Assessment/issues/new) and describe your suggestion or problem.
2. Fork the repo, commit your fixes to a feature branch, and open a **Pull Request**—we’ll review ASAP.

> *Maintainer username*: **[@Jabs081](https://github.com/Jabs081)**

---

**Prepared & submitted by** | **JABS**
**Date** | 17 May 2025
**Location** | Africa/Lagos
