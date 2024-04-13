-- Link project >> https://ourworldindata.org/covid-deaths
--SELECT top 20 location,date,total_cases,new_cases,total_deaths,population
--FROM [FirstProject]..[Covid]
--WHERE total_cases IS NOT NULL AND total_deaths IS NOT NULL
--ORDER BY 1,2

-- SELECT Data That we are going to be using
--SELECT top 20 location,date,total_cases,new_cases,total_deaths,population
--FROM [FirstProject]..[Covid]
--ORDER BY 1,2

-- تعديل نوع البيانات الي float

--ALTER TABLE Covid
--ALTER COLUMN total_cases float;

-- Looking at total Cases Vs Total Deaths

--SELECT TOP 1000 location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
--FROM Covid
--WHERE location LIKE '%egypt%'
--ORDER BY 1,2;

-- Looking at total Cases Vs Population
-- Shows What Precentage of population got Covid

--SELECT TOP 1000 location,date,population,total_cases,(total_cases / population) * 100 AS PrecentPopulationInfection
--FROM Covid
--WHERE location LIKE '%states%'
--ORDER BY 1,2;

-- Looking at Countries With Highest Infection Rate Compared to population

SELECT Location,Population,MAX(total_cases) AS HightInfectionCount,MAX((total_cases / population)) * 100 AS PrecentPopulationInfection
FROM Covid
--WHERE location LIKE '%states%'
GROUP BY Location,Population
ORDER BY PrecentPopulationInfection DESC;


-- LET'S BREAK THINGS DOWN BY CONTINENT

SELECT Location,MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM Covid
WHERE continent IS NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;

SELECT continent,MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM Covid
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC;	

-- Showing Countries With Highest Death count Per Population

SELECT Location,MAX(cast(total_deaths AS int)) AS TotalDeathCount
FROM Covid
WHERE [continent] IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC;	

-- GLOBAL NUMBERS

SELECT SUM(new_cases) AS TotalCases,
    SUM(CAST(new_deaths AS INT)) AS TotalDeaths,
    SUM(CAST(new_deaths AS INT)) / SUM(new_cases) * 100 AS DeathsPercentage
FROM Covid
WHERE new_deaths <> 0
    AND new_cases <> 0
    AND [continent] IS NOT NULL --GROUP BY date
ORDER BY 1,
    2;

-- Looking at total Population Vs Vaccintions
SELECT * FROM Covid2
WITH PopvsVac (continent, Location, Date, Population,Roll) AS (
    SELECT dea.continent,
        dea.location,
        dea.date,
        dea.population,
        COUNT(CONVERT(int, vac.new_deaths_smoothed)) OVER (
            PARTITION BY dea.Location
            ORDER BY dea.location,
                dea.date ROWS UNBOUNDED PRECEDING
        ) AS Roll
    FROM Covid dea
        JOIN Covid2 vac ON dea.location = vac.location
        AND dea.date = vac.date
    WHERE dea.continent IS NOT NULL
    --ORDER BY 2,3
)
SELECT * FROM PopvsVac

-- TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
    continent nvarchar(255),
    Location nvarchar(255),
    Date datetime,
    Population numeric,
    Roll numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,
    dea.location,
    dea.date,
    dea.population,
    COUNT(CONVERT(int, vac.new_deaths_smoothed)) OVER (
        PARTITION BY dea.Location
        ORDER BY dea.location,
            dea.date ROWS UNBOUNDED PRECEDING
    ) AS Roll
FROM Covid dea
    JOIN Covid2 vac ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;
--ORDER BY 2,3
SELECT *
FROM #PercentPopulationVaccinated;

-- Creating View To Store Data For Later Visualizations

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,
    dea.location,
    dea.date,
    dea.population,
    COUNT(CONVERT(int, vac.new_deaths_smoothed)) OVER (
        PARTITION BY dea.Location
        ORDER BY dea.location,
            dea.date ROWS UNBOUNDED PRECEDING
    ) AS Roll
FROM Covid dea
    JOIN Covid2 vac ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT * FROM [SQLTutorial].[dbo].[DoNky] WHERE ExamplesId%2=1;
SELECT * FROM [SQLTutorial].[dbo].[DoNky] WHERE ExamplesId%2=0;
DROP TABLE IF EXISTS Persons;
CREATE TABLE Persons (
    ID int PRIMARY KEY IDENTITY(1, 1),
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Phone nvarchar(255) NOT NULL,
    City varchar(255),
	CONSTRAINT CK_Persons_Phone CHECK (Phone BETWEEN 10 AND 12)
);
INSERT INTO Persons
VALUES('Fhony','Lhony','01146139111','Egypt');
SELECT * FROM Persons;

CREATE VIEW towlink AS
SELECT * FROM [SQLTutorial].[dbo].[DoNky] WHERE ExamplesId%2=1 AND Link LIKE '%google%';

ALTER VIEW towlink AS
SELECT * FROM [SQLTutorial].[dbo].[DoNky] WHERE ExamplesId%2=0;

SELECT ExamplesId,PcName,Link,Phone,Price FROM [dbo].[towlink];

SELECT * FROM [towlink];

SELECT * FROM [SQLTutorial].[dbo].[DoNky];
