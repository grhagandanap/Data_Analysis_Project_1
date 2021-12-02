
SELECT TOP 20 continent,location,population 
FROM [Project Covid Analysis]..covid_death$ 

-- Evaluating total cases vs population

SELECT location, date, total_cases, total_deaths, (total_cases/population)*100 as caserate, population
FROM [Project Covid Analysis]..covid_death$ 
WHERE location LIKE '%states%'
ORDER BY 1,2

-- Finding countries with high infectious rate

SELECT continent,location, MAX(total_cases) as total_cases, MAX(total_cases)*100/population as percentage_cases, population
FROM [Project Covid Analysis]..covid_death$
WHERE continent IS NOT NULL
GROUP BY continent,location,population
HAVING continent='Asia'
ORDER BY total_cases DESC

-- Finding countries with high deaths

SELECT continent, location, MAX(CAST(total_deaths as INT)) as total_deaths
FROM [Project Covid Analysis]..covid_death$
WHERE continent IS NOT NULL
GROUP BY continent,location
HAVING continent = 'North America'
ORDER By 1,3 DESC

-- Death rate

SELECT date, SUM(new_cases) as total_cases, SUM(CAST(new_deaths as INT)) as new_deaths, 
	SUM(CAST(new_deaths as INT))*100/SUM(new_cases) as death_percent
FROM [Project Covid Analysis]..covid_death$
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1 

-- Comparing cases, vaccinated, and death people by date

SELECT cd.date, SUM(cd.new_cases) cases, 
	SUM(CAST(cv.new_vaccinations as BIGINT)) vaccine, SUM(CAST(cd.new_deaths as INT)) deaths
FROM [Project Covid Analysis]..covid_death$ as cd
JOIN [Project Covid Analysis]..covid_vaccine$ as cv
ON cd.date=cv.date 
	AND cd.location=cv.location
WHERE cd.continent IS NOT NULL
GROUP BY cd.date
ORDER BY 1

-- Population vs new vaccinations

With popandvac (continent,location,date,population,new_vaccinations,total_vaccinations)
as
(
	SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
		,SUM(CONVERT(bigint, cv.new_vaccinations)) OVER (Partition by cd.location ORDER BY cd.date
		ROWS UNBOUNDED PRECEDING)
		as total_vaccinations
	FROM [Project Covid Analysis]..covid_death$ as cd
	INNER JOIN [Project Covid Analysis]..covid_vaccine$ as cv
		ON cd.date=cv.date AND cd.location=cv.location
	WHERE cd.continent IS NOT NULL 
)
SELECT *,total_vaccinations*100/population as percentage_vaccinated
FROM popandvac

-- Temp New Table
DROP TABLE IF EXISTS #PercentVaccine
CREATE TABLE #PercentVaccine
(
	Continent nvarchar(255),
	Location nvarchar(255),
	Date datetime,
	Population numeric,
	New_vaccinations numeric,
	Total_vaccinations numeric
)
INSERT INTO #PercentVaccine
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
		,SUM(CONVERT(bigint, cv.new_vaccinations)) OVER (Partition by cd.location ORDER BY cd.date
		ROWS UNBOUNDED PRECEDING)
		as total_vaccinations
	FROM [Project Covid Analysis]..covid_death$ as cd
	INNER JOIN [Project Covid Analysis]..covid_vaccine$ as cv
		ON cd.date=cv.date AND cd.location=cv.location
	WHERE cd.continent IS NOT NULL
SELECT *,total_vaccinations*100/population as percentage_vaccinated
FROM #PercentVaccine

-- Creating View
CREATE VIEW PercentVaccination as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations
		,SUM(CONVERT(bigint, cv.new_vaccinations)) OVER (Partition by cd.location ORDER BY cd.date
		ROWS UNBOUNDED PRECEDING)
		as total_vaccinations
	FROM [Project Covid Analysis]..covid_death$ as cd
	INNER JOIN [Project Covid Analysis]..covid_vaccine$ as cv
		ON cd.date=cv.date AND cd.location=cv.location
	WHERE cd.continent IS NOT NULL