SELECT *
FROM portfolio1..CovidDeaths
ORDER BY 3,4

SELECT *
FROM portfolio1..CovidVaccinations
ORDER BY 3,4


SELECT continent,location
FROM portfolio1..CovidVaccinations

SELECT Location,continent,population,total_tests,total_deaths_per_million
FROM portfolio1..CovidDeaths
ORDER BY 3,4

--Total cases and total deaths

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Deathpercentage
FROM portfolio1..CovidDeaths


SELECT Location,continent,population,total_tests,total_deaths,(total_deaths/total_cases)*100 AS Deathpercentage
FROM portfolio1..CovidDeaths
ORDER BY location

SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Deathpercentage
FROM portfolio1..CovidDeaths
WHERE location = 'India' 


SELECT Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS Deathpercentage
FROM portfolio1..CovidDeaths
WHERE location LIKE '%states%' 


SELECT Location,date,total_cases,total_deaths,population,(total_cases/population)*100 AS populationinfected
FROM portfolio1..CovidDeaths
WHERE location LIKE 'India'

--Highest covid cases and deaths
SELECT Location,MAX(total_cases) AS Highestcases,MAX(total_cases/population)*100 AS populationinfected
FROM portfolio1..CovidDeaths
GROUP BY location
ORDER BY populationinfected DESC

SELECT continent,MAX (CAST(total_deaths as int)) AS Highestdeaths
FROM portfolio1..CovidDeaths
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY Highestdeaths desc

SELECT  date,SUM(new_cases) AS totalnewcases,SUM(CAST(new_deaths as int))AS totalnewdeath,SUM(cast(new_deaths AS int))/SUM(new_cases )*100 AS percentagenewdeaths
FROM portfolio1..CovidDeaths
WHERE continent is NOT NULL
GROUP BY date
--Total New cases,deaths,percentage deaths
SELECT SUM(new_cases) AS totalnewcases,SUM(CAST(new_deaths as int))AS totalnewdeath,SUM(cast(new_deaths AS int))/SUM(new_cases )*100 AS percentagenewdeaths
FROM portfolio1..CovidDeaths
WHERE continent is NOT NULL

--Joining two table
SELECT *
FROM portfolio1..CovidDeaths AS dea
INNER JOIN portfolio1..CovidVaccinations AS vac
ON dea.location = vac.location AND 
 dea.date = vac.date
 WHERE dea.continent is NOT NULL
ORDER BY 3,4
--new vaccination in  population
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
FROM portfolio1..CovidDeaths AS dea
INNER JOIN portfolio1..CovidVaccinations AS vac
ON dea.location = vac.location AND 
 dea.date = vac.date
 WHERE dea.continent is NOT NULL 
ORDER BY 2,3

SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.Location) AS totalnewvacciations
FROM portfolio1..CovidDeaths AS dea
INNER JOIN portfolio1..CovidVaccinations AS vac
ON dea.location = vac.location AND 
 dea.date = vac.date
  WHERE dea.continent is NOT NULL
ORDER BY 2,3

--CTE

with populationvsvaccine (continent,location,date,population,new_vaccinations,totalnewvaccinations)
AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.Location) AS totalnewvacciations
FROM portfolio1..CovidDeaths AS dea
INNER JOIN portfolio1..CovidVaccinations AS vac
ON dea.location = vac.location AND 
 dea.date = vac.date
 -- WHERE dea.continent is NOT NULL
  )
SELECT *,(totalnewvaccinations/population)*100 AS percentagenewvaccinationpopulation
FROM populationvsvaccine

--using temp table
DROP TABLE IF EXISTS #perecentpopulation
CREATE TABLE #percentpopulation
(
continent NVARCHAR (150),
Location NVARCHAR(150),
date DATETIME,
population Numeric,
new_vaccinations NUMERIC,
totalnewvaccinations NUMERIC,
)

INSERT INTO #percentpopulation
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.Location) AS totalnewvacciations
FROM portfolio1..CovidDeaths AS dea
INNER JOIN portfolio1..CovidVaccinations AS vac
ON dea.location = vac.location AND 
 dea.date = vac.date
 SELECT *,(totalnewvaccinations/population)*100 AS percentagenewvaccinationpopulation
FROM #percentpopulation
 
 --view to store data
 CREATE VIEW percentvaccination AS
 SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.Location) AS totalnewvacciations
FROM portfolio1..CovidDeaths AS dea
INNER JOIN portfolio1..CovidVaccinations AS vac
ON dea.location = vac.location AND 
 dea.date = vac.date
  WHERE dea.continent is NOT NULL
--ORDER BY 2,3

SELECT * FROM percentvaccination

















