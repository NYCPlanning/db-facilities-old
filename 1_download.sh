################################################################################################
### OBTAINING DATA
################################################################################################
### NOTE: This script requires that you setup the DATABASE_URL environment variable. 
### Directions are in the README.md.

## Load all datasets from sources using civic data loader
## https://github.com/NYCPlanning/civic-data-loader

cd '/Users/hannahbkates/Sites/repos/data-loading-scripts'

## Open_datasets - PULLING FROM OPEN DATA
echo 'Loading open source datasets...'
## Data you probably already have loaded
node loader.js install dcp_mappluto
node loader.js install doitt_buildingfootprints
node loader.js install dpr_parksproperties
## Data you probably don't have loaded
node loader.js install bic_facilities_tradewaste
node loader.js install dca_facilities_operatingbusinesses
node loader.js install dcla_facilities_culturalinstitutions
node loader.js install dcp_facilities_sfpsd
node loader.js install dhs_facilities_shelters
node loader.js install dfta_facilities_contracts
node loader.js install doe_facilities_busroutesgarages
node loader.js install doe_facilities_universalprek
node loader.js install dohmh_facilities_daycare
node loader.js install hhc_facilities_hospitals
node loader.js install nycha_facilities_policeservice
node loader.js install nysdec_facilities_lands
node loader.js install nysdec_facilities_solidwaste
node loader.js install nysdoh_facilities_healthfacilities
node loader.js install nysdoh_nursinghomebedcensus
node loader.js install nysomh_facilities_mentalhealth
node loader.js install nysopwdd_facilities_providers
node loader.js install nysparks_facilities_historicplaces
node loader.js install nysparks_facilities_parks
node loader.js install usdot_facilities_airports
node loader.js install usdot_facilities_ports
node loader.js install usnps_facilities_parks
echo 'Done loading open source datasets. Moving on to "other" datasets...'

## Other_datasets - PULLING FROM FTP SITE
node loader.js install acs_facilities_daycareheadstart
node loader.js install dcas_facilities_colp
node loader.js install doe_facilities_schoolsbluebook
node loader.js install dot_facilities_pedplazas
node loader.js install dot_facilities_publicparking ## Kind of open, need to see if url can be worked out
node loader.js install dsny_facilities_mtsgaragemaintenance
node loader.js install facilities_togeocode ## Addresses copied and pasted from websites
node loader.js install foodbankny_facilities_foodbanks
node loader.js install hhs_facilities_acceleratorall ## Will be open but isn't yet
node loader.js install nysoasas_facilities_programs ## Being shared with us monthly by email in xlsx
node loader.js install nysed_facilities_activeinstitutions ## Actually is open but need to figue out url
node loader.js install nysed_nonpublicenrollment ## Actually is open but in xlsx that needs to be formatted
node loader.js install omb_facilities_libraryvisits
echo 'Done loading other source datasets'

cd '/Users/hannahbkates/facilities-db'