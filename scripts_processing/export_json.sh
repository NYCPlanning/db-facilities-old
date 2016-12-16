  ogr2ogr -f GeoJSON \
	test.json \
  "PG:host=localhost dbname=postgres user=postgres" \
  -sql "SELECT * FROM backup_12_12 LIMIT 10";