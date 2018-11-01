-- Reports how many records for the new version of the facilities table Geographical data columns and the old version
-- Calculate the percentage change from the old version to the new version
DROP TABLE IF EXISTS frequencygeocomparison;
WITH facilitiesnew as (SELECT * FROM facilities),
facilitiesprev as (SELECT * FROM dcp_facilieis),
newfrequency(field,newcount) AS (
  SELECT 'boro' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE boro IS NOT NULL
  UNION
  SELECT 'borocode' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE borocode IS NOT NULL
  UNION
  SELECT 'zipcode' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE zipcode IS NOT NULL
  UNION
  SELECT 'latitude' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE latitude IS NOT NULL
  UNION
  SELECT 'longitude' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE longitude IS NOT NULL
  UNION
  SELECT 'xcoord' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE xcoord IS NOT NULL
  UNION
  SELECT 'ycoord' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE ycoord IS NOT NULL
  UNION
  SELECT 'nta' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE nta IS NOT NULL
  UNION
  SELECT 'geom' AS field, COUNT(*) AS newcount
  FROM facilitiesnew
  WHERE geom IS NOT NULL),
oldfrequency AS (
  SELECT 'boro' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE boro IS NOT NULL
  UNION
  SELECT 'borocode' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE borocode IS NOT NULL
  UNION
  SELECT 'zipcode' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE zipcode IS NOT NULL
  UNION
  SELECT 'latitude' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE latitude IS NOT NULL
  UNION
  SELECT 'longitude' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE longitude IS NOT NULL
  UNION
  SELECT 'xcoord' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE xcoord IS NOT NULL
  UNION
  SELECT 'ycoord' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE ycoord IS NOT NULL
  UNION
  SELECT 'nta' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE nta IS NOT NULL
  UNION
  SELECT 'geom' AS field, COUNT(*) AS oldcount
  FROM facilitiesprev
  WHERE geom IS NOT NULL)
SELECT a.field,
       a.newcount,
       b.oldcount,
       100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
INTO frequencygeocomparison
FROM newfrequency a
JOIN oldfrequency b
ON a.field = b.field
ORDER BY a.field;

copy (SELECT * FROM frequencygeocomparison) TO '/prod/db-facilities/output/qc_frequencygeocomparison.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencygeocomparison;