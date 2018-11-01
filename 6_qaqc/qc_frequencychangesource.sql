-- Reports how many records for the new version of the facilities table datasource and the old version
-- Calculate the percentage change from the old version to the new version
DROP TABLE IF EXISTS frequencychangesource;
WITH newfrequency(dataname) AS (
  SELECT dataname,
        COUNT(dataname) AS newcount
  FROM facilities
  GROUP BY dataname),
oldfrequency(dataname) AS (
  SELECT dataname,
        COUNT(dataname) AS oldcount
  FROM dcp_facilities
  GROUP BY dataname)
SELECT a.dataname,
      a.newcount,
      b.oldcount,
      -- 100.0 * (new- prev) / (new)
    	100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
INTO frequencychangesource
FROM newfrequency a
JOIN oldfrequency b
ON a.dataname = b.dataname
GROUP BY a.dataname, a.newcount, b.oldcount
ORDER BY a.dataname;

\copy (SELECT * FROM frequencychangesource) TO '/prod/db-facilities/output/qc_frequencychangesource.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychangesource;