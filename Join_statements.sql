USE government;
SELECT * FROM city;
SELECT * FROM country;

/*below code will display which city belong to which country
using INNER JOIN*/
SELECT city.name, country.name
FROM city 
	INNER JOIN 
    country ON city.country_code = country.code;

SELECT 
    countryTable.name AS Country,
    COUNT(cityTable.country_code) AS NumOfCities
FROM
    city AS cityTable
        JOIN
    country AS countryTable ON cityTable.country_code = countryTable.code
GROUP BY cityTable.country_code HAVING NumOfCities > 100
ORDER BY NumOfCities DESC;

SELECT
	SUM(cityTable.population) as TotalPopulation,
    countryTable.continent as Continent
FROM
	city AS cityTable
		JOIN
	country AS countryTable ON cityTable.country_code = countryTable.Code
    GROUP BY countryTable.Continent
    ORDER BY TotalPopulation DESC;

/* the following code will display all the records from city
but only records that match the city record will be displayed 
for the country table*/

SELECT city.name AS city_name, city.population, country.name AS country_name, country.region
FROM city 
	LEFT JOIN 
    country 
	ON city.country_code = country.code
WHERE country.Region = "Middle East"
ORDER BY city.population ASC; 

/* the following code will display  only records from city
that matches records from country, but will display all records from
country table using right join*/

SELECT city.name AS city_name, city.population, country.name AS country_name, country.region
FROM city 
	RIGHT JOIN 
    country 
	ON city.country_code = country.code
WHERE country.Population < 100000
ORDER BY city.population DESC; 

-- USING AN UNION OPERATOR

SELECT 
    id, name, population
FROM
    city
WHERE
    country_code LIKE 'B%' 
UNION SELECT 
    id, name, population
FROM
    city
WHERE
    country_code LIKE 'A%';
    
SELECT 
    concat(code,' - ',name, ' - ', population) Country_Name
FROM
    country
WHERE population < 1000000
UNION SELECT 
    concat(code,' - ',name, ' - ', population)
FROM
    country
    WHERE population > 10000000
ORDER BY Country_Name; 