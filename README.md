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

<div class="mxgraph" style="max-width:100%;border:1px solid transparent;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;nav&quot;:true,&quot;resize&quot;:true,&quot;toolbar&quot;:&quot;zoom layers lightbox&quot;,&quot;edit&quot;:&quot;_blank&quot;,&quot;xml&quot;:&quot;&lt;mxfile userAgent=\&quot;Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36\&quot; version=\&quot;6.3.1\&quot; editor=\&quot;www.draw.io\&quot; type=\&quot;device\&quot;&gt;&lt;diagram name=\&quot;Page-1\&quot;&gt;1Vnfj6M2EP5rUNuHSvwISfZxk927tupJVfehzw4M4J6xqTEhub++Y2MnsM6t7nSrIJKHmPEYj7/5ZjIMQbKvTx8laapPIgcWxGF+CpKnII6jbZzij5acrSSMV4OklDS3sqvghX4Bp2ilHc2hnSgqIZiizVSYCc4hUxMZkVL0U7VCsOmuDSnBE7xkhPnSf2iuKiuNwvA68RvQsrJbb1M7cSDZ51KKjtv9gjgpzGeYrom7l9VvK5KLfiRKnoNkL4VQw6g+7YFpcB1sw7oPX5m92C2Bq29ZYN1yJKwDZ7GxS50dFuY0oPXDINlVqmY4jHD4Lyh1tr4jnRIoElJVohScsD+FaKwe5Iitvd9V4fkq3WWdPJodtLp/BHuqVnQys0ZZMxWRJVitZBDp3UbL7LE/gqhByTMqSGBE0ePU08QSprzoXUHDgcXtNoaxh+GT6DkTJNchQBR5A1J94L6iCl4aYs7WY0RNYS4oY3vBhDRrk5zAtshQ3iopPsNoZp1t4VC8heARpILTm+jYWcdPG8Abe9mPgsGpVKM4WIc/Dud6oZRMfEqmc1Ey8TD8nbfofLNXJmTeBvGaoZW7nB5xWOrhzxkjbUsLbRHh+UXX3eiypm0Id4t+cUI0aSwfiUdbvGskFKn+3owE83mfSIjW84XCdqGhkPqhsJkrFFIPwz8ERZqGgl/SszMer0ERytoF8jQJ5+OpK9sWR9SNT9SHuYi68TD8QE+6xiUNVYTRL7id4eyQm1uFv0TmGrhrgl48baP0nrx9WChvH3zeRtu5iOuD+IhlRGlyLBKhNT6LQwZH85hYII2mM/gwxbPzAsm7Ws1I3nipSdcxdcLeaC72Rn6R9TfUSE9tzYm2ivJyxFG0usQ8uzdn0pcVaGkv+E+aygdTRHQNoxlRCMvyOY0Z+o4Jean9CMffCadn60g4a26l5DGRL9nYlQ9IZ6JpXJOzI3MNeKLcsFoOoYDgd40ZLo7c6XZOci+1sxHdaG1Es/U2Ir+5sZeA2RZlHc0vnObQB6N2h6N2RUxqPwDoaKCmLbLIRP2ay0l0z+LDd4IH4XdS8Yep/21cvtGbcLbPwGW/O7EH3g4Vcqfp2uIlNXuOudybMsPWHE13YLStFkjhTTwnhWMP+09D2WeespWu7oJ4/V+n38Xs/pIiA/wP1X97TqbhziRt1Ps+eN+nw+9h/3BP7G/VeUPD+PC6g1wIribgOvj1xK+tyQuPqBCvmtPYN8NdsO6B+sD0wV+cry6d6eHWXsP68NV2NWKrpr6b+ogLDq8cakWE6fIrecrQY4DynfYUPiSwRztR0zw3SfEWWd7B36/cHfvejsPU9/bq+72Nl9cXmGZu9Jo4ef4f&lt;/diagram&gt;&lt;/mxfile&gt;&quot;}"></div>
<script type="text/javascript" src="https://www.draw.io/js/viewer.min.js"></script>

4. Run the processing scripts using `sh run_processing.sh` This script runs all the scripts inside the scripts_processing. It is also annotated, describing what each one does.
