-- Přehled odvětví jak rostou/klesají mzdy
WITH mzda_1 AS (
SELECT 
		rok,	
		ROUND(AVG (prumerna_mzda), 0) AS prumerna_mzda,
		jednotka,
		odvetvi
FROM t_jan_stastny_project_SQL_primary_table_payroll
WHERE rok BETWEEN 2006 AND 2018
GROUP BY odvetvi, rok
ORDER BY odvetvi, rok),
mzda_2 AS (
SELECT 
	*,
	LAG(prumerna_mzda) OVER (ORDER BY odvetvi, rok) AS prumerna_mzda_nasledujici
FROM mzda_1
)
SELECT 
	rok,
	odvetvi,
	ROUND((((prumerna_mzda - prumerna_mzda_nasledujici)/ prumerna_mzda_nasledujici)*100),2) AS 'roční změna_v_procentech',
	CASE WHEN odvetvi IS NULL THEN 'Nezname/Neurcene odvětví' ELSE 'V pořádku' END AS poznamka_k_odvetvi
FROM mzda_2
WHERE rok BETWEEN 2007 AND 2018
; 

-- výpočet, kolikrát klesla/vzrostla mzda
WITH mzda_1 AS (
SELECT 
		rok,	
		ROUND(AVG (prumerna_mzda), 0) AS prumerna_mzda,
		jednotka,
		odvetvi
FROM t_jan_stastny_project_SQL_primary_table_payroll
WHERE rok BETWEEN 2006 AND 2018
GROUP BY odvetvi, rok
ORDER BY odvetvi, rok),
mzda_2 AS (
SELECT 
	*,
	LAG(prumerna_mzda) OVER (ORDER BY odvetvi, rok) AS prumerna_mzda_nasledujici
FROM mzda_1
)
SELECT 
	COUNT(CASE WHEN ((prumerna_mzda - prumerna_mzda_nasledujici)/ prumerna_mzda_nasledujici)*100 > 0 THEN 1 END) AS 'počet zvýšení mzdy za období',
	COUNT(CASE WHEN ((prumerna_mzda - prumerna_mzda_nasledujici)/ prumerna_mzda_nasledujici)*100 < 0 THEN 1 END) AS 'počet snížení mzdy za období',
	COUNT (((prumerna_mzda - prumerna_mzda_nasledujici)/ prumerna_mzda_nasledujici)*100) AS 'počet záznamů(kontrola)'
FROM mzda_2
