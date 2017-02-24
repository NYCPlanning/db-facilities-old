UPDATE facilities
    SET
        facilityname = TRIM(both ' ' from facilityname),
        facilitytype = TRIM(both ' ' from facilitytype),
        operatorname = TRIM(both ' ' from operatorname),
        streetname = TRIM(both ' ' from streetname),
        address = TRIM(both ' ' from address)
        ;

UPDATE facilities
    SET
        facilityname = TRIM(both '''' from facilityname),
        facilitytype = TRIM(both '''' from facilitytype),
        operatorname = TRIM(both '''' from operatorname),
        streetname = TRIM(both '''' from streetname),
        address = TRIM(both '''' from address)
        ;

UPDATE facilities
    SET
        facilityname = TRIM(both ' ' from facilityname),
        facilitytype = TRIM(both ' ' from facilitytype),
        operatorname = TRIM(both ' ' from operatorname),
        streetname = TRIM(both ' ' from streetname),
        address = TRIM(both ' ' from address)
        ;