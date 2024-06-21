-- Data Cleaning

SELECT *
FROM world_layloff.layoffs;

-- REMOVE DUPLICATES

CREATE TABLE layoff_staging
LIKE layoffs;

SELECT *
FROM world_layloff.layoff_staging;

INSERT layoff_staging
SELECT *
FROM world_layloff.layoffs;

SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, percentage_laid_off, 'date') AS row_num
FROM world_layloff.layoff_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,date,stage, country,funds_raised_millions) AS row_num
FROM world_layloff.layoff_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

SELECT *
FROM world_layloff.layoff_staging
WHERE company = "Casper";

CREATE TABLE `layoff_staging4` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_nums` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM world_layloff.layoff_staging4;

INSERT INTO layoff_staging4
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,date,stage, country,funds_raised_millions) AS row_num
FROM world_layloff.layoff_staging;

SELECT *
FROM world_layloff.layoff_staging4
WHERE row_nums > 1;


DELETE
FROM world_layloff.layoff_staging4
WHERE row_nums > 1;

-- Standardizing data
SELECT company, TRIM(company)
FROM world_layloff.layoff_staging4;

UPDATE layoff_staging4
SET company = TRIM(company);

SELECT DISTINCT country
FROM world_layloff.layoff_staging4
ORDER BY 1
 ;

UPDATE layoff_staging4
SET country = 'United States'
WHERE country LIKE 'United States%' ;

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y') AS formatted_date
FROM world_layloff.layoff_staging4;

UPDATE layoff_staging4
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoff_staging4
MODIFY COLUMN `date` DATE;


-- null 
SELECT *
FROM world_layloff.layoff_staging4
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

UPDATE layoff_staging4
SET industry = NULL
WHERE industry = '';

SELECT *
FROM world_layloff.layoff_staging4
WHERE industry IS NULL OR industry = '';

SELECT *
FROM world_layloff.layoff_staging4
WHERE company = 'Airbnb';

SELECT st4.industry, st1.industry
FROM world_layloff.layoff_staging4 AS st4
JOIN world_layloff.layoff_staging4 AS st1
	ON st4.company = st1.company
    AND st4.location = st1.location
WHERE (st4.industry IS NULL OR st4.industry = '')
AND st1.industry IS NOT NULL;

UPDATE world_layloff.layoff_staging4 AS st4
JOIN world_layloff.layoff_staging4 AS st1
	ON st4.company = st1.company
 SET st4.industry = st1.industry   
WHERE (st4.industry IS NULL )
AND st1.industry IS NOT NULL;

-- Remove any columns
SELECT *
FROM world_layloff.layoff_staging4
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

DELETE
FROM world_layloff.layoff_staging4
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

SELECT *
FROM world_layloff.layoff_staging4;

ALTER TABLE layoff_staging4
DROP COLUMN row_nums;
