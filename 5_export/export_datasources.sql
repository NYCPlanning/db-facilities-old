COPY (
	SELECT
		*
	FROM
		facilities_datasources
	ORDER BY
		datasourcefull
) TO '/Users/hannahbkates/facilities-db/facdb_datasources.csv' WITH CSV DELIMITER ',' HEADER;