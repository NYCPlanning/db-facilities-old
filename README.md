### Database and Documentation:

  * [Webmap Explorer](http://cpp.capitalplanning.nyc/facilities)
  * [Shapefile download]()
  * [Documentation](https://nycplanning.github.io/cpdocs/facdb/)
  * [Feedback Form](https://docs.google.com/forms/d/e/1FAIpQLSffdzVSCRmMQhGn32Z6bDnBEKPXJw20m6CkDMeco-z4B1FcNQ/viewform)

### Summary of Build Process and Stages:

The build follows an Extract -> Load -> Transform sequence rather than an ETL (Extract-Transform-Load) sequence.

All the source datasets are first loaded using the [Civic Data Loader](https://github.com/NYCPlanning/civic-data-loader) scripts. The datasets which must be loaded are listed out in the `run_assembly.sh` script.

After the required source data is loaded, the build process is broken into two stages: **Assembly** and **Processing**.

**Assembly**: Creates the empty FacDB table, matches and inserts desired columns from the source data into the FacDB schema, recodes variables, classifies the facilities, and concatenates the DCP ID. The end product is all the records and available attributes from the source datasets formatted, recoded (if necessary), and inserted into the FacDB table. There are many missing geometries and other missing attributes related to location like addresses, zipcodes, BBLs, and BINs.

**Processing**: Fills in all the missing values that weren't provided in the source data before doing a final round of formatting and cleanup. Records without geometries get geocoded, x & y coordinates (SRID 2263) are calculated and filled in, and spatial joins with MapPLUTO are performed to get additional location details like BBL and addresses when missing. Finally, a script performs final formatting by querying for acronyms that need to be changed back to all caps.

### How to Build:

1. Create an environment variable in your bash profile that provides your DATABASE_URL. This gets used in both the run_assembly.sh and run_processing.sh scripts.
  * `cd ~/.bash_profile`
  * Open .bash_profile in Sublime and add the following code:
  * `export DATABASE_URL=postgres://{User}:{Password}@{Host}:{Post}/{Database}`
  * Check that it was created successfully with `printenv`

2. Use the Civic Data Loader scripts to load all the source data files.

3. Run the assembly scripts using `sh run_assembly.sh` This script runs all the scripts inside the scripts_assembly folder. It is also annotated, describing what each one does.

4. Run the processing scripts using `sh run_processing.sh` This script runs all the scripts inside the scripts_processing. It is also annotated, describing what each one does.
