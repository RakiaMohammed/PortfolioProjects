-- Data Exploration of Bank Customer Churn using SQL:

SELECT * FROM BankChurn.bankchurn;

-- 1. Total Customers:
SELECT count(distinct customer_id) as Total_Customers FROM BankChurn.bankchurn;

-- 2. Total Customers in each Country:
SELECT country, count(customer_id) as total_cust FROM BankChurn.bankchurn group by country;

-- 3. Total Customers Exited from each country:
SELECT country, count(churn) as ExitedCustomers FROM BankChurn.bankchurn 
WHERE churn=1 group by country order by ExitedCustomers desc ; 

 -- 4. Total Customers Exited from each country based on gender:
SELECT country, gender, count(gender) FROM BankChurn.bankchurn WHERE churn=1 group by country, gender
 order by country; -- Comparitively more Female exits
 
 -- 5. Total Customers Exited having a credit card:
 SELECT credit_card, count(churn) as ExitedCust FROM BankChurn.bankchurn WHERE churn=1 
 GROUP BY credit_card; 
 
 -- 6. Number of Products owned by exited customers:
 SELECT products_number, count(churn) as ExitedCust FROM BankChurn.bankchurn 
 WHERE churn=1 GROUP BY products_number order by ExitedCust desc; -- More Products, Less exits
 
 -- 7. Exited customer count vs active members:
 SELECT active_member, count(churn) as ExitedCust FROM BankChurn.bankchurn 
 WHERE churn=1 GROUP BY active_member order by ExitedCust desc; -- More active, Less exits
 
 -- 8. Tenure of Exited Customers:
 SELECT tenure, count(churn) as ExitedCust FROM BankChurn.bankchurn 
 WHERE churn=1 GROUP BY tenure order by ExitedCust desc;
 
 -- 9. Average Salary of Exited Customers for each country:
 SELECT country, gender, round(avg(estimated_salary)) FROM BankChurn.bankchurn
 WHERE churn=1 GROUP BY country, gender order by country, gender;
 
 -- 10. Age bracket of Exited Customers:
 SELECT CASE
 WHEN age<21 THEN "0-20"
 WHEN age>=21 and age<31 THEN "21-30"
 WHEN age>=31 and age<41 THEN "31-40"
 WHEN age>=41 and age<51 THEN "41-50"
 WHEN age>=51 and age<61 THEN "51-60"
 ELSE "60+"
 END as age_bracket, 
 COUNT(churn) as ExitedCust
 FROM BankChurn.bankchurn WHERE churn=1
 GROUP BY (CASE
 WHEN age<21 THEN "0-20"
 WHEN age>=21 and age<31 THEN "21-30"
 WHEN age>=31 and age<41 THEN "31-40"
 WHEN age>=41 and age<51 THEN "41-50"
 WHEN age>=51 and age<61 THEN "51-60"
 ELSE "60+"
 END)
 order by ExitedCust desc; 
 
 -- 11. Credit Score of Exited Customers:
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
 FROM BankChurn.bankchurn WHERE churn=1)
 SELECT CreditScore_bracket, count(churn) FROM CTE_BankChurn GROUP BY CreditScore_bracket;
 
 