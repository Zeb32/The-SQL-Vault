Create database Loan_Risk_Prediction
use loan_Risk_Prediction

Select * from credit_features_subset
select * from loan_applications
select * from loan_data_dictionary



1--Questions to Explore**
--Loan Application Analysis**:
   -- How many loan applications were successful (`Success = 1`) versus unsuccessful?

Select COUNT(*) as Succes_Application
from loan_applications
WHERE success = 1

   -- What is the average requested loan amount for successful applications?
select avg(amount) as Average_Loan_App
from loan_applications


   -- Which loan purposes have the highest approval rates?
select top (1) loanpurpose,count(success) as App_Rate
from loan_applications
group by loanpurpose
order by App_Rate desc



--2. **Employment Type Insights**:
   -- What is the distribution of loan applications by employment type?

select  employmenttype, count(*) as Distributions
from loan_applications
group by employmenttype
order by Distributions desc


   -- Does employment type affect the success rate of loan applications?
select 
	employmenttype,
	count(*) as Total_App,
	sum(case when success = 1 then 1 else 0 end) as SuccesApp,
	round(sum(case when success = 1 then 1 else 0 end)*100/count(*),2) as SuccessRate
from
	loan_applications
group by
	employmenttype
order by SuccessRate desc


--3. **Loan Amount and Term Analysis**:
   -- What is the average loan amount by term (e.g., 36 months, 60 months)?
 
 SELECT 
	term,
	avg(amount) as Avg_by_trem
 FROM 
	loan_applications
group by
	term
order by 
	term desc


   -- What is the maximum loan amount requested for each loan purpose?
SELECT loanpurpose, max(amount) as Max_loanAmount
from loan_applications
group by loanpurpose
order by Max_loanAmount desc



--4. **Credit Features and Loan Success**:
   -- Is there a correlation between the number of default accounts (`ALL_CountDefaultAccounts`) and loan success

   SELECT success, avg(all_countdefaultaccounts) as AVGACCOUNT
   FROM credit_features_subset CF
   JOIN loan_applications la
   ON	cf.uid = la.uid
   group by SUCCESS
   order by SUCCESS desc


   -- What is the average `ALL_SumCurrentOutstandingBal` for successful versus unsuccessful applications?

   SELECT success, avg(all_sumcurrentoutstandingbal) as AvgOutstanding_Bal
   FROM credit_features_subset CF
   JOIN loan_applications la
   ON	cf.uid = la.uid
   group by SUCCESS
   order by SUCCESS desc


--5. **Account Age and Loan Success**:
   -- Does the age of the oldest account (`ALL_AgeOfOldestAccount`) influence loan success rates?

SELECT 
	success, 
	avg(ALL_AgeOfOldestAccount) as AgeOldestAcoount
FROM	
	credit_features_subset CF
JOIN 
	loan_applications la
ON	
	cf.uid = la.uid
group by 
	SUCCESS
order by 
	SUCCESS desc


   -- What is the average account age for successful loan applicants?
  SELECT * FROM loan_applications
  SELECT * FROM credit_features_subset
  
SELECT  
	round(avg(ALL_meanaccountage),0) as Avgaccountage
FROM	
	credit_features_subset CF
JOIN 
	loan_applications la
ON	
	cf.uid = la.uid
	where success=	1


--6. **Loan Purpose Analysis**:
   -- Which loan purpose is most common among applications?
   select top (1) LoanPurpose, count(LoanPurpose) Num_Loan
   from loan_applications
   group by LoanPurpose
   order by count(LoanPurpose) desc ;




   -- What is the average loan amount for each purpose?
   select LoanPurpose, avg(Amount) as Avg_Amount
   from loan_applications
   group by LoanPurpose
   order by Avg_Amount desc ;



--7. **Time-Based Trends**:
   -- How many loan applications were submitted each month?
   select  MONTH(applicationdate) as Months, count(*) as Total_App
   from loan_applications
   group by MONTH(applicationdate)
   order by MONTH(applicationdate) asc

   -- Is there a trend in loan success rates over time?

  Select  datename(MONTH,applicationdate) as Months,count(*) as Total_App, sum(Success) as SucessApp,
   sum(Success)*100/count(Success) as Success_Rate
   from loan_applications
   group by datename(MONTH,applicationdate)
   --having Success = 1
   order by datename(MONTH,applicationdate) asc


--8. **Credit Metrics Overview**:
   -- What is the average and median `ALL_MeanAccountAge` for all users?

 WITH SortedData AS (
    SELECT 
        ALL_MeanAccountAge,
        ROW_NUMBER() OVER (ORDER BY ALL_MeanAccountAge) AS RowNum,
        COUNT(*) OVER () AS TotalCount
    FROM credit_features_subset
)
SELECT 
    (SELECT round(AVG(ALL_MeanAccountAge),2) FROM credit_features_subset	) AS AverageAge,
    round(CASE 
        WHEN TotalCount % 2 = 1 THEN 
            (SELECT ALL_MeanAccountAge
             FROM SortedData 
             WHERE RowNum = (TotalCount + 1) / 2)
        ELSE 
            (SELECT AVG(ALL_MeanAccountAge) 
             FROM SortedData 
             WHERE RowNum IN (TotalCount / 2, TotalCount / 2 + 1))
    END,2) AS MedianAge
FROM SortedData
WHERE RowNum = 1;



   -- What are the top 5 users with the highest `ALL_SumCurrentOutstandingBal`?

  Select top (5) UID, ALL_SumCurrentOutstandingBal
  from credit_features_subset
  ORDER BY ALL_SumCurrentOutstandingBal DESC

--9. **Comparative Analysis**:
   -- How does the number of active accounts (`ALL_CountActive`) differ between successful and unsuccessful loan applicants?
   SELECT SUM(ALL_CountActive) AS Active_Account , SUCCESS
   FROM credit_features_subset CF
   JOIN	loan_applications LA
   ON CF.UID = LA.UID
   GROUP BY SUCCESS


   -- What is the proportion of users with at least one default account who got their loan approved?

  SELECT 
    ROUND(
        CAST(SUM(CASE WHEN cf.ALL_CountDefaultAccounts > 0 AND la.Success = 1 THEN 1 ELSE 0 END) AS FLOAT) 
        / SUM(CASE WHEN cf.ALL_CountDefaultAccounts > 0 THEN 1 ELSE 0 END) * 100, 2
    ) AS ApprovalRate
FROM 
    credit_features_subset cf
JOIN 
    loan_applications la
ON 
    cf.UID = la.UID;



--10. **Demographic Insights**:
    -- Which employment type requested the highest average loan amount?
	select top (1)
	EmploymentType,COUNT(EmploymentType) App_Req
	from loan_applications
	group by EmploymentType

    -- Are self-employed individuals more or less likely to have loans approved?
SELECT 
    EmploymentType,
    COUNT(*) AS TotalApplications,
    SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) AS ApprovedLoans,
    ROUND(SUM(CASE WHEN Success = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS ApprovalRate
FROM 
    loan_applications
GROUP BY 
    EmploymentType
ORDER BY 
    ApprovalRate DESC;

