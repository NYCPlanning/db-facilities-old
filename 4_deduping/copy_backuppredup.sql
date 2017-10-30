DROP TABLE IF EXISTS facdb_backuppredup;

CREATE TABLE facdb_backuppredup AS (
	SELECT facilities.*
	FROM
		facilities
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);

DROP TABLE IF EXISTS facilities;

CREATE TABLE facilities AS (
	SELECT facdb_backuppredup.*
	FROM
		facdb_backuppredup
	ORDER BY
		facdomain, facgroup, facsubgrp, factype
);