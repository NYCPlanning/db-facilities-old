UPDATE facilities AS f
    SET
        bbl = ARRAY[ROUND(p.bbl,0)],
        processingflag = 'bblfromjoin_closest'
    FROM
	dcp_mappluto AS p
    WHERE
        f.bbl IS NULL
        AND f.geom IS NOT NULL
        AND f.facilitygroup NOT LIKE '%Parks and Plazas%'
      	AND ST_DWithin(ST_ClosestPoint(p.geom,f.geom), p.geom, 0.001)



(
WITH needbbls AS (
    SELECT facilities.* 
    FROM
        facilities,
        dcp_boroboundaries
    WHERE
        bbl IS NULL
        AND geom IS NOT NULL
        AND facilitygroup NOT LIKE '%Parks and Plazas%'
        AND dcp_boroboundaries.borocode = 1
        AND ST_Intersects(facilities.geom, dcp_boroboundaries.geom)
), 

pluto AS (
SELECT dcp_mappluto.*
FROM 
    dcp_mappluto, 
    needbbls
WHERE 
    borough = 'MN'
    AND ST_DWithin(dcp_mappluto.geom,needbbls.geom,100)
)

SELECT
md.min_distance,
f.guid,
pluto.bbl AS bbl_p
FROM
    needbbls AS f,
    pluto,
    (
        SELECT n.geom,
        min(ST_Distance(p.geom,n.geom)) AS min_distance
        FROM
            needbbls AS n, 
            pluto AS p
        GROUP BY n.geom
    ) AS md 
WHERE ST_Distance(pluto.geom,f.geom)=md.min_distance
)

