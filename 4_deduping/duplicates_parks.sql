-- Reconcile duplicate records for park properties

-- Finding duplicate records
CREATE VIEW duplicates AS
WITH grouping AS (
SELECT 
	a.uid,
	a.overabbrev,
	LEFT(
		TRIM(
			split_part(
		REPLACE(
			REPLACE(
		REPLACE(
			REPLACE(
		REPLACE(
			UPPER(a.facname)
		,'THE ','')
			,'-','')
		,' ','')
			,'.','')
		,',','')
			,'(',1)
		,' ')
	,4) as facnamefour,
	LEFT(
		TRIM(
			split_part(
		REPLACE(
			REPLACE(
		REPLACE(
			REPLACE(
		REPLACE(
			UPPER(b.facname)
		,'THE ','')
			,'-','')
		,' ','')
			,'.','')
		,',','')
			,'(',1)
		,' ')
	,4) as facnamefour_b,
	a.geom,
	b.geom as geom_b
	FROM facilities a
	JOIN facilities b
	ON a.facgroup=b.facgroup
	WHERE
		a.facgroup = 'Parks and Plazas'
		AND a.overabbrev=b.overabbrev
		AND a.uid<>b.uid
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			=
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
),

duplicated AS (
	SELECT 
	min(uid) as minuid,
	count(*),
	a.overabbrev,
	a.facnamefour,
	a.geom
	FROM grouping a
	WHERE ST_DWithin(a.geom::geography, geom_b::geography, 500)
	GROUP BY 
	a.overabbrev,
	a.facnamefour,
	a.geom
)

-- finding duplicate neighbioring colp records
	SELECT a.minuid,
	b.*
	FROM duplicated a
	LEFT JOIN facilities b
	ON a.overabbrev=b.overabbrev
	WHERE
		b.facgroup = 'Parks and Plazas'
		AND b.geom IS NOT NULL
		AND ST_DWithin(a.geom::geography, b.geom::geography, 500)
		AND a.facnamefour
			=
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4);