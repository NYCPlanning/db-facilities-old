################################################################################################
## PROCESSING
################################################################################################
## This file runs all the scripts which geocode and process all the assembled data
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

## Joining on source data info
psql $DATABASE_URL -f ./scripts_processing/join_sourcedatainfo.sql

## Standardizing agency names and abbreviations
## NEED TO FINISH

## Standardizing borough and assigning borough code
psql $DATABASE_URL -f ./scripts_processing/standardize_borough.sql

## 0. Switching One to 1 for geocoding
psql $DATABASE_URL -f ./scripts_processing/One_to_1.sql

## Checking if address number is actually a number, if not, deleting text value
## NEED TO FINISH

## 1. Run the geocoding script using address and borough - get BBL, BIN, lat/long

echo 'Running geocoding script using address and borough...'
time node ./scripts_processing/address2geom_borough.js
echo 'Done geocoding using address and borough'

## 2. Run the geocoding script using address and zipcode - get BBL, BIN, lat/long

echo 'Running geocoding script using address and zip code...'
time node ./scripts_processing/address2geom_zipcode.js
echo 'Done geocoding using address and zip code'

# ## 3. Run the geocoding script using place name (facilityname) - get BBL, BIN, lat/long

# echo 'Running geocoding script using place name and borough...'
# time node ./scripts_processing/place2geom_nameborough.js
# echo 'Done geocoding using place name and borough'
# # ^^ Hasn't been catching anything

# ## 4. Run the geocoding script using place name (address) - get BBL, BIN, lat/long

# echo 'Running geocoding script using place name and zip code...'
# time node ./scripts_processing/place2geom_addressborough.js
# echo 'Done geocoding using place name and zip code'
# ## ^^ Hasn't been catching anything

# ## 3. If record could not be geocoded but came with a BBL, use BBL to get geom
# ##    Should only be relevant for Gazetteer/COLP records

echo 'Joining on geometry using BBL...'
time psql $DATABASE_URL -f ./scripts_processing/bbl2geom.sql
echo 'Done joining on geometry using BBL'

## 4. Create backup table of records with no geom or outside NYC and then delete from database


## 5. Create a spatial index for the facilities database and for MapPLUTO and VACUUM
##	  (Reindex and vacuum after each spatial join)

echo 'Indexing and vacuuming facilities and dcp_mappluto...'
psql $DATABASE_URL -f ./scripts_processing/force2D.sql
psql $DATABASE_URL -f ./scripts_processing/setSRID_26918.sql
psql $DATABASE_URL -f ./scripts_processing/vacuum.sql
echo 'Done indexing and vacuuming facilities and dcp_mappluto'

# ## 6. Do a spatial join with MapPLUTO to get BBL and addresses info if missing

echo 'Spatially joining with dcp_mappluto...'
time psql $DATABASE_URL -f ./scripts_processing/bbljoin.sql
echo 'Done spatially joining with dcp_mappluto'
psql $DATABASE_URL -f ./scripts_processing/vacuum.sql

# ## 7. For facilities which did not overlap with a BBL in MapPLUTO but should be located on a BBL lot, 
# ## 	  assign the closest BBL to the record

echo 'Spatially joining with dcp_mappluto - Finding closest...'
time psql $DATABASE_URL -f ./scripts_processing/bbljoin_closest.sql
echo 'Done spatially joining with dcp_mappluto - Found closest'
psql $DATABASE_URL -f ./scripts_processing/vacuum.sql

## 8. Convert back to 4326, calculating lat,long and x,y for all blank records, and create ID for all records at once to use for deduping

psql $DATABASE_URL -f ./scripts_processing/setSRID_4326.sql
echo 'Calculating x,y for all blank records...'
time psql $DATABASE_URL -f ./scripts_processing/calcxy.sql
echo 'Done calculating x,y for all blank records'
psql $DATABASE_URL -f ./scripts_processing/addID.sql

## Doing spatial join to fill in City
## Doing spatial join to fill in BIN

## 9. Final formatting -- find and properly capitalize acronyms and abbreviations

echo 'Cleaning up capitalization...'
time psql $DATABASE_URL -f ./scripts_processing/fixallcaps.sql
echo 'Done cleaning up capitalization'
psql $DATABASE_URL -f ./scripts_processing/vacuum.sql

## 10. Join on COLP attributes to records from other datasets

# ## Merge Child Care and Pre-K Duplicate records
# psql $DATABASE_URL -f ./scripts_processing/duplicates_ccprek_doe_acs.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates_ccprek_doe_dohmh.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates_ccprek_acs_dohmh.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates_ccprek_dohmh.sql

# ## 10. Remove DPR properties sourced from COLP that overlap with records from DPR's data
# echo 'Updating DPR records with attributes from properties that came from COLP...'
# time psql $DATABASE_URL -f ./scripts_processing/update_ParkDupsFromCOLP.sql

# echo 'Removing overlapping DPR properties that came from COLP...'
# time psql $DATABASE_URL -f ./scripts_processing/delete_ParkDupsFromCOLP.sql

# ## 11. Final export to csv that excludes null geoms and geoms outside NYC

# echo 'Exporting...'
# time psql $DATABASE_URL -f ./scripts_processing/export.sql
# echo 'All done!'



###########################################################################################
## NOT FINISHED AND/OR NOT WORKING BEYOND THIS POINT
###########################################################################################

## TO DO:
## Need to fix the script that assigns a record to its closest BBL and BIN
## Running BBL through GeoClient may no longer be necessary since info can be 
## filled in using a spatial join now that the join is faster

# # ## 5. Run the geocoding script using intersection - get BBL, BIN, lat/long
# node ./scripts_processing/intersection2geom.js
# # # ^^ Regex problems -- not working

# ## 6. Run BBLs through geoclient to get all formatted addresses and BINS for records without addresses
# node ./scripts_processing/bbl2address.js
# psql $DATABASE_URL -f ./scripts_processing/vacuum.sql

# ## 11. Query for duplicate records (BBLs with more than one record on the same BBL) sourced
# ## from different datasets
# psql $DATABASE_URL -f ./scripts_processing/duplicates_samesource_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates_samesource_delete.sql

# ## 12. Query for duplicate records (BBLs with more than one record on the same BBL) sourced
# ## from different datasets
# psql $DATABASE_URL -f ./scripts_processing/duplicates_diffsource_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/duplicates_diffsource_delete.sql

# ## 13. Remove records outside of NYC
# psql $DATABASE_URL -f ./scripts_processing/outsiders_copy.sql
# psql $DATABASE_URL -f ./scripts_processing/outsiders_delete.sql



