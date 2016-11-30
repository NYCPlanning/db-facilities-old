SELECT
	CONCAT(a.agencysource,'-',b.agencysource) as sourcecombo,
	a.id,
	b.id as id_b,
	-- a.guid,
	-- b.guid as guid_b,
	a.facilityname,
	b.facilityname as facilityname_b,
	a.facilitysubgroup,
	b.facilitysubgroup as facilitysubgroup_b,
	a.facilitytype,
	b.facilitytype as facilitytype_b,
	a.processingflag,
	b.processingflag as processingflag_b,
	a.bbl,
	a.address,
	b.address as address_b,
	a.geom,
	a.agencysource,
	b.agencysource as agencysource_b,
	a.sourcedatasetname,
	b.sourcedatasetname as sourcedatasetname_b
FROM kiddies a
FULL OUTER JOIN kiddies b
ON a.bbl = b.bbl
WHERE
	a.agencysource = 'NYCDOE'
	AND b.agencysource = 'NYCDOHMH'
	AND a.geom IS NOT NULL
	AND b.geom IS NOT NULL
	AND a.bbl IS NOT NULL
	AND b.bbl IS NOT NULL
	AND a.bbl <> '{""}'
	AND b.bbl <> '{""}'
	AND a.bbl <> '{0.00000000000}'
	AND b.bbl <> '{0.00000000000}'
	-- AND TRIM(split_part(REPLACE(REPLACE(REPLACE(UPPER(a.facilityname),' ',''),'.',''),',',''),'(',1),' ') 
	-- 	LIKE TRIM(split_part(REPLACE(REPLACE(REPLACE(UPPER(b.facilityname),' ',''),'.',''),',',''),'(',1),' ') 
	-- AND a.facilitysubgroup = b.facilitysubgroup
	AND a.agencysource <> b.agencysource
	AND a.guid <> b.guid
	AND a.id <> b.id
	ORDER BY CONCAT(a.agencysource,'-',b.agencysource), a.facilityname, a.facilitysubgroup