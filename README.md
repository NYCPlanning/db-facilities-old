## Database and Documentation:

  * [NYC Facilities Explorer](http://capitalplanning.nyc.gov/facilities)
  * [Data Download](https://www1.nyc.gov/site/planning/data-maps/open-data/dwn-selfac.page)
  * [Data User Guide / Documentation](http://docs.capitalplanning.nyc/facdb/)

## Summary of Build Process and Stages:

![High Level](./diagrams/FacDB_HighLevel.png)

**Obtaining Data**: The build follows an Extract -> Load -> Transform sequence rather than an ETL (Extract-Transform-Load) sequence. All the source datasets are first loaded into PostGreSQL using the [Civic Data Loader](https://github.com/NYCPlanning/civic-data-loader) scripts. The datasets which must be loaded are listed out in the [`run_download.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/run_download.sh) script. After the required source data is loaded in the PostGIS database, the build or update process begins, consisting of four phases: Assembly, Geoprocessing, Deduping, and Exporting.

**Assembly**: [`run_assembly.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/run_download.sh). Creates the empty FacDB table, matches and inserts desired columns from the source data into the FacDB schema, recodes variables, classifies the facilities, and concatenates the DCP ID. The end product is all the records and available attributes from the source datasets formatted, recoded (if necessary), and inserted into the FacDB table. There are many missing geometries and other missing attributes related to location like addresses, zipcodes, BBLs, and BINs. A diagram of the [assembly process](https://github.com/NYCPlanning/facilities-db#assembly) is provided below.

**Geoprocessing**: [`run_geoprocessing.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/run_geoprocessing.sh). Fills in all the missing values that weren't provided in the source data before doing a final round of formatting and cleanup. Records without geometries get geocoded, x & y coordinates (SRID 2263) are calculated and filled in, and spatial joins with MapPLUTO are performed to get additional location details like BBL and addresses when missing. Finally, a script performs final formatting by querying for acronyms that need to be changed back to all caps. A diagram of the [geoprocessing steps](https://github.com/NYCPlanning/facilities-db#geoprocessing) is provided below.

**Deduping**: [`run_deduping.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/run_deduping.sh). Fills in all the missing values that weren't provided in the source data before doing a final round of formatting and cleanup. Records without geometries get geocoded, x & y coordinates (SRID 2263) are calculated and filled in, and spatial joins with MapPLUTO are performed to get additional location details like BBL and addresses when missing. Finally, a script performs final formatting by querying for acronyms that need to be changed back to all caps. A diagram of the [deduping process](https://github.com/NYCPlanning/facilities-db#deduping) is provided below.

**Exporting**: [`run_export.sh`](https://github.com/NYCPlanning/facilities-db/blob/master/run_export.sh)


## Prerequisites:

1. Create an environment variable in your bash profile that provides your DATABASE_URL. This gets used in both the run_assembly.sh and run_processing.sh scripts.
  * `cd ~/.bash_profile`
  * Open .bash_profile in Sublime and add the following code:
  * `export DATABASE_URL=postgres://{User}:{Password}@{Host}:{Post}/{Database}`
  * Check that it was created successfully with `printenv`

## Scheduled Maintenance and Data Quality Checks:

Coming soon!

## Process Diagrams

### Assembly
![Assembly Diagram](./diagrams/FacDB_Assembly.png)

### Geoprocessing
![Geoprocessing Diagram](./diagrams/FacDB_Geoprocessing.png)

### Deduping
![Deduping Diagram](./diagrams/FacDB_Deduping.png)
