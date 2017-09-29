WITH facilities AS (
    SELECT * FROM facilities f
     LEFT JOIN facdb_bbl b
     ON f.uid=b.uid
     LEFT JOIN facdb_bin n
     ON f.uid=n.uid
     ) f

        bin = p.bin::text,
        processingflag = 
        	(CASE
	        	WHEN processingflag IS NULL THEN 'bbl2bin'
	        	ELSE CONCAT(processingflag, '_bbl2bin')
        	END)
    FROM
        bblbin_one2one AS p
    WHERE
        f.bbl = p.bbl::text
        AND f.bin IS NULL;


-- testing

WITH master AS (
    SELECT f.uid, b.bbl, n.bin FROM facilities f
     LEFT JOIN facdb_bbl b
     ON f.uid=b.uid
     LEFT JOIN facdb_bin n
     ON f.uid=n.uid
     )


UPDATE facdb_bin
    SET bin = p.bin::text          
    FROM
        master f,
        bblbin_one2one p
    WHERE 
    f.bin IS NULL
    AND f.bbl::text=ROUND(p.bbl,0)::text
    AND f.uid=facdb_bin.uid;

WITH master AS (
    SELECT f.uid, b.bbl, n.bin FROM facilities f
     LEFT JOIN facdb_bbl b
     ON f.uid=b.uid
     LEFT JOIN facdb_bin n
     ON f.uid=n.uid
     )

UPDATE facilities
SET processingflag =
        (CASE
            WHEN processingflag IS NULL THEN 'bbl2bin'
            ELSE CONCAT(processingflag, '_bbl2bin')
        END)
FROM
        master f,
        bblbin_one2one p
    WHERE 
    f.bin IS NULL
    AND f.bbl::text=ROUND(p.bbl,0)::text
    AND f.uid=facilities.uid;