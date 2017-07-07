################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires that you setup the DATABASE_URL environment variable.
### Directions are in the README.md.

## Load all datasets from sources using civic data loader
## https://github.com/NYCPlanning/data-loading-scripts

cd '/prod/data-loading-scripts'
pwd

## Open_datasets - PULLING FROM OPEN DATA

echo 'Loading open source datasets...'
	## Data you probably already have loaded
psql -d facdb -U dbadmin -f datasets/dcp_mappluto/after.sql
psql -d facdb -U dbadmin -f datasets/doitt_buildingfootprints/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_boroboundaries_wi/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_cdboundaries/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_censustracts/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_councildistricts/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_ntaboundaries/after.sql
psql -d facdb -U dbadmin -f datasets/doitt_zipcodes/after.sql

	## Data you probably don't have loaded
psql -d facdb -U dbadmin -f datasets/bic_facilities_tradewaste/after.sql
psql -d facdb -U dbadmin -f datasets/dca_facilities_operatingbusinesses/after.sql
psql -d facdb -U dbadmin -f datasets/dcla_facilities_culturalinstitutions/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_facilities_sfpsd/after.sql
psql -d facdb -U dbadmin -f datasets/dcp_facilities_pops/after.sql
psql -d facdb -U dbadmin -f datasets/dfta_facilities_contracts/after.sql
psql -d facdb -U dbadmin -f datasets/doe_facilities_busroutesgarages/after.sql
psql -d facdb -U dbadmin -f datasets/doe_facilities_universalprek/after.sql
psql -d facdb -U dbadmin -f datasets/dohmh_facilities_daycare/after.sql
psql -d facdb -U dbadmin -f datasets/dpr_parksproperties/after.sql
psql -d facdb -U dbadmin -f datasets/hhc_facilities_hospitals/after.sql
psql -d facdb -U dbadmin -f datasets/nycha_facilities_policeservice/after.sql
psql -d facdb -U dbadmin -f datasets/nysdec_facilities_lands/after.sql
psql -d facdb -U dbadmin -f datasets/nysdec_facilities_solidwaste/after.sql
psql -d facdb -U dbadmin -f datasets/nysdoh_facilities_healthfacilities/after.sql
psql -d facdb -U dbadmin -f datasets/nysdoh_nursinghomebedcensus/after.sql
psql -d facdb -U dbadmin -f datasets/nysomh_facilities_mentalhealth/after.sql
psql -d facdb -U dbadmin -f datasets/nysopwdd_facilities_providers/after.sql
psql -d facdb -U dbadmin -f datasets/nysparks_facilities_historicplaces/after.sql
psql -d facdb -U dbadmin -f datasets/nysparks_facilities_parks/after.sql
psql -d facdb -U dbadmin -f datasets/usdot_facilities_airports/after.sql
psql -d facdb -U dbadmin -f datasets/usdot_facilities_ports/after.sql
psql -d facdb -U dbadmin -f datasets/usnps_facilities_parks/after.sql

echo 'Done loading open source datasets. Moving on to "other" datasets...'
	## Other_datasets - PULLING FROM FTP SITE
psql -d facdb -U dbadmin -f datasets/acs_facilities_daycareheadstart/after.sql
psql -d facdb -U dbadmin -f datasets/dcas_facilities_colp/after.sql
psql -d facdb -U dbadmin -f datasets/dhs_facilities_shelters/after.sql
psql -d facdb -U dbadmin -f datasets/doe_facilities_schoolsbluebook/after.sql
psql -d facdb -U dbadmin -f datasets/dot_facilities_pedplazas/after.sql
psql -d facdb -U dbadmin -f datasets/dot_facilities_publicparking ## Kind of open, need to see if url can be worked out/after.sql
psql -d facdb -U dbadmin -f datasets/dot_facilities_parkingfacilities/after.sql
psql -d facdb -U dbadmin -f datasets/dot_facilities_bridgehouses/after.sql
psql -d facdb -U dbadmin -f datasets/dot_facilities_ferryterminalslandings/after.sql
psql -d facdb -U dbadmin -f datasets/dot_facilities_mannedfacilities/after.sql
psql -d facdb -U dbadmin -f datasets/dsny_facilities_mtsgaragemaintenance/after.sql
	# node loader.js $action facilities_togeocode ## Addresses copied and pasted from websites
psql -d facdb -U dbadmin -f datasets/facdb_datasources/after.sql
psql -d facdb -U dbadmin -f datasets/foodbankny_facilities_foodbanks/after.sql
psql -d facdb -U dbadmin -f datasets/hhs_facilities_fmscontracts/after.sql
psql -d facdb -U dbadmin -f datasets/hhs_facilities_financialscontracts/after.sql
psql -d facdb -U dbadmin -f datasets/hhs_facilities_proposals/after.sql
psql -d facdb -U dbadmin -f datasets/nysoasas_facilities_programs ## Being shared with us monthly by email in xlsx/after.sql
psql -d facdb -U dbadmin -f datasets/nysed_facilities_activeinstitutions ## Actually is open but need to figue out url/after.sql
psql -d facdb -U dbadmin -f datasets/nysed_nonpublicenrollment ## Actually is open but in xlsx that needs to be formatted/after.sql
psql -d facdb -U dbadmin -f datasets/omb_facilities_libraryvisits/after.sql
psql -d facdb -U dbadmin -f datasets/dycd_facilities_compass/after.sql
psql -d facdb -U dbadmin -f datasets/dycd_facilities_otherprograms/after.sql
psql -d facdb -U dbadmin -f datasets/hra_facilities_centers/after.sql
psql -d facdb -U dbadmin -f datasets/sbs_facilities_workforce1/after.sql

echo 'Done loading other source datasets'
cd '../facilities-db'
