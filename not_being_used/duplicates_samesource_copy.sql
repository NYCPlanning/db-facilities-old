CREATE TABLE duplicates_samesource FROM (
	SELECT
		a.*,
		b.uid as uid_b
	FROM facilities as a
	LEFT JOIN facilities as b
	ON a.id = b.id
	WHERE
		a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl = b.bbl
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> '{""}'
		AND b.bbl <> '{""}'
		AND a.bbl <> '{0.00000000000}'
		AND b.bbl <> '{0.00000000000}'
	ORDER BY a.agencysource, a.facilitysubgroup, a.bbl, a.facilityname
)