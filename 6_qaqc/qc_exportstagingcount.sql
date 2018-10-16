-- Reports how many records of geom is not null in both the geoprocessing table and the export table
WITH staging(pgtable) AS (
  SELECT pgtable,
       count(*) AS initialrecords,
       count(pgtable) AS recordswithgeom
       FROM facdb_staging
       WHERE geom IS NOT NULL
       GROUP BY pgtable),
export(pgtable) AS (
  SELECT pgtable,
       count(*) AS exportwithgeom
       FROM facdb
       WHERE geom IS NOT NULL
       GROUP BY pgtable)
SELECT a.pgtable,
      a.initialrecords,
      a.recordswithgeom,
      b.exportwithgeom
INTO exportstaging
FROM staging a
JOIN export b
ON a.pgtable = b.pgtable
GROUP BY a.pgtable,
      a.initialrecords,
      a.recordswithgeom,
      b.exportwithgeom
ORDER BY a.pgtable

copy (SELECT * FROM exportstaging) TO '/Users/tommywang/git/db-facilities/output/qc_exportstagingcount.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS exportstaging;
