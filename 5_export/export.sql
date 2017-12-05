COPY (
	SELECT
		facilities.uid,
		facilities.facname,
		facilities.addressnum,
		facilities.streetname,
		facilities.address,
		facilities.city,
		facilities.boro,
		facilities.borocode,
		facilities.zipcode,
		facilities.latitude,
		facilities.longitude,
		facilities.xcoord,
		facilities.ycoord,
		facilities.commboard,
		facilities.council,
		facilities.censtract,
		facilities.nta,
		facilities.facdomain,
		facilities.facgroup,
		facilities.facsubgrp,
		facilities.factype,
		facilities.optype,
		facilities.opname,
		facilities.opabbrev,
		facilities.geom
	FROM
		facilities,
		dcp_boroboundaries_wi
	WHERE
		facilities.geom IS NOT NULL
		AND ST_Intersects (facilities.geom, dcp_boroboundaries_wi.geom)
) TO '/prod/db-facilities/exports/facdb_facilities.csv' DELIMITER ',' CSV HEADER;