-- Reports how many records of geom is not null in both the geoprocessing table and the export table
DROP TABLE IF EXISTS geocodingreport;
CREATE TABLE geocodingreport AS (
WITH newcount as (
  SELECT pgtable::text, COUNT(*) as newcount
  FROM facilities
  GROUP BY pgtable::text),
oldcount as (
  SELECT pgtable::text, COUNT(*) as oldcount
  FROM dcp_facilities
  GROUP BY pgtable::text)
SELECT a.pgtable, newcount, oldcount FROM newcount a
LEFT JOIN oldcount b
ON a.pgtable=b.pgtable);

\copy (SELECT * FROM geocodingreport) TO '/prod/db-facilities/output/qc_geocodingreport.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS geocodingreport;