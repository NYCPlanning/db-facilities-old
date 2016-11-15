UPDATE facilities
    -- SET ID = REPLACE(CONCAT(agencysource,'-',oversightabbrev,'-',idagency,facilityname,bbl,addressnumber,LEFT(agencyclass1,10),LEFT(agencyclass2,10),'-',sourcedatasetname),' ','')
    SET ID = REPLACE(CONCAT(agencysource,'-',oversightabbrev,'-',idagency,'-',facilitysubgroup,'-',bbl),' ','')

    -- WHERE ID IS NULL