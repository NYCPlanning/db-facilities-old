psql -U dbadmin -d capdb -f ./2_assembly/assign_uid.sql
for S in $(ls 2_assembly | grep create); do psql -U dbadmin capdb -f 2_assembly/$S; done
psql -U dbadmin -d capdb -f ./2_assembly/acs_facilities_daycareheadstart.sql
psql -U dbadmin -d capdb -f ./2_assembly/bic_facilities_tradewaste.sql
psql -U dbadmin -d capdb -f ./2_assembly/dca_facilities_operatingbusinesses.sql
psql -U dbadmin -d capdb -f ./2_assembly/dcas_facilities_colp.sql
psql -U dbadmin -d capdb -f ./2_assembly/dcla_facilities_culturalinstitutions.sql
psql -U dbadmin -d capdb -f ./2_assembly/dcp_facilities_pops.sql
psql -U dbadmin -d capdb -f ./2_assembly/dcp_facilities_sfpsd.sql
psql -U dbadmin -d capdb -f ./2_assembly/dcp_facilities_togeocode.sql