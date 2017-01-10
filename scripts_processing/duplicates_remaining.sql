--------------------------------------------------------------------------------------------------
-- 1. CREATING A TABLE TO BACKUP THE DUPLICATE RECORDS BEFORE DROPPING THEM FROM THE DATABASE
--------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS duplicates_remaining;
CREATE TABLE duplicates_remaining AS (

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.guid,
		b.guid as guid_b,
		a.facilitysubgroup
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facilitysubgroup = b.facilitysubgroup
		AND a.facilitygroup <> 'Child Care and Pre-Kindergarten'
	    AND a.pgtable <> ARRAY['dcas_facilities_colp']
	    AND b.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> '{""}'
		AND b.bbl <> '{""}'
		AND a.bbl <> '{0.00000000000}'
		AND b.bbl <> '{0.00000000000}'
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
		AND a.guid <> b.guid
		AND a.id <> b.id
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilitysubgroup
	),  

duplicates AS (
	SELECT
		guid,
		array_agg(guid_b) AS guid_merged
	FROM matches
	WHERE
		(sourcecombo = '{nysoasas_facilities_programs}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Chemical Dependency')
		OR (sourcecombo = '{dpr_parksproperties}-{nysparks_facilities_historicplaces}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo = '{nysparks_facilities_historicplaces}-{usnps_facilities_parks}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo = '{nysomh_facilities_mentalhealth}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Mental Health')
		OR (sourcecombo = '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' AND facilitysubgroup = 'Museums')
		OR (sourcecombo = '{dpr_parksproperties}-{dcp_facilities_sfpsd}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo = '{dpr_parksproperties}-{nysparks_facilities_parks}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo = '{dpr_parksproperties}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Preserves and Conservation Areas')
		OR (sourcecombo = '{nysopwdd_facilities_providers}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Programs for People with Disabilities')
		OR (sourcecombo = '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Residential Health Care')
		OR (sourcecombo = '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Hospitals and Clinics')
		OR (sourcecombo = '{dfta_facilities_contracts}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Senior Services')
		OR (sourcecombo = '{dca_facilities_operatingbusinesses}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Solid Waste Processing')
		OR (sourcecombo = '{dpr_parksproperties}-{dot_facilities_pedplazas}' AND facilitysubgroup = 'Streetscapes, Plazas, and Malls')
		OR (sourcecombo = '{dhs_facilities_shelters}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Shelters and Transitional Housing')
		OR (sourcecombo = '{dca_facilities_operatingbusinesses}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Solid Waste Processing')
	GROUP BY
	guid, sourcecombo, facilitysubgroup
	ORDER BY facilitysubgroup)

SELECT facilities.*
FROM facilities
WHERE
	facilities.guid IN (SELECT unnest(duplicates.guid_merged) FROM duplicates)
	AND facilities.guid NOT IN (SELECT duplicates.guid FROM duplicates)
ORDER BY guid

);

--------------------------------------------------------------------------------------------------
-- 2. UPDATING FACDB BY MERGING ATTRIBUTES FROM DUPLICATE RECORDS INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

WITH matches AS (
	SELECT
		CONCAT(a.pgtable,'-',b.pgtable) as sourcecombo,
		a.id,
		b.id as id_b,
		a.idagency,
		b.idagency as idagency_b,
		a.guid,
		b.guid as guid_b,
		a.hash,
		b.hash as hash_b,
		a.facilityname,
		b.facilityname as facilityname_b,
		a.facilitysubgroup,
		b.facilitysubgroup as facilitysubgroup_b,
		a.processingflag,
		b.processingflag as processingflag_b,
		a.bbl,
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
		a.oversightagency,
		b.oversightagency as oversightagency_b,
		a.oversightabbrev,
		b.oversightabbrev as oversightabbrev_b
		-- a.propertytype,
		-- b.propertytype as propertytype_b
	FROM facilities a
	LEFT JOIN facilities b
	ON a.bbl = b.bbl
	WHERE
		a.facilitysubgroup = b.facilitysubgroup
		AND a.facilitygroup <> 'Child Care and Pre-Kindergarten'
	    AND a.pgtable <> ARRAY['dcas_facilities_colp']
	    AND b.pgtable <> ARRAY['dcas_facilities_colp']
		AND a.geom IS NOT NULL
		AND b.geom IS NOT NULL
		AND a.bbl IS NOT NULL
		AND b.bbl IS NOT NULL
		AND a.bbl <> '{""}'
		AND b.bbl <> '{""}'
		AND a.bbl <> '{0.00000000000}'
		AND b.bbl <> '{0.00000000000}'
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
		AND a.guid <> b.guid
		AND a.id <> b.id
		ORDER BY CONCAT(a.pgtable,'-',b.pgtable), a.facilityname, a.facilitysubgroup
	),

duplicates AS (
	SELECT
		count(*) AS countofdups,
		-- array_agg(distinct bin_b) AS BIN,
		guid,
		array_agg(guid_b) AS guid_merged,
		--array_agg(distinct idagency_b) AS idagency_merged,
		array_agg(distinct hash_b) AS hash_merged,
		array_agg(distinct agencysource_b) AS agencysource,
		array_agg(distinct sourcedatasetname_b) AS sourcedatasetname,
		array_agg(distinct oversightagency_b) AS oversightagency,
		array_agg(distinct oversightabbrev_b) AS oversightabbrev,
		array_agg(distinct pgtable_b) AS pgtable,
		sourcecombo
		-- array_agg(distinct propertytype_b) as propertytype
	FROM matches
	WHERE
		(sourcecombo = '{nysoasas_facilities_programs}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Chemical Dependency')
		OR (sourcecombo = '{dpr_parksproperties}-{nysparks_facilities_historicplaces}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo = '{nysparks_facilities_historicplaces}-{usnps_facilities_parks}' AND facilitysubgroup = 'Historical Sites')
		OR (sourcecombo = '{nysomh_facilities_mentalhealth}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Mental Health')
		OR (sourcecombo = '{dcla_facilities_culturalinstitutions}-{nysed_facilities_activeinstitutions}' AND facilitysubgroup = 'Museums')
		OR (sourcecombo = '{dpr_parksproperties}-{dcp_facilities_sfpsd}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo = '{dpr_parksproperties}-{nysparks_facilities_parks}' AND facilitysubgroup = 'Parks')
		OR (sourcecombo = '{dpr_parksproperties}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Preserves and Conservation Areas')
		OR (sourcecombo = '{nysopwdd_facilities_providers}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Programs for People with Disabilities')
		OR (sourcecombo = '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Residential Health Care')
		OR (sourcecombo = '{nysdoh_facilities_healthfacilities}-{hhc_facilities_hospitals}' AND facilitysubgroup = 'Hospitals and Clinics')
		OR (sourcecombo = '{dfta_facilities_contracts}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Senior Services')
		OR (sourcecombo = '{dca_facilities_operatingbusinesses}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Solid Waste Processing')
		OR (sourcecombo = '{dpr_parksproperties}-{dot_facilities_pedplazas}' AND facilitysubgroup = 'Streetscapes, Plazas, and Malls')
		OR (sourcecombo = '{dhs_facilities_shelters}-{hhs_facilities_acceleratorall}' AND facilitysubgroup = 'Shelters and Transitional Housing')
		OR (sourcecombo = '{dca_facilities_operatingbusinesses}-{nysdec_facilities_solidwaste}' AND facilitysubgroup = 'Solid Waste Processing')
	GROUP BY
	guid, sourcecombo, facilitysubgroup
	ORDER BY countofdups DESC )

UPDATE facilities AS f
SET
	-- BIN = d.BIN,
	-- idagency = array_cat(idagency, d.idagency_merged),
	guid_merged = d.guid_merged,
	hash_merged = d.hash_merged,
	pgtable = array_cat(f.pgtable,d.pgtable),
	sourcedatasetname = array_cat(f.sourcedatasetname, d.sourcedatasetname),
	oversightagency = 
		(CASE
			WHEN split_part(sourcecombo,'-',2) <> '{nysed_facilities_activeinstitutions}' THEN array_cat(f.oversightagency, d.oversightagency)
		END),
	oversightabbrev =
		(CASE
			WHEN split_part(sourcecombo,'-',2) <> '{nysed_facilities_activeinstitutions}' THEN array_cat(f.oversightabbrev, d.oversightabbrev)
		END)
	-- propertytype =
	-- 	(CASE
	-- 		WHEN split_part(sourcecombo,'-',2) = '{dcas_facilities_colp}' THEN d.propertytype
	-- 	END)
FROM duplicates AS d
WHERE f.guid = d.guid
;

--------------------------------------------------------------------------------------------------
-- 3. DROPPING DUPLICATE RECORDS AFTER ATTRIBUTES HAVE BEEN MERGED INTO PREFERRED RECORD
--------------------------------------------------------------------------------------------------

DELETE FROM facilities
WHERE facilities.guid IN (SELECT duplicates_remaining.guid FROM duplicates_remaining)
;

