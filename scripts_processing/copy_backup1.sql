DROP TABLE IF EXISTS copy_backup1;

CREATE TABLE copy_backup1 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		domain, facilitygroup, facilitysubgroup, facilitytype
);