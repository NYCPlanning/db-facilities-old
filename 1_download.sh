################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires that you setup the DATABASE_URL environment variable.
### Directions are in the README.md.

## Load all datasets from sources using civic data loader
## https://github.com/NYCPlanning/data-loading-scripts

cd 'prod/data-loading-scripts'
pwd

## Open_datasets - PULLING FROM OPEN DATA

for action in get push after
do 

	echo 'Loading open source datasets...'
	## Data you probably already have loaded
	node loader.js $action dcp_mappluto
	node loader.js $action doitt_buildingfootprints
	node loader.js $action dcp_boroboundaries_wi
	node loader.js $action dcp_cdboundaries
	node loader.js $action dcp_censustracts
	node loader.js $action dcp_councildistricts
	node loader.js $action dcp_ntaboundaries
	node loader.js $action doitt_zipcodes

	## Data you probably don't have loaded
	node loader.js $action bic_facilities_tradewaste
	node loader.js $action dca_facilities_operatingbusinesses
	node loader.js $action dcla_facilities_culturalinstitutions
	node loader.js $action dcp_facilities_sfpsd
	node loader.js $action dcp_facilities_pops
	node loader.js $action dfta_facilities_contracts
	node loader.js $action doe_facilities_busroutesgarages
	node loader.js $action doe_facilities_universalprek
	node loader.js $action dohmh_facilities_daycare
	node loader.js $action dpr_parksproperties
	node loader.js $action hhc_facilities_hospitals
	node loader.js $action nycha_facilities_policeservice
	node loader.js $action nysdec_facilities_lands
	node loader.js $action nysdec_facilities_solidwaste
	node loader.js $action nysdoh_facilities_healthfacilities
	node loader.js $action nysdoh_nursinghomebedcensus
	node loader.js $action nysomh_facilities_mentalhealth
	node loader.js $action nysopwdd_facilities_providers
	node loader.js $action nysparks_facilities_historicplaces
	node loader.js $action nysparks_facilities_parks
	node loader.js $action usdot_facilities_airports
	node loader.js $action usdot_facilities_ports
	node loader.js $action usnps_facilities_parks

	echo 'Done loading open source datasets. Moving on to "other" datasets...'
	## Other_datasets - PULLING FROM FTP SITE
	node loader.js $action acs_facilities_daycareheadstart
	node loader.js $action dcas_facilities_colp
	node loader.js $action dhs_facilities_shelters
	node loader.js $action doe_facilities_schoolsbluebook
	node loader.js $action dot_facilities_pedplazas
	node loader.js $action dot_facilities_publicparking ## Kind of open, need to see if url can be worked out
	node loader.js $action dot_facilities_parkingfacilities
	node loader.js $action dot_facilities_bridgehouses
	node loader.js $action dot_facilities_ferryterminalslandings
	node loader.js $action dot_facilities_mannedfacilities
	node loader.js $action dsny_facilities_mtsgaragemaintenance
	# node loader.js $action facilities_togeocode ## Addresses copied and pasted from websites
	node loader.js $action facdb_datasources
	node loader.js $action foodbankny_facilities_foodbanks
	node loader.js $action hhs_facilities_fmscontracts
	node loader.js $action hhs_facilities_financialscontracts
	node loader.js $action hhs_facilities_proposals
	node loader.js $action nysoasas_facilities_programs ## Being shared with us monthly by email in xlsx
	node loader.js $action nysed_facilities_activeinstitutions ## Actually is open but need to figue out url
	node loader.js $action nysed_nonpublicenrollment ## Actually is open but in xlsx that needs to be formatted
	node loader.js $action omb_facilities_libraryvisits
	node loader.js $action dycd_facilities_compass
	node loader.js $action dycd_facilities_otherprograms
	node loader.js $action hra_facilities_centers
	node loader.js $action sbs_facilities_workforce1

done
echo 'Done loading other source datasets'
cd '../facilities-db'