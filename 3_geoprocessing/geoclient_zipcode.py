import pandas as pd
import subprocess
import os
import sqlalchemy as sql
import json
from nyc_geoclient import Geoclient

# make sure we are at the top of the repo
wd = subprocess.check_output('git rev-parse --show-toplevel', shell = True)
os.chdir(wd[:-1]) #-1 removes \n

# load config file
with open('config.json') as conf:
    config = json.load(conf)

DBNAME = config['DBNAME']
DBUSER = config['DBUSER']
app_id = config['GEOCLIENT_APP_ID']
app_key = config['GEOCLIENT_APP_KEY']

# connect to postgres db
engine = sql.create_engine('postgresql://{}@localhost:5432/{}'.format(DBUSER, DBNAME))


# read in dcp_cpdb_agencyverified table
facdb_geocodezip = pd.read_sql_query('SELECT * FROM facilities WHERE addressnum IS NOT NULL AND streetname IS NOT NULL AND zipcode IS NOT NULL AND processingflag IS NULL;', engine)

# get the geo data

g = Geoclient(app_id, app_key)

def get_loc(num, street, zip):
    geo = g.address(num, street, zip)
    try:
        b_in = geo['buildingIdentificationNumber']
    except:
        b_in = 'none'
    try:
        lat = geo['latitude']
    except:
        lat = 'none'
    try:
        lon = geo['longitude']
    except:
        lon = 'none'
    try:
        xcoord = geo['xCoordinate']
    except:
        xcoord = 'none'
    try:
        ycoord = geo['yCoordinate']
    except:
        ycoord = 'none'
    try:
        bbl = geo['bbl']
    except:
        bbl = 'none'
    try:
        borocode = geo['bblBoroughCode']
    except:
        borocode = 'none'
    try:
        boro = geo['firstBoroughName']
    except:
        boro = 'none'
    try:
        zipcode = geo['zipCode']
    except:
        zipcode = 'none'
    try:
        city = geo['uspsPreferredCityName']
    except:
        city = 'none'
    try:
        newaddressnum = geo['houseNumber']
    except:
        newaddressnum = 'none'
    try:
        newstreetname = geo['boePreferredStreetName']
    except:
        newstreetname = 'none'


    loc = pd.DataFrame({'bin' : [b_in],
                        'lat' : [lat],
                        'lon' : [lon],
                        'xcoord' : [xcoord],
                        'ycoord' : [ycoord],
                        'bbl' : [bbl],
                        'borocode' : [borocode],
                        'boro' : [boro],
                        'zipcode' : [zipcode],
                        'city' : [city],
                        'newaddressnum' : [newaddressnum],
                        'newstreetname' : [newstreetname]},)
    return(loc)

locs = pd.DataFrame()
for i in range(len(facdb_geocodezip)):
    new = get_loc(facdb_geocodezip['addressnum'],
                  facdb_geocodezip['streetname'],
                  facdb_geocodezip['zipcode'][i]
    )
    locs = pd.concat((locs, new))
locs.reset_index(inplace = True)

# update the facilities table
for i in range(len(facdb_geocodezip)):
    if (locs['lat'][i] != 'none') & (locs['lon'][i] != 'none'): 
        upd = "UPDATE facilities a SET geom = ST_SetSRID(ST_MakePoint(" + str(locs['lon'][i]) + ", " + str(locs['lat'][i]) + "), 4326) WHERE addressnum = '" + facdb_geocodezip['addressnum'][i] + "' AND streetname = '" + facdb_geocodezip['streetname'][i] + "' AND zipcode = '" + facdb_geocodezip['zipcode'][i] + "';"
    elif (locs['lat'][i] == 'none') & (locs['lon'][i] == 'none') & (locs['bin'][i] == 'none'):
        upd = "UPDATE facilities a SET geom = NULL WHERE addressnum = '" + facdb_geocodezip['addressnum'][i] + "' AND streetname = '" + facdb_geocodezip['streetname'][i] + "' AND zipcode = '" + facdb_geocodezip['zipcode'][i] + "';"
    engine.execute(upd)
if i % 100 == 0:
    print (i)
# not deleting because if I ever figure it out this is probably a better way of doing this... 
#md = sql.MetaData(engine)
#table = sql.Table('sca', md, autoload=True)
#upd = table.update(values={










