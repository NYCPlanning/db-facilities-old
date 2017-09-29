WITH target AS (
    SELECT
        hash,
        f.uid,
        p.borough,
        p.borocode,
        p.zipcode,
        p.address
    FROM 
        dcp_mappluto AS p,
        facilities f
        LEFT JOIN facdb_bbl b
        ON f.uid=b.uid
    WHERE
        b.bbl = ROUND(p.bbl,0)::text
        AND b.bbl IS NOT NULL
        AND f.addressnum IS NULL
        AND f.processingflag IS NULL
        AND b.bbl IN 
        (SELECT split_part(bbl::text,'.',1) FROM bblbin_one2one)
)

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
        addressnum = initcap(split_part(p.address,' ',1)),
        streetname = initcap(trim(both ' ' from substr(trim(both ' ' from p.address), strpos(trim(both ' ' from p.address), ' ')+1, (length(trim(both ' ' from p.address))-strpos(trim(both ' ' from p.address), ' '))))),
        address = initcap(p.address),
        processingflag = 'joinPLUTOtabular2address'
    FROM target p
        WHERE f.uid=p.uid;


        
