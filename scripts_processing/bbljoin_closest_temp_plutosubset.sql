CREATE TABLE temp_plutosubset AS (
	SELECT
	    dcp_mappluto.*
	FROM
	    dcp_mappluto,
	    temp_needbbls
	WHERE
	    ST_DWithin(temp_needbbls.geom::geography, dcp_mappluto.geom::geography, 100)
	)