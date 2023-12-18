CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_finalni AS
SELECT 
	t_jan_stastny_project_SQL_primary_table_payroll.*,
	t_jan_stastny_project_SQL_primary_table_3.potravina,
	t_jan_stastny_project_SQL_primary_table_3.cena
FROM  t_jan_stastny_project_SQL_primary_table_payroll
LEFT JOIN t_jan_stastny_project_SQL_primary_table_3
   ON t_jan_stastny_project_SQL_primary_table_3.datum =  t_jan_stastny_project_SQL_primary_table_payroll.rok;

WITH vypocet_1 AS (
SELECT 
		rok,
		AVG(prumerna_mzda) AS mzda,
		potravina,
		cena AS mleko
FROM t_jan_stastny_project_SQL_primary_finalni
WHERE potravina IN ('Mléko polotučné pasterované', 'Chléb konzumní kmínový')
GROUP BY rok, potravina
HAVING rok = 2006 OR rok = 2018
ORDER BY rok, potravina
),
vypocet_2 AS (
SELECT
	*, lag(mleko,2) OVER (ORDER BY potravina, rok) AS chleb
	FROM vypocet_1
)
SELECT 
	rok, ROUND(mzda,0) AS prum_mzda_vsechny_odv, ROUND(mzda/mleko, 1) AS mleko_pocet_litru, ROUND(mzda/chleb,1) AS chleb_pocet_kg
	FROM vypocet_2
WHERE chleb IS NOT NULL;

-- prům mzda za rok 2006 a 2018
CREATE OR REPLACE TABLE vypocty_chleba_mleko
SELECT odvetvi, rok, ROUND(AVG(prumerna_mzda), 0) AS prum_mzda
FROM t_jan_stastny_project_SQL_primary_finalni
WHERE rok = 2018 OR rok = 2006
GROUP BY odvetvi, rok;

 -- pro daná odvětví?
SELECT 	rok,	
		ROUND(AVG(prumerna_mzda), 3) AS prumerna_mzda_rocni,
		odvetvi,
		jednotka
FROM t_jan_stastny_project_SQL_primary_table
WHERE rok = 2000 OR rok = 2021
GROUP BY odvetvi, rok;

