--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

-- still need to figure out distance issues, especially for unnamed

DROP TABLE IF EXISTS duplicates_colp_relatedlots_colponly_p2;
CREATE TABLE duplicates_colp_relatedlots_colponly_p2 AS (

-- starting with all records in table, 
WITH primaryguids AS (
	SELECT
		(array_agg(distinct guid))[1] AS guid
	FROM facilities
	WHERE
		pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND geom IS NOT NULL
		AND guid_merged IS NULL
		AND (facilityname = 'Unnamed'
		OR facilityname = 'Park'
		OR facilityname = 'Office Bldg'
		OR facilityname = 'Park Strip'
		OR facilityname = 'Playground'
		OR facilityname = 'NYPD Parking'
		OR facilityname = 'Multi-Service Center'
		OR facilityname = 'Animal Shelter'
		OR facilityname = 'Garden'
		OR facilityname = 'L.U.W'
		OR facilityname = 'Long Term Tenant: NYCHA'
		OR facilityname = 'Help Social Service Corporation'
		OR facilityname = 'Day Care Center'
		OR facilityname = 'Safety City Site'
		OR facilityname = 'Public Place'
		OR facilityname = 'Sanitation Garage'
		OR facilityname = 'MTA Bus Depot'
		OR facilityname = 'Mta Bus Depot'
		OR facilityname = 'Mall'
		OR oversightabbrev = ARRAY['NYCDOE'])
	GROUP BY
		facilitytype,
		oversightagency,
		councildistrict,
		facilityname
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE guid IN (SELECT guid from primaryguids)
),

matches AS (
	SELECT
		a.guid,
		b.guid AS guid_b
	FROM primaries AS a
	INNER JOIN facilities AS b
	ON
		a.facilityname = b.facilityname
	WHERE
		b.pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND a.facilitytype = b.facilitytype
		AND a.oversightagency = b.oversightagency
		AND a.councildistrict = b.councildistrict
		AND a.guid <> b.guid
		AND b.geom IS NOT NULL
		AND b.guid_merged IS NULL
),

duplicates AS (
	SELECT
		guid,
		array_agg(guid_b) AS guid_merged
	FROM matches
	GROUP BY
	guid
)

SELECT facilities.*
FROM facilities
WHERE facilities.guid IN (SELECT unnest(duplicates.guid_merged) FROM duplicates)
ORDER BY guid

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH primaryguids AS (
	SELECT
		(array_agg(distinct guid))[1] AS guid
	FROM facilities
	WHERE
		pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND geom IS NOT NULL
		AND guid_merged IS NULL
		AND (facilityname = 'Unnamed'
		OR facilityname = 'Park'
		OR facilityname = 'Office Bldg'
		OR facilityname = 'Park Strip'
		OR facilityname = 'Playground'
		OR facilityname = 'NYPD Parking'
		OR facilityname = 'Multi-Service Center'
		OR facilityname = 'Animal Shelter'
		OR facilityname = 'Garden'
		OR facilityname = 'L.U.W'
		OR facilityname = 'Long Term Tenant: NYCHA'
		OR facilityname = 'Help Social Service Corporation'
		OR facilityname = 'Day Care Center'
		OR facilityname = 'Safety City Site'
		OR facilityname = 'Public Place'
		OR facilityname = 'Sanitation Garage'
		OR facilityname = 'MTA Bus Depot'
		OR facilityname = 'Mta Bus Depot'
		OR facilityname = 'Mall'
		OR oversightabbrev = ARRAY['NYCDOE'])
	GROUP BY
		facilitytype,
		oversightagency,
		councildistrict,
		facilityname
),

primaries AS (
	SELECT *
	FROM facilities
	WHERE guid IN (SELECT guid from primaryguids)
),

matches AS (
	SELECT
		a.guid,
		a.facilityname,
		a.facilitytype,
		b.guid AS guid_b,
		b.hash AS hash_b,
		(CASE WHEN b.bin IS NULL THEN ARRAY['FAKE!'] ELSE b.bin END) AS bin_b,
		(CASE WHEN b.bbl IS NULL THEN ARRAY['FAKE!'] ELSE b.bbl END) AS bbl_b
	FROM primaries AS a
	INNER JOIN facilities AS b
	ON
		a.facilityname = b.facilityname
	WHERE
		b.pgtable = ARRAY['dcas_facilities_colp']::text[]
		AND a.facilitytype = b.facilitytype
		AND a.oversightagency = b.oversightagency
		AND a.councildistrict = b.councildistrict
		AND a.guid <> b.guid
		AND b.geom IS NOT NULL
		AND b.guid_merged IS NULL
),

duplicates AS (
	SELECT
		guid,
		count(*) AS countofdups,
		facilityname,
		facilitytype,
		array_agg(distinct BIN_b) AS bin_merged,
		array_agg(distinct BBL_b) AS bbl_merged,
		array_agg(guid_b) AS guid_merged,
		array_agg(distinct hash_b) AS hash_merged
	FROM matches
	GROUP BY
		guid, facilityname, facilitytype
	ORDER BY facilitytype, countofdups DESC )

UPDATE facilities AS f
SET
	BIN = 
		(CASE
			WHEN d.bin_merged <> ARRAY['FAKE!'] THEN array_cat(BIN, d.bin_merged)
			ELSE BIN
		END),
	BBL = 
		(CASE
			WHEN d.BBL_merged <> ARRAY['FAKE!'] THEN array_cat(BBL, d.BBL_merged)
			ELSE BBL
		END),
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_colp_relatedlots_colponly_p2.guid FROM duplicates_colp_relatedlots_colponly_p2)
;

