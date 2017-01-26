UPDATE facilities AS f
    SET
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
        addressnumber = initcap(split_part(p.address,' ',1)),
        streetname = initcap(trim(both ' ' from substr(trim(both ' ' from p.address), strpos(trim(both ' ' from p.address), ' ')+1, (length(trim(both ' ' from p.address))-strpos(trim(both ' ' from p.address), ' '))))),
        address = initcap(p.address),
        processingflag = 'bbl2address'
    FROM 
        dcp_mappluto AS p
    WHERE
        f.bbl = ARRAY[ROUND(p.bbl,0)::text]
        AND f.bbl IS NOT NULL
        AND f.geom IS NOT NULL
        AND f.addressnumber IS NULL
        AND f.processingflag IS NULL
