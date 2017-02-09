--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_remaining;
CREATE TABLE duplicates_remaining AS (

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.hash,
		b.hash as hash_b,
		a.facilitysubgroup
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facilitysubgroup = b.facilitysubgroup
		AND a.facilitygroup <> 'Child Care and Pre-Kindergarten'
	    AND a.pgtable <> ARRAY['dcas_facilities_colp']
	    AND b.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
		AND a.bin <> ARRAY['']
		AND b.bin <> ARRAY['']
		AND a.bin <> ARRAY['0.00000000000']
		AND b.bin <> ARRAY['0.00000000000']
		AND
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			LIKE
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
		AND a.pgtable <> b.pgtable
		AND a.hash <> b.hash
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilitysubgroup
	),  

duplicates AS (
	SELECT
		hash,
		array_agg(hash_b) AS hash_merged
	FROM matches
	WHERE
		(sourcecombo LIKE '{nysoasas_facilities_programs}-{hhs_facilities_%' AND facilitysubgroup = 'Chemical Dependency')
		OR (sourcecombo LIKE '{dycd_facilities_otherprograms}-{hhs_facilities_%')
		OR (sourcecombo LIKE '{hhs_facilities_financials}-{hhs_facilities_proposals}')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysparks_facilities_historicplaces}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo LIKE '{nysparks_facilities_historicplaces}-{usnps_facilities_parks}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo LIKE '{nysomh_facilities_mentalhealth}-{hhs_facilities_%' AND facilitysubgroup = 'Mental Health')
		OR (sourcecombo LIKE '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' AND facilitysubgroup = 'Museums')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{dcp_facilities_sfpsd}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysparks_facilities_parks}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysdec_facilities_lands}')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Preserves and Conservation Areas')
		OR (sourcecombo LIKE '{nysopwdd_facilities_providers}-{hhs_facilities_%' AND facilitysubgroup = 'Programs for People with Disabilities')
		OR (sourcecombo LIKE '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Residential Health Care')
		OR (sourcecombo LIKE '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Hospitals and Clinics')
		OR (sourcecombo LIKE '{dfta_facilities_contracts}-{hhs_facilities_%' AND facilitysubgroup = 'Senior Services')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{dot_facilities_pedplazas}' AND facilitysubgroup = 'Streetscapes, Plazas, and Malls')
		OR (sourcecombo LIKE '{dhs_facilities_shelters}-{hhs_facilities_%' AND facilitysubgroup = 'Shelters and Transitional Housing')
		OR (sourcecombo LIKE '{dca_facilities_operatingbusinesses}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Solid Waste Processing')
		OR (sourcecombo LIKE '{nysdec_facilities_solidwaste}-{bic_facilities_tradewaste}')
	GROUP BY
	hash, sourcecombo, facilitysubgroup
	ORDER BY facilitysubgroup)

SELECT facilities.*
FROM facilities
WHERE
	facilities.hash IN (SELECT unnest(duplicates.hash_merged) FROM duplicates)
	AND facilities.hash NOT IN (SELECT duplicates.hash FROM duplicates)
ORDER BY hash

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.idagency,
		(CASE WHEN b.idagency IS NULL THEN ARRAY['FAKE!'] ELSE b.idagency END) as idagency_b,
		a.uid,
		b.uid as uid_b,
		a.hash,
		b.hash as hash_b,
		a.facilityname,
		b.facilityname as facilityname_b,
		a.facilitysubgroup,
		b.facilitysubgroup as facilitysubgroup_b,
		a.processingflag,
		b.processingflag as processingflag_b,
		a.bin,
		b.bin as bin_b,
		a.address,
		b.address as address_b,
		a.geom,
		a.pgtable,
		b.pgtable as pgtable_b,
		a.agencysource,
		b.agencysource as agencysource_b,
		a.sourcedatasetname,
		b.sourcedatasetname as sourcedatasetname_b,
		b.datesourceupdated as datesourceupdated_b,
		b.linkdata as linkdata_b,
		a.oversightagency,
		b.oversightlevel as oversightlevel_b,
		b.oversightagency as oversightagency_b,
		a.oversightabbrev,
		b.oversightabbrev as oversightabbrev_b,
		(CASE WHEN b.capacity IS NULL THEN ARRAY['FAKE!'] ELSE b.capacity END) as capacity_b,
		(CASE WHEN b.capacitytype IS NULL THEN ARRAY['FAKE!'] ELSE b.capacitytype END) capacitytype_b,
		(CASE WHEN b.utilization IS NULL THEN ARRAY['FAKE!'] ELSE b.utilization END) as utilization_b,
		(CASE WHEN b.area IS NULL THEN ARRAY['FAKE!'] ELSE b.area END) as area_b,
		(CASE WHEN b.areatype IS NULL THEN ARRAY['FAKE!'] ELSE b.areatype END) areatype_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bin = b.bin
	WHERE
		a.facilitysubgroup = b.facilitysubgroup
		AND a.facilitygroup <> 'Child Care and Pre-Kindergarten'
	    AND a.pgtable <> ARRAY['dcas_facilities_colp']
	    AND b.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bin IS NOT NULL
		AND b.bin IS NOT NULL
		AND a.bin <> ARRAY['']
		AND b.bin <> ARRAY['']
		AND a.bin <> ARRAY['0.00000000000']
		AND b.bin <> ARRAY['0.00000000000']
		AND
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(a.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
			LIKE
			LEFT(
				TRIM(
					split_part(
				REPLACE(
					REPLACE(
				REPLACE(
					REPLACE(
				REPLACE(
					UPPER(b.facilityname)
				,'THE ','')
					,'-','')
				,' ','')
					,'.','')
				,',','')
					,'(',1)
				,' ')
			,4)
		AND a.pgtable <> b.pgtable
		AND a.hash <> b.hash
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
	),

duplicates AS (
	SELECT
		count(*) AS countofdups,
		hash,
		array_agg(uid_b) AS uid_merged,
		array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct datesourceupdated_b) AS datesourceupdated,
		array_agg(distinct linkdata_b) AS linkdata,
		array_agg(distinct oversightlevel_b) AS oversightlevel,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		array_agg(capacity_b) AS capacity,
		array_agg(distinct capacitytype_b) AS capacitytype,
		array_agg(utilization_b) AS utilization,
		array_agg(area_b) AS area,
		array_agg(distinct areatype_b) AS areatype,
		sourcecombo
	FROM matches
	WHERE
		(sourcecombo LIKE '{nysoasas_facilities_programs}-{hhs_facilities_%' AND facilitysubgroup = 'Chemical Dependency')
		OR (sourcecombo LIKE '{dycd_facilities_otherprograms}-{hhs_facilities_%')
		OR (sourcecombo LIKE '{hhs_facilities_financials}-{hhs_facilities_proposals}')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysparks_facilities_historicplaces}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo LIKE '{nysparks_facilities_historicplaces}-{usnps_facilities_parks}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo LIKE '{nysomh_facilities_mentalhealth}-{hhs_facilities_%' AND facilitysubgroup = 'Mental Health')
		OR (sourcecombo LIKE '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' AND facilitysubgroup = 'Museums')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{dcp_facilities_sfpsd}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysparks_facilities_parks}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysdec_facilities_lands}')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Preserves and Conservation Areas')
		OR (sourcecombo LIKE '{nysopwdd_facilities_providers}-{hhs_facilities_%' AND facilitysubgroup = 'Programs for People with Disabilities')
		OR (sourcecombo LIKE '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Residential Health Care')
		OR (sourcecombo LIKE '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Hospitals and Clinics')
		OR (sourcecombo LIKE '{dfta_facilities_contracts}-{hhs_facilities_%' AND facilitysubgroup = 'Senior Services')
		OR (sourcecombo LIKE '{dpr_parksproperties}-{dot_facilities_pedplazas}' AND facilitysubgroup = 'Streetscapes, Plazas, and Malls')
		OR (sourcecombo LIKE '{dhs_facilities_shelters}-{hhs_facilities_%' AND facilitysubgroup = 'Shelters and Transitional Housing')
		OR (sourcecombo LIKE '{dca_facilities_operatingbusinesses}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Solid Waste Processing')
		OR (sourcecombo LIKE '{nysdec_facilities_solidwaste}-{bic_facilities_tradewaste}')
	GROUP BY
	hash, sourcecombo, facilitysubgroup
	ORDER BY countofdups DESC )

UPDATE facilities AS f
SET
	idagency = 
		(CASE
			WHEN d.idagency_merged <> ARRAY['FAKE!'] THEN array_cat(idagency, d.idagency_merged)
			ELSE idagency
		END),
	uid_merged = d.uid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	agencysource = array_cat(f.agencysource,d.agencysource),
	sourcedatasetname = array_cat(f.sourcedatasetname, d.sourcedatasetname),
	datesourceupdated = array_cat(f.datesourceupdated, d.datesourceupdated),
	linkdata = array_cat(f.linkdata, d.linkdata),
	capacity = (CASE WHEN d.capacity <> ARRAY['FAKE!'] THEN array_cat(f.capacity, d.capacity) END),
	capacitytype = (CASE WHEN d.capacitytype <> ARRAY['FAKE!'] THEN array_cat(f.capacitytype, d.capacitytype) END),
	utilization = (CASE WHEN d.utilization <> ARRAY['FAKE!'] THEN array_cat(f.utilization, d.utilization) END),
	area = (CASE WHEN d.area <> ARRAY['FAKE!'] THEN array_cat(f.area, d.area) END),
	areatype = (CASE WHEN d.areatype <> ARRAY['FAKE!'] THEN array_cat(f.areatype, d.areatype) END),	
	oversightagency = 
		(CASE
			WHEN sourcecombo NOT LIKE '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' THEN array_cat(f.oversightagency, d.oversightagency)
			ELSE f.oversightagency
		END),
	oversightabbrev =
		(CASE
			WHEN sourcecombo NOT LIKE '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' THEN array_cat(f.oversightabbrev, d.oversightabbrev)
			ELSE f.oversightabbrev
		END),
	oversightlevel =
		(CASE
			WHEN sourcecombo NOT LIKE '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' THEN array_cat(f.oversightlevel, d.oversightlevel)
			ELSE f.oversightlevel
		END)
FROM duplicates AS d
WHERE f.hash = d.hash
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.hash IN (SELECT duplicates_remaining.hash FROM duplicates_remaining)
;

