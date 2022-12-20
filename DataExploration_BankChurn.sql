-- Data Exploration of Bank Customer Churn using SQL:

SELECT * FROM BankChurn.bankchurn;

-- 1. Total Customers:
SELECT count(distinct customer_id) as Total_Customers FROM BankChurn.bankchurn;

-- 2. Total Customers in each Country:
SELECT country, count(customer_id) as total_cust FROM BankChurn.bankchurn group by country;

-- 3. Proportion of Customers Exited from each country:
SELECT country,count(churn) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust FROM BankChurn.bankchurn 
group by country order by PropExitedCust desc ; -- More exists in Germany

 -- 4. Proportion of Customers Exited from each country based on gender:
SELECT country, gender, count(gender) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCus
FROM BankChurn.bankchurn group by country, gender
 order by country, PropExitedCus desc; -- Comparitively more Female exits for each country
 
 -- 5. Proportion of Customers Exited having a credit card:
 SELECT credit_card, sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust FROM BankChurn.bankchurn
 GROUP BY credit_card; 
 
 -- 6. Number of Products owned by proportion of Customers Exited:
 SELECT products_number, count(churn) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
 sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust
 FROM BankChurn.bankchurn 
 GROUP BY products_number order by PropExitedCust desc; -- More Products, More exits
 
 -- 7. Proportion of Customers Exited vs active status:
 SELECT active_member, count(churn) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
 sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust
 FROM BankChurn.bankchurn 
 GROUP BY active_member order by PropExitedCust desc; -- More active, Less exits
 
 -- 8. Tenure of Exited Customers:
 SELECT tenure, count(churn) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
 sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust
 FROM BankChurn.bankchurn 
 GROUP BY tenure order by PropExitedCust desc;
 
 -- 9. Average Salary of Exited Customers for each country:
 SELECT country, gender, round(avg(estimated_salary)) FROM BankChurn.bankchurn
 WHERE churn=1 GROUP BY country, gender order by country, gender;
 
 -- 10. Age bracket of Proportion of Customers Exited:
 SELECT CASE
 WHEN age<21 THEN "0-20"
 WHEN age>=21 and age<31 THEN "21-30"
 WHEN age>=31 and age<41 THEN "31-40"
 WHEN age>=41 and age<51 THEN "41-50"
 ELSE "50+"
 END as age_bracket, count(churn) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
 sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust
 FROM BankChurn.bankchurn
 GROUP BY (CASE
 WHEN age<21 THEN "0-20"
 WHEN age>=21 and age<31 THEN "21-30"
 WHEN age>=31 and age<41 THEN "31-40"
 WHEN age>=41 and age<51 THEN "41-50"
 ELSE "50+"
 END)
 order by PropExitedCust desc; -- age=40 to 50+ more exits
 
 -- 11. Credit Score of Proportion of Customers Exited:
 WITH CTE_BankChurn(churn, CreditScore_bracket)
 as
(SELECT churn, CASE
 WHEN credit_score<=200 THEN "0-200"
 WHEN credit_score>200 and credit_score<=400 THEN "201-400"
 WHEN credit_score>400 and credit_score<=600 THEN "401-600"
 WHEN credit_score>600 and credit_score<=800 THEN "601-800"
 WHEN credit_score>800 and credit_score<=1000 THEN "801-1000"
 ELSE "1000+"
 END as CreditScore_bracket
 FROM BankChurn.bankchurn)
 SELECT CreditScore_bracket, count(churn) as total_cust, sum(case when churn=1 then 1 else 0 end) as exited_cust,
 sum(case when churn=1 then 1 else 0 end)/count(churn) as PropExitedCust 
 FROM CTE_BankChurn GROUP BY CreditScore_bracket order by PropExitedCust desc; -- Less Score More Exits
 
 