################################################################################################
## GEOPROCESSING
################################################################################################
## NOTE: This script requires that your setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

## GEOCLIENT - DIDN'T COME WITH A GEOMETRY

## Run the geocoding script using address and borough - get BBL, BIN, lat/long
echo 'Running geocoding script using address and borough...'
time node ./3_geoprocessing/geoclient/address2geom_borough.js
echo 'Done geocoding using address and borough'

## Run the geocoding script using address and zipcode - get BBL, BIN, lat/long
echo 'Running geocoding script using address and zip code...'
time node ./3_geoprocessing/geoclient/address2geom_zipcode.js
echo 'Done geocoding using address and zip code'

## GEOCLIENT - CAME WITH A GEOMETRY

## Prep - Do spatial join with borough for remaining records with geoms that have blanks
echo 'Forcing 2D...'
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup_spatial/force2D.sql
echo 'Forced 2D complete'
echo 'Spatial join with boroughs'
time psql $DATABASE_URL -f ./3_geoprocessing/joins/boroughjoin.sql
## ^ added this step because a lot of zipcode Geoclient searches weren't finding results

# Run the geocoding script using address get BBL and BIN and standardize address
echo 'Running geocoding script getting BBL using address and borough...'
time node ./3_geoprocessing/geoclient/address2bbl_borough.js
echo 'Done getting BBL using address and borough'

echo 'Running geocoding script getting BBL using address and zipcode...'
time node ./3_geoprocessing/geoclient/address2bbl_zipcode.js
echo 'Done getting BBL using address and zipcode'
# ^^ Hasn't been catching anything

## Standardizing borough and assigning borough code again because
## Geoclient sometimes fills in Staten Is instead of Staten Island
time psql $DATABASE_URL -f ./3_geoprocessing/joins/boroughjoin.sql
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup/removeinvalidBIN.sql

time psql $DATABASE_URL -f ./3_geoprocessing/backup/copy_backup1.sql

## FILLING IN MISSING ADDRESS INFO FROM PLUTO USING BBL WHEN GEOM EXISTS

echo 'Joining missing address info using BBL...'
time psql $DATABASE_URL -f ./3_geoprocessing/bbl2address.sql

## SPATIAL JOINS WITH PLUTO TO GET BBL AND OTHER MISSING INFO

## Create a spatial index for the facilities database and for MapPLUTO and VACUUM

echo 'Indexing and vacuuming facilities and dcp_mappluto...'
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup_spatial/setSRID_4326.sql
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup_spatial/vacuum.sql
echo 'Done indexing and vacuuming facilities and dcp_mappluto'

## Do a spatial join with MapPLUTO to get BBL and address info if missing

echo 'Spatially joining with dcp_mappluto...'
time psql $DATABASE_URL -f ./3_geoprocessing/bbljoin.sql
echo 'Done spatially joining with dcp_mappluto'
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup_spatial/vacuum.sql
time psql $DATABASE_URL -f ./2_assembly/standardize_address.sql
# ^ need to clean up addresses again after filling in with PLUTO address

## FILLING IN REMAINING MISSING BINS

echo 'Filling in missing BINS where there is a 1-1 relationship between BBL and BIN...'
time psql $DATABASE_URL -f ./3_geoprocessing/bbl2bin.sql

echo 'Creating a backup copy before overwriting any geometries...'
time psql $DATABASE_URL -f ./3_geoprocessing/backup/copy_backup2.sql

# ## TABULAR JOINS WITH BUILDINGFOOTPRINTS AND PLUTO TO OVERWRITE GEOMS WITH CENTROID

echo 'Overwriting geometry using BIN centroid...'
time psql $DATABASE_URL -f ./3_geoprocessing/bin2overwritegeom.sql
echo 'Done overwriting geometry using BIN centroid'

echo 'Overwriting geometry using BBL centroid...'
time psql $DATABASE_URL -f ./3_geoprocessing/bbl2overwritegeom.sql
echo 'Done overwriting geometry using BBL centroid'

## Calculating lat,long and x,y for all blank records
echo 'Calculating x,y for all blank records...'
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup_spatial/calcxy.sql
echo 'Done calculating x,y for all blank records'

echo 'Spatially joining with neighborhood boundaries...'
time psql $DATABASE_URL -f ./3_geoprocessing/joins/cdjoin.sql
time psql $DATABASE_URL -f ./3_geoprocessing/joins/ntajoin.sql
time psql $DATABASE_URL -f ./3_geoprocessing/joins/zipcodejoin.sql
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup/removeinvalidZIP.sql
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup/cleanup_cityboro.sql
time psql $DATABASE_URL -f ./3_geoprocessing/joins/counciljoin.sql
time psql $DATABASE_URL -f ./3_geoprocessing/joins/tractjoin.sql
echo 'Spatially joining with COLP bbls to get propertytype...'
time psql $DATABASE_URL -f ./3_geoprocessing/joins/propertytypejoin.sql
## ^ In FacDB V1.5, will add conditional logic for type of facility
echo 'Setting propertytype for street plazas...'
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup/plazas.sql
time psql $DATABASE_URL -f ./3_geoprocessing/cleanup_spatial/vacuum.sql

## Create backup table before merging and dropping duplicates
echo 'Creating backup before merging and dropping duplicates...'
time psql $DATABASE_URL -f ./3_geoprocessing/backup/copy_backup3.sql