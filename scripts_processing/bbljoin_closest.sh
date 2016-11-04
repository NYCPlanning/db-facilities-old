# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_needbbls.sql
# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_needbbls_index.sql
# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_needbbls_vacuum.sql

# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_plutosubset.sql
# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_plutosubset_index.sql
# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_plutosubset_vacuum.sql

psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_update.sql
# psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest_temp_droptemp.sql
# psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql