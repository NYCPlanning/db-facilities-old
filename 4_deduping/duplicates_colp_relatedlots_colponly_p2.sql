-- Reconcile duplicate records in COLP

-- Finding duplicate records
CREATE VIEW duplicates AS
WITH primaries AS (
	SELECT
		min(uid) as minuid,
		count(*),
		facname,
		factype,
		overagency
	FROM facilities
	WHERE
		pgtable = 'dcas_facilities_colp'
		AND geom IS NOT NULL
		AND (facname = 'Unnamed'
		OR facname = 'No Use-Vacant Land'
		OR facname = 'No Use'
		OR facname = 'City Owned Property'
		OR facname = 'Park'
		OR facname = 'Office Bldg'
		OR facname = 'Office'
		OR facname = 'Park Strip'
		OR facname = 'Playground'
		OR facname = 'NYPD Parking'
		OR facname = 'Multi-Service Center'
		OR facname = 'Animal Shelter'
		OR facname = 'Garden'
		OR facname = 'L.U.W'
		OR facname = 'Long Term Tenant: NYCHA'
		OR facname = 'Help Social Service Corporation'
		OR facname = 'Day Care Center'
		OR facname = 'Safety City Site'
		OR facname = 'Public Place'
		OR facname = 'Sanitation Garage'
		OR facname = 'MTA Bus Depot'
		OR facname = 'Mta Bus Depot'
		OR facname = 'Mall'
		OR facname = 'Vest Pocket Park'
		OR facname = 'Pier 6'
		OR overabbrev = 'NYCDOE')
	GROUP BY
		facname,
		factype,
		overagency)

	SELECT
		a.minuid,
		b.*
	FROM primaries AS a
	INNER JOIN facilities AS b
	ON
		a.facname = b.facname
	WHERE
		b.pgtable = 'dcas_facilities_colp'
		AND a.factype = b.factype
		AND a.overagency = b.overagency
		AND b.geom IS NOT NULL
		AND count > 1;

-- Inserting values into relational tables
WITH distincts AS(
	SELECT DISTINCT minuid, bbl
	FROM duplicates
	WHERE bbl IS NOT NULL)

	INSERT INTO facdb_bbl
	SELECT minuid, bbl
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, bin
	FROM duplicates
	WHERE bin IS NOT NULL)

	INSERT INTO facdb_bin
	SELECT minuid, bin
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, idagency, idname, idfield, pgtable
	FROM duplicates
	WHERE idagency IS NOT NULL)

	INSERT INTO facdb_agencyid
	SELECT minuid, idagency, idname, idfield, pgtable
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, area, areatype
	FROM duplicates
	WHERE area IS NOT NULL)

	INSERT INTO facdb_area
	SELECT minuid, area, areatype
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, capacity, capacitytype
	FROM duplicates
	WHERE capacity IS NOT NULL)

	INSERT INTO facdb_capacity
	SELECT minuid, capacity, capacitytype
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, hash
	FROM duplicates
	WHERE hash IS NOT NULL)

	INSERT INTO facdb_hashes
	SELECT minuid, hash
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, overagency, overabbrev, overlevel
	FROM duplicates
	WHERE overagency IS NOT NULL)

	INSERT INTO facdb_oversight
	SELECT minuid, overagency, overabbrev, overlevel
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, pgtable
	FROM duplicates
	WHERE pgtable IS NOT NULL)

	INSERT INTO facdb_pgtable
	SELECT minuid, pgtable
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, uid
	FROM duplicates
	WHERE uid IS NOT NULL)

	INSERT INTO facdb_uidsmerged
	SELECT minuid, uid
	FROM distincts;

WITH distincts AS(
	SELECT DISTINCT minuid, util, capacitytype
	FROM duplicates
	WHERE util IS NOT NULL)

	INSERT INTO facdb_utilization
	SELECT minuid, util, capacitytype
	FROM distincts;

-- Deleting duplicate records
DELETE FROM facilities USING duplicates
WHERE facilities.uid = duplicates.uid
AND duplicates.uid<>duplicates.minuid;

-- Dropping duplicate records
DROP VIEW IF EXISTS duplicates;