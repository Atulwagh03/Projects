Select Location, date,total_cases, new_cases , total_deaths,population
From Portfolio_Project..CovidDeaths$
order by 1,2

Select * 
From Portfolio_Project..CovidDeaths$
Where continent is not null
order by 1,2


--Total cases vs Total Deaths 
Select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercent
From Portfolio_Project..CovidDeaths$
where location like '%India%'
order by 1,2

--Total cases vs Population
Select Location, date,total_cases,population,(total_cases/population)*100 as InfectedPopulationpercent
From Portfolio_Project..CovidDeaths$
where location like '%India%'
order by 1,2

--Countries with high infection vs Population
Select Location,MAX (total_cases) as HighInfectionCount, Population, MAX((total_cases/population))*100 
as PercentPopulationInfected
From Portfolio_Project..CovidDeaths$
--where location like '%India%'
Group by location, population
order by PercentPopulationInfected desc

-- High death count per population
Select Location, MAX(cast (total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths$
--where location like '%India%'
Where continent is null
Group by location, population
order by TotalDeathCount desc

--BY CONTINENT
-- continent vs highest death
 
 Select Location, MAX(cast (total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths$
--where location like '%India%'
Where continent is null
Group by location
order by TotalDeathCount desc


--GLOBAL NUMBERS
Select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as Deathpercent
From Portfolio_Project..CovidDeaths$
--where location like '%India%'
where continent is not null
--Group by date
order by 1,2


-- TOTAL POPulation VS VACC

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER
(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVacci

From Portfolio_Project..CovidDeaths$ dea
Join Portfolio_Project..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--and dea.location like '%Alb%'
order by 2,3

-- USE CTE 
With PopuvsVac(Continent,Location,Date,Population, New_Vaccinations ,RollingPeopleVacci)
as (

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER
(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVacci

From Portfolio_Project..CovidDeaths$ dea
Join Portfolio_Project..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--and dea.location like '%Alb%'
--order by 2,3
)
Select *,(RollingPeopleVacci/Population)*100
From PopuvsVac


--Creating View for visulaisation

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as int)) OVER
(Partition by dea.Location Order by dea.location, dea.date) as RollingPeopleVacci
From Portfolio_Project..CovidDeaths$ dea
Join Portfolio_Project..CovidVaccinations$ vac
     On dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--and dea.location like '%Alb%'
--order by 2,3
