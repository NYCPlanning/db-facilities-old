UPDATE facilities AS f
    SET
        borough = p.boroname,
        boroughcode = p.borocode
    FROM 
        dcp_boroboundaries AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
