UPDATE facilities
    SET ID = REPLACE(CONCAT(agencysource,'-',oversightabbrev,'-',idagency,facilityname,addressnumber,LEFT(agencyclass1,10),LEFT(agencyclass2,10)),' ','')
    WHERE ID IS NULL