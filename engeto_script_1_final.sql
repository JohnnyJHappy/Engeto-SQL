WITH mzda_1 AS (
SELECT 
		rok,	
		ROUND(AVG (prumerna_mzda), 0) AS prumerna_mzda_2021,
		jednotka,
		odvetvi
FROM t_jan_stastny_project_SQL_primary_table_payroll
WHERE rok = '2000' OR rok = '2021'
GROUP BY odvetvi, rok
ORDER BY odvetvi, rok),
mzda_2 AS (
SELECT 
	*,
	LAG(prumerna_mzda_2021) OVER (ORDER BY odvetvi, rok) AS prumerna_mzda_2000
FROM mzda_1
)
SELECT 
	odvetvi,
	prumerna_mzda_2000,
	prumerna_mzda_2021,
	ROUND(((prumerna_mzda_2021 / prumerna_mzda_2000)*100),1) AS rust_v_procentech,
	CASE WHEN odvetvi IS NULL THEN 'Nezname/Neurcene odvětví' ELSE 'V pořádku' END AS poznamka
FROM mzda_2 
WHERE rok = '2021'
ORDER BY rust_v_procentech DESC
;