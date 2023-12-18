-- #1 Průměrné mzdy
-- ALTER TABLE czechia_payroll_industry_branch CHANGE COLUMN  `name` name_industry_branch varchar(255);
-- ALTER TABLE czechia_payroll_industry_branch CHANGE COLUMN `code` code_industry_branch char(1);
-- ALTER TABLE czechia_payroll_value_type CHANGE COLUMN `name` name_value_type varchar(255);
-- ALTER TABLE czechia_payroll_value_type CHANGE COLUMN `code` code_value_type int(11);
-- ALTER TABLE czechia_payroll_unit CHANGE COLUMN `name` name_payroll_unit varchar(255);
-- ALTER TABLE czechia_payroll_unit CHANGE COLUMN `code `code_payroll_unit int(11);
-- ALTER TABLE	czechia_payroll_calculation CHANGE COLUMN `name` name_calculation varchar(255);
-- ALTER TABLE	czechia_payroll_calculation CHANGE COLUMN `code` code_calculation int(11);
-- neni povoleno menit data

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

-- přehled prvotní joinované tabulky

SELECT *
FROM t_jan_stastny_project_SQL_primary_table_payroll;

-- přehled vybraných hodnot
SELECT 	rok,	
		prumerna_mzda,	
		jednotka,
		odvetvi
FROM t_jan_stastny_project_SQL_primary_table_payroll;

-- joinovaná tabulka pro potraviny
CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_table_food AS
SELECT *
FROM czechia_price cp 
LEFT JOIN czechia_price_category cpc  
	ON cpc.code = cp.category_code;

-- joinovaná tabulka pro potraviny
SELECT *
FROM t_jan_stastny_project_SQL_primary_table_food;

-- joinovaná tabulka pro potraviny se sloupcem rok
CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_table_food_year
SELECT YEAR(date_from) AS rokk, AVG(value) AS hodnota
FROM t_jan_stastny_project_SQL_primary_table_food
GROUP BY rokk, name;

-- joinovaná tabulka pro potraviny
SELECT 
	YEAR(date_from) AS datum,	
	name AS potravina,
	value AS cena,
	price_value AS mnozstvi_potraviny,
	price_unit AS jednotka_potraviny
FROM t_jan_stastny_project_SQL_primary_table_food

-- vsechno dohromady
CREATE OR REPLACE TABLE t_jan_stastny_project_SQL_primary_table_4
	SELECT *
	FROM t_jan_stastny_project_SQL_primary_table_payroll
	LEFT JOIN t_jan_stastny_project_SQL_primary_table_food_year
	ON t_jan_stastny_project_SQL_primary_table_food_year.rokk = t_jan_stastny_project_SQL_primary_table_payroll.rok;
 
SELECT 
		YEAR(date_from) AS datum,	
		name AS potravina,
		value AS cena,
		price_value AS mnozstvi_potraviny,
		price_unit AS jednotka_potraviny
	FROM t_jan_stastny_project_SQL_primary_table_food
	GROUP BY datum, potravina

	
-- tabulka s potravinami s rokem	
SELECT *
FROM t_jan_stastny_project_SQL_primary_table_4

SELECT *
FROM t_jan_stastny_project_SQL_primary_table_food

