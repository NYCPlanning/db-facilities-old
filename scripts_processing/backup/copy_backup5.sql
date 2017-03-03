DROP TABLE IF EXISTS copy_backup5;

CREATE TABLE copy_backup5 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		domain, facilitygroup, facilitysubgroup, facilitytype
);