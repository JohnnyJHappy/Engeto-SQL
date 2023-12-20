CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_table_payroll AS 
SELECT 
	cp.value AS prumerna_mzda,		
	cp.value_type_code,
	cp.unit_code,
	cp.calculation_code,
	cp.industry_branch_code,
	cpc.code AS cpc_code,
	cpc.name AS calculation_name,
	cpib.code AS cpib_code,
	cpu.code AS cpu_code,
	cpvt.code AS cpvt_code,
	cpvt.name AS value_type_name,
	cp.payroll_year AS rok,	
	cp.value, 
	cpib.name AS odvetvi,
	cpu.name AS jednotka
FROM czechia_payroll cp
LEFT JOIN czechia_payroll_value_type cpvt 
	ON cpvt.code = cp.value_type_code
LEFT JOIN czechia_payroll_industry_branch cpib 
	ON cpib.code = cp.industry_branch_code
LEFT JOIN czechia_payroll_unit cpu 
	ON cpu.code = cp.unit_code 
LEFT JOIN czechia_payroll_calculation cpc 
	ON cpc.code = cp.calculation_code
WHERE 
	cpu.name = 'Kč';

-- joinovaná tabulka pro potraviny
CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_table_food AS
SELECT 
	YEAR(date_from) AS datum,	
	name AS potravina,
	ROUND(AVG(value),1) AS cena,
	price_value AS mnozstvi_potraviny,
	price_unit AS jednotka_potraviny
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc  
	ON cpc.code = cp.category_code
GROUP BY datum, potravina;


-- finální tabulka
CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_final
	SELECT rok, prumerna_mzda, jednotka, odvetvi, datum, potravina, cena, mnozstvi_potraviny, jednotka_potraviny
	FROM t_jan_stastny_project_SQL_primary_table_payroll
	LEFT JOIN t_jan_stastny_project_SQL_primary_table_food
	ON t_jan_stastny_project_SQL_primary_table_food.datum = t_jan_stastny_project_SQL_primary_table_payroll.rok;

