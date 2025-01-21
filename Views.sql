USE Government;

CREATE VIEW country_city_view AS
    SELECT 
        city.Name, city.population, country.region
    FROM
        city
            JOIN
        Country 
    WHERE
        city.country_code = country.code
	ORDER BY country.region;
    
SELECT * FROM country_city_view;

DROP VIEW country_city_view;