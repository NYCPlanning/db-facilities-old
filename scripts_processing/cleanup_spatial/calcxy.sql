-- UPDATE facilities 
--     SET 
--     	latitude =
--     		(CASE
-- 	    		WHEN latitude IS NULL THEN ROUND(ST_Y(ST_Transform(geom,4326))::numeric,4)
-- 	    	END),
--     	longitude =
--     		(CASE
-- 	    		WHEN longitude IS NULL THEN ROUND(ST_X(ST_Transform(geom,4326))::numeric,4)
-- 	    	END),
--     	xcoord = 
--     		(CASE
--     			WHEN xcoord IS NULL THEN ROUND(ST_X(ST_Transform(geom,2263))::numeric,4)
--     		END),
--     	ycoord =
--     		(CASE
--     			WHEN ycoord IS NULL THEN ROUND(ST_Y(ST_Transform(geom,2263))::numeric,4)
--     		END)
--     WHERE
--         geom IS NOT NULL

UPDATE facilities 
    SET 
        latitude = ROUND(ST_Y(ST_Transform(geom,4326))::numeric,6),
        longitude = ROUND(ST_X(ST_Transform(geom,4326))::numeric,6),
        xcoord = ROUND(ST_X(ST_Transform(geom,2263))::numeric,4),
        ycoord = ROUND(ST_Y(ST_Transform(geom,2263))::numeric,4)
    WHERE
        geom IS NOT NULL