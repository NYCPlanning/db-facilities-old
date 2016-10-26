################################################################################################
## PROCESSING
################################################################################################
## This file runs all the scripts which geocode and process all the assembled data
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.


## 1. Run the geocoding script using address and borough - get BBL, BIN, lat/long
node ./scripts_processing/facilities_address2geom_borough.js

## 2. Run the geocoding script using address and zipcode - get BBL, BIN, lat/long
node ./scripts_processing/facilities_address2geom_zipcode.js

## 3. Run the geocoding script using place name (facilityname) - get BBL, BIN, lat/long
node ./scripts_processing/facilities_place2geom_nameborough.js
# ^^ Hasn't been catching anything

## 4. Run the geocoding script using place name (address) - get BBL, BIN, lat/long
node ./scripts_processing/facilities_place2geom_addressborough.js
# ^^ Hasn't been catching anything

## 3. If record could not be geocoded but came with a BBL, use BBL to get geom
##    Should only be relevant for Gazetteer/COLP records
psql $DATABASE_URL -f ./scripts_processing/facilities_bbl2geom.sql

## 4. Calculate x,y for all blank records
psql $DATABASE_URL -f ./scripts_processing/facilities_calcxy.sql

## 5. Create a spatial index for the facilities database and for MapPLUTO and VACUUM
## 	  (Reindex and vacuum after each spatial join)
psql $DATABASE_URL -f ./scripts_processing/facilities_force2D.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_setSRID.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_spatialindex.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

psql $DATABASE_URL -f ./scripts_processing/facilities_mapplutosetSRID.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_mapplutoindex.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_mapplutovacuum.sql

## 6. Do a spatial join with MapPLUTO to get BBL and addresses info if missing
psql $DATABASE_URL -f ./scripts_processing/facilities_join_bbl.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

# 10. Final formatting -- find and capitalize acronyms and abbreviations
psql $DATABASE_URL -f ./scripts_processing/facilities_fixallcaps.sql
psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

#  11. Final export that excludes null geoms and geoms outside NYC
psql $DATABASE_URL -f ./scripts_processing/facilities_export.sql



###########################################################################################
## NOT FINISHED AND/OR NOT WORKING BEYOND THIS POINT
###########################################################################################

## TO DO:
## Need to fix the script that assigns a record to its closest BBL and BIN
## Running BBL through GeoClient may no longer be necessary since info can be 
## filled in using a spatial join now that the join is faster

# # ## 5. Run the geocoding script using intersection - get BBL, BIN, lat/long
# node ./scripts_processing/facilities_intersection2geom.js
# # # ^^ Regex problems -- not working

# ## 6. Run BBLs through geoclient to get all formatted addresses and BINS for records without addresses
# node ./scripts_processing/facilities_bbl2address.js
# psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

# ## 7. For facilities which did not overlap with a BBL in MapPLUTO but should be located on a BBL lot, 
# ## 	  assign the closest BBL to the record
# psql $DATABASE_URL -f ./scripts_processing/facilities_join_bbl_closest_1.sql
# psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

# ## 8. Run (closest from step 5) BBLs through geoclient to get all formatted addresses and BINS for records without addresses
# node ./scripts_processing/facilities_bbl2address_closest.js
# psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

# ## 9. Run BBLs through geoclient to get BINs for all remaining records without BINs
# node ./scripts_processing/facilities_bbl2bin.js
# psql $DATABASE_URL -f ./scripts_processing/facilities_vacuum.sql

# ## 11. Query for duplicate records (BBLs with more than one record on the same BBL) sourced
# ## from different datasets
# psql $DATABASE_URL -f ./scripts_processing/facilities_duplicates_samesource_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/facilities_duplicates_samesource_delete.sql

# ## 12. Query for duplicate records (BBLs with more than one record on the same BBL) sourced
# ## from different datasets
# psql $DATABASE_URL -f ./scripts_processing/facilities_duplicates_diffsource_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/facilities_duplicates_diffsource_delete.sql

# ## 13. Remove records outside of NYC
# psql $DATABASE_URL -f ./scripts_processing/facilities_outsiders_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/facilities_outsiders_delete.sql

# ## 14. Copy database to a csv file


