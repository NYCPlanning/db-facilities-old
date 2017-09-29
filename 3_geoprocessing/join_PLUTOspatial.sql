DROP VIEW target;
CREATE VIEW target AS
    SELECT
        hash,
        f.uid,
        p.borough,
        p.borocode,
        p.zipcode,
        p.address,
        p.bbl
    FROM 
        dcp_mappluto AS p,
        facilities f
        LEFT JOIN facdb_bbl b
        ON f.uid=b.uid
    WHERE
        (b.bbl IS NULL
            OR f.addressnum IS NULL)
        AND f.geom IS NOT NULL
        AND ST_Intersects(p.geom,f.geom)
        AND processingflag IS NULL;

UPDATE facilities f
    SET
        boro = 
	        (CASE
	        	WHEN p.borough = 'MN' THEN 'Manhattan'
	        	WHEN p.borough = 'BX' THEN 'Bronx'
	        	WHEN p.borough = 'BK' THEN 'Brooklyn'
	        	WHEN p.borough = 'QN' THEN 'Queens'
	        	WHEN p.borough = 'SI' THEN 'Staten Island'
	        END),
        borocode = p.borocode,
        zipcode = p.zipcode,
        addressnum = 
        	(CASE
	        	WHEN f.addressnum IS NULL THEN initcap(split_part(p.address,' ',1))
	        	ELSE f.addressnum
        	END),
        streetname = 
        	(CASE
	        	WHEN f.addressnum IS NULL THEN initcap(trim(both ' ' from substr(trim(both ' ' from p.address), strpos(trim(both ' ' from p.address), ' ')+1, (length(trim(both ' ' from p.address))-strpos(trim(both ' ' from p.address), ' ')))))
	        	ELSE f.streetname
        	END),
        address = 
        	(CASE
	        	WHEN f.addressnum IS NULL THEN initcap(p.address)
	        	ELSE f.address
        	END),
        processingflag = 
        	(CASE
	        	WHEN f.addressnum IS NULL AND p.address IS NOT NULL THEN 'joinPLUTOspatial2address'
	        	ELSE 'joinPLUTOspatial'
        	END)
    FROM target AS p 
    WHERE f.uid=p.uid;

UPDATE facdb_bbl f
SET bbl = ROUND(p.bbl,0)
FROM target AS p 
    WHERE f.uid=p.uid;

DROP VIEW target;

