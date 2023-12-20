CREATE OR REPLACE VIEW ukol_3  AS
SELECT 
	datum,
	potravina,
	cena 
FROM t_jan_stastny_project_SQL_primary_table_food
WHERE potravina IS
NOT NULL 
GROUP BY datum, potravina
ORDER BY potravina, datum; 

CREATE OR REPLACE VIEW vypocet_rozdil AS
SELECT 
	*, 
	LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum) AS lag,
	ROUND(((cena - LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum)) / (LAG(cena,1) OVER(PARTITION BY potravina ORDER BY datum)) * 100), 2) AS procentualni_zmena
FROM ukol_3
WHERE datum BETWEEN 2006 AND 2018
ORDER BY potravina, datum;

-- takto vidim jak se mění cena mezi roky 2006-2018
SELECT * 
FROM vypocet_rozdil
WHERE procentualni_zmena IS NOT NULL


-- CREATE OR REPLACE VIEW prehled_zdrazovani_final AS
SELECT 
	datum,
	potravina, 
	procentualni_zmena,
	CASE WHEN procentualni_zmena< 0 THEN 'klesá' END AS rozdil_3
FROM vypocet_rozdil
WHERE procentualni_zmena IS NOT NULL
ORDER BY potravina, datum; -- nevidím žádnou skupinu, kde by to rostlo každý rok

-- přehled pro brambory v průběhu období
SELECT * 
FROM vypocet_rozdil
WHERE procentualni_zmena IS NOT NULL AND potravina = 'Konzumní brambory'