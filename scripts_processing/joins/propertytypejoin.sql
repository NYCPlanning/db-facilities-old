WITH COLP_bbls AS (
SELECT
	bbl,
    array_agg(distinct propertytype) AS propertytype,
    array_agg(distinct oversightabbrev) AS oversightabbrev,
    array_agg(distinct pgtable) AS pgtable,
    array_agg(distinct agencysource) AS agencysource,
    array_agg(distinct sourcedatasetname) AS sourcedatasetname,
    array_agg(distinct linkdata) AS linkdata,
    array_agg(distinct datesourceupdated) AS datesourceupdated
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
		END),
	pgtable = array_append(f.pgtable, array_to_string(c.pgtable,';')),
	agencysource = array_append(f.agencysource, array_to_string(c.agencysource,';')),
	sourcedatasetname = array_append(f.sourcedatasetname, array_to_string(c.sourcedatasetname,';')),
	linkdata = array_append(f.linkdata, array_to_string(c.linkdata,';')),
	datesourceupdated = array_append(f.datesourceupdated, array_to_string(c.datesourceupdated,';'))
FROM COLP_bbls AS c
WHERE
	f.bbl = c.bbl
	AND f.bbl IS NOT NULL
	AND array_to_string(f.pgtable,';') NOT LIKE CONCAT('%',array_to_string(c.pgtable,';'),'%');