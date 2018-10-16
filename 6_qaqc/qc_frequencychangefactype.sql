-- Reports how many records for the new version of the facilities table facilities type and the old version
-- Calculate the percentage change from the old version to the new version
WITH newfrequency(factype) AS (
  SELECT factype,
        COUNT(factype) AS newcount
  FROM facdb
  GROUP BY factype),
oldfrequency(factype) AS (
  SELECT factype,
        COUNT(factype) AS oldcount
  FROM facdb_prev
  GROUP BY factype)
SELECT a.factype,
      a.newcount,
      b.oldcount,
      -- 100.0 * (new- prev) / (new)
    	100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
INTO frequencychanges
FROM newfrequency a
JOIN oldfrequency b
ON a.factype = b.factype
GROUP BY a.factype, a.newcount, b.oldcount
ORDER BY a.factype

copy (SELECT * FROM frequencychanges) TO '/Users/tommywang/git/db-facilities/output/qc_frequencychangefactype.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychanges;
