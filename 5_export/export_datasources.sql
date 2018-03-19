COPY (
	SELECT
		*
	FROM
		facdb_datasources
	ORDER BY
		datasourcefull
) TO '/prod/db-facilities/output/facdb_datasources.csv' WITH CSV DELIMITER ',' HEADER;