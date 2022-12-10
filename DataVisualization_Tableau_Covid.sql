/* Tableau Dashboard (Data Visualization) Output Queries: */

-- Output1(Global Numbers):
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as PercentageDeath
FROM Covid.coviddeaths WHERE continent!='' ORDER BY 1,2;
-- Output2(Total Deaths Per Continent):
SELECT location, SUM(new_deaths) as deathcount
FROM Covid.coviddeaths WHERE continent='' AND location not in ('World','European Union','International') GROUP BY location ORDER BY deathcount desc;
-- Output3(Percent Population Infected Per Country):
SELECT location, population, Max(CAST(total_cases AS unsigned))  as HighestInfectionCount, 
Max(CAST(total_cases AS unsigned))/population*100 as PercentPopulationInfected
FROM Covid.coviddeaths GROUP BY location, population ORDER BY PercentPopulationInfected desc;
-- Output4(Percent Population Infected)
SELECT location, population, date, Max(CAST(total_cases AS unsigned))  as HighestInfectionCount, 
Max(CAST(total_cases AS unsigned))/population*100 as PercentPopulationInfected
FROM Covid.coviddeaths GROUP BY location, population, date ORDER BY PercentPopulationInfected desc;