COPY (
	SELECT
		*
	FROM
		facdb_uid_key
) TO '/prod/db-facilities/output/facdb_uid_key.csv' WITH CSV DELIMITER ',' HEADER;