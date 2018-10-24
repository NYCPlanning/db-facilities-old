-- Reports how many records for the new version of the facilities table oversight agency and the old version
-- Calculate the percentage change from the old version to the new version
WITH newfrequency(overabbrev) AS(
  SELECT overabbrev,
  COUNT(overabbrev) AS newcount
  FROM facdb
  GROUP BY overabbrev),
oldfrequency(overabbrev) AS(
  SELECT overabbrev,
  COUNT(overabbrev) AS oldcount
  FROM facdb_prev
  GROUP BY overabbrev)
SELECT a.overabbrev AS oversightagency,
      a.newcount,
      b.oldcount,
      100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
      INTO frequencychanges
      FROM newfrequency a
      JOIN oldfrequency b
      ON a.overabbrev = b.overabbrev
      GROUP BY a.overabbrev, a.newcount, b.oldcount
      ORDER BY a.overabbrev;
SELECT * FROM frequencychanges;

copy (SELECT * FROM frequencychanges) TO '/Users/tommywang/git/db-facilities/output/qc_frequencychangesoversight.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychanges;
