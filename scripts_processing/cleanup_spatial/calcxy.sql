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

UPDATE facilities AS f
    SET 
        latitude = ROUND(ST_Y(ST_Transform(f.geom,4326))::numeric,6),
        longitude = ROUND(ST_X(ST_Transform(f.geom,4326))::numeric,6),
        xcoord = ROUND(ST_X(ST_Transform(f.geom,2263))::numeric,4),
        ycoord = ROUND(ST_Y(ST_Transform(f.geom,2263))::numeric,4)
    FROM dcp_boroboundaries_wi AS bb
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(f.geom, bb.geom)