DROP TABLE IF EXISTS facdb_backuppredup;

CREATE TABLE facdb_backuppredup AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);