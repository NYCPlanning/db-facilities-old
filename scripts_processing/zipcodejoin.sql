UPDATE facilities AS f
    SET
        zipcode = p.zipcode::integer,
        city = p.po_name
    FROM 
        doitt_zipcodes AS p
    WHERE
        f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
