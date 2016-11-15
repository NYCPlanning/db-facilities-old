COPY (
	SELECT facilities.*
	FROM
		facilities,
		dcp_boroboundaries
	WHERE
		facilities.geom IS NOT NULL
		AND ST_Intersects (facilities.geom, dcp_boroboundaries.geom)
	ORDER BY
		-- domain, facilitygroup, facilitysubgroup, facilitytype
		RANDOM()
) TO '/Users/hannahbkates/Desktop/facilities_data.csv'  With CSV DELIMITER ',' HEADER;