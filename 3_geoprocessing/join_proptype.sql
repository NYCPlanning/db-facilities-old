WITH COLP_bbls AS (
SELECT
	DISTINCT
	bbl,
    proptype,
    proptypeag,
    overabbrev,
    pgtable
FROM
	facilities
WHERE
	pgtable = 'dcas_facilities_colp'
GROUP BY bbl)

UPDATE facilities AS f
SET 
    proptype = 
		(CASE
			WHEN c.proptype @> 'City Owned' THEN 'City Owned'
			WHEN c.proptype @> 'City Leased' AND c.overabbrev @> f.overabbrev THEN 'City Leased'
		END),
	proptype = c.proptype	
FROM COLP_bbls AS c
WHERE
	f.bbl = c.bbl
	AND f.bbl IS NOT NULL
	AND f.pgtable NOT LIKE CONCAT('%',c.pgtable,'%');