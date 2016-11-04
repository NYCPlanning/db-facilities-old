UPDATE facilities 
    SET 
    	xcoord = ROUND(ST_X(ST_Transform(geom,2263))::numeric,4),
    	ycoord = ROUND(ST_Y(ST_Transform(geom,2263))::numeric,4)
    WHERE
        xcoord IS NULL
        AND ycoord IS NULL
        AND geom IS NOT NULL