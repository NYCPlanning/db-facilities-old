DROP TABLE IF EXISTS facilities;
CREATE TABLE facilities (

-- PUBLISHED FIELDS

-- ids
-- guid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
hash text,
uid text,
idold text,
idagency text ARRAY,
-- name
facilityname text,
-- core address information
addressnumber text,
streetname text,
address text,
city text,
borough text,
boroughcode smallint,
zipcode integer,
-- core geospatial reference information
geom geometry,
latitude double precision,
longitude double precision,
xcoord double precision,
ycoord double precision,
bin text ARRAY,
bbl text ARRAY,
communityboard text,
councildistrict text,
censustract text,
nta text,
-- dcp classification
domain text,
facilitygroup text,
facilitysubgroup text,
facilitytype text,
-- size
capacity text ARRAY,
utilization text ARRAY,
capacitytype text ARRAY,
utilizationrate text ARRAY,
area text ARRAY,
areatype text ARRAY,
-- servicearea text,
-- operator, oversight, and property information
propertytype text,
-- propertynycha boolean,
operatortype text,
operatorname text,
operatorabbrev text,
oversighttype text ARRAY,
oversightlevel text ARRAY,
oversightagency text ARRAY,
oversightabbrev text ARRAY,
-- published data source details
agencysource text ARRAY,
sourcedatasetname text ARRAY,
linkdata text ARRAY,
datesourceupdated text ARRAY,
processingflag text,

-- NON-PUBLISHED FIELDS

-- agency classification
agencyclass1 text,
agencyclass2 text,
colpusetype text,
-- information on when the facility opened/closed and tags classifing the facility
dateactive date,
dateinactive date,
inactivestatus boolean,
tags text ARRAY,
-- information to be tracked by the data admin
notes text,
datesourcereceived text ARRAY,
datecreated date,
dateedited date,
creator text,
editor text,
linkdownload text ARRAY,
datatype text ARRAY,
refreshmeans text ARRAY,
refreshfrequency text ARRAY,
pgtable text ARRAY,
-- details on duplicate records merged into the primary record
uid_merged text ARRAY,
hash_merged text ARRAY,
idagency_merged text ARRAY,
-- administrative location information
-- admin_addressnumber text,
-- admin_streetname text,
-- admin_address text,
-- admin_borough text,
-- admin_boroughcode smallint,
-- admin_zipcode integer,
-- attributes specific to schools
buildingid text,
buildingname text,
schoolorganizationlevel text,
-- served populations
children boolean,
youth boolean,
senior boolean,
family boolean,
disabilities boolean,
dropouts boolean,
unemployed boolean,
homeless boolean,
immigrants boolean,
-- miscellaneous
groupquarters boolean
)