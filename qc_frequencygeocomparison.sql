-- Reports how many records for the new version of the facilities table Geographical data columns and the old version
-- Calculate the percentage change from the old version to the new version

WITH newfrequency(field,newcount) AS (
  SELECT 'boro' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE boro IS NOT NULL
  UNION
  SELECT 'borocode' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE borocode IS NOT NULL
  UNION
  SELECT 'zipcode' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE zipcode IS NOT NULL
  UNION
  SELECT 'latitude' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE latitude IS NOT NULL
  UNION
  SELECT 'longitude' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE longitude IS NOT NULL
  UNION
  SELECT 'xcoord' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE xcoord IS NOT NULL
  UNION
  SELECT 'ycoord' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE ycoord IS NOT NULL
  UNION
  SELECT 'nta' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE nta IS NOT NULL
  UNION
  SELECT 'geom' AS field, COUNT(*) AS newcount
  FROM facdb
  WHERE geom IS NOT NULL),
oldfrequency AS (
  SELECT 'boro' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE boro IS NOT NULL
  UNION
  SELECT 'borocode' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE borocode IS NOT NULL
  UNION
  SELECT 'zipcode' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE zipcode IS NOT NULL
  UNION
  SELECT 'latitude' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE latitude IS NOT NULL
  UNION
  SELECT 'longitude' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE longitude IS NOT NULL
  UNION
  SELECT 'xcoord' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE xcoord IS NOT NULL
  UNION
  SELECT 'ycoord' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE ycoord IS NOT NULL
  UNION
  SELECT 'nta' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE nta IS NOT NULL
  UNION
  SELECT 'geom' AS field, COUNT(*) AS oldcount
  FROM facdb
  WHERE geom IS NOT NULL)
SELECT a.field,
       a.newcount,
       b.oldcount,
       100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
INTO frequencychanges
FROM newfrequency a
JOIN oldfrequency b
ON a.field = b.field
ORDER BY a.field

copy (SELECT * FROM frequencychanges) TO '/Users/tommywang/git/db-facilities/output/qc_frequencygeocomparison.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychanges;
