# City Planning Facilities Database (FacDB)

  * [NYC Facilities Explorer](http://capitalplanning.nyc.gov/facilities)
  * [Data Download](https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-selfac.page)
  * [General User Guide: Classification Hierarchy, Data Dictionary, Data Sources](http://docs.capitalplanning.nyc/facdb/)

# Documentation for Building and Maintaining FacDB

## Contents
- [Prerequisites Before Running Build](https://github.com/NYCPlanning/facilities-db#prerequisites)
- [Summary of Build Process and Stages](https://github.com/NYCPlanning/facilities-db#summary-of-build-process-and-stages)
- [Updating and Maintaining the Database](https://github.com/NYCPlanning/facilities-db#updating-and-maintaining-the-database)
- [Process Diagrams](https://github.com/NYCPlanning/facilities-db#process-diagrams)
- [Notes on Specific Source Datasets](https://github.com/NYCPlanning/facilities-db#notes-on-specific-data-sources)


## Prerequisites

1. Install Node.js
2. Install PostgreSQL
3. Install PostGIS


## Getting Started

1. Create a database in your PostgreSQL instance to use for this project
2. Create an environment variable in your bash profile that provides your DATABASE_URL. This gets used in all the .sh scripts.
    * `cd ~/.bash_profile`
    * Open .bash_profile in Sublime and add the following code:
    * `export DATABASE_URL=postgres://{User}:{Password}@{Host}:{Port}/{Database}`
    * Check that it was created successfully with `printenv`
5. Clone [Data Loading Scripts](https://github.com/NYCPlanning/data-loading-scripts) repo and run `npm install` inside of it.
6. Plug in your database information in [dbconfig.sample.js](https://github.com/NYCPlanning/facilities-db/blob/master/3_geoprocessing/geoclient/dbconfig.sample.js) and save as dbconfig.js.
7. Generate an API ID and Key for Geoclient. [Directions here](https://developer.cityofnewyork.us/api/geoclient-api). Plug these values into the [apiCredentials.sample.js](https://github.com/NYCPlanning/facilities-db/blob/master/3_geoprocessing/geoclient/apiCredentials.sample.js) and save as apiCredentials.js.
8. Run `sh 1_download.sh`
9. Run `sh 2_assembly.sh`
10. Run `sh 3_geoprogressing.sh`
11. Run `sh 4_deduping.sh`
12. Run `sh 5_export.sh`


## Summary of Build Process and Stages

![High Level](./diagrams/FacDB_HighLevel.png)

### 1 . Obtaining Data

The build follows an Extract -> Load -> Transform sequence rather than an ETL (Extract-Transform-Load) sequence. All the source datasets are first loaded into PostgreSQL using the [Data Loading Scripts](https://github.com/NYCPlanning/data-loading-scripts) scripts. After the required source data is loaded in the PostGIS database, the build or update process begins.

Over 50% of the data sources used for FacDB are available in a machine readable format via the NYC Open Data Portal, NYS Open Data Portal, or an agency's website. Other sources that are not published in this format are generally shared with DCP over email and DCP then puts these files on an FTP for DCP's internal use.

[`1_download.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/1_download.sh) script downloads and loads all the neccesary source datasets for the Facilities Database (FacDB).

### 2. Assembly

When building the database from scratch, this stage begins with creating the empty FacDB table. Then, for each source data table, a 'config' script is used to insert the records. The desired columns in the source data get mapped to the columns in FacDB schema. Many values also need to be recoded and the facility records then need to be classified. The facilities are classified using categories or descriptions provided by the agency. In general, the final Facility Type categories in FacDB are formatted versions of the original, most granular classification provided by the agency, but there are also cases where the source description was too specific and records were grouped together into broader type categories using keywords in the description.

Critically, during the insert process, an encrypted hash of the full row in the source data table is created and stored in each record in FacDB in the 'hash' field. This hash is the unique identifier that allows records in FacDB to be modified and improved while still being able to link that modified record back to the original format in the source data table. This is essential for the FacDB update process of reconciling refreshed source data against the existing contents in FacDB. The hash is then converted to an integer 'uid' which is used as the true unique identifier for each facility and is used in the Facilities Explorer.

The end product of this Assembly stage is all the records and available attributes from the source datasets formatted, recoded (if necessary), and inserted into the FacDB table. There are many missing geometries and other missing attributes related to location like addresses, zipcodes, BBLs, and BINs.

[Diagram of the Assembly process](https://github.com/NYCPlanning/facilities-db#assembly) is provided below.

[`2_assembly.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/2_assembly.sh) script runs all the steps in the Assembly process and is annotated to decribe each of the scripts used.

### 3. Geoprocessing

Many of the source datasets only provide addresses without coordinates. Records without coordinates are geocoded with the [GeoClient API](https://developer.cityofnewyork.us/api/geoclient-api) using the Address and either the Borough or ZIP Code to get the BIN, BBL, and other standardized location details. Records that come with both a geometry and an address are also run through GeoClient in a separate batch, to standardize the addresses and fill in other missing information like BIN and BBL. 

Records that are provided in the source data with only coordinates and no addresses are processed by doing a spatial join with MapPLUTO to get the BBL and other location related details like Address, Borough, ZIP Code, and BIN when there is a 1-1 BIN-BBL relationship. 

The coordinates provided by GeoClient are generally not inside tax lots. There are also many cases where an agency provides coordinates, but the coordinates they provided fall in the road bed, rather than inside a BBL boundary, due to the geocoding technique used by the source agency. For these reasons, the BIN centroid was used to overwrite geometries. If a record does not have a BIN but has been assigned a BBL, the BBL centroid is used to overwrite the geometry instead. 

Each record in the database is flagged with a code for the geoprocessing technique that was used to complete all of its information in the `processingflag` field.

[Diagram of the Geoprocessing steps](https://github.com/NYCPlanning/facilities-db#geoprocessing) is provided below.

[`3_geoprocessing.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/3_geoprocessing.sh) script runs all Geoprocessing steps and is annotated to decribe each of the scripts used.

### 4. Deduping

Several of the source datasets have content which overlaps with other datasets. Duplicate records were identified by querying for all the records which fall on the same BIN or BBL as a record with the same Facility Subgroup or Type, same Facility Name, or same Oversight Agency. The values from the duplicate records were merged before dropping the duplicate records from the database. 

[Diagram of the Deduping process](https://github.com/NYCPlanning/facilities-db#deduping) is provided below.

[`4_deduping.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/4_deduping.sh)  script runs all the steps in the Deduping process and is annotated to decribe each of the scripts used.

### 5. Exporting

[`5_export.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/5_export.sh) script runs each of the scripts that export each of the data views that get published and are used for the NYC Facilities Explorer and other documentation.


## Updating and Maintaining the Database

This process is still in development.

See [diagram of proposed Maintenance work flow](https://github.com/NYCPlanning/facilities-db#maintenance) provided below.



## Process Diagrams

### Assembly
![Assembly Diagram](./diagrams/FacDB_Assembly.png)

### Geoprocessing
![Geoprocessing Diagram](./diagrams/FacDB_Geoprocessing.png)

### Deduping
![Deduping Diagram](./diagrams/FacDB_Deduping.png)

### Maintenance
![Maintenance Diagram](./diagrams/FacDB_Maintenance.png)


## Notes on Specific Data Sources

Coming soon!
