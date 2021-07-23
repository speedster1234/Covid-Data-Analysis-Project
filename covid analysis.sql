select * 
from CovidProject..Vaccinations$
 order by 3,4

 #select * 
#from CovidProject..Deaths
 #order by 3,4

 Select location, date, total_cases, new_cases,total_deaths, population
 from CovidProject..Deaths
 order by 1,2

 --Total cases vs total deaths
 --Possibility of dying if you contract covid in your country
 select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as PercentageDeaths
 from CovidProject..Deaths
 Where location like '%turkey%' 
order by 1,2


--Determining the percentage of population that got infected(total cases vs population
select location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulation
from CovidProject..Deaths
where location like '%turkey%'
order by 1,2

--Examining Countries with highest infection rates compared to population
select location,population,max (total_cases) as HIghestInfectionCount,max((total_cases/population))*100 as InfectedPopPercentage
from CovidProject..Deaths
--Where location like'%Turkey%'
Group by location, population
order by InfectedPopPercentage desc

--Examining highest death count per population for countries
select location,max(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..Deaths
Where continent is not null
Group by location
order by TotalDeathCount desc

--Examining Death figures by continent
select continent, max(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..Deaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Examining highest death count per population for continents
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..Deaths
Where continent is not null
Group by continent
order by TotalDeathCount desc

--Examining Global figures
select date, sum(New_cases) as total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
from covidproject..Deaths
where continent is not null
group by date
order by 1,2

--Viewing total world figure at a glance

select sum(New_cases) as total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
from covidproject..Deaths
where continent is not null
order by 1,2
--Population Vs Vaccination figures
with popvsvac  (continent, location, date, population,New_vaccinations, VaccinatedPeopleUpdate)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as VaccinatedPeopleUpdate
from CovidProject..Deaths dea
join CovidProject.. Vaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3
)
--USING COMMON TABLE EXPRESSION
with popvsvac (continent, Location, Date, population, new_vaccinations, VaccinatedPeopleUpdate)

as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date)as VaccinatedPeopleUpdate
from CovidProject..Deaths dea
join CovidProject.. Vaccinations vac
	on dea.location=vac.location
	and dea.date=vac.date
where dea.continent is not null

)

select *, (VaccinatedPeopleUpdate/population)*100
from popvsvac

--CREATING VISUALIZATION DATA
create view Possibility_of_dying_if_you_got_covid_in_Turkey as
 select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as PercentageDeaths
 from CovidProject..Deaths
 Where location like '%turkey%' 
--order by 1,2


create view GlobalFigures as
select date, sum(New_cases) as total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
from covidproject..Deaths
where continent is not null
group by date

Create view GlobalFiguresSum as
select sum(New_cases) as total_cases, sum(cast(new_deaths as int)) as Total_deaths, sum(cast(new_deaths as int))/sum(New_cases)*100 as DeathPercentage
from covidproject..Deaths
where continent is not null

create view HighestDeathCountPerContinent as
select continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidProject..Deaths
Where continent is not null
Group by continent

create view HIghestInfectionRateComparedToPopulation as
select location,population,max (total_cases) as HIghestInfectionCount,max((total_cases/population))*100 as InfectedPopPercentage
from CovidProject..Deaths
Group by location, population

create view PercentgePopulationInfectedInTurkey as
select location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulation
from CovidProject..Deaths
where location like '%turkey%'

create view PossibilityOfDyingFromCovidInTurkey as
select location, date,total_cases,total_deaths, (total_deaths/total_cases)*100 as PercentageDeaths
 from CovidProject..Deaths
 Where location like '%turkey%' 

 








