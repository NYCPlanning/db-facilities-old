DROP TABLE IF EXISTS copy_backup4;

CREATE TABLE copy_backup4 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		domain, facilitygroup, facilitysubgroup, facilitytype
);