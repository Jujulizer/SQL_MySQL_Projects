DELIMITER $$

CREATE PROCEDURE getPeople()
BEGIN
	SELECT * FROm Country;
	SELECT * FROM city;
END $$

DELIMITER ;

CALL getPeople();
-- Statement to recieve all stared procedured in the database
SHOW PROCEDURE STATUS;
SHOW PROCEDURE STATUS LIKE '%People%'; 

-- DELETE A STORED PROCEDURE WITH THE DROP KEYWORD
DROP PROCEDURE getPeople;
DROP PROCEDURE IF EXISTS getPeople;

-- Declating variable in the stored procedure
DELIMITER $$
CREATE PROCEDURE countCities()
BEGIN
	DECLARE total INT DEFAULT 0;
    
    SELECT COUNT(*) INTO total from city;
    SELECT total;
END $$;

DELIMITER ;

CALL countCities();

/* In this exercise your task is to sum up the total number of cities (CITY database table) 
and the total number of countries (COUNTRY database table). */

DELIMITER $$
 
CREATE PROCEDURE countAll() 
BEGIN
    DECLARE totalCity INT DEFAULT 0;
    DECLARE totalCountry INT DEFAULT 0;
    
    SELECT COUNT(*) INTO totalCity FROM city;
    SELECT COUNT(*) INTO totalCountry FROM country;
    
    SELECT totalCity+totalCountry;
END $$
 
DELIMITER ;

CALL countAll;

-- dealing with IN and OUT parameters 
DELIMITER $$

CREATE PROCEDURE numOfCities(
IN country Char(3),
OUT total INT
)

BEGIN
	SELECT COUNT(*)
    INTO total
    FROM city
    WHERE country_code = country;
END $$
    
DELIMITER ;

CALL numOfCities('USA', @total);
SELECT @total;

/* Exercise
So far we have seen how to define stored procedures - with variables and parameters. 
Your task is to create a procedure that has: a country code as an input parameter 
it can count the number of cities in a given country (the country is the parameter)
that starts with letter 'A' it prints the result in the procedure 
(so no need to return or store the value) */

DELIMITER $$
 
CREATE PROCEDURE exercise(
	IN country CHAR(3)
)
 
BEGIN
	
    DECLARE counter INT DEFAULT 0;
    
    SELECT COUNT(*) INTO counter
    FROM city 
    WHERE country_code = country 
    AND name LIKE 'A%';
 
    SELECT counter;
END $$
 
DELIMITER ;

CALL exercise('USA');

-- Using loops with stored procedures

DELIMITER $$
 
CREATE PROCEDURE labelPopulation( IN country CHAR(3), OUT label VARCHAR(20))
 
BEGIN
	DECLARE total INT DEFAULT 0;
SELECT 
    population
INTO total FROM
    country
WHERE
    code = country;

	IF total > 100000000 THEN
	    SET label = "Large Country";
	ELSE 
		SET label = "Small Country";
	END IF;
END $$

-- looping and iterations 
DELIMITER ;

CALL labelPopulation("HUN", @label);
SELECT @label;

Drop procedure labelPopulation;

DELIMITER $$

CREATE  PROCEDURE loopExampl()

BEGIN
	DECLARE a INT DEFAULT 1;
    DECLARE s VARCHAR(255);
    
    SET S ='';
    
    loop_label: LOOP
		IF A > 10 THEN
			LEAVE loop_label;
		END IF;
        
		SET a = a + 1;
        IF a = 3 THEN
			ITERATE loop_label;
		END IF;
        set s = CONCAT(s,a,' ');
		END LOOP;
        
        SELECT s;
	END $$
    
DELIMITER ;


    
CALL loopExampl();
DROP PROCEDURE loopExampl;

-- USING WHILE LOOPS IN SQL PROCEDURES
DELIMITER $$

CREATE PROCEDURE whileExample()
BEGIN

	DECLARE a INT DEFAULT 0;
    DECLARE s VARCHAR(255) DEFAULT '';
    
    WHILE LENGTH(s) < 5 DO
    SET a = a + 1;
    set s = CONCAT(s,a,' ');
    END WHILE;
    
    SELECT s;
END $$

DELIMITER ;

CALL whileExample();

-- Returning multiple values from stored procedures

DELIMITER $$

CREATE PROCEDURE multiValues(
OUT population_counter INT, 
OUT life_counter INT
)

BEGIN
	SELECT COUNT(*) INTO population_counter 
    FROM country 
    WHERE population > 100000000;
    
    SELECT COUNT(*) INTO life_counter 
    FROM country 
    WHERE life_expectancy > 70;

END $$

DELIMITER ;

CALL multiValues(@c1, @c2);
SELECT @c1, @c2;

-- DEALING WITH CURSORS
SHOW PROCEDURE STATUS;

SELECT name from city WHERE LENGTH(name) = 4;

SET @cities = "";
CALL city_list(@cities);
SELECT @cities; 

DELIMITER $$
CREATE PROCEDURE city_list (INOUT c_list VARCHAR(4000))
BEGIN
	DECLARE finished INTEGER DEFAULT 0;
	DECLARE cityVAR VARCHAR(20) DEFAULT "";

	-- define the CURSOR itself
	DECLARE cursorCity CURSOR FOR
			SELECT name from city WHERE LENGTH(name) = 4;
		
        -- defining a not found handler
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1;
        
	OPEN cursorCity;
	
    getCities: LOOP
			FETCH cursorCity INTO cityVar;
				IF finished = 1 THEN
					LEAVE getCities;
				END IF;
        
			SET c_list = CONCAT(cityVar,'-', c_list);
		END LOOP getCities;
        
	CLOSE cursorCity;
    
END$$

DELIMITER ;

DROP procedure city_list;


