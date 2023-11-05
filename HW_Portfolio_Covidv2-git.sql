--SELECT *
--FROM HW_Portfolio..CovidDeaths
--ORDER BY 3,4

----SELECT *
----FROM hw_pORTFOLIO..CovidVacs
----ORDER BY 3,4

--- SELECT DATA BEING USED ----

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM HW_Portfolio..CovidDeaths
--ORDER BY 1,2

--- TOTAL CASES VS TOTAL DEATHS ---

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentageDeaths
--FROM HW_Portfolio..CovidDeaths
--WHERE Location like '%states%'
--ORDER BY 1,2

--- PERCENTAGE OF INFECTION PER US STATE ---

--SELECT location, date, population, total_cases, (total_cases/population)*100 as PopulationCasesPercent
--FROM HW_Portfolio..CovidDeaths
--WHERE Continent is NOT NULL AND Location like 'South Africa'
--ORDER BY 1,2

--- COUNTRIES WITH HIGHEST INFECTION RATE PER POPULATION ---

--SELECT Location, Population, MAX(total_cases) as topcases, MAX((total_cases/population))*100 as CasesPercentPerPop
--FROM HW_Portfolio..CovidDeaths
--WHERE continent is NOT NULL
--GROUP By Location, Population
--ORDER BY CasesPercentPerPop DESC

--- COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION ---

--SELECT TOP 10 Location, MAX(cast(total_deaths as int)) as totalDeathsCount
--FROM HW_Portfolio..CovidDeaths
--WHERE continent is NOT NULL
--GROUP By Location, Population
--ORDER BY TotalDeathsCount DESC

-- DEATH BY CONTINENT ---

--SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathsCount
--FROM HW_Portfolio..CovidDeaths
--WHERE continent is NOT NULL
--GROUP By continent
--ORDER BY TotalDeathsCount DESC

--GLOBAL NUMBERS

-- SUM OF NEW CASES BY DATE---

--SELECT date, SUM(new_cases), SUM(cast(total_deaths as int)) as totaldeaths, SUM(total_deaths/total_cases)*100 as PercentageDeaths
--FROM HW_Portfolio..CovidDeaths
--WHERE continent is not null
--GROUP BY date
--ORDER BY date

--	WORLD WIDE DEATH PERCENTAGE---

--SELECT  SUM(new_cases) AS totalnewcases, SUM(cast(total_deaths as int)) AS totaldeaths, SUM(cast(total_deaths as int))/ SUM(new_cases)*100 as PercentageDeaths
--FROM HW_Portfolio..CovidDeaths
--WHERE continent is not null
--ORDER BY 1,2

--GLOBAL POPULATOIN VS VACCINATIONS---

--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM (cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY  dea.date, dea.location) as Rolling_Vacs
--FROM HW_Portfolio..CovidVacs dea
--JOIN HW_Portfolio..CovidVacs vac
--	ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent is not null
--Order by 2,3

--USING CTE---

--WITH PopvsVac (continent, Location, date, population, new_vaccinations, Rolling_Vacs)
--as 
--(
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM (cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY  dea.date, dea.location) as Rolling_Vacs
--FROM HW_Portfolio..CovidVacs dea
--JOIN HW_Portfolio..CovidVacs vac
--	ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent is not null
--)
--Select *, (Rolling_Vacs/population)*100 as Percentage_Vaccinated
--FROM PopvsVac

--- TEMP TABLE ---
--DROP TABLE if exists #Temp_PercentPopulationVaccinated
--CREATE TABLE #Temp_PercentPopulationVaccinated
--(
--Continent nvarchar(255),
--Location nvarchar (255),
--Date datetime,
--Population numeric,
--New_VAccinations numeric,
--Rolling_Vacs numeric,
--)

--INSERT INTO #Temp_PercentPopulationVaccinated
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--SUM (cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY  dea.date, dea.location) as Rolling_Vacs
--FROM HW_Portfolio..CovidVacs dea
--JOIN HW_Portfolio..CovidVacs vac
--	ON dea.location = vac.location AND dea.date = vac.date
--WHERE dea.continent is not null

--Select *, (Rolling_Vacs/population)*100 as Percentage_Vaccinated
--FROM #Temp_PercentPopulationVaccinated


--- CREATING A VIEW EXAMPLE ---
CREATE VIEW Temp_PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM (cast(vac.new_vaccinations as int)) OVER (PARTITION BY dea.location ORDER BY  dea.date, dea.location) as Rolling_Vacs
FROM HW_Portfolio..CovidVacs dea
JOIN HW_Portfolio..CovidVacs vac
	ON dea.location = vac.location AND dea.date = vac.date
WHERE dea.continent is not null


