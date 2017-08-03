################################################################################################
## ASSEMBLY
################################################################################################
## NOTE: This script requires that you setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat config.json | jq -r '.DBNAME')
DBUSER=$(cat config.json | jq -r '.DBUSER')

## STEP 1
## create empty master table with facilities db schema
echo 'Creating empty facilities table...'
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/create.sql
##echo 'Done creating empty facilities table'


## create facilities table and relational tables
for S in $(ls 2_assembly | grep create); do psql -U dbadmin capdb -f 2_assembly/$S; done
psql -U $DBUSER -d $DBNAME -f ./2_assembly/assign_uid.sql


## STEP 2
## configure (transform) each dataset and insert into master table
echo 'Transforming and inserting records from source data'
psql -U $DBUSER -d $DBNAME -f ./2_assembly/acs_facilities_daycareheadstart.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/bic_facilities_tradewaste.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dca_facilities_operatingbusinesses.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dcas_facilities_colp.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dcla_facilities_culturalinstitutions.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dcp_facilities_pops.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dcp_facilities_sfpsd.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dcp_facilities_togeocode.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dhs_facilities_shelters.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dfta_facilities_contracts.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/doe_facilities_busroutesgarages.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/doe_facilities_universalprek.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/doe_facilities_schoolsbluebook.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dohmh_facilities_daycare.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dot_facilities_pedplazas.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dot_facilities_bridgehouses.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dot_facilities_ferryterminalslandings.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dot_facilities_mannedfacilities.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dot_facilities_parkingfacilities.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dpr_parksproperties.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dsny_facilities_mtsgaragemaintenance.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dycd_facilities_compass.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/dycd_facilities_otherprograms.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/foodbankny_facilities_foodbanks.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/hhs_facilities_financialscontracts.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/hhs_facilities_fmscontracts.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/hhs_facilities_proposals.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/hra_facilities_centers.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nycha_facilities_policeservice.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysoasas_facilities_programs.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysdec_facilities_lands.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysdec_facilities_solidwaste.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysdoh_facilities_healthfacilities.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysed_facilities_activeinstitutions.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysomh_facilities_mentalhealth.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysopwdd_facilities_providers.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysparks_facilities_historicplaces.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/nysparks_facilities_parks.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/omb_facilities_libraryvisits.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/sbs_facilities_workforce1.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/usdot_facilities_airports.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/usdot_facilities_ports.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/usnps_facilities_parks.sql
##echo 'Done transforming and inserting records from source data'
##
#### STEP 3 
#### Joining on source data info and standardizing capitalization
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/join_sourcedatainfo.sql
##echo 'Cleaning up capitalization, standardizing values, and adding agency tags in arrays...'
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_fixallcaps.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_capacity.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_oversightlevel.sql
### psql -U $DBUSER -d $DBNAME -f ./2_assembly/undo_agencytags.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_agencytag.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_trim.sql
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_factypes.sql
#### Standardizing borough and assigning borough code
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_borough.sql
#### Switching One to 1 for geocoding and removing invalid (string) address numbers
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize_address.sql
##
#### STEP 4
#### Fill in the uid for all new records in the database
##echo 'Filling in / creating uid...'
##psql -U $DBUSER -d $DBNAME -f ./2_assembly/create_uid.sql
##
