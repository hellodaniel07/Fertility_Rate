-- data source: https://data.worldbank.org/indicator/SP.DYN.TFRT.IN?most_recent_value_desc=false


SELECT *
From fertility.global;


/* Few things were noted while perusing the initial data:
1. The value in every row in columns 1 and 2 are identical: "Fertility rate, total (births per woman)" and "SP.DYN.TFRT.IN", respectively. (Drop columns 1 and 2).
2. Column names are irregular i.e - `1990 [YR1990]`. (Standardize column names)
3. Data includes more than just countries in the Country Name column. It includes continents, sub-contients, regions, economical and social distributions such as 
  "Heavily indebted poor countries", "IDA blend", "IBRD only", "Early-demographic dividend", and etc.. (Remove these contents).
4. ".." are placeholders for missing values (Address '..' values)
5. Entire Column 2022 [YR2022] is ".." (Drop column 2022).
*/


-- DROP Columns 1,2 and 2022 [YR2022]
ALTER TABLE fertility.global
DROP `Series Name`,
DROP `Series Code`,
DROP `2022 [YR2022]` 



-- RENAME all column for uniformity
ALTER TABLE fertility.global
rename column `Country Name` to country,
rename column `Country Code` to code,
rename column `1990 [YR1990]` to `1990`,
rename column `2000 [YR2000]` to `2000`,
rename column `2013 [YR2013]` to `2013`,
rename column `2014 [YR2014]` to `2014`,
rename column `2015 [YR2015]` to `2015`,
rename column `2016 [YR2016]` to `2016`,
rename column `2017 [YR2017]` to `2017`,
rename column `2018 [YR2018]` to `2018`,
rename column `2019 [YR2019]` to `2019`,
rename column `2020 [YR2020]` to `2020`,
rename column `2021 [YR2021]` to `2021`;

 

-- Add id column 
ALTER TABLE fertility.global
ADD column id INT



-- Modify id column and assign unique id to each row in the country column
ALTER TABLE fertility.global
modify column id INT auto_increment unique first



/* There are 271 unique id's. 1-217 are countries and territories. 218-266 are the miscellaneous contents; and 267-271 are blank lines */

-- Last country is Zimbabwe id = 217. Filter to keep only id's 1-217.
-- Create new table 
CREATE TABLE country 
SELECT *
FROM fertility.global
WHERE
	id <= 217



-- Check columns for '..'
SELECT *
FROM country
WHERE
	( `1990` = '..'
	OR `2020` = '..'
	OR `2013` = '..'
	OR `2014` = '..'
	OR `2015` = '..'
	OR `2016` = '..'
	OR `2017` = '..'
	OR `2018` = '..'
	OR `2019` = '..'
	OR `2020` = '..'
	OR `2021` = '..')
  
  
 
/* Total of 9 countries return. 6 countries has '..' in all fields (remove these countries); 
1 country has some '..' (remove this country); and 2 countries have '..' only in 1990 (change 1990 values to null).
*/
  
-- DELETE '..' from 2021 column (delete 7 countries)
DELETE FROM fertility.country
WHERE
	`2021` LIKE '..'



-- Change '..' in 1990 to Null
UPDATE fertility.country
SET 
	`1990` = NULL
WHERE
	`1990` = '..'



-- DROP id column
Alter table fertility.country
drop `id`


/* Data is cleaned and will export to Tableau for visualization. 

















