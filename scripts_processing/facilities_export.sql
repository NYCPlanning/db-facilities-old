COPY (
	SELECT facilities.*
	FROM
		facilities,
		dcp_boroboundaries
	WHERE
		facilities.geom IS NOT NULL
		AND ST_Intersects (facilities.geom, dcp_boroboundaries.geom)
) TO '/Users/hannahbkates/Desktop/20160930_facilitiesdraft.csv'  With CSV DELIMITER ',' HEADER;