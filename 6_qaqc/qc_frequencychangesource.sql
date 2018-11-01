-- Reports how many records for the new version of the facilities table datasource and the old version
-- Calculate the percentage change from the old version to the new version
DROP TABLE IF EXISTS frequencychangesource;
WITH newfrequency(pgtable) AS (
  SELECT pgtable,
        COUNT(pgtable) AS newcount
  FROM facilities
  GROUP BY pgtable),
oldfrequency(pgtable) AS (
  SELECT pgtable,
        COUNT(pgtable) AS oldcount
  FROM dcp_facilities
  GROUP BY pgtable)
SELECT a.pgtable,
      a.newcount,
      b.oldcount,
      -- 100.0 * (new- prev) / (new)
    	100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
INTO frequencychangesource
FROM newfrequency a
JOIN oldfrequency b
ON a.pgtable = b.pgtable
GROUP BY a.pgtable, a.newcount, b.oldcount
ORDER BY a.pgtable;

\copy (SELECT * FROM frequencychangesource) TO '/prod/db-facilities/output/qc_frequencychangesource.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychangesource;