# Loan Risk Prediction Database

## Overview
This project analyzes loan applications and credit features to extract meaningful insights and trends that help in predicting loan risks. Below are the key questions and SQL queries used for this analysis.

---

## Database Schema
```sql
CREATE DATABASE Loan_Risk_Prediction;
USE Loan_Risk_Prediction;

SELECT * FROM credit_features_subset;
SELECT * FROM loan_applications;
SELECT * FROM loan_data_dictionary;
```

---

## Analysis and Queries

### 1. Loan Application Analysis
- **How many loan applications were successful (`Success = 1`) versus unsuccessful?**
```sql
SELECT COUNT(*) AS Success_Application
FROM loan_applications
WHERE success = 1;
```

- **What is the average requested loan amount for successful applications?**
```sql
SELECT AVG(amount) AS Average_Loan_App
FROM loan_applications;
```

- **Which loan purposes have the highest approval rates?**
```sql
SELECT TOP (1) loanpurpose, COUNT(success) AS App_Rate
FROM loan_applications
GROUP BY loanpurpose
ORDER BY App_Rate DESC;
```

---

### 2. Employment Type Insights
- **What is the distribution of loan applications by employment type?**
```sql
SELECT employmenttype, COUNT(*) AS Distributions
FROM loan_applications
GROUP BY employmenttype
ORDER BY Distributions DESC;
```

- **Does employment type affect the success rate of loan applications?**
```sql
SELECT 
    employmenttype,
    COUNT(*) AS Total_App,
    SUM(CASE WHEN success = 1 THEN 1 ELSE 0 END) AS SuccessApp,
    ROUND(SUM(CASE WHEN success = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS SuccessRate
FROM loan_applications
GROUP BY employmenttype
ORDER BY SuccessRate DESC;
```

---

### 3. Loan Amount and Term Analysis
- **What is the average loan amount by term (e.g., 36 months, 60 months)?**
```sql
SELECT 
    term,
    AVG(amount) AS Avg_By_Term
FROM loan_applications
GROUP BY term
ORDER BY term DESC;
```

- **What is the maximum loan amount requested for each loan purpose?**
```sql
SELECT loanpurpose, MAX(amount) AS Max_LoanAmount
FROM loan_applications
GROUP BY loanpurpose
ORDER BY Max_LoanAmount DESC;
```

---

### 4. Credit Features and Loan Success
- **Is there a correlation between the number of default accounts (`ALL_CountDefaultAccounts`) and loan success?**
```sql
SELECT success, AVG(all_countdefaultaccounts) AS AVGACCOUNT
FROM credit_features_subset CF
JOIN loan_applications la ON cf.uid = la.uid
GROUP BY success
ORDER BY success DESC;
```

- **What is the average `ALL_SumCurrentOutstandingBal` for successful versus unsuccessful applications?**
```sql
SELECT success, AVG(all_sumcurrentoutstandingbal) AS AvgOutstanding_Bal
FROM credit_features_subset CF
JOIN loan_applications la ON cf.uid = la.uid
GROUP BY success
ORDER BY success DESC;
```

---

### 5. Account Age and Loan Success
- **Does the age of the oldest account (`ALL_AgeOfOldestAccount`) influence loan success rates?**
```sql
SELECT 
    success, 
    AVG(ALL_AgeOfOldestAccount) AS AgeOldestAccount
FROM credit_features_subset CF
JOIN loan_applications la ON cf.uid = la.uid
GROUP BY success
ORDER BY success DESC;
```

- **What is the average account age for successful loan applicants?**
```sql
SELECT 
    ROUND(AVG(ALL_meanaccountage), 0) AS AvgAccountAge
FROM credit_features_subset CF
JOIN loan_applications la ON cf.uid = la.uid
WHERE success = 1;
```

---

### 6. Loan Purpose Analysis
- **Which loan purpose is most common among applications?**
```sql
SELECT TOP (1) LoanPurpose, COUNT(LoanPurpose) AS Num_Loan
FROM loan_applications
GROUP BY LoanPurpose
ORDER BY COUNT(LoanPurpose) DESC;
```

- **What is the average loan amount for each purpose?**
```sql
SELECT LoanPurpose, AVG(Amount) AS Avg_Amount
FROM loan_applications
GROUP BY LoanPurpose
ORDER BY Avg_Amount DESC;
```

---

### 7. Time-Based Trends
- **How many loan applications were submitted each month?**
```sql
SELECT MONTH(applicationdate) AS Months, COUNT(*) AS Total_App
FROM loan_applications
GROUP BY MONTH(applicationdate)
ORDER BY MONTH(applicationdate) ASC;
```

- **Is there a trend in loan success rates over time?**
```sql
SELECT 
    DATENAME(MONTH, applicationdate) AS Months,
    COUNT(*) AS Total_App, 
    SUM(Success) AS SuccessApp,
    SUM(Success) * 100.0 / COUNT(Success) AS Success_Rate
FROM loan_applications
GROUP BY DATENAME(MONTH, applicationdate)
ORDER BY DATENAME(MONTH, applicationdate) ASC;
```

---

### 8. Credit Metrics Overview
- **What is the average and median `ALL_MeanAccountAge` for all users?**
```sql
WITH SortedData AS (
    SELECT 
        ALL_MeanAccountAge,
        ROW_NUMBER() OVER (ORDER BY ALL_MeanAccountAge) AS RowNum,
        COUNT(*) OVER () AS TotalCount
    FROM credit_features_subset
)
SELECT 
    (SELECT ROUND(AVG(ALL_MeanAccountAge), 2) FROM credit_features_subset) AS AverageAge,
    ROUND(CASE 
        WHEN TotalCount % 2 = 1 THEN 
            (SELECT ALL_MeanAccountAge
             FROM SortedData 
             WHERE RowNum = (TotalCount + 1) / 2)
        ELSE 
            (SELECT AVG(ALL_MeanAccountAge) 
             FROM SortedData 
             WHERE RowNum IN (TotalCount / 2, TotalCount / 2 + 1))
    END, 2) AS MedianAge
FROM SortedData
WHERE RowNum = 1;
```

- **What are the top 5 users with the highest `ALL_SumCurrentOutstandingBal`?**
```sql
SELECT TOP (5) UID, ALL_SumCurrentOutstandingBal
FROM credit_features_subset
ORDER BY ALL_SumCurrentOutstandingBal DESC;
```

---

### 9. Comparative Analysis
- **How does the number of active accounts (`ALL_CountActive`) differ between successful and unsuccessful loan applicants?**
```sql
SELECT SUM(ALL_CountActive) AS Active_Account, SUCCESS
FROM credit_features_subset CF
JOIN loan_applications LA ON CF.UID = LA.UID
GROUP BY SUCCESS;
```

- **What is the proportion of users with at least one default account who got their loan approved?**
```sql
SELECT 
    ROUND(
        CAST(SUM(CASE WHEN cf.ALL_CountDefaultAccounts > 0 AND la.Success = 1 THEN 1 ELSE 0 END) AS FLOAT) 
        / SUM(CASE WHEN cf.ALL_CountDefaultAccounts > 0 THEN 1 ELSE 0 END) * 100, 2
    ) AS ApprovalRate
FROM credit_features_subset cf
JOIN loan_applications la ON cf.UID = la.UID;
```

---

### 10. Demographic Insights
- **Which employment type requested the highest average loan amount?**
```sql
SELECT TOP (1)
    EmploymentType, COUNT(EmploymentType) AS App_Req
FROM loan_applications
GROUP BY EmploymentType;
```

- **Are self-employed individuals more or less likely to have loans approved?**
```sql
SELECT 
    EmploymentType,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) AS ApprovedLoans,
    ROUND(SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM loan_applications
GROUP BY EmploymentType
ORDER BY ApprovalRate DESC;
```
```
