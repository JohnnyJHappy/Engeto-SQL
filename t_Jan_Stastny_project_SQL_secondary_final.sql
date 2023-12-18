SELECT * 
FROM countries 
LEFT JOIN  economies
ON economies.country = countries.country
GROUP BY countries.country;

SELECT * 
FROM economies 
LEFT JOIN countries 
ON economies.country = countries.country
GROUP BY countries.country;

SELECT 
	AVG(value) AS prum_hodnota,
	YEAR(date_from) AS rok
FROM czechia_price cp
GROUP BY rok
ORDER BY rok; 

CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_secondary
SELECT 
	economies.country,
	economies.`year`,
	economies.GDP
FROM economies
WHERE `year` BETWEEN 2006 AND 2018
ORDER BY economies.country, `year`;

-- zjištění začátek a konec dat 

SELECT 
	MIN(YEAR(date_from)),
	MAX(YEAR(date_from))
FROM czechia_price; -- 2006 - 2018

SELECT 
	MIN(payroll_year),
	MAX(payroll_year)
FROM czechia_payroll;--  2000 - 2021

SELECT * FROM t_jan_stastny_project_SQL_secondary
