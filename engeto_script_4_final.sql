WITH prum_hod AS 
(SELECT 
	rok,
	ROUND(AVG(value), 2) AS mzda,
	ROUND(AVG(hodnota), 2) AS cena
FROM t_jan_stastny_project_SQL_primary_table_4
WHERE rok BETWEEN 2006 AND 2018
GROUP BY rok
),
lagy AS 
(SELECT 
	*,
	LAG(mzda,1) OVER(ORDER BY rok) AS lag_mzda,
	LAG(cena,1) OVER(ORDER BY rok) AS lag_cena
FROM prum_hod
),	
vypoc AS 
(SELECT 
	*,	
	ROUND(((mzda - lag_mzda) / lag_mzda), 4) * 100 AS zmena_mzda, 
	ROUND(((cena - lag_cena) / lag_cena), 4) * 100 AS zmena_ceny
FROM lagy)
SELECT
	rok,
	zmena_mzda,
	zmena_ceny,
	ROUND(zmena_mzda - zmena_ceny,2) AS 'absolutní rozdíl',
	CASE WHEN ROUND(zmena_mzda - zmena_ceny,1) > 10 THEN 'Ano' ELSE 'Ne' END AS 'Rozdíl větší než 10%?'
FROM vypoc 
HAVING rok IN ('2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018');