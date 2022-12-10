/* Data Exploration using SQL (Covid 19 Data): */

-------------------------------------------------------------------------------------------------------------
-- 1.Change Date column format from d/m/y to yyyy-mm-dd:
Select STR_TO_DATE(date, '%d/%m/%Y') from Covid.coviddeaths order by 1 desc;
UPDATE Covid.covidvaccinations SET date = STR_TO_DATE(date, '%d/%m/%Y');
-------------------------------------------------------------------------------------------------------------
-- 2.Selecting required Data for further exploration:
SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM Covid.coviddeaths WHERE continent!='' order by 1,2;
-------------------------------------------------------------------------------------------------------------
-- 3.Total Cases vs Total Deaths & likelihood of dying if one contracts covid in their country:
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage 
FROM Covid.coviddeaths WHERE location like '%states%' order by 1,2;
-------------------------------------------------------------------------------------------------------------
-- 4. Total Cases vs Population & percentage of population infected with Covid:
Select location, date, population, total_cases, (total_cases/population)*100 as PercentPopulationInfected
FROM Covid.coviddeaths WHERE continent!='' order by 1,2;
-------------------------------------------------------------------------------------------------------------
-- 5.Countries with Highest Infection Rate compared to Population:
Select location, population, MAX(total_cases) as HighestInfectionCount,
Max((total_cases/population))*100 as PercentPopulationInfected From Covid.coviddeaths WHERE continent!=''
Group by location, population order by PercentPopulationInfected desc;
-------------------------------------------------------------------------------------------------------------
-- 6.Countries with Highest Death Count:
Select location, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From Covid.coviddeaths WHERE continent!='' Group by location
order by TotalDeathCount desc;
-------------------------------------------------------------------------------------------------------------
-- 7.Contintents with the highest death count:
Select continent, MAX(cast(Total_deaths as unsigned)) as TotalDeathCount
From Covid.coviddeaths WHERE continent!=''
Group by continent order by TotalDeathCount desc;
-------------------------------------------------------------------------------------------------------------
-- 8. Global Numbers:
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, 
SUM(new_deaths)/SUM(new_cases)*100 as PercentageDeath
FROM Covid.coviddeaths WHERE continent!='' ORDER BY 1,2;
-------------------------------------------------------------------------------------------------------------
-- 9. Total Population vs Vaccinations:
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
as RollingPeopleVaccinated FROM Covid.coviddeaths dea 
JOIN Covid.covidvaccinations vac ON dea.location=vac.location AND dea.date=vac.date 
WHERE dea.continent!='' order by 2,3;
-------------------------------------------------------------------------------------------------------------
-- 10. Using CTE to perform Calculation on Partition By in previous query:
WITH PopVsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) 
AS (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(cast(vac.new_vaccinations as unsigned)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) 
as RollingPeopleVaccinated FROM Covid.coviddeaths dea 
JOIN Covid.covidvaccinations vac ON dea.location=vac.location AND dea.date=vac.date 
WHERE dea.continent!='') 
SELECT *, (RollingPeopleVaccinated/Population)*100 FROM PopVsVac order by 2,3;