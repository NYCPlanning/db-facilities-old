-- Reports how many records of geom is not null in both the geoprocessing table and the export table
DROP TABLE IF EXISTS geocodingreport;
WITH staging(pgtable) AS (
  SELECT pgtable,
       count(*) AS initialrecords,
       count(pgtable) AS recordswithgeom
       FROM facilities_all
       WHERE geom IS NOT NULL
       GROUP BY pgtable),
export(pgtable) AS (
  SELECT pgtable,
       count(*) AS exportwithgeom
       FROM facilities
       WHERE geom IS NOT NULL
       GROUP BY pgtable)
SELECT a.pgtable,
      a.initialrecords,
      a.recordswithgeom,
      b.exportwithgeom
INTO geocodingreport
FROM staging a
JOIN export b
ON a.pgtable = b.pgtable
GROUP BY a.pgtable,
      a.initialrecords,
      a.recordswithgeom,
      b.exportwithgeom
ORDER BY a.pgtable

copy (SELECT * FROM geocodingreport) TO '/prod/db-facilities/output/qc_geocodingreport.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS geocodingreport;