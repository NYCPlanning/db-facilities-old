DROP TABLE IF EXISTS facilities;
CREATE TABLE facilities (

-- PUBLISHED FIELDS

-- ids
hash text PRIMARY KEY,
uid text,

-- name
facname text,
-- core address information
addressnum text,
streetname text,
address text,
city text,
boro text,
borocode smallint,
zipcode integer,
-- core geospatial reference information
geom geometry,
geomsource text,
latitude double precision,
longitude double precision,
xcoord double precision,
ycoord double precision,
commboard text,
council text,
censtract text,
nta text,
-- dcp classification
facdomain text,
facgroup text,
facsubgrp text,
factype text,
-- operator, oversight, and property information
proptype text,
-- propertynycha boolean,
optype text,
opname text,
opabbrev text,

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
