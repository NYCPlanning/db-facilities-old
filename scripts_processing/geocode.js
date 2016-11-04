/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROCESS OVERVIEW
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// Select all records with null geoms and borough value
// Geocode using borough and address -- need to be able to skip errors and keep going
// Select remaining records with null geoms and zipcode value
// Geocode using zipcode and address -- need to be able to skip errors and keep going
// Select all records with geoms
// Join all records with bbl
// Use bbl to get rest of desired info from geoclient (formatted address, xcoord, ycoord, cd, census, etc)

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 1 --- LOADING DEPENDENCIES
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// REQUIRE CODE LIBRARY DEPENDENCIES
var pgp = require('pg-promise')(), 
  request = require('request'),
  Mustache = require('mustache');

// REQUIRE JS FILE WITH API CREDENTIALS -- USED IN addressLookup FUNCTION
// ALSO REQUIRES JS SILE WITH DATABASE CONFIGURATION
var config = require('./dbconfig.js'),
  apiCredentials = require('./apiCredentials.js');

// USE DATABASE CONFIGURATION JS FILE TO LINK TO DATABASE
var db = pgp(config);


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 2 --- DEFINING THE QUERY USED TO FIND NULL GEOMETRIES
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// querying for records without geoms
// var nullGeomQuery = 'SELECT DISTINCT borough, addressnumber, streetname FROM facilities WHERE geom IS NULL AND addressnumber IS NOT NULL AND streetname IS NOT NULL AND borough IS NOT NULL';

var nullGeomQuery = 'SELECT DISTINCT zipcode, addressnumber, streetname FROM facilities WHERE geom IS NULL AND addressnumber IS NOT NULL AND streetname IS NOT NULL AND zipcode IS NOT NULL';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 3 --- APPLYING THE nullGeomQuery IN THE DATABASE TO FIND RECORDS WITH NULL GEOM
/////////////////////////////////////////////////////////////////////////////////////////////////////////


var i=0;
var nullGeomResults;

db.any(nullGeomQuery)
  .then(function (data) { 
    nullGeomResults = data

    console.log('Found ' + nullGeomResults.length + ' null geometries in facilities ')
    addressLookup1(nullGeomResults[i]);
  })
  .catch(function(err) {
    console.log(err)
  })


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 4 --- SETTING TEMPLATES FOR REQUEST TO API -- REQUIRES ADDRESS#, STREET NAME, AND BOROUGH OR ZIP
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// records without geoms and with boro
// var geoclientTemplate1 = 'https://api.cityofnewyork.us/geoclient/v1/address.json?houseNumber={{housenumber}}&street={{{streetname}}}&borough={{borough}}&app_id={{app_id}}&app_key={{app_key}}';

// // records without geoms and with zipcode, not boro
var geoclientTemplate1 = 'https://api.cityofnewyork.us/geoclient/v1/address.json?houseNumber={{housenumber}}&street={{{streetname}}}&zip={{zipcode}}&app_id={{app_id}}&app_key={{app_key}}';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 5 --- DEFINES/RUNS FUNCTION WHICH LOOKS UP ADDRESSES USING geoclientTemplate
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function addressLookup1(row) {
  // console.log('Looking up address', row.borough.trim(), row.addressnumber.trim(), row.streetname.split(',')[0].split('#')[0].split(' - ')[0].trim())
  console.log('Looking up address', row.zipcode, row.addressnumber.trim(), row.streetname.split(',')[0].split('#')[0].split(' - ')[0].trim())

      var apiCall1 = Mustache.render(geoclientTemplate1, {
        
        // MAKE SURE THESE MATCH THE FIELD NAMES
        housenumber: row.addressnumber.replace("/", "").replace("\"", "").replace("!", "").trim(),
        streetname: row.streetname.split(',')[0].split('#')[0].split(' - ')[0].trim(),
        // borough: row.borough.trim(),
        zipcode: row.zipcode,
        app_id: apiCredentials.app_id,
        app_key: apiCredentials.app_key
      })

      console.log(apiCall1);

      request(apiCall1, function(err, response, body) {
          var data = JSON.parse(body);
          // console.log(data)
          data = data.address;

          updateFacilities(data, row);
      })
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 6 --- DEFINES/RUNS FUNCTION updateFacilities 
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function updateFacilities(data, row) {

  var insertTemplate = 'UPDATE facilities SET geom=ST_SetSRID(ST_GeomFromText(\'POINT({{longitude}} {{latitude}})\'),4326), addressnumber=\'{{newaddressnumber}}\', streetname=\'{{newstreetname}}\' WHERE (addressnumber=\'{{oldaddressnumber}}\' AND streetname=\'{{oldstreetname}}\')'

  if(data.latitude && data.longitude) {
    console.log('Updating facilities');

    var insert = Mustache.render(insertTemplate, {
      
      // data. comes from api response
      latitude: data.latitude,
      longitude: data.longitude,
      xcoord: data.xCoordinate,
      ycoord: data.yCoordinate,
      newaddressnumber: data.houseNumber,
      newstreetname: data.firstStreetNameNormalized,
      bbl: data.bbl,
      bin: data.buildingIdentificationNumber,

      // row. comes from original table row from psql query
      oldaddressnumber: row.addressnumber,
      oldstreetname: row.streetname
    })

    console.log(insert);


    db.none(insert)
    .then(function(data) {
      i++;
      console.log(i,nullGeomResults.length)
      if (i<nullGeomResults.length) {
         addressLookup1(nullGeomResults[i])
      } else {
        console.log('Done!')
      }
      
    })
    .catch(function(err) {
      console.log(err);
    })

  } else {
    console.log('Response did not include a lat/lon, skipping...');
    i++;
        console.log(i,nullGeomResults.length)
        if (i<nullGeomResults.length) {
           addressLookup1(nullGeomResults[i])
        }
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 7 --- DEFINES QUERY USED TO BRING IN ALL RECORDS WITH AN ASSOCIATED BBL
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// var allQuery = 'SELECT DISTINCT * FROM facilities AS f LEFT JOIN dcp_mappluto AS p ON ST_Within() WHERE f.geom IS NOT NULL';

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 8 --- USES BBL TO PULL IN FORMATTED/VERIFIED DATA FROM GECLIENT
/////////////////////////////////////////////////////////////////////////////////////////////////////////



