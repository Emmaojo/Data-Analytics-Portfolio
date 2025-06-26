select * 
from ['Summary Table$']



-- new query to generate the drug categroy table
SELECT 
[Drug Category and Types] AS [Drug Use Category],
  [General Estimated Number] AS [Estimate Prevalence Total],
  [General Estimated prevalence per cent ] AS [Estimate Prevalence Percentage],
  [Estimated Number (MEN)] AS [Male Prevalence],
  [Estimated prevalence per cent (MEN)] AS [Male Prevalence Percentage],
  [Estimated Number (WOMEN)] AS [Female Prevalence], 
  [Estimated prevalence percent (WOMEN)] AS [Female Prevalence Percentage]
  
INTO [NEW - DRUG CATEGORIES]
FROM 
  ['Summary Table$']
WHERE 
  [Drug Category and Types] IN (
    'Any Drug Use', 
    'High-risk drug Use', 
    'People who inject drugs')


SELECT * FROM [NEW - DRUG CATEGORIES]

-- table to create table for specific drug types
SELECT 
  [Drug Category and Types] AS [Specific Drug Type],
  [General Estimated Number] AS [Estimate Prevalence Total],
  [General Estimated prevalence per cent ] AS [Estimate Prevalence Percentage],
  [Estimated Number (MEN)] AS [Male Prevalence],
  [Estimated prevalence per cent (MEN)] AS [Male Prevalence Percentage],
  [Estimated Number (WOMEN)] AS [Female Prevalence], 
  [Estimated prevalence percent (WOMEN)] AS [Female Prevalence Percentage]
INTO [NEW - SPECIFIC DRUG EXTENT OF USE]
FROM 
  ['Summary Table$']
WHERE 
 [Drug Category and Types] IN (
    'Cannabis', 
    'Opioids', 
    'Heroin',
	'Pharmaceutical Opioids (tramadol, codeine, morphine)',
	'Cocaine', 
	'Tranquilizers/sedatives',
	'Amphetamines', 
	'Pharmaceutical Amphetamine and illicit amphetamine',
	'Methamphetamine', 
	'Ecstasy',
	'Hallucinogens', 
	'Solvents/inhalants', 
	'Cough syrups'
  );

  SELECT * FROM [NEW - SPECIFIC DRUG EXTENT OF USE]



 
  -- QUERY TO CREATE TABLE THAT COMPILES ALL STATES AND THEIR PREVALENCE LEVEL 
  -- North Central
SELECT 
    'North Central' AS Region,
    [State (North Central Zone)] AS [State],
    [Estimated numbers] AS [Estimated Prevalence Number],
    [Estimated prevalence (per cent)] AS [Estimated prevalence per cent]
INTO [NEW - All_States_Drug_Use]
FROM ['NCZS $']
WHERE  [State (North Central Zone)] IS NOT NULL

UNION ALL

-- North East
SELECT 
    'North East' AS Region,
    [State (North East Zone)] AS [State],
    [Estimated numbers] AS [Estimated Prevalence Number],
	[Estimated prevalence (per cent )] AS [Estimated prevalence per cent]
   
FROM ['NEZS $']
WHERE [State (North East Zone)] IS NOT NULL

UNION ALL

-- North West
SELECT 
   'North West' AS Region,
   [State (North West zone)] AS [State],
    [Estimated numbers] AS [Estimated Prevalence Number],
    [Estimated prevalence (per cent )] AS [Estimated prevalence per cent]
FROM ['NWZS $']
WHERE  [State (North West zone)] IS NOT NULL

UNION ALL

-- South East
SELECT 
    'South East' AS Region,
    [State (South East)] AS [State],
    [Estimated numbers] AS [Estimated Prevalence Number],
   [Estimated prevalence (per cent )] AS [Estimated prevalence per cent]
FROM ['SEZS $']
WHERE [State (South East)]  IS NOT NULL

UNION ALL

-- South West
SELECT 
    'South West' AS Region,
	[State (South West)] AS [State],
    [ Estimated numbers] AS [Estimated Prevalence Number],
    [Estimated prevalence (per cent)] AS [Estimated prevalence per cent]
FROM ['SWZS $']
WHERE [State (South West)] IS NOT NULL

UNION ALL

-- South South
SELECT 
    'South South' AS Region,
	[State (South South)] AS [State],
	[ Estimated numbers] AS [Estimated Prevalence Number],
	[Estimated prevalence (per cent)] AS [Estimated prevalence per cent]
FROM ['SSZS $']
WHERE [State (South South)] IS NOT NULL;


-- query to check highest state
select State, [Estimated Prevalence Number], [Estimated prevalence per cent] 
From [New - All_States_Drug_Use]
order by [Estimated prevalence per cent] desc



-- Query to create table that shows all geoplitical zones and prevelence
  -- North Central
SELECT 
    'North Central' AS Region, AVG ([Estimated prevalence (per cent)]) AS [Average prevalence per cent], SUM ([Estimated numbers]) AS [Total Number]
INTO [NEW - All_Region_Drug_Use]
FROM ['NCZS $']
WHERE  [State (North Central Zone)] IS NOT NULL

UNION ALL

-- North East
SELECT 
    'North East' AS Region, AVG([Estimated prevalence (per cent )]) AS [Average prevalence per cent], SUM ([Estimated numbers]) AS [Total Number]
FROM ['NEZS $']
WHERE [State (North East Zone)] IS NOT NULL

UNION ALL

-- North West
SELECT 
   'North West' AS Region, AVG([Estimated prevalence (per cent )]) AS [Average prevalence per cent], SUM ([Estimated numbers]) AS [Total Number]
FROM ['NWZS $']
WHERE  [State (North West zone)] IS NOT NULL

UNION ALL

-- South East
SELECT 
    'South East' AS Region, AVG([Estimated prevalence (per cent )]) AS [Average prevalence per cent], SUM ([Estimated numbers]) AS [Total Number]
FROM ['SEZS $']
WHERE [State (South East)]  IS NOT NULL

UNION ALL

-- South West
SELECT 
    'South West' AS Region, AVG([Estimated prevalence (per cent)]) AS [Average prevalence per cent], SUM ([ Estimated numbers]) AS [Total Number]
FROM ['SWZS $']
WHERE [State (South West)] IS NOT NULL

UNION ALL

-- South South
SELECT 
    'South South' AS Region, AVG([Estimated prevalence (per cent)]) AS [Average prevalence per cent], SUM([ Estimated numbers]) AS [Total Number]
FROM ['SSZS $']
WHERE [State (South South)] IS NOT NULL;


select * 
from [NEW - All_Region_Drug_Use]



-- new query (drug use and infection)
-- perceived ease or difficulty in accessing drug treatment by geopolitical zones 
-- perceived ease or difficulty in accessing drug treatment by states
-- prevalence of drug usage across geopolitical zones
