
CREATE TABLE PROJECT2.TRANSPOSE_DATA_Q4 (CountryName varchar(50), IndicatorCode varchar(30), 
YearsByCountry INTEGER, DATA FLOAT );

DELIMITER $$
CREATE PROCEDURE PROJECT2.TRANSPOSE_Q4(MIN_VALUE INTEGER, MAX_VALUE INTEGER)
BEGIN

DECLARE YEAR INTEGER;
DECLARE COLNAME varchar(50);
SET YEAR = MIN_VALUE;

WHILE YEAR <= MAX_VALUE 
DO

SET @COLNAME = CONCAT('`',YEAR,'`');
SET @STATEMENT = CONCAT(
    'INSERT INTO PROJECT2.TRANSPOSE_DATA_Q4 (CountryName, IndicatorCode, YearsByCountry, Data)',
    ' SELECT CountryName, IndicatorCode, ', YEAR,',', @COLNAME,
    ' FROM PROJECT2.gender_data2',
    ' WHERE ', @COLNAME,
    ' IS NOT NULL'
);

PREPARE STMT FROM @STATEMENT;
EXECUTE STMT;
DEALLOCATE PREPARE STMT;

SET YEAR = YEAR + 1;
END WHILE;
END$$
DELIMITER ;

CALL PROJECT2.TRANSPOSE_Q4(2000,2016);

--Created view--

CREATE VIEW question_4_hive AS
SELECT CountryName, IndicatorCode, YearsByCountry, Data
FROM TRANSPOSE_DATA_Q4
WHERE IndicatorCode = 'SL.EMP.SELF.FE.ZS';

