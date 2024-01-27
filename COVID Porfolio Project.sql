SELECT * FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

--Select data that we are going to use

SELECT location, date, total_cases, new_cases, CAST(total_deaths AS INT), population FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

--Looking at total cases vs. total dealths
--Show likelihood of dying if you contact covid in the US

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS dealth_percentage FROM PortfolioProject..CovidDeaths
WHERE location like '%states%'
AND continent IS NOT NULL
ORDER BY 1, 2

--Looking at total cases vs. population
--Show what percentage of population got Covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS case_percentage FROM PortfolioProject..CovidDeaths
--WHERE location like '%states%'
WHERE continent IS NOT NULL
ORDER BY 1, 2

--Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(CAST(total_deaths AS INT)) AS highest_infection_count, MAX((total_cases/population)*100) AS highest_case_percentage FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY highest_case_percentage DESC

--Let's break things down by continent 

--Showing continent with highest death count

SELECT continent, MAX(CAST(total_deaths AS INT)) AS highest_dealth_count FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY highest_dealth_count DESC

--GLOBAL NUMBERS

SELECT continent, SUM(new_cases) AS total_new_case, SUM(CAST(new_deaths AS INT)) AS total_new_death, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS new_death_percentage FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY 1, 2

SELECT date, SUM(new_cases) AS total_new_case, SUM(CAST(new_deaths AS INT)) AS total_new_death, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS new_death_percentage FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1, 2

SELECT SUM(new_cases) AS total_new_case, SUM(CAST(new_deaths AS INT)) AS total_new_death, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS new_death_percentage FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
--GROUP BY date
ORDER BY 1, 2

--Looking at total population vs vaccination

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccination_Count, Rolling_Total_Vaccinations) AS
( 
	SELECT dea.continent, dea.location, dea.date, dea.population, CAST (new_vaccinations AS BIGINT) AS new_vaccination_count
	, SUM(CONVERT (BIGINT, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_total_vaccinations
	FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
)
SELECT *, (Rolling_Total_Vaccinations/Population)*100 AS Vaccination_Over_Population FROM PopvsVac

	
-- TEMP TABLE

DROP TABLE IF EXISTS #PopulationVaccination
CREATE TABLE #PopulationVaccination
(
	Continent NVARCHAR(60),
	Location NVARCHAR(255),
	Date DATETIME,
	Population FLOAT,
	New_vaccination_Count BIGINT,
	Rolling_Total_Vaccinations BIGINT,
) 

INSERT INTO #PopulationVaccination
SELECT dea.continent, dea.location, dea.date, dea.population, CAST (new_vaccinations AS BIGINT) AS new_vaccination_count
	, SUM(CONVERT (BIGINT, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_rotal_vaccinations
	FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL
SELECT *, (Rolling_Total_Vaccinations/Population)*100 FROM #PopulationVaccination

-- CREATE VIEW to store data for later visualization
USE PortfolioProject
GO
CREATE VIEW Population_Vaccination AS 
SELECT dea.continent, dea.location, dea.date, dea.population, CAST (new_vaccinations AS BIGINT) AS new_vaccination_count
	, SUM(CONVERT (BIGINT, new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS rolling_rotal_vaccinations
	FROM PortfolioProject..CovidDeaths dea
	JOIN PortfolioProject..CovidVaccinations vac 
		ON dea.location = vac.location
		AND dea.date = vac.date
	WHERE dea.continent IS NOT NULL

SELECT * FROM Population_Vaccination

