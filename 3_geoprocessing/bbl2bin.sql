DROP TABLE IF EXISTS bblbin_one2one;
CREATE TABLE bblbin_one2one(
bbl text, bin text, concat text, numbins text);
\COPY bblbin_one2one FROM '/prod/db-facilities/helpers/bblbin_one2one.csv' CSV HEADER;


UPDATE facilities AS f
    SET
        BIN = ARRAY[p.bin::text],
        processingflag = 
        	(CASE
	        	WHEN processingflag IS NULL THEN 'bbl2bin'
	        	ELSE CONCAT(processingflag, '_bbl2bin')
        	END)
    FROM
        bblbin_one2one AS p
    WHERE
        f.bbl = ARRAY[p.bbl::text]
        AND f.bin IS NULL
