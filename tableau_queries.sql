-- Queries for Tableau Viz

-- 1.

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
	SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercent
FROM [Project Covid Analysis]..covid_death$
WHERE continent IS NOT NULL
ORDER BY 1,2

--2.

SELECT continent, SUM(CAST(new_deaths as int)) as TotalDeathCount
FROM [Project Covid Analysis]..covid_death$
WHERE continent IS NOT NULL
	AND location NOT IN ('World','European Union','International')
GROUP BY continent
ORDER BY TotalDeathCount DESC

--3.

SELECT location, population, MAX(total_cases) as HighInfectionCount,
	MAX ((total_cases/population))*100 as PercentPopulationInfected
FROM [Project Covid Analysis]..covid_death$
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

--4.

SELECT location, population, date, MAX(total_cases) as HighestInfectionCount,
	MAX((total_cases/population))*100 as PercentPopulationInfected
FROM [Project Covid Analysis]..covid_death$
GROUP BY location, population, date
ORDER BY PercentPopulationInfected DESC