psql $DATABASE_URL -f ./scripts_processing/facilities_join_bbl_closest_1_createtemp.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_join_bbl_closest_1_indextemp.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_join_bbl_closest_1_vacuumtemp.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_join_bbl_closest_1_droptemp.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql