-- ================================================
-- BANK CUSTOMER CHURN ANALYSIS
-- Dataset : Bank Customer Churn
-- Tool    : MySQL
-- ================================================

CREATE DATABASE IF NOT EXISTS bank_churn_analysis;
USE bank_churn_analysis;

-- ------------------------------------------------
-- Q1. What is the overall churn rate?
-- ------------------------------------------------
SELECT
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn;

-- ------------------------------------------------
-- Q2. Average balance of churned vs stayed customers?
-- ------------------------------------------------
SELECT
    CASE
        WHEN Exited = 1 THEN 'Churned'
        ELSE 'Stayed'
    END AS CustomerStatus,
    ROUND(AVG(Balance), 2) AS AverageBalance
FROM bank_churn
GROUP BY Exited;

-- ------------------------------------------------
-- Q3. Which country has the highest churn rate?
-- ------------------------------------------------
SELECT
    Geography,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY Geography
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q4. Which age group churns the most?
-- ------------------------------------------------
SELECT
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '51+'
    END AS AgeGroup,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY AgeGroup
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q5. Do inactive members churn more?
-- ------------------------------------------------
SELECT
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS MemberStatus,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY IsActiveMember
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q6. Does filing a complaint lead to churn?
-- ------------------------------------------------
SELECT
    CASE
        WHEN Complain = 1 THEN 'Yes'
        ELSE 'No'
    END AS ComplainStatus,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY Complain
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q7. Does number of products affect churn?
-- ------------------------------------------------
SELECT
    NumOfProducts,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY NumOfProducts
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q8. Which card type customers leave most?
-- ------------------------------------------------
SELECT
    CardType,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY CardType
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q9. Which customer profile is most at risk?
-- ------------------------------------------------
SELECT
    COUNT(*) AS CustomerCount,
    Geography,
    CASE
        WHEN Age BETWEEN 18 AND 30 THEN '18-30'
        WHEN Age BETWEEN 31 AND 40 THEN '31-40'
        WHEN Age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '51+'
    END AS AgeGroup,
    CASE
        WHEN IsActiveMember = 1 THEN 'Active'
        ELSE 'Inactive'
    END AS MemberStatus,
    NumOfProducts,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY Geography, AgeGroup, MemberStatus, NumOfProducts
HAVING COUNT(*) > 50
ORDER BY ChurnRate DESC;

-- ------------------------------------------------
-- Q10. Which high value customers are at risk?
-- ------------------------------------------------
SELECT
    CASE
        WHEN Balance < 50000 THEN 'Low Value'
        WHEN Balance BETWEEN 50000 AND 100000 THEN 'Medium Value'
        ELSE 'High Value'
    END AS ValueStatus,
    ROUND(
        COUNT(CASE WHEN Exited = 1 THEN 1 END) / COUNT(*) * 100.0, 2
    ) AS ChurnRate
FROM bank_churn
GROUP BY ValueStatus
ORDER BY ChurnRate DESC;