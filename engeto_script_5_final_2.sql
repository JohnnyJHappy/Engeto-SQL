CREATE OR REPLACE VIEW ekonomiky AS
SELECT 
	t_jan_stastny_project_SQL_secondary.country,
	t_jan_stastny_project_SQL_secondary.`year`,
	ROUND(AVG(t_jan_stastny_project_SQL_secondary.GDP), 0) AS hdp,
	ROUND(AVG(t_jan_stastny_project_SQL_primary_table_4.prumerna_mzda), 0) AS mzdaa,
	ROUND(AVG(t_jan_stastny_project_SQL_primary_table_4.hodnota), 2) AS hodnotaa
FROM t_jan_stastny_project_SQL_secondary
LEFT JOIN t_jan_stastny_project_SQL_primary_table_4
	 ON t_jan_stastny_project_SQL_primary_table_4.rok = t_jan_stastny_project_SQL_secondary.`year` 
WHERE prumerna_mzda IS NOT NULL AND country = 'Czech Republic'	 
GROUP BY t_jan_stastny_project_SQL_secondary.`year`
ORDER BY t_jan_stastny_project_SQL_secondary.`year`;

WITH vysl AS 
(SELECT 
	*,
	ROUND(hdp * 100 / (LAG(hdp,1) OVER(ORDER BY `year`)),2) AS zmena_hdp,
	ROUND(mzdaa * 100 / (LAG(mzdaa,1) OVER(ORDER BY `year`)),2) AS zmena_mzdy,
	ROUND(hodnotaa * 100 / (LAG(hodnotaa,1) OVER(ORDER BY `year`)),2) AS zmena_ceny	
FROM ekonomiky)
SELECT 
	vysl.`year` AS rok,
	zmena_hdp - 100 AS zmena_HDP,
	CASE WHEN zmena_hdp > 100.0 THEN '↑' ELSE '↓' END AS HDP,
	CASE WHEN zmena_mzdy > 100.0 THEN '↑' ELSE '↓' END AS mzdy,
	CASE WHEN zmena_ceny > 100.0 THEN '↑' ELSE '↓' END AS ceny,
	CASE WHEN zmena_hdp > 100.0 AND zmena_mzdy > 100.0  THEN '+' ELSE '' END AS 'když roste HDP, rostou mzdy', 
    CASE WHEN zmena_hdp > 100.0 AND zmena_ceny > 100.0  THEN '+' ELSE '' END AS 'když roste HDP, rostou ceny',
	CASE WHEN zmena_hdp > 100.0  AND LAG(zmena_mzdy,-1) OVER(ORDER BY `year`) > 100.0  THEN '+' ELSE '' END AS 'když roste HDP, rostou mzdy v dalším roce',
    CASE WHEN zmena_hdp > 100.0  AND LAG(zmena_ceny,-1) OVER(ORDER BY `year`) > 100.0  THEN '+' ELSE '' END AS 'když roste HDP, rostou ceny v dalším roce'
FROM vysl
HAVING `year` BETWEEN 2007 AND 2018;