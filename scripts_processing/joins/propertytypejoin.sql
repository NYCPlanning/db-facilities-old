WITH COLP_bbls AS (
SELECT
	bbl,
    array_agg(distinct propertytype) AS propertytype,
    array_agg(distinct oversightabbrev) AS oversightabbrev
FROM
	facilities
WHERE
	pgtable = ARRAY['dcas_facilities_colp']
GROUP BY bbl)

UPDATE facilities AS f
SET 
    propertytype = 
		(CASE
			WHEN c.propertytype @> ARRAY['City Owned'] THEN 'City Owned'
			WHEN c.propertytype @> ARRAY['City Leased'] AND c.oversightabbrev @> f.oversightabbrev THEN 'City Leased'
		END)
FROM COLP_bbls AS c
WHERE
	f.bbl = c.bbl
	AND f.bbl IS NOT NULL;