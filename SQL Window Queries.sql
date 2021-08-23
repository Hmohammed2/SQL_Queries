SELECT *
FROM population_years
LIMIT 10;

-- Utilization of window functions in order to find the ranking of each countries population partitioned by year
SELECT country,
		population,
		year,
	RANK() OVER(
		PARTITION BY year
		ORDER BY population DESC
	) as Rank_of_countries_by_Popularion
FROM population_years; 

-- Utilization of window functions in order to find the row number of each countries population partitioned by year. 
-- Difference of row number from ranking function is when two values are the same ranking will make it the same rank, whereas row number will still give a sequential integer
SELECT country,
		population,
		year,
	ROW_NUMBER() OVER(
		PARTITION BY year
		ORDER BY population DESC
	) as Rank_of_countries_by_Popularion
FROM population_years; 

-- Utilize lag() function to measure the change in population from the previous offset row to the current row.
-- Utilize lead() function to measure the change in population from the next offset row to the current row.
SELECT country,
		population,
		year,
	population - LAG(population, 1) OVER(
		PARTITION BY country
		ORDER BY population
	) as Change_in_population_offset_from_previous,
	LEAD(population, 1) OVER(
		PARTITION BY country
		ORDER BY population
	) - population as Change_in_population_offest_from_future
FROM population_years;


--- Utilize NTILE to split dataset into quartiles/groupings. Helpful for split data into clusters for analysis

SELECT country,
		population,
		year,
	NTILE(4) OVER(
		PARTITION BY year
		ORDER BY population DESC
	) as Quartile
FROM population_years;

-- WIndow functions can also be used to compute running totals, or running avgs

SELECT country,
		population,
		year,
	SUM(population) OVER(
		PARTITION BY country
		ORDER BY population ASC
	) as Running_Total,
	AVG(population) OVER(
		PARTITION BY country
		ORDER BY population ASC
	) as Running_Average
FROM population_years;

