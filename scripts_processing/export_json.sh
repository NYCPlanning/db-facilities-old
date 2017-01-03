  ogr2ogr -f GeoJSON \
	facilities_data_newschema.json \
  "PG:host=localhost dbname=postgres user=postgres" \
  -sql "SELECT facilities.geom, guid, idagency, facilityname, address, bbl, domain, facilitygroup, facilitysubgroup, facilitytype, agencysource, sourcedatasetname, datesourceupdated, oversightagency, oversightabbrev, operatorname, operatorabbrev, operatortype FROM facilities, dcp_boroboundaries WHERE facilities.geom IS NOT NULL AND ST_Intersects (facilities.geom, dcp_boroboundaries.geom) ORDER BY RANDOM()";