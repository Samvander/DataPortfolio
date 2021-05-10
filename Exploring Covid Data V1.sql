--select location, date, total_cases, new_cases, total_deaths, population
--from DataAnalysis..covid_deaths
--where continent is not null
--order by 1,2

-- Total cases vs total deaths
-- Query by country, date and % of cases where patient died
--select location, date, total_cases, total_deaths, ((total_deaths/total_cases)*100) as 'Death Percentage'
--from DataAnalysis..covid_deaths
--order by 1,2

-- Infection rates by country
--select location, date, total_cases, population, ((total_cases/population) *100) as ' % infected'
--from DataAnalysis..covid_deaths
--where location like '%france%'
--order by 5 desc

-- Infection rates vs. population
--select location, population, max(total_cases) as 'Highest Infection Count', max ((total_cases/population) *100) as 'Highest infection rate'
--from DataAnalysis..[covid_deaths]
--where continent is not null
--group by location, population
--order by 4 desc

--Death count by country 
--select location, population, max(cast(total_deaths as int)) as 'Total Death Count'
--from DataAnalysis..[covid_deaths]
--where continent is not null
--group by location, population
--order by 3 desc

-- Global Numbers
--select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/ sum(new_cases)*100 as 'Death Percentage'  
----((total_cases/total_deaths)*100)
--from DataAnalysis..covid_deaths
--where continent is not null
--group by date
--order by date 

--use DataAnalysis
--select * 
--from [dbo].[covid_deaths] dea
--join [dbo].[covid_vaccinations] vac
--on dea.location = vac.location
--and dea.date = vac.date

--Total Pop vs. total vaccinations

--select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
--sum(cast (new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Vaccination_Counter
--from [dbo].[covid_deaths] dea
--join [dbo].[covid_vaccinations] vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null

--order by 2,3

--Using CTE
--with PopvsVac (continent, location, date, population, new_vaccinations, Vaccination_Counter)
--as 
--(
--select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
--sum(cast (new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Vaccination_Counter
--from [dbo].[covid_deaths] dea
--join [dbo].[covid_vaccinations] vac
--on dea.location = vac.location
--and dea.date = vac.date
--where dea.continent is not null

--)
--select *, (Vaccination_Counter/population)*100 as '% Pop Vaccinated'
--from PopvsVac
--order by 7 desc

create view PopulationVaccinated as 
select dea.continent, dea.location, dea.date, dea.population, new_vaccinations,
sum(cast (new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as Vaccination_Counter
from [dbo].[covid_deaths] dea
join [dbo].[covid_vaccinations] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
