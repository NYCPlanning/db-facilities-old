-- Reports how many records for the new version of the facilities table Geographical data columns and the old version
-- Calculate the percentage change from the old version to the new version
DROP TABLE IF EXISTS frequencygeocomparison;
WITH facilitiesnew as (SELECT * FROM facilities),
facilitiesprev as (SELECT * FROM dcp_facilities),
newfrequency(field,newcountnull) AS (
  SELECT 'boro' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE boro IS NULL
  UNION
  SELECT 'borocode' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE borocode IS NULL
  UNION
  SELECT 'zipcode' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE zipcode IS NULL
  UNION
  SELECT 'latitude' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE latitude IS NULL
  UNION
  SELECT 'longitude' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE longitude IS NULL
  UNION
  SELECT 'xcoord' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE xcoord IS NULL
  UNION
  SELECT 'ycoord' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE ycoord IS NULL
  UNION
  SELECT 'nta' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE nta IS NULL
  UNION
  SELECT 'geom' AS field, COUNT(*) AS newcountnull
  FROM facilitiesnew
  WHERE geom IS NULL),
oldfrequency AS (
  SELECT 'boro' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE boro IS NULL
  UNION
  SELECT 'borocode' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE borocode IS NULL
  UNION
  SELECT 'zipcode' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE zipcode IS NULL
  UNION
  SELECT 'latitude' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE latitude IS NULL
  UNION
  SELECT 'longitude' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE longitude IS NULL
  UNION
  SELECT 'xcoord' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE xcoord IS NULL
  UNION
  SELECT 'ycoord' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE ycoord IS NULL
  UNION
  SELECT 'nta' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE nta IS NULL
  UNION
  SELECT 'geom' AS field, COUNT(*) AS oldcountnull
  FROM facilitiesprev
  WHERE geom IS NULL)
SELECT a.field,
       a.newcountnull,
       b.oldcountnull,
       100.0 * (a.newcountnull - b.oldcountnull) / NULLIF(a.newcountnull, 0) AS percentage_change
INTO frequencygeocomparison
FROM newfrequency a
JOIN oldfrequency b
ON a.field = b.field
ORDER BY a.field;

\copy (SELECT * FROM frequencygeocomparison) TO '/prod/db-facilities/output/qc_frequencygeocomparison.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencygeocomparison;
