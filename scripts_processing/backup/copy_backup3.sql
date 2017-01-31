DROP TABLE IF EXISTS copy_backup3;

CREATE TABLE copy_backup3 AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		domain, facilitygroup, facilitysubgroup, facilitytype
);