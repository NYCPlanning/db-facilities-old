COPY (
	SELECT
		*
	FROM
		facilities_uid_key
) TO '/Users/hannahbkates/facilities-db/facilities_uid_key.csv' WITH CSV DELIMITER ',' HEADER;