-- Reports how many records for the new version of the facilities table oversight agency and the old version
-- Calculate the percentage change from the old version to the new version
DROP TABLE IF EXISTS frequencychangesoversight;
WITH newfrequency(overabbrev) AS(
  SELECT overabbrev,
  COUNT(overabbrev) AS newcount
  FROM facilities
  GROUP BY overabbrev),
oldfrequency(overabbrev) AS(
  SELECT overabbrev,
  COUNT(overabbrev) AS oldcount
  FROM dcp_facilities
  GROUP BY overabbrev)
SELECT a.overabbrev AS oversightagency,
      a.newcount,
      b.oldcount,
      100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
      INTO frequencychangesoversight
      FROM newfrequency a
      JOIN oldfrequency b
      ON a.overabbrev = b.overabbrev
      GROUP BY a.overabbrev, a.newcount, b.oldcount
      ORDER BY a.overabbrev;
SELECT * FROM frequencychangesoversight;

copy (SELECT * FROM frequencychangesoversight) TO '/prod/db-facilities/output/qc_frequencychangesoversight.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychangesoversight;
