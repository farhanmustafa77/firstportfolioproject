-- SELECT * FROM covid.coviddeaths
-- Order By 3, 4;

-- SELECT location, date, total_cases, new_cases, total_deaths, population 
-- FROM covid.coviddeaths
-- Order By 1, 2;


-- IMPORTANT!!!! changing date column format from text to date format. Is permanent.
-- UPDATE covid.coviddeaths
-- SET date = str_to_date(date, "%d/%m/%Y");

-- SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deathprcntg
-- FROM covid.coviddeaths
-- WHERE location like "%states%"
-- Order By date

-- SELECT location, date, population, total_cases, total_deaths, (total_cases/population) * 100 as infectionperpop
-- FROM covid.coviddeaths
-- Order By 1,2;

-- SELECT location, population, MAX(total_cases) as mostinfections, MAX((total_cases/population)) * 100 as infectionperpop
-- FROM covid.coviddeaths
-- Group By population, location
-- Order By infectionperpop desc;

-- SELECT CAST(total_deaths AS UNSIGNED) AS new_total_deaths
-- FROM coviddeaths;

-- SELECT location, population, MAX(CAST(total_deaths AS UNSIGNED)) as mostdeaths, (MAX(total_deaths) / population) * 100 as deathperpop
-- FROM covid.coviddeaths
-- GROUP BY location, population
-- ORDER BY mostdeaths DESC;

-- SELECT location, max(cast(total_deaths as unsigned)) as totaldeaths
-- FROM covid.coviddeaths
-- -- WHERE continent is null
-- GROUP BY location
-- ORDER BY totaldeaths desc

-- Important!!! converting empty rows into nulls
-- UPDATE coviddeaths
-- SET continent = NULLIF(continent, '')
-- WHERE continent = '';

-- SELECT continent, location, max(cast(total_deaths as signed)) as totaldeaths
-- FROM covid.coviddeaths
-- WHERE continent is null
-- GROUP BY location, continent
-- ORDER BY totaldeaths desc

-- SELECT continent, max(cast(total_deaths as signed)) as totaldeaths
-- FROM covid.coviddeaths
-- WHERE continent is not null
-- GROUP BY continent
-- ORDER BY totaldeaths desc

-- SELECT location, max(cast(total_deaths as signed)) as totaldeaths
-- FROM covid.coviddeaths
-- WHERE continent is null
-- GROUP BY location
-- ORDER BY totaldeaths desc

-- GLOBAL

-- SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deathpercentage
-- FROM covid.coviddeaths
-- WHERE continent is not null
-- -- GROUP BY location, date
-- ORDER BY deathpercentage desc

-- TABLE JOIN

-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
-- FROM covid.coviddeaths as dea
-- JOIN covid.covidvaccinations as vac
-- On dea.location = vac.location and dea.date = vac.date
-- WHERE dea.continent is not null
-- ORDER BY 2,3

-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
-- SUM(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as vaccinated
-- FROM covid.coviddeaths as dea
-- JOIN covid.covidvaccinations as vac
-- On dea.location = vac.location and dea.date = vac.date
-- WHERE dea.continent is not null
-- ORDER BY 2,3

-- Common Table Expressions CTE

-- With PopvsVac (continent, location, date, population, new_vaccinations, vaccinated)
-- as (
-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
-- SUM(cast(vac.new_vaccinations as unsigned)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as vaccinated
-- FROM covid.coviddeaths as dea
-- JOIN covid.covidvaccinations as vac
-- On dea.location = vac.location and dea.date = vac.date
-- WHERE dea.continent is not null
-- ORDER BY 2,3
-- )
-- SELECT * , (vaccinated/population) * 100 as vaccedpercentage
-- FROM PopvsVac

-- Temp Table

-- DROP Table IF Exists PercentPopVacced;

-- CREATE Table PercentPopVacced 
-- (
-- continent varchar(255),
-- location varchar(255),
-- date datetime,
-- population numeric,
-- new_vaccinations numeric,
-- vaccinated numeric
-- );

-- INSERT INTO PercentPopVacced
-- SELECT
--     dea.continent,
--     dea.location,
--     dea.date,
--     dea.population,
--     vac.new_vaccinations,
--     SUM(CAST(CASE WHEN vac.new_vaccinations REGEXP '^[0-9]+$' THEN vac.new_vaccinations ELSE NULL END AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccinated
-- FROM
--     covid.coviddeaths AS dea
-- JOIN
--     covid.covidvaccinations AS vac ON dea.location = vac.location AND dea.date = vac.date
-- WHERE
--     dea.continent IS NOT NULL
--     AND vac.new_vaccinations <> ''
-- ORDER BY
--     dea.location, dea.date;

-- -- SELECT * , (vaccinated/population) * 100 as vaccedpercentage
-- -- FROM PercentPopVacced

-- -- -- Create View to store for visualization

-- -- -- Drop the view if it exists
-- DROP VIEW IF EXISTS PercentPopVacced;

-- CREATE VIEW PercentPopVacced AS
-- SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
--      SUM(CAST(CASE WHEN vac.new_vaccinations REGEXP '^[0-9]+$' THEN vac.new_vaccinations ELSE NULL END AS UNSIGNED)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS vaccinated
-- FROM covid.coviddeaths AS dea
-- JOIN covid.covidvaccinations AS vac ON dea.location = vac.location AND dea.date = vac.date
-- WHERE dea.continent IS NOT NULL AND vac.new_vaccinations <> '';

-- -- SHOW CREATE VIEW PercentPopVacced;
-- SHOW TABLES IN covid;

SELECT * FROM PercentPopVacced;