WITH matches AS (
SELECT
	CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
	a.id,
	b.id as id_b,
	a.guid,
	b.guid as guid_b,
	a.facilityname,
	b.facilityname as facilityname_b,
	LEFT(
		TRIM(
			split_part(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									UPPER(a.facilityname)
								,'THE ','')
							,'-','')
						,' ','')
					,'.','')
				,',','')
			,'(',1)
		,' ')
	,4) as trim_a,
	LEFT(
		TRIM(
			split_part(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									UPPER(b.facilityname)
								,'THE ','')
							,'-','')
						,' ','')
					,'.','')
				,',','')
			,'(',1)
		,' ')
	,4) as trim_b,
	a.facilitysubgroup,
	b.facilitysubgroup as facilitysubgroup_b,
	a.facilitytype,
	b.facilitytype as facilitytype_b,
	a.processingflag,
	b.processingflag as processingflag_b,
	a.bbl,
	a.bin,
	b.bin as bin_b,
	a.address,
	b.address as address_b,
	a.geom,
	a.pgtable,
	b.pgtable as pgtable_b,
	a.sourcedatasetname,
	b.sourcedatasetname as sourcedatasetname_b
FROM facilities a
LEFT JOIN facilities b
ON a.bbl = b.bbl
WHERE
	a.facilitygroup LIKE '%Child Care%'
	AND (a.facilitytype LIKE '%Early%'
	OR a.facilitytype LIKE '%Charter%')
	AND a.pgtable = 'doe_facilities_universalprek'
	AND b.pgtable = 'acs_facilities_daycareheadstart'
	AND a.geom IS NOT NULL
	AND b.geom IS NOT NULL
	AND a.bbl IS NOT NULL
	AND b.bbl IS NOT NULL
	AND a.bbl <> '{""}'
	AND b.bbl <> '{""}'
	AND a.bbl <> '{0.00000000000}'
	AND b.bbl <> '{0.00000000000}'
	AND
		LEFT(
			TRIM(
				split_part(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										UPPER(a.facilityname)
									,'THE ','')
								,'-','')
							,' ','')
						,'.','')
					,',','')
				,'(',1)
			,' ')
		,4)
		LIKE
		LEFT(
			TRIM(
				split_part(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									REPLACE(
										UPPER(b.facilityname)
									,'THE ','')
								,'-','')
							,' ','')
						,'.','')
					,',','')
				,'(',1)
			,' ')
		,4)
	AND a.pgtable <> b.pgtable
	AND a.guid <> b.guid
	AND a.id <> b.id
	ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
)
--, 

--duplicates AS (
SELECT
	id,
	count(*),
	facilityname,
	array_agg(distinct facilityname_b),
	facilitytype,
	array_agg(distinct facilitytype_b),
	array_agg(distinct bin_b),
	guid,
	array_agg(guid_b) AS guid_duplicate
FROM matches
GROUP BY
id, guid, facilityname, facilitytype
ORDER BY facilitytype, count DESC
--)

-- UPDATE facilities AS f
-- SET
-- 	idagency = array_cat(idagency, d.idagency),
-- 	guid_duplicate = d.guid_duplicate
-- 	pgtable = array_cat(pgtable, 'NYCDOHMH')
-- 	sourcedatasetname = array_cat(sourcedatasetname, 'NYCDOHMH'),
-- 	oversightagency = array_cat(oversightagency, 'NYCDOHMH')
-- 	capacity = array_cat(capacity, d.capacity)
-- FROM duplicates AS d
-- WHERE f.guid = d.guid
