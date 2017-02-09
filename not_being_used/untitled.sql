WITH matches AS (
SELECT
	CONCAT(a.agencysource,'-',b.agencysource) as sourcecombo,
	a.id,
	b.id as id_b,
	a.uid,
	b.uid as uid_b,
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
	a.address,
	b.address as address_b,
	a.geom,
	a.agencysource,
	b.agencysource as agencysource_b,
	a.sourcedatasetname,
	b.sourcedatasetname as sourcedatasetname_b
FROM facilities a
LEFT JOIN facilities b
ON a.bbl = b.bbl
WHERE
	a.facilitygroup LIKE '%Child Care%'
	AND (a.facilitytype LIKE '%Early%'
	OR a.facilitytype LIKE '%Charter%')
	AND b.facilitytype LIKE '%Preschool%'
	AND a.agencysource = 'NYCDOE'
	AND b.agencysource = 'NYCDOHMH'
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
	AND a.agencysource <> b.agencysource
	AND a.uid <> b.uid
	AND a.id <> b.id
	ORDER BY CONCAT(a.agencysource,'-',b.agencysource), a.facilityname, a.facilitysubgroup
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
	uid,
	array_agg(uid_b) AS uid_duplicate
FROM matches
GROUP BY
id, uid, facilityname, facilitytype
ORDER BY facilitytype, count DESC
--)