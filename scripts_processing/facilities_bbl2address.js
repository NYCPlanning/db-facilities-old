/////////////////////////////////////////////////////////////////////////////////////////////////////////
// PROCESS OVERVIEW
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// Select all records with BBls and geoms but no address
// Use bbl to get rest of desired info from geoclient (formatted address, BIN)

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
var bblQuery = 'SELECT DISTINCT bbl_unnested AS bbl FROM (SELECT *, unnest(bbl) AS bbl_unnested FROM facilities WHERE bbl IS NOT NULL AND address IS NULL) AS fac_unnested';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 3 --- APPLYING THE bblQuery IN THE DATABASE TO FIND RECORDS WITH NULL GEOM
/////////////////////////////////////////////////////////////////////////////////////////////////////////


var i=0;
var bblResults;

db.any(bblQuery)
  .then(function (data) { 
    bblResults = data

    console.log('Found ' + bblResults.length + ' bbls in facilities ')
    dataLookup(bblResults[i]);
  })
  .catch(function(err) {
    console.log('ERROR WITH QUERY: ', err)
  })


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 4 --- SETTING TEMPLATES FOR REQUEST TO API -- REQUIRES ADDRESS#, STREET NAME, AND BOROUGH OR ZIP
/////////////////////////////////////////////////////////////////////////////////////////////////////////


// records with bbls
var geoclientTemplate1 = 'https://api.cityofnewyork.us/geoclient/v1/search.json?input={{bbl}}&app_id={{app_id}}&app_key={{app_key}}';


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 5 --- DEFINES/RUNS FUNCTION WHICH LOOKS UP ADDRESSES USING geoclientTemplate
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function dataLookup(row) {
  console.log('Looking up bbl', row.bbl)

      var apiCall1 = Mustache.render(geoclientTemplate1, {
        
        // MAKE SURE THESE MATCH THE FIELD NAMES
        bbl: row.bbl,
        app_id: apiCredentials.app_id,
        app_key: apiCredentials.app_key
      })

      console.log(apiCall1);


      request(apiCall1, function(err, response, body) {
          console.log('ERROR WITH API RESPONSE: ', err)
          // A. try PARSING json
          try { 
            var data = JSON.parse(body)
            // B. try getting RESPONSE from data response
            try {
              data = data.results[0].response
              // C. try UPDATING facilities with the address from data
              try {
                updateFacilities(data, row)
              // C. catch error when UPDATING facilities table
              } catch (e) {
                console.log(data)
                i++;
                console.log(i,bblResults.length)
                  if (i<bblResults.length) {
                    dataLookup(bblResults[i])
                  }
              }
            // B. catch error with getting RESPONSE from data response
            } catch (e) {
              i++;
              console.log(i,bblResults.length)
              if (i<bblResults.length) {
                dataLookup(bblResults[i])
              }
            }
          // A. catch error with PARSING json
          } catch (e) {
            i++;
            console.log(i,bblResults.length)
            if (i<bblResults.length) {
              dataLookup(bblResults[i])
            }
          }
      })
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// STEP 6 --- DEFINES/RUNS FUNCTION updateFacilities 
/////////////////////////////////////////////////////////////////////////////////////////////////////////


function updateFacilities(data, row) {

  var insertTemplate = 'UPDATE facilities SET addressnumber = (CASE WHEN \'{{newaddressnumber}}\' = '' THEN NULL ELSE \'{{newaddressnumber}}\' END), streetname=initcap(\'{{newstreetname}}\'), address=(CASE WHEN \'{{newaddressnumber}}\' = '' THEN NULL ELSE CONCAT(\'{{newaddressnumber}}\',' ',\',initcap(\'{{newstreetname}}\')) END), bin=ARRAY[\'{{bin}}\'], processingflag=\'bbl2address\' WHERE bbl=ARRAY[\'{{bbl}}\'] AND address IS NULL'

  if(data.bbl) {
    console.log('Updating facilities');

    var insert = Mustache.render(insertTemplate, {
      
      // data. comes from api response
      newaddressnumber: data.giHighHouseNumber2,
      newstreetname: data.giStreetName1,
      bin: data.buildingIdentificationNumber,

      // row. comes from original table row from psql query
      bbl: row.bbl
    })

    console.log(insert);


    db.none(insert)
    .then(function(data) {
      i++;
      console.log(i,bblResults.length)
      if (i<bblResults.length) {
         dataLookup(bblResults[i])
      } else {
        console.log('Done!')
      }
      
    })
    .catch(function(err) {
      console.log('ERROR WITH UPDATE: ', err);
    })

  } else {
    console.log('Response did not include a lat/lon, skipping...');
    i++;
        console.log(i,bblResults.length)
        if (i<bblResults.length) {
           dataLookup(bblResults[i])
        }
  }
}

