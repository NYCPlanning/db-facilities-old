UPDATE facilities 
    SET 
    	latitude =
    		(CASE
	    		WHEN latitude IS NULL THEN ST_Y(geom)
	    	END),
    	longitude =
    		(CASE
	    		WHEN longitude IS NULL THEN ST_X(geom)
	    	END),
    	xcoord = 
    		(CASE
    			WHEN xcoord IS NULL THEN ROUND(ST_X(ST_Transform(geom,2263))::numeric,4)
    		END),
    	ycoord =
    		(CASE
    			WHEN ycoord IS NULL THEN ROUND(ST_Y(ST_Transform(geom,2263))::numeric,4)
    		END)
    WHERE
        geom IS NOT NULL