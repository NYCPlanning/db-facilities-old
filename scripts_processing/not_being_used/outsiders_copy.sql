CREATE TABLE backup_outsiders AS (
SELECT facilities.*
FROM facilities, dcp_boroboundaries
WHERE
	geom IS NULL
	or ST_Disjoint(facilities.geom, dcp_boroboundaries.geom))