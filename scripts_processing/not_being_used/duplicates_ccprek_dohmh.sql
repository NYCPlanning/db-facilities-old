SELECT
	(array_agg(distinct guid))[1] as guid,
	(array_agg(distinct facilityname))[1] as facilityname,
	array_to_string(array_agg(distinct facilitytype),' & ') as facilitytype,
	facilitysubgroup,
	BBL,
	count(*),
	array_agg(distinct idagency),
	array_agg(distinct facilityname),
	array_agg(distinct BIN),
	array_agg(distinct facilitytype),
	array_agg(distinct guid)
FROM facilities
WHERE
	agencysource = 'NYCDOHMH'
	AND geom IS NOT NULL
GROUP BY
	facilitysubgroup,
	BBL,
	(LEFT(
		TRIM(
			split_part(
				REPLACE(
					REPLACE(
						REPLACE(
							REPLACE(
								REPLACE(
									UPPER(facilityname)
								,'THE ','')
							,'-','')
						,' ','')
					,'.','')
				,',','')
			,'(',1)
		,' ')
	,4))
ORDER BY facilitysubgroup, count DESC

-- UPDATE facilities AS f
-- SET
-- 	idagency = array_cat(idagency, d.idagency),
-- 	guid_duplicate = d.guid_duplicate
-- 	agencysource = array_cat(agencysource, 'NYCDOHMH')
-- 	sourcedatasetname = array_cat(sourcedatasetname, 'NYCDOHMH'),
-- 	oversightagency = array_cat(oversightagency, 'NYCDOHMH')
-- 	capacity = array_cat(capacity, d.capacity)
-- FROM duplicates AS d
-- WHERE f.guid = d.guid
