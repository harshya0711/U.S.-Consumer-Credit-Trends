
SELECT * FROM consumer_credit_data;

---- # View the First 10 Records  -----

SELECT * FROM consumer_credit_data LIMIT 10;

----- # Count Total Records ------

SELECT COUNT(*) FROM consumer_credit_data;

----- # Check for Duplicate Entries  ------

SELECT time_period, COUNT(*) 
FROM consumer_credit_data
GROUP BY time_period
HAVING COUNT(*) > 1 ;

---- # Find the Earliest and Latest Date in the Data  -----

SELECT MIN(time_period) AS earliest_date,
      MAX(time_period) AS latest_date
          FROM consumer_credit_data;
          
-------# Monthly Average of Consumer Credit Growth -----

SELECT 
    YEAR(time_period) AS year, 
    MONTH(time_period) AS month, 
    AVG(percent_change_total_credit) AS avg_growth 
FROM consumer_credit_data
GROUP BY YEAR(time_period), MONTH(time_period)
ORDER BY year, month;

------ # Compare Revolving vs Non-Revolving Credit ------------

SELECT 
    time_period, 
    revolving_credit_seasonally_adjusted, 
    nonrevolving_credit_seasonally_adjusted, 
    ROUND ((revolving_credit_seasonally_adjusted /
      total_credit_seasonally_adjusted),2) * 100 AS revolving_percentage, 
    ROUND ((nonrevolving_credit_seasonally_adjusted /
    total_credit_seasonally_adjusted),2) * 100 AS nonrevolving_percentage
FROM consumer_credit_data
ORDER BY time_period DESC ;

------ #  Detect Recession Indicators (Decline in Credit Usage) -----

SELECT time_period, percent_change_total_credit 
FROM consumer_credit_data
WHERE percent_change_total_credit < 0
ORDER BY time_period DESC;

------  # Top 5 Months with Highest Growth in Consumer Credit  ------

SELECT time_period, percent_change_total_credit 
FROM consumer_credit_data
ORDER BY percent_change_total_credit DESC
LIMIT 5;

----- # Yearly Trend in Student Loan and Motor Vehicle Loans ----

SELECT 
    YEAR(time_period) AS year, 
    SUM(student_loans_not_adjusted) AS total_student_loans, 
    SUM(motor_vehicle_loans_not_adjusted) AS total_vehicle_loans 
FROM consumer_credit_data
GROUP BY YEAR(time_period)
ORDER BY year;

----- # Find the Most Volatile Periods in Credit Trends ------

SELECT time_period, percent_change_total_credit 
FROM consumer_credit_data
WHERE ABS(percent_change_total_credit) >
     (SELECT AVG(ABS(percent_change_total_credit))
                    FROM consumer_credit_data)
ORDER BY ABS(percent_change_total_credit) DESC;

-- # Find Missing (NULL) Values ----

SELECT 
    COUNT(*) AS total_rows,
    SUM(CASE WHEN percent_change_total_credit
            IS NULL THEN 1 ELSE 0 END) 
                AS missing_total_credit,
    SUM(CASE WHEN percent_change_revolving_credit 
            IS NULL THEN 1 ELSE 0 END) 
               AS missing_revolving_credit,
    SUM(CASE WHEN percent_change_nonrevolving_credit 
            IS NULL THEN 1 ELSE 0 END) 
			   AS missing_nonrevolving_credit
FROM consumer_credit_data;

---- # Identify the Most and Least Volatile Years in Credit Growth -----

SELECT 
    YEAR(time_period) AS year, 
   ROUND(STDDEV(percent_change_total_credit),1) AS credit_growth_volatility
FROM consumer_credit_data
GROUP BY YEAR(time_period)
ORDER BY credit_growth_volatility DESC;

----- # Detect Periods When Credit Growth Was Led by Non-Revolving Loans ----

SELECT 
    YEAR(time_period) AS year, 
    SUM(total_credit_seasonally_adjusted) AS total_credit, 
    SUM(nonrevolving_credit_seasonally_adjusted) AS total_nonrevolving_credit, 
    ROUND ((SUM(nonrevolving_credit_seasonally_adjusted) /
       SUM(total_credit_seasonally_adjusted)),2)  * 100 AS nonrevolving_credit_ratio
FROM consumer_credit_data
GROUP BY YEAR(time_period)
ORDER BY year;