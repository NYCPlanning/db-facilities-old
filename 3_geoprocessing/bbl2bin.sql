WITH facilities AS (
    SELECT * FROM facilities f
     LEFT JOIN facdb_bbl b
     ON f.uid=b.uid
     LEFT JOIN facdb_bin n
     ON f.uid=n.uid
     ) f

UPDATE facilities
    SET
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
