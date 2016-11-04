SELECT DISTINCT ON(f.guid)
	f.guid,
	p.bbl
FROM 
	temp_plutosubset AS p,
	temp_needbbls AS f
-- WHERE
-- 	ST_DWithin(f.geom::geography, p.geom::geography, 100)
ORDER BY
	f.guid,
	ST_Distance(f.geom::geography,p.geom::geography)