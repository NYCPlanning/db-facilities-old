COPY (
	SELECT
		*
	FROM
		hash_uid_lookup
) TO '/Users/hannahbkates/facilities-db/facdb_hash_uid_lookup.csv' WITH CSV DELIMITER ',' HEADER;