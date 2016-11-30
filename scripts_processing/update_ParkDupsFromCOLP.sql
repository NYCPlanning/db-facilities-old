UPDATE facilities
SET
	colpusetype = 

FROM	
WHERE guid IN (
	SELECT facilities.guid
	FROM facilities, dpr_parksproperties
	WHERE
		ST_Intersects(facilities.geom, dpr_parksproperties.geom)
		AND facilities.agencysource = 'NYCDCAS'
		AND facilities.operatorabbrev = 'NYCDPR'
		AND (facilities.facilitysubgroup = 'Preserves and Conservation Areas'
		OR facilities.facilitysubgroup = 'Streetscapes, Plazas, and Malls'
		OR facilities.facilitysubgroup = 'Undeveloped or No Use'
		OR facilities.facilitysubgroup = 'Cemeteries'
		OR facilities.facilitysubgroup = 'Recreation and Waterfront Sites'
		OR facilities.facilitysubgroup = 'Historical Sites'
		OR facilities.facilitysubgroup = 'Parking'
		OR facilities.facilitysubgroup = 'Parks'
		OR facilities.facilitysubgroup = 'Gardens')
	)