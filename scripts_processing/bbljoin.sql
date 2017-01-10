UPDATE facilities AS f
    SET
        bbl = ARRAY[ROUND(p.bbl,0)],
        borough = 
	        (CASE
	        	WHEN p.borough = 'MN' THEN 'Manhattan'
	        	WHEN p.borough = 'BX' THEN 'Bronx'
	        	WHEN p.borough = 'BK' THEN 'Brooklyn'
	        	WHEN p.borough = 'QN' THEN 'Queens'
	        	WHEN p.borough = 'SI' THEN 'Staten Island'
	        END),
        boroughcode = p.borocode,
        zipcode = p.zipcode,
        addressnumber = 
        	(CASE
	        	WHEN f.addressnumber IS NULL THEN initcap(split_part(p.address,' ',1))
	        	ELSE f.addressnumber
        	END),
        streetname = 
        	(CASE
	        	WHEN f.addressnumber IS NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from p.address), strpos(trim(both ' ' from p.address), ' ')+1, (length(trim(both ' ' from p.address))-strpos(trim(both ' ' from p.address), ' ')))))
	        	ELSE f.streetname
        	END),
        address = 
        	(CASE
	        	WHEN f.addressnumber IS NULL THEN initcap(p.address)
	        	ELSE f.address
        	END),
        processingflag = 
        	(CASE
	        	WHEN f.addressnumber IS NULL AND p.address IS NOT NULL THEN 'bbljoin2address'
	        	ELSE 'bbljoin'
        	END)
    FROM 
        dcp_mappluto AS p
    WHERE
        (f.bbl IS NULL
            OR f.addressnumber IS NULL)
        AND f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
