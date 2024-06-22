-- Exploratory Data Analysis

SELECT *
FROM world_layloff.layoff_staging4;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM world_layloff.layoff_staging4;

SELECT *
FROM world_layloff.layoff_staging4
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC
;

SELECT company, SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY company
ORDER BY 2 DESC
;

SELECT MIN(`date`), MAX(`date`)
FROM world_layloff.layoff_staging4;

SELECT industry, SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY industry
ORDER BY 2 DESC;

SELECT location, SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY location
ORDER BY 2 DESC;

SELECT country, SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY YEAR(date)
ORDER BY 2 DESC;

SELECT stage, SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY stage
ORDER BY 2 DESC;

SELECT SUBSTRING(date,1,7) AS `Month`, SUM(total_laid_off)
FROM world_layloff.layoff_staging4
GROUP BY `Month`
HAVING `Month` IS NOT NULL
ORDER BY 1 ASC
;

WITH Rolling_Total AS
(SELECT SUBSTRING(date,1,7) AS `Month`, SUM(total_laid_off) AS total_laid_off_sum
FROM world_layloff.layoff_staging4
GROUP BY `Month`
HAVING `Month` IS NOT NULL
ORDER BY 1 ASC
)
SELECT `Month`, total_laid_off_sum,
 SUM(total_laid_off_sum) OVER(ORDER BY `Month`) AS rolling_total
FROM Rolling_Total
;


SELECT company, YEAR(date), SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY company, YEAR(date)
ORDER BY 3 DESC
;

WITH Company_Year(company, years, total_laid_off) AS
(
SELECT company, YEAR(date), SUM(total_laid_off) 
FROM world_layloff.layoff_staging4
GROUP BY company, YEAR(date)
), Company_Year_Rank AS
(SELECT * , DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5
;


