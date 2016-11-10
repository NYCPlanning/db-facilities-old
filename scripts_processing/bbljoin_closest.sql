UPDATE facilities
    SET
        bbl = ARRAY[ROUND(j.bbl,0)],
        borough = 
	        (CASE
	        	WHEN j.borough = 'MN' THEN 'Manhattan'
	        	WHEN j.borough = 'BX' THEN 'Bronx'
	        	WHEN j.borough = 'BK' THEN 'Brooklyn'
	        	WHEN j.borough = 'QN' THEN 'Queens'
	        	WHEN j.borough = 'SI' THEN 'Staten Island'
	        END),
        boroughcode = j.borocode,
        zipcode = j.zipcode,
        addressnumber = 
        	(CASE
	        	WHEN facilities.address IS NULL THEN initcap(split_part(j.address,' ',1))
	        	ELSE facilities.addressnumber
        	END),
        streetname = 
        	(CASE
	        	WHEN facilities.address IS NULL THEN initcap(split_part(j.address,' ',2))
	        	ELSE facilities.streetname
        	END),
        address = 
        	(CASE
	        	WHEN facilities.address IS NULL THEN initcap(j.address)
	        	ELSE facilities.address
        	END),
        processingflag = 
        	(CASE
	        	WHEN facilities.address IS NULL AND j.address IS NOT NULL THEN 'bbljoin2address_closest'
	        	ELSE 'bbljoin_closest'
        	END)
    FROM 
        (SELECT DISTINCT ON(f.guid)
		    f.guid,
		    p.bbl,
		    p.address,
		    p.borough,
		    p.borocode,
		    p.zipcode
		FROM dcp_mappluto p
		JOIN facilities f ON ST_DWithin(p.geom, f.geom, 100)
		WHERE
			f.geom IS NOT NULL
			AND f.bbl IS NULL
			AND NOT f.facilitygroup ~ 'Parks and Plazas'
		ORDER BY
		    f.guid,
		    ST_Distance(f.geom, p.geom)
        ) AS j
    WHERE
        facilities.guid = j.guid
