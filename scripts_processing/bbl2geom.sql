UPDATE facilities AS f
    SET
        geom = ST_Centroid(p.geom),
        processingflag = 
        	(CASE
	        	WHEN processingflag IS NULL THEN 'bbl2geom'
	        	ELSE CONCAT(processingflag, '_bbl2geom')
        	END)
    FROM
        dcp_mappluto AS p
    WHERE
        f.bbl = ARRAY[ROUND(p.bbl,0)::text]
        AND f.bbl IS NOT NULL
        AND f.geom IS NULL
