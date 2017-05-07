################################################################################################
## ASSEMBLY
################################################################################################
## NOTE: This script requires that you setup the DATABASE_URL environment variable. 
## Directions are in the README.md.

## STEP 1
## create empty master table with facilities db schema
echo 'Creating empty facilities table...'
psql $DATABASE_URL -f ./2_assembly/create.sql
echo 'Done creating empty facilities table'

## STEP 2
## configure (transform) each dataset and insert into master table
echo 'Transforming and inserting records from source data'
# psql $DATABASE_URL -f ./2_assembly/config_acs_facilities_daycareheadstart.sql
# psql $DATABASE_URL -f ./2_assembly/config_bic_facilities_tradewaste.sql
# psql $DATABASE_URL -f ./2_assembly/config_dca_facilities_operatingbusinesses.sql
# psql $DATABASE_URL -f ./2_assembly/config_dcas_facilities_colp.sql
# psql $DATABASE_URL -f ./2_assembly/config_dcla_facilities_culturalinstitutions.sql
# psql $DATABASE_URL -f ./2_assembly/config_dcp_facilities_pops.sql
# psql $DATABASE_URL -f ./2_assembly/config_dcp_facilities_sfpsd.sql
# psql $DATABASE_URL -f ./2_assembly/config_dhs_facilities_shelters.sql
# psql $DATABASE_URL -f ./2_assembly/config_dfta_facilities_contracts.sql
# psql $DATABASE_URL -f ./2_assembly/config_doe_facilities_busroutesgarages.sql
# psql $DATABASE_URL -f ./2_assembly/config_doe_facilities_universalprek.sql
# psql $DATABASE_URL -f ./2_assembly/config_doe_facilities_schoolsbluebook.sql
# psql $DATABASE_URL -f ./2_assembly/config_dohmh_facilities_daycare.sql
# psql $DATABASE_URL -f ./2_assembly/config_dot_facilities_pedplazas.sql
# psql $DATABASE_URL -f ./2_assembly/config_dot_facilities_bridgehouses.sql
# psql $DATABASE_URL -f ./2_assembly/config_dot_facilities_ferryterminalslandings.sql
# psql $DATABASE_URL -f ./2_assembly/config_dot_facilities_mannedfacilities.sql
# psql $DATABASE_URL -f ./2_assembly/config_dot_facilities_parkingfacilities.sql
# psql $DATABASE_URL -f ./2_assembly/config_dpr_facilities_parksproperties.sql
# psql $DATABASE_URL -f ./2_assembly/config_dsny_facilities_mtsgaragemaintenance.sql
# psql $DATABASE_URL -f ./2_assembly/config_dycd_facilities_compass.sql
# psql $DATABASE_URL -f ./2_assembly/config_dycd_facilities_otherprograms.sql
# psql $DATABASE_URL -f ./2_assembly/config_foodbankny_facilities_foodbanks.sql
# psql $DATABASE_URL -f ./2_assembly/config_hhs_facilities_financialscontracts.sql
# psql $DATABASE_URL -f ./2_assembly/config_hhs_facilities_fmscontracts.sql
# psql $DATABASE_URL -f ./2_assembly/config_hhs_facilities_proposals.sql
# psql $DATABASE_URL -f ./2_assembly/config_hra_facilities_centers.sql
# psql $DATABASE_URL -f ./2_assembly/config_nycha_facilities_policeservice.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysoasas_facilities_programs.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysdec_facilities_lands.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysdec_facilities_solidwaste.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysdoh_facilities_healthfacilities_joinnursingbeds.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysed_facilities_activeinstitutions.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysomh_facilities_mentalhealth.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysopwdd_facilities_providers.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysparks_facilities_historicplaces.sql
# psql $DATABASE_URL -f ./2_assembly/config_nysparks_facilities_parks.sql
# psql $DATABASE_URL -f ./2_assembly/config_omb_facilities_libraryvisits.sql
# psql $DATABASE_URL -f ./2_assembly/config_sbs_facilities_workforce1.sql
# psql $DATABASE_URL -f ./2_assembly/config_usdot_facilities_airports.sql
# psql $DATABASE_URL -f ./2_assembly/config_usdot_facilities_ports.sql
# psql $DATABASE_URL -f ./2_assembly/config_usnps_facilities_parks.sql
psql $DATABASE_URL -f ./2_assembly/config_facilities_togeocode.sql
echo 'Done transforming and inserting records from source data'

## STEP 3 
## Joining on source data info and standardizing capitalization
psql $DATABASE_URL -f ./2_assembly/join_sourcedatainfo.sql
echo 'Cleaning up capitalization, standardizing values, and adding agency tags in arrays...'
psql $DATABASE_URL -f ./2_assembly/standardize_fixallcaps.sql
psql $DATABASE_URL -f ./2_assembly/standardize_capacity.sql
psql $DATABASE_URL -f ./2_assembly/standardize_oversightlevel.sql
# psql $DATABASE_URL -f ./2_assembly/undo_agencytags.sql
psql $DATABASE_URL -f ./2_assembly/standardize_agencytag.sql
psql $DATABASE_URL -f ./2_assembly/standardize_trim.sql
psql $DATABASE_URL -f ./2_assembly/standardize_factypes.sql
## Standardizing borough and assigning borough code
psql $DATABASE_URL -f ./2_assembly/standardize_borough.sql
## Switching One to 1 for geocoding and removing invalid (string) address numbers
psql $DATABASE_URL -f ./2_assembly/standardize_address.sql

## STEP 4
## Fill in the uid for all new records in the database
echo 'Filling in / creating uid...'
psql $DATABASE_URL -f ./2_assembly/create_uid.sql