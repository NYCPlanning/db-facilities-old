DROP TABLE IF EXISTS facilities;
CREATE TABLE facilities (

-- PUBLISHED FIELDS

-- ids
-- guid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
hash text PRIMARY KEY,
uid text,

idagency text,
idname text,
idfield text,
pgtable text,

-- name
facname text,

-- core address information
addressnum text,
streetname text,
address text,
city text,
boro text,
borocode smallint,
zipcode text,

-- core geospatial reference information
geom geometry,
geomsource text,
processingflag text,
latitude double precision,
longitude double precision,
xcoord double precision,
ycoord double precision,
bin text,
bbl text,
commboard text,
council text,
censtract text,
nta text,

-- dcp classification
facdomain text,
facgroup text,
facsubgrp text,
factype text,

-- size
capacity text,
util text,
capacitytype text,
utilrate text,
area text,
areatype text,

-- operator, oversight, and property information
proptype text,
-- propertynycha boolean,
optype text,
opname text,
opabbrev text,
overtype text ARRAY,
overlevel text,
overagency text,
overabbrev text,

-- NON-PUBLISHED FIELDS

-- information to be tracked by the data admin
datecreated date,

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