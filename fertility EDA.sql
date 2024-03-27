/* Below are some macro EDA for comparison with the dashboard. 
Per OECD.org "..total fertility rate of 2.1 children per woman ensures a broadly stable population."*/


-- What is the average birth rate in 2021?
SELECT	
	ROUND(avg(`2021`),4) AS avg_2021
FROM fertility.country



-- Which countries had birthrates less than or equal to the 2021 average?
SELECT
	country,
	`2021`
FROM country
WHERE
	`2021` <= (SELECT	
				ROUND(avg(`2021`),4) AS avg_2021
			   FROM fertility.country)
ORDER BY 
	`2021` DESC



-- Rank the top 10 countries with the highest birthrate in 2021.
SELECT
	country,
	`2021`,
	ROW_NUMBER() OVER(ORDER BY `2021` DESC) AS highest_birthrate
FROM fertility.country
LIMIT 10



-- Rank the top 10 countries with the lowest birthrate in 2021.
SELECT
	country,
	`2021`,
	ROW_NUMBER() OVER(ORDER BY `2021`) AS lowest_birthrate
FROM fertility.country
LIMIT 10



-- When ranked in descending order, what was USA ranked in 2021?
WITH rate_ranked AS (
SELECT
	country,
	`2021`,
	ROW_NUMBER() OVER(ORDER BY `2021` DESC) AS ranked
FROM fertility.country
)
SELECT
	*
FROM 
	rate_ranked
WHERE
	country = 'United States'



-- Which 5 countries were ranked above and below USA in 2021?
WITH cterank AS(
	SELECT
		country,
		`2021`,
		row_number() OVER(ORDER BY `2021` DESC) AS ranked
	FROM fertility.country
)
(
	(SELECT *
	FROM cterank
	WHERE ranked <= 142
	ORDER BY ranked DESC
	LIMIT 6
	)
UNION ALL
	(SELECT *
	FROM cterank
	WHERE ranked > 142
	LIMIT 5)
)



-- How many countries in 1990 had birthrate below 2.1 vs 2021?
WITH cte1990 AS(
	SELECT
		country,
		`1990`
	FROM fertility.country
	WHERE
		`1990` < 2.1
	AND 
		`1990` IS NOT NULL
),
cte2021 AS(
	SELECT
		country,
		`2021`
	FROM fertility.country
	WHERE
		`2021` < 2.1
)
SELECT
	COUNT(cte1990.country) AS `Total_1990`,
	COUNT(cte2021.country) AS `Total_2021`
FROM
	cte1990
RIGHT JOIN
	cte2021
ON
	cte1990.country = cte2021.country