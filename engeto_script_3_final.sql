CREATE OR REPLACE VIEW ukol_3  AS
SELECT 
	datum,
	potravina,
	cena 
FROM t_jan_stastny_project_SQL_primary_table_3
WHERE potravina IS
NOT NULL 
GROUP BY datum, potravina
ORDER BY potravina, datum; 

SELECT 
	datum,
	potravina,
	cena,
	LAG(cena) OVER(ORDER BY potravina, datum) AS predesly
FROM ukol_3;

CREATE OR REPLACE VIEW vypocet_rozdil AS
SELECT 
	*, 
	LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum) AS lagg,
	ROUND(((cena - LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum)) / (LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum)) * 100), 2) AS rozdil_2
FROM t_jan_stastny_project_SQL_primary_table_3
WHERE datum IN ('2006', '2007', '2008', '2008', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018')
ORDER BY potravina, datum;		



-- takto vidim jak se mění cena
SELECT * FROM vypocet_rozdil
WHERE rozdil_2 IS NOT NULL 
-- mezi roky 2006-2018

CREATE OR REPLACE VIEW vypocet_rozdil_final AS
SELECT 
	*, 
	LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum) AS lagg,
	ROUND(((cena - LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum)) / (LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum)) * 100), 2) AS rozdil_2
FROM t_jan_stastny_project_SQL_primary_table_3
WHERE datum IN ('2006', '2018')
ORDER BY potravina, datum;	

-- filtr
SELECT 
	potravina, 
	rozdil_2 AS zmena_v_procentech
FROM vypocet_rozdil_final
WHERE rozdil_2 IS NOT NULL 
HAVING rozdil_2 > 0
ORDER BY rozdil_2 ASC
LIMIT 1;

-- přehled pro brambory
SELECT
	datum
	potravina,
	cena,
	rozdil_2 AS zmena_v_procentech
FROM vypocet_rozdil
WHERE potravina = 'Konzumní brambory'

-- průmer
SELECT
	datum
	potravina,
	AVG(cena),
	rozdil_2 AS zmena_v_procentech
FROM vypocet_rozdil
WHERE potravina = 'Konzumní brambory'
	