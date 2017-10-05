################################################################################################
## ASSEMBLY
################################################################################################
## NOTE: This script requires that you setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

DBNAME=$(cat facdb.config.json| jq -r '.DBNAME')
DBUSER=$(cat facdb.config.json | jq -r '.DBUSER')

## STEP 1
## create empty master table with facilities db schema
echo 'Creating empty facilities table...'
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/create.sql
echo 'Done creating empty facilities table'

## STEP 2
## configure (transform) each dataset and insert into master table
echo 'Transforming and inserting records from source data'
psql -U $DBUSER -d $DBNAME -f ./2_assembly/insert/acs_facilities_daycareheadstart.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_bic_facilities_tradewaste.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dca_facilities_operatingbusinesses.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dcas_facilities_colp.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dcla_facilities_culturalinstitutions.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dcp_facilities_pops.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dcp_facilities_sfpsd.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dcp_facilities_togeocode.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dhs_facilities_shelters.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dfta_facilities_contracts.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_doe_facilities_busroutesgarages.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_doe_facilities_universalprek.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_doe_facilities_schoolsbluebook.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dohmh_facilities_daycare.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dot_facilities_pedplazas.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dot_facilities_bridgehouses.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dot_facilities_ferryterminalslandings.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dot_facilities_mannedfacilities.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dot_facilities_parkingfacilities.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dpr_parksproperties.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dsny_facilities_mtsgaragemaintenance.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dycd_facilities_compass.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_dycd_facilities_otherprograms.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_foodbankny_facilities_foodbanks.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_hhs_facilities_financialscontracts.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_hhs_facilities_fmscontracts.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_hhs_facilities_proposals.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_hra_facilities_centers.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nycha_facilities_policeservice.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysoasas_facilities_programs.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysdec_facilities_lands.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysdec_facilities_solidwaste.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysdoh_facilities_healthfacilities.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysed_facilities_activeinstitutions.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysomh_facilities_mentalhealth.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysopwdd_facilities_providers.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysparks_facilities_historicplaces.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_nysparks_facilities_parks.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_omb_facilities_libraryvisits.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_sbs_facilities_workforce1.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_usdot_facilities_airports.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_usdot_facilities_ports.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/config_usnps_facilities_parks.sql
echo 'Done transforming and inserting records from source data'

## STEP 3 
## Joining on source data info and standardizing capitalization
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/join_sourcedatainfo.sql
echo 'Cleaning up capitalization, standardizing values, and adding agency tags in arrays...'
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_fixallcaps.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_capacity.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_oversightlevel.sql
# psql -U $DBUSER -d $DBNAME -f ./2_assembly/undo_agencytags.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_agencytag.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_trim.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_factypes.sql
## Standardizing borough and assigning borough code
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_borough.sql
## Switching One to 1 for geocoding and removing invalid (string) address numbers
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_address.sql
## Assigning a group and domain to each facility type
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_group.sql
psql -U $DBUSER -d $DBNAME -f ./2_assembly/standardize/standardize_domain.sql

## STEP 4
## Fill in the uid for all new records in the database
echo 'Filling in / creating uid...'
psql -U $DBUSER -d $DBNAME -f ./2_assembly/create/create_uid.sql
