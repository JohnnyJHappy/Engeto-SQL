CREATE OR REPLACE VIEW ukol_2 AS
SELECT 
	t_jan_stastny_project_SQL_primary_table_payroll.*,
	t_jan_stastny_project_SQL_primary_table_food.potravina,
	t_jan_stastny_project_SQL_primary_table_food.cena
FROM  t_jan_stastny_project_SQL_primary_table_payroll
LEFT JOIN t_jan_stastny_project_SQL_primary_table_food
   ON t_jan_stastny_project_SQL_primary_table_food.datum =  t_jan_stastny_project_SQL_primary_table_payroll.rok;

WITH vypocet_1 AS (
SELECT 
		rok,
		AVG(prumerna_mzda) AS mzda,
		potravina,
		cena AS mleko
FROM ukol_2
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



