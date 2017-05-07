COPY (
	SELECT
		*
	FROM
		facdb_uid_key
) TO '/Users/hannahbkates/facilities-db/tables/facdb_uid_key.csv' WITH CSV DELIMITER ',' HEADER;