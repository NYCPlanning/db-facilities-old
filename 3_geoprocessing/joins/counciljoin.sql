UPDATE facilities AS f
    SET
        councildistrict = p.coundist
    FROM 
        dcp_councildistricts AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
