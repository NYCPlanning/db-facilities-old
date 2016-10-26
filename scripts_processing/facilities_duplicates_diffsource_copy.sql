SELECT
CONCAT(a.agencysource,'-',b.agencysource) as sourcecombo,
a.id,
a.guid,
a.facilityname,
a.facilitysubgroup,
a.bbl,
a.geom,
a.agencysource,
a.sourcedatasetname,
b.id as id_b,
b.guid as guid_b,
b.facilityname as facilityname_b,
b.facilitysubgroup as facilitysubgroup_b,
b.agencysource as agencysource_b,
b.sourcedatasetname as sourcedatasetname_b
FROM facilities a
LEFT JOIN facilities b
ON a.bbl = b.bbl
WHERE
a.geom IS NOT NULL
AND b.geom IS NOT NULL
AND a.bbl IS NOT NULL
AND b.bbl IS NOT NULL
AND a.bbl <> '{""}'
AND b.bbl <> '{""}'
AND a.bbl <> '{0.00000000000}'
AND b.bbl <> '{0.00000000000}'
AND TRIM(split_part(REPLACE(REPLACE(REPLACE(UPPER(a.facilityname),' ',''),'.',''),',',''),'(',1),' ') 
	LIKE TRIM(split_part(REPLACE(REPLACE(REPLACE(UPPER(b.facilityname),' ',''),'.',''),',',''),'(',1),' ') 
AND a.facilitysubgroup = b.facilitysubgroup
AND a.agencysource <> b.agencysource
AND a.guid <> b.guid
AND a.id <> b.id
ORDER BY a.facilitysubgroup, a.bbl, a.facilityname