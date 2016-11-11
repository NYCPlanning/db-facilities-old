INSERT INTO
facilities (
	id,
	idold,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	city,
	borough,
	boroughcode,
	zipcode,
	bbl,
	bin,
	parkid,
	xcoord,
	ycoord,
	latitude,
	longitude,
	facilitytype,
	domain,
	facilitygroup,
	facilitysubgroup,
	agencyclass1,
	agencyclass2,
	colpusetype,
	capacity,
	utilization,
	capacitytype,
	utilizationrate,
	area,
	areatype,
	servicearea,
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	dateactive,
	dateinactive,
	inactivestatus,
	tags,
	notes,
	datesourcereceived,
	datesourceupdated,
	datecreated,
	dateedited,
	creator,
	editor,
	geom,
	agencysource,
	sourcedatasetname,
	linkdata,
	linkdownload,
	datatype,
	refreshmeans,
	refreshfrequency,
	buildingid,
	buildingname,
	schoolorganizationlevel,
	children,
	youth,
	senior,
	family,
	disabilities,
	dropouts,
	unemployed,
	homeless,
	immigrants,
	groupquarters
)
SELECT
	-- id
	NULL,
	-- idold
	NULL,
	-- idagency
	NULL,
	-- facilityname
		(CASE
			WHEN parcel_name <> ' ' THEN initcap(Parcel_Name)
			ELSE 'Unnamed'
		END),
	-- addressnumber
	initcap(house_number),
	-- streetname
	initcap(street_name),
	-- address
		(CASE
			WHEN house_number IS NOT NULL
				AND house_number <> ' '
				THEN initcap(CONCAT(house_number,' ',street_name))
		END),
	-- city
	NULL,
	-- borough
	initcap(Borough),
	-- boroughcode
		(CASE
			WHEN borough = 'MANHATTAN' THEN 1
			WHEN borough = 'BRONX' THEN 2
			WHEN borough = 'BROOKLYNK' THEN 3
			WHEN borough = 'QUEENS' THEN 4
			WHEN borough = 'STATEN ISLAND' THEN 5
		END),
	-- zipcode
	NULL,
	-- bbl
	ARRAY[BBL::text],
	-- bin
	NULL,
	-- parkid
	NULL,
	-- xcoord
	(CASE
		WHEN xcoord <> ' ' THEN xcoord::numeric
	END),
	-- ycoord
	(CASE
		WHEN xcoord <> ' ' THEN ycoord::numeric
	END),
	-- latitude
	(CASE
		WHEN xcoord <> ' ' THEN ST_Y(ST_Transform(ST_SetSRID(ST_MakePoint(xcoord::numeric, ycoord::numeric),2263),4326))
	END),
	-- longitude
	(CASE
		WHEN xcoord <> ' ' THEN ST_X(ST_Transform(ST_SetSRID(ST_MakePoint(xcoord::numeric, ycoord::numeric),2263),4326))
	END),
	-- facilitytype
	initcap(use_type),
	-- domain

(CASE
			-- Admin of Gov
			WHEN use_type LIKE '%AGREEMENT%'
				OR use_type LIKE '%DISPOSITION%'
				OR use_type LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Administration of Government'
			WHEN use_type LIKE '%SECURITY%' THEN 'Administration of Government'
			WHEN (use_type LIKE '%PARKING%'
				OR use_type LIKE '%PKNG%')
				AND use_type NOT LIKE '%MUNICIPAL%'
				THEN 'Administration of Government'
			WHEN use_type LIKE '%STORAGE%' OR use_type LIKE '%STRG%' THEN 'Administration of Government'
			WHEN use_type LIKE '%CUSTODIAL%' THEN 'Administration of Government'
			WHEN use_type LIKE '%GARAGE%' THEN 'Administration of Government'
			WHEN use_type LIKE '%OFFICE%' THEN 'Administration of Government'
			WHEN use_type LIKE '%MAINTENANCE%' THEN 'Administration of Government'
			WHEN use_type LIKE '%NO USE%' THEN 'Administration of Government'
			WHEN use_type LIKE '%MISCELLANEOUS USE%' THEN 'Administration of Government'
			WHEN use_type LIKE '%OTHER HEALTH%' AND parcel_name LIKE '%ANIMAL%' THEN 'Administration of Government'
			WHEN agency LIKE '%DCA%' and use_type LIKE '%OTHER%' THEN 'Administration of Government'
			WHEN use_type LIKE '%UNDEVELOPED%' THEN 'Administration of Government'
			WHEN (use_type LIKE '%TRAINING%' 
				OR use_type LIKE '%TESTING%')
				AND use_type NOT LIKE '%LABORATORY%'
				THEN 'Administration of Government'


			-- Trans and Infra
			WHEN use_type LIKE '%MUNICIPAL PARKING%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%MARKET%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%MATERIAL PROCESSING%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%ASPHALT%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%AIRPORT%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%ROAD/HIGHWAY%'
				OR use_type LIKE '%TRANSIT WAY%'
				OR use_type LIKE '%OTHER TRANSPORTATION%'
				THEN 'Core Infrastructure and Transportation'
			WHEN agency LIKE '%DEP%'
				AND (use_type LIKE '%WATER SUPPLY%'
				OR use_type LIKE '%RESERVOIR%'
				OR use_type LIKE '%AQUEDUCT%')
				THEN 'Core Infrastructure and Transportation'
			WHEN agency LIKE '%DEP%'
				AND use_type NOT LIKE '%NATURE AREA%'
				AND use_type NOT LIKE '%NATURAL AREA%'
				AND use_type NOT LIKE '%OPEN SPACE%'
				THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%WASTEWATER%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%LANDFILL%' 
				OR use_type LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND use_type LIKE '%SANITATION SECTION%')
				THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%ANTENNA%' OR use_type LIKE '%TELE/COMP%' THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%PIER - MARITIME%'
				OR use_type LIKE '%FERRY%' 
				OR use_type LIKE '%WATERFRONT TRANSPORTATION%'
				OR use_type LIKE '%MARINA%'
				THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%RAIL%'
				OR (use_type LIKE '%TRANSIT%'
					AND use_type NOT LIKE '%TRANSITIONAL%')
				THEN 'Core Infrastructure and Transportation'
			WHEN use_type LIKE '%BUS%' THEN 'Core Infrastructure and Transportation'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Health and Human Services'
			WHEN use_type LIKE '%HOSPITAL%' THEN 'Health and Human Services'
			WHEN use_type LIKE '%AMBULATORY HEALTH%' THEN 'Health and Human Services'
			WHEN agency LIKE '%OCME%' THEN 'Health and Human Services'
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%HOUSING%' THEN 'Health and Human Services'
			WHEN agency LIKE '%AGING%' THEN 'Health and Human Services'
			WHEN agency LIKE '%DHS%' THEN 'Health and Human Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND use_type LIKE '%RESIDENTIAL%'
				THEN 'Health and Human Services'
			WHEN use_type LIKE '%COMMUNITY CENTER%' THEN 'Health and Human Services'

			-- Parks, Cultural
			WHEN use_type LIKE '%LIBRARY%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%MUSEUM%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%CULTURAL%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%ZOO%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%CEMETERY%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN agency LIKE '%CULT%' AND use_type LIKE '%MUSEUM%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN agency LIKE '%CULT%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%NATURAL AREA%'
				OR (use_type LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%BOTANICAL GARDENS%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%GARDEN%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%PARK%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%PLAZA%'
				OR use_type LIKE '%SITTING AREA%' 
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%PLAYGROUND%'
				OR use_type LIKE '%SPORTS%'
				OR use_type LIKE '%TENNIS COURT%'
				OR (use_type LIKE '%RECREATION%'
					AND agency NOT LIKE '%ACS%')
				OR use_type LIKE '%BEACH%'
				OR use_type LIKE '%PLAYING FIELD%'
				OR use_type LIKE '%GOLF COURSE%'
				OR use_type LIKE '%POOL%'
				OR use_type LIKE '%STADIUM%'
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN agency LIKE '%PARKS%'
				AND use_type LIKE '%OPEN SPACE%'
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN use_type LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Parks, Cultural, and Other Community Facilities'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%DETENTION%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%CORR%' AND use_type LIKE '%COURT%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%CORR%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%COURT%' AND use_type LIKE '%COURT%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN use_type LIKE '%AMBULANCE%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN use_type LIKE '%EMERGENCY MEDICAL%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN use_type LIKE '%FIREHOUSE%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN use_type LIKE '%POLICE STATION%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN use_type LIKE '%PUBLIC SAFETY%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%OCME%' THEN 'Public Safety, Emergency Services, and Administration of Justice'

			-- Education, Children, Youth
			WHEN use_type LIKE '%UNIVERSITY%' THEN 'Education, Child Welfare, and Youth'
			WHEN use_type LIKE '%EARLY CHILDHOOD%' THEN 'Education, Child Welfare, and Youth'
			WHEN use_type LIKE '%DAY CARE%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%RESIDENTIAL%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%ACS%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%EDUC%' and use_type LIKE '%PLAY AREA%' THEN 'Education, Child Welfare, and Youth'
			WHEN use_type LIKE '%HIGH SCHOOL%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%CUNY%' THEN 'Education, Child Welfare, and Youth'
			WHEN AGENCY LIKE '%EDUC%' AND use_type LIKE '%SCHOOL%' THEN 'Education, Child Welfare, and Youth'
			WHEN use_type LIKE '%EDUCATIONAL SKILLS%' THEN 'Education, Child Welfare, and Youth'

			ELSE 'Administration of Government'
		END),


	-- facilitygroup
		(CASE
			-- Admin of Gov
			WHEN use_type LIKE '%AGREEMENT%'
				OR use_type LIKE '%DISPOSITION%'
				OR use_type LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Other Property'
			WHEN use_type LIKE '%SECURITY%' THEN 'Other Property'
			WHEN (use_type LIKE '%PARKING%'
				OR use_type LIKE '%PKNG%')
				AND use_type NOT LIKE '%MUNICIPAL%'
				THEN 'Parking, Maintenance, and Storage'
			WHEN use_type LIKE '%STORAGE%' OR use_type LIKE '%STRG%' THEN 'Parking, Maintenance, and Storage'
			WHEN use_type LIKE '%CUSTODIAL%' THEN 'Parking, Maintenance, and Storage'
			WHEN use_type LIKE '%GARAGE%' THEN 'Parking, Maintenance, and Storage'
			WHEN use_type LIKE '%OFFICE%' THEN 'Offices, Training, and Testing'
			WHEN use_type LIKE '%MAINTENANCE%' THEN 'Parking, Maintenance, and Storage'
			WHEN use_type LIKE '%NO USE%' THEN 'Other Property'
			WHEN use_type LIKE '%MISCELLANEOUS USE%' THEN 'Other Property'
			WHEN use_type LIKE '%OTHER HEALTH%' AND parcel_name LIKE '%ANIMAL%' THEN 'Other Property'
			WHEN agency LIKE '%DCA%' and use_type LIKE '%OTHER%' THEN 'Other Property'
			WHEN use_type LIKE '%UNDEVELOPED%' THEN 'Other Property'
			WHEN (use_type LIKE '%TRAINING%' 
				OR use_type LIKE '%TESTING%')
				AND use_type NOT LIKE '%LABORATORY%'
				THEN 'Offices, Training, and Testing'


			-- Trans and Infra
			WHEN use_type LIKE '%MUNICIPAL PARKING%' THEN 'Transportation'
			WHEN use_type LIKE '%MARKET%' THEN 'Material Supplies and Markets'
			WHEN use_type LIKE '%MATERIAL PROCESSING%' THEN 'Material Supplies and Markets'
			WHEN use_type LIKE '%ASPHALT%' THEN 'Material Supplies and Markets'
			WHEN use_type LIKE '%AIRPORT%' THEN 'Transportation'
			WHEN use_type LIKE '%ROAD/HIGHWAY%'
				OR use_type LIKE '%TRANSIT WAY%'
				OR use_type LIKE '%OTHER TRANSPORTATION%'
				THEN 'Transportation'
			WHEN agency LIKE '%DEP%'
				AND (use_type LIKE '%WATER SUPPLY%'
				OR use_type LIKE '%RESERVOIR%'
				OR use_type LIKE '%AQUEDUCT%')
				THEN 'Water and Wastewater'
			WHEN agency LIKE '%DEP%'
				AND use_type NOT LIKE '%NATURAL AREA%'
				AND use_type NOT LIKE '%NATURE AREA%'
				AND use_type NOT LIKE '%OPEN SPACE%'
				THEN 'Water and Wastewater'
			WHEN use_type LIKE '%WASTEWATER%' THEN 'Water and Wastewater'
			WHEN use_type LIKE '%LANDFILL%' 
				OR use_type LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Solid Waste'
			WHEN use_type LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND use_type LIKE '%SANITATION SECTION%')
				THEN 'Solid Waste'
			WHEN use_type LIKE '%ANTENNA%' OR use_type LIKE '%TELE/COMP%' THEN 'Telecommunications'
			WHEN use_type LIKE '%PIER - MARITIME%'
				OR use_type LIKE '%FERRY%' 
				OR use_type LIKE '%WATERFRONT TRANSPORTATION%'
				OR use_type LIKE '%MARINA%'
				THEN 'Transportation'
			WHEN use_type LIKE '%RAIL%'
				OR (use_type LIKE '%TRANSIT%'
					AND use_type NOT LIKE '%TRANSITIONAL%')
				THEN 'Transportation'
			WHEN use_type LIKE '%BUS%' THEN 'Transportation'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Health Care'
			WHEN use_type LIKE '%HOSPITAL%' THEN 'Health Care'
			WHEN use_type LIKE '%AMBULATORY HEALTH%' THEN 'Health Care'
			WHEN agency LIKE '%OCME%' THEN 'Health Care'
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%HOUSING%' THEN 'Human Services'
			WHEN agency LIKE '%AGING%' THEN 'Human Services'
			WHEN agency LIKE '%DHS%' THEN 'Human Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND use_type LIKE '%RESIDENTIAL%'
				THEN 'Human Services'
			WHEN use_type LIKE '%COMMUNITY CENTER%' THEN 'Human Services'

			-- Parks, Cultural
			WHEN use_type LIKE '%LIBRARY%' THEN 'Libraries'
			WHEN use_type LIKE '%MUSEUM%' THEN 'Cultural Institutions'
			WHEN use_type LIKE '%CULTURAL%' THEN 'Cultural Institutions'
			WHEN use_type LIKE '%ZOO%' THEN 'Cultural Institutions'
			WHEN use_type LIKE '%CEMETERY%' THEN 'Parks and Plazas'
			WHEN agency LIKE '%CULT%' AND use_type LIKE '%MUSEUM%' THEN 'Cultural Institutions'
			WHEN agency LIKE '%CULT%' THEN 'Cultural Institutions'
			WHEN use_type LIKE '%NATURAL AREA%'
				OR (use_type LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Parks and Plazas'
			WHEN use_type LIKE '%BOTANICAL GARDENS%' THEN 'Cultural Institutions'
			WHEN use_type LIKE '%GARDEN%' THEN 'Parks and Plazas'
			WHEN use_type LIKE '%PARK%' THEN 'Parks and Plazas'
			WHEN use_type LIKE '%PLAZA%'
				OR use_type LIKE '%SITTING AREA%' 
				THEN 'Parks and Plazas'
			WHEN use_type LIKE '%PLAYGROUND%'
				OR use_type LIKE '%SPORTS%'
				OR use_type LIKE '%TENNIS COURT%'
				OR (use_type LIKE '%RECREATION%'
					AND agency NOT LIKE '%ACS%')
				OR use_type LIKE '%BEACH%'
				OR use_type LIKE '%PLAYING FIELD%'
				OR use_type LIKE '%GOLF COURSE%'
				OR use_type LIKE '%POOL%'
				OR use_type LIKE '%STADIUM%'
				THEN 'Parks and Plazas'
			WHEN agency LIKE '%PARKS%'
				AND use_type LIKE '%OPEN SPACE%'
				THEN 'Parks and Plazas'
			WHEN use_type LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Cultural Institutions'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%DETENTION%' THEN 'Justice and Corrections'
			WHEN agency LIKE '%CORR%' AND use_type LIKE '%COURT%' THEN 'Justice and Corrections'
			WHEN agency LIKE '%CORR%' THEN 'Justice and Corrections'
			WHEN agency LIKE '%COURT%' AND use_type LIKE '%COURT%' THEN 'Justice and Corrections'
			WHEN use_type LIKE '%AMBULANCE%' THEN 'Emergency Services'
			WHEN use_type LIKE '%EMERGENCY MEDICAL%' THEN 'Emergency Services'
			WHEN use_type LIKE '%FIREHOUSE%' THEN 'Emergency Services'
			WHEN use_type LIKE '%POLICE STATION%' THEN 'Public Safety'
			WHEN use_type LIKE '%PUBLIC SAFETY%' THEN 'Public Safety'
			WHEN agency LIKE '%OCME%' THEN 'Justice and Corrections'

			-- Education, Children, Youth
			WHEN use_type LIKE '%UNIVERSITY%' THEN 'Higher Education'
			WHEN use_type LIKE '%EARLY CHILDHOOD%' THEN 'Schools'
			WHEN use_type LIKE '%DAY CARE%' THEN 'Childcare'
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%RESIDENTIAL%' THEN 'Childrens Services'
			WHEN agency LIKE '%ACS%' THEN 'Childcare'
			WHEN agency LIKE '%EDUC%' and use_type LIKE '%PLAY AREA%' THEN 'Schools'
			WHEN use_type LIKE '%HIGH SCHOOL%' THEN 'Schools'
			WHEN agency LIKE '%CUNY%' THEN 'Higher Education and Adult Education'
			WHEN AGENCY LIKE '%EDUC%' AND use_type LIKE '%SCHOOL%' THEN 'Schools'
			WHEN use_type LIKE '%EDUCATIONAL SKILLS%' THEN 'Schools'

			ELSE 'Other Property'
		END),

	-- facilitysubgroup
		(CASE
			-- Admin of Gov
			WHEN use_type LIKE '%AGREEMENT%'
				OR use_type LIKE '%DISPOSITION%'
				OR use_type LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Properties Leased or Licensed to Non-public Entities'
			WHEN use_type LIKE '%SECURITY%' THEN 'Miscellaneous Use'
			WHEN (use_type LIKE '%PARKING%'
				OR use_type LIKE '%PKNG%')
				AND use_type NOT LIKE '%MUNICIPAL%'
				THEN 'Parking'
			WHEN use_type LIKE '%STORAGE%' OR use_type LIKE '%STRG%' THEN 'Storage'
			WHEN use_type LIKE '%CUSTODIAL%' THEN 'Custodial'
			WHEN use_type LIKE '%GARAGE%' THEN 'Maintenance and Garages'
			WHEN use_type LIKE '%OFFICE%' THEN 'Offices'
			WHEN use_type LIKE '%MAINTENANCE%' THEN 'Maintenance and Garages'
			WHEN use_type LIKE '%NO USE%' THEN 'Undeveloped or No Use'
			WHEN use_type LIKE '%MISCELLANEOUS USE%' THEN 'Miscellaneous Use'
			WHEN use_type LIKE '%OTHER HEALTH%' AND parcel_name LIKE '%ANIMAL%' THEN 'Miscellaneous Use'
			WHEN agency LIKE '%DCA%' and use_type LIKE '%OTHER%' THEN 'Miscellaneous Use'
			WHEN use_type LIKE '%UNDEVELOPED%' THEN 'Undeveloped or No Use'
			WHEN (use_type LIKE '%TRAINING%' 
				OR use_type LIKE '%TESTING%')
				AND use_type NOT LIKE '%LABORATORY%'
				THEN 'Training and Testing'

			-- Trans and Infra
			WHEN use_type LIKE '%MUNICIPAL PARKING%' THEN 'Public Parking Lots and Garages'
			WHEN use_type LIKE '%MARKET%' THEN 'Wholesale Markets'
			WHEN use_type LIKE '%MATERIAL PROCESSING%' THEN 'Material Supplies'
			WHEN use_type LIKE '%ASPHALT%' THEN 'Material Supplies'
			WHEN use_type LIKE '%AIRPORT%' THEN 'Airports and Heliports'
			WHEN use_type LIKE '%ROAD/HIGHWAY%'
				OR use_type LIKE '%TRANSIT WAY%'
				OR use_type LIKE '%OTHER TRANSPORTATION%'
				THEN 'Other Transportation'
			WHEN agency LIKE '%DEP%'
				AND (use_type LIKE '%WATER SUPPLY%'
				OR use_type LIKE '%RESERVOIR%'
				OR use_type LIKE '%AQUEDUCT%')
				THEN 'Water Supply'
			WHEN agency LIKE '%DEP%'
				AND use_type NOT LIKE '%NATURE AREA%'
				AND use_type NOT LIKE '%NATURAL AREA%'
				AND use_type NOT LIKE '%OPEN SPACE%'
				THEN 'Wastewater and Pollution Control'
			WHEN use_type LIKE '%WASTEWATER%' THEN 'Wastewater and Pollution Control'
			WHEN use_type LIKE '%LANDFILL%' 
				OR use_type LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Solid Waste Processing'
			WHEN use_type LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND use_type LIKE '%SANITATION SECTION%')
				THEN 'Solid Waste Transfer and Carting'
			WHEN use_type LIKE '%ANTENNA%' OR use_type LIKE '%TELE/COMP%' THEN 'Telecommunications'
			WHEN use_type LIKE '%PIER - MARITIME%'
				OR use_type LIKE '%FERRY%' 
				OR use_type LIKE '%WATERFRONT TRANSPORTATION%'
				OR use_type LIKE '%MARINA%'
				THEN 'Ports and Ferry Landings'
			WHEN use_type LIKE '%RAIL%'
				OR (use_type LIKE '%TRANSIT%'
					AND use_type NOT LIKE '%TRANSITIONAL%')
				THEN 'Rail Yards and Maintenance'
			WHEN use_type LIKE '%BUS%' THEN 'Bus Depots and Terminals'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Hospitals and Clinics'
			WHEN use_type LIKE '%HOSPITAL%' THEN 'Hospitals and Clinics'
			WHEN use_type LIKE '%AMBULATORY HEALTH%' THEN 'Hospitals and Clinics'
			WHEN agency LIKE '%OCME%' THEN 'Other Health Care'
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%HOUSING%' THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%AGING%' THEN 'Senior Services'
			WHEN agency LIKE '%DHS%'
				AND (use_type LIKE '%RESIDENTIAL%'
				OR use_type LIKE '%TRANSITIONAL HOUSING%')
				THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%DHS%' THEN 'Non-residential Housing and Homeless Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND use_type LIKE '%RESIDENTIAL%'
				THEN 'Public or Affordable Housing'
			WHEN use_type LIKE '%COMMUNITY CENTER%' THEN 'Community Centers'

			-- Parks, Cultural
			WHEN use_type LIKE '%LIBRARY%' THEN 'Public Libraries'
			WHEN use_type LIKE '%MUSEUM%' THEN 'Museums'
			WHEN use_type LIKE '%CULTURAL%' THEN 'Other Cultural Institutions'
			WHEN use_type LIKE '%ZOO%' THEN 'Other Cultural Institutions'
			WHEN use_type LIKE '%CEMETERY%' THEN 'Cemeteries'
			WHEN agency LIKE '%CULT%' AND use_type LIKE '%MUSEUM%' THEN 'Museums'
			WHEN agency LIKE '%CULT%' THEN 'Other Cultural Institutions'
			WHEN use_type LIKE '%NATURAL AREA%'
				OR (use_type LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Preserves and Conservation Areas'
			WHEN use_type LIKE '%BOTANICAL GARDENS%' THEN 'Other Cultural Institutions'
			WHEN use_type LIKE '%GARDEN%' THEN 'Gardens'
			WHEN use_type LIKE '%PARK%' THEN 'Parks'
			WHEN use_type LIKE '%PLAZA%'
				OR use_type LIKE '%SITTING AREA%' 
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN use_type LIKE '%PLAYGROUND%'
				OR use_type LIKE '%SPORTS%'
				OR use_type LIKE '%TENNIS COURT%'
				OR (use_type LIKE '%RECREATION%'
					AND agency NOT LIKE '%ACS%')
				OR use_type LIKE '%BEACH%'
				OR use_type LIKE '%PLAYING FIELD%'
				OR use_type LIKE '%GOLF COURSE%'
				OR use_type LIKE '%POOL%'
				OR use_type LIKE '%STADIUM%'
				THEN 'Recreation and Waterfront Sites'
			WHEN agency LIKE '%PARKS%'
				AND use_type LIKE '%OPEN SPACE%'
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN use_type LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Other Cultural Institutions'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%DETENTION%' THEN 'Detention and Correctional'
			WHEN agency LIKE '%CORR%' AND use_type LIKE '%COURT%' THEN 'Courthouses and Judicial'
			WHEN agency LIKE '%CORR%' THEN 'Detention and Correctional'
			WHEN agency LIKE '%COURT%' AND use_type LIKE '%COURT%' THEN 'Courthouses and Judicial'
			WHEN use_type LIKE '%AMBULANCE%' THEN 'Other Emergency Services'
			WHEN use_type LIKE '%EMERGENCY MEDICAL%' THEN 'Other Emergency Services'
			WHEN use_type LIKE '%FIREHOUSE%' THEN 'Fire Services'
			WHEN use_type LIKE '%POLICE STATION%' THEN 'Police Services'
			WHEN use_type LIKE '%PUBLIC SAFETY%' THEN 'Other Public Safety'
			WHEN agency LIKE '%OCME%' THEN 'Forensics'

			-- Education, Children, Youth
			WHEN use_type LIKE '%UNIVERSITY%' THEN 'Colleges or Universities'
			WHEN use_type LIKE '%EARLY CHILDHOOD%' THEN 'Preschools'
			WHEN use_type LIKE '%DAY CARE%' THEN 'Childcare'
			WHEN agency LIKE '%ACS%' AND use_type LIKE '%RESIDENTIAL%' THEN 'Childrens Services'
			WHEN agency LIKE '%ACS%' THEN 'Childcare'
			WHEN agency LIKE '%EDUC%' and use_type LIKE '%PLAY AREA%' THEN 'Public Schools'
			WHEN use_type LIKE '%HIGH SCHOOL%' THEN 'Public Schools'
			WHEN agency LIKE '%CUNY%' THEN 'Colleges or Universities'
			WHEN AGENCY LIKE '%EDUC%' AND use_type LIKE '%SCHOOL%' THEN 'Public Schools'
			WHEN use_type LIKE '%EDUCATIONAL SKILLS%' THEN 'Public Schools'

			ELSE 'Miscellaneous Use'
		END),
	-- agencyclass1
	use_type,
	-- agencyclass2
		(CASE
			WHEN type='OF' THEN 'City Owned - OF'
			WHEN type='LF' THEN 'City Leased - LF'
		END),
	-- colpusetype
	use_type,
	-- capacity
	NULL,
	-- utilization
	NULL,
	-- capacitytype
	NULL,
	-- utilizationrate
	NULL,
	-- area
	NULL,
	-- areatype
	NULL,
	-- servicearea
	NULL,
	-- operatortype
	'Public',
	-- operatorname
		(CASE
			WHEN agency='ACS' THEN 'Agency for Childrens Services'
			WHEN agency='ACTRY' THEN 'Office of the Actuary'
			WHEN agency='AGING' THEN 'Department for the Aging'
			WHEN agency='BIC' THEN 'Business Integrity Commission'
			WHEN agency='BLDGS' THEN 'Department of Buildings'
			WHEN agency='BP-BK' THEN 'Borough President - Brooklyn'
			WHEN agency='BP-BX' THEN 'Borough President - Bronx'
			WHEN agency='BP-MN' THEN 'Borough President - Manhattan'
			WHEN agency='BP-QN' THEN 'Borough President - Queens'
			WHEN agency='BP-SI' THEN 'Borough President - Staten Island'
			WHEN agency='BPL' THEN 'Brooklyn Public Library'
			WHEN agency='BSA' THEN 'Board of Standards & Appeals'
			WHEN agency LIKE 'CB%' THEN CONCAT('Community Board ', RIGHT(agency,3))
			WHEN agency='CCRB' THEN 'Civilian Complaint Review Board'
			WHEN agency='CEO' THEN 'Center for Economic Opportunity'
			WHEN agency='CFB' THEN 'Campaign Finance Board'
			WHEN agency='CIVIL' THEN 'City Civil Service Commission'
			WHEN agency='CLERK' THEN 'Office of the City Clerk'
			WHEN agency='COIB' THEN 'Conflict of Interest Board'
			WHEN agency='COMPT' THEN 'Office of the Comptroller'
			WHEN agency='CORR' THEN 'Department of Correction'
			WHEN agency='COUNC' THEN 'City Council'
			WHEN agency='COURT' THEN 'Court System (General)'
			WHEN agency='CULT' THEN 'Department of Cultural Affairs'
			WHEN agency='CUNY' THEN 'City University of New York'
			WHEN agency='DA-BK' THEN 'District Attorney - Brooklyn'
			WHEN agency='DA-BX' THEN 'District Attorney - Bronx '
			WHEN agency='DA-MN' THEN 'District Attorney - Manhattan'
			WHEN agency='DA-QN' THEN 'District Attorney - Queens'
			WHEN agency='DA-SI' THEN 'District Attorney - Staten Island'
			WHEN agency='DA-SP' THEN 'District Attorney-Office Special Narcotics'
			WHEN agency='DCA' THEN 'Department of Consumer Affairs'
			WHEN agency='DCAS' THEN 'Department of Citywide Administrative Services'
			WHEN agency='DDC' THEN 'Department of Design & Construction'
			WHEN agency='DEP' THEN 'Department of Environmental Protection'
			WHEN agency='DHS' THEN 'Department of Homeless Services'
			WHEN agency='DOI' THEN 'Department of Investigation'
			WHEN agency='DOITT' THEN 'Department of Information Technology & Telecommunications'
			WHEN agency='DORIS' THEN 'Department of Records and Information Services'
			WHEN agency='DOT' THEN 'Department of Transportation'
			WHEN agency='DSBS' THEN 'Department of Small Business Services'
			WHEN agency='DYCD' THEN 'Department of Youth & Community Development'
			WHEN agency='EDC' THEN 'Economic Development Corporation'
			WHEN agency='EDUC' THEN 'Department of Education'
			WHEN agency='ELECT' THEN 'Board of Elections'
			WHEN agency='FINAN' THEN 'Department of Finance'
			WHEN agency='FIRE' THEN 'Fire Department'
			WHEN agency='FISA' THEN 'Financial Information Services Agency'
			WHEN agency='HHC' THEN 'Health and Hospitals Corporation'
			WHEN agency='HLTH' THEN 'Department of Health and Mental Hygiene'
			WHEN agency='HPD' THEN 'Department of Housing Preservation and Development'
			WHEN agency='HRA' THEN 'Human Resources Administration'
			WHEN agency='HUMRT' THEN 'Commission on Human Rights'
			WHEN agency='HYDC' THEN 'Hudson Yards Development Corporation'
			WHEN agency='IBO' THEN 'Independent Budget Office'
			WHEN agency='LAW' THEN 'Law Department'
			WHEN agency='LDMKS' THEN 'Landmarks Preservation Commission'
			WHEN agency='MAYOR' THEN 'Office of the Mayor'
			WHEN agency='MOME' THEN 'Mayors Office of Media and Entertainment'
			WHEN agency='MTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYCHA' THEN 'New York City Housing Authority'
			WHEN agency='NYCTA' THEN 'New York City Transit Authority'
			WHEN agency='NYPD' THEN 'Police Department'
			WHEN agency='NYPL' THEN 'New York Public Library'
			WHEN agency='OATH' THEN 'Office of Admin Trials/Hearings'
			WHEN agency='OCA' THEN 'Office of Court Administration'
			WHEN agency='OCB' THEN 'Office of Collective Bargaining'
			WHEN agency='OCME' THEN 'Office of the Medical Examiner'
			WHEN agency='OEM' THEN 'Office of Emergency Management'
			WHEN agency='OLR' THEN 'Office of Labor Relations'
			WHEN agency='OMB' THEN 'Office of Management and Budget'
			WHEN agency='OPA' THEN 'Office of Payroll Administration'
			WHEN agency='PA-BK' THEN 'Public Administrators Office - Brooklyn'
			WHEN agency='PA-BX' THEN 'Public Administrators Office - Bronx'
			WHEN agency='PA-MN' THEN 'Public Administrators Office - Manhattan'
			WHEN agency='PA-QN' THEN 'Public Administrators Office - Queens'
			WHEN agency='PA-SI' THEN 'Public Administrators Office - Staten Island'
			WHEN agency='PARKS' THEN 'Department of Parks and Recreation'
			WHEN agency='PBADV' THEN 'Office of Public Advocate'
			WHEN agency='PLAN' THEN 'Department of City Planning'
			WHEN agency='PRIV' THEN 'Private'
			WHEN agency='PROB' THEN 'Department of Probation'
			WHEN agency='QPL' THEN 'Queens Borough Public Library'
			WHEN agency='SANIT' THEN 'Department of Sanitation'
			WHEN agency='TAXCM' THEN 'Tax Commission'
			WHEN agency='TBTA' THEN 'Triborough Bridge & Tunnel Authority'
			WHEN agency='TLC' THEN 'Taxi and Limousine Commission'
			WHEN agency='UNKN' THEN 'Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN agency LIKE 'SANIT' THEN 'NYCDSNY'
			WHEN agency LIKE 'AGING' THEN 'NYCDFTA'
			WHEN agency LIKE 'EDUC' THEN 'NYCDOE'
			WHEN agency LIKE 'CULT' THEN 'NYCDCLA'
			WHEN agency LIKE 'CORR' THEN 'NYCDOC'
			WHEN agency LIKE 'FIRE' THEN 'NYCFDNY'
			WHEN agency LIKE 'HLTH' THEN 'NYCODHMH'
			ELSE CONCAT('NYC',agency)
		END),
	-- oversightagency
		(CASE
			WHEN agency='ACS' THEN 'Agency for Childrens Services'
			WHEN agency='ACTRY' THEN 'Office of the Actuary'
			WHEN agency='AGING' THEN 'Department for the Aging'
			WHEN agency='BIC' THEN 'Business Integrity Commission'
			WHEN agency='BLDGS' THEN 'Department of Buildings'
			WHEN agency='BP-BK' THEN 'Borough President - Brooklyn'
			WHEN agency='BP-BX' THEN 'Borough President - Bronx'
			WHEN agency='BP-MN' THEN 'Borough President - Manhattan'
			WHEN agency='BP-QN' THEN 'Borough President - Queens'
			WHEN agency='BP-SI' THEN 'Borough President - Staten Island'
			WHEN agency='BPL' THEN 'Brooklyn Public Library'
			WHEN agency='BSA' THEN 'Board of Standards & Appeals'
			WHEN agency LIKE 'CB%' THEN CONCAT('Community Board ', RIGHT(agency,3))
			WHEN agency='CCRB' THEN 'Civilian Complaint Review Board'
			WHEN agency='CEO' THEN 'Center for Economic Opportunity'
			WHEN agency='CFB' THEN 'Campaign Finance Board'
			WHEN agency='CIVIL' THEN 'City Civil Service Commission'
			WHEN agency='CLERK' THEN 'Office of the City Clerk'
			WHEN agency='COIB' THEN 'Conflict of Interest Board'
			WHEN agency='COMPT' THEN 'Office of the Comptroller'
			WHEN agency='CORR' THEN 'Department of Correction'
			WHEN agency='COUNC' THEN 'City Council'
			WHEN agency='COURT' THEN 'Court System (General)'
			WHEN agency='CULT' THEN 'Department of Cultural Affairs'
			WHEN agency='CUNY' THEN 'City University of New York'
			WHEN agency='DA-BK' THEN 'District Attorney - Brooklyn'
			WHEN agency='DA-BX' THEN 'District Attorney - Bronx '
			WHEN agency='DA-MN' THEN 'District Attorney - Manhattan'
			WHEN agency='DA-QN' THEN 'District Attorney - Queens'
			WHEN agency='DA-SI' THEN 'District Attorney - Staten Island'
			WHEN agency='DA-SP' THEN 'District Attorney-Office Special Narcotics'
			WHEN agency='DCA' THEN 'Department of Consumer Affairs'
			WHEN agency='DCAS' THEN 'Department of Citywide Administrative Services'
			WHEN agency='DDC' THEN 'Department of Design & Construction'
			WHEN agency='DEP' THEN 'Department of Environmental Protection'
			WHEN agency='DHS' THEN 'Department of Homeless Services'
			WHEN agency='DOI' THEN 'Department of Investigation'
			WHEN agency='DOITT' THEN 'Department of Information Technology & Telecommunications'
			WHEN agency='DORIS' THEN 'Department of Records and Information Services'
			WHEN agency='DOT' THEN 'Department of Transportation'
			WHEN agency='DSBS' THEN 'Department of Small Business Services'
			WHEN agency='DYCD' THEN 'Department of Youth & Community Development'
			WHEN agency='EDC' THEN 'Economic Development Corporation'
			WHEN agency='EDUC' THEN 'Department of Education'
			WHEN agency='ELECT' THEN 'Board of Elections'
			WHEN agency='FINAN' THEN 'Department of Finance'
			WHEN agency='FIRE' THEN 'Fire Department'
			WHEN agency='FISA' THEN 'Financial Information Services Agency'
			WHEN agency='HHC' THEN 'Health and Hospitals Corporation'
			WHEN agency='HLTH' THEN 'Department of Health and Mental Hygiene'
			WHEN agency='HPD' THEN 'Department of Housing Preservation and Development'
			WHEN agency='HRA' THEN 'Human Resources Administration'
			WHEN agency='HUMRT' THEN 'Commission on Human Rights'
			WHEN agency='HYDC' THEN 'Hudson Yards Development Corporation'
			WHEN agency='IBO' THEN 'Independent Budget Office'
			WHEN agency='LAW' THEN 'Law Department'
			WHEN agency='LDMKS' THEN 'Landmarks Preservation Commission'
			WHEN agency='MAYOR' THEN 'Office of the Mayor'
			WHEN agency='MOME' THEN 'Mayors Office of Media and Entertainment'
			WHEN agency='MTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYCHA' THEN 'New York City Housing Authority'
			WHEN agency='NYCTA' THEN 'New York City Transit Authority'
			WHEN agency='NYPD' THEN 'Police Department'
			WHEN agency='NYPL' THEN 'New York Public Library'
			WHEN agency='OATH' THEN 'Office of Admin Trials/Hearings'
			WHEN agency='OCA' THEN 'Office of Court Administration'
			WHEN agency='OCB' THEN 'Office of Collective Bargaining'
			WHEN agency='OCME' THEN 'Office of the Medical Examiner'
			WHEN agency='OEM' THEN 'Office of Emergency Management'
			WHEN agency='OLR' THEN 'Office of Labor Relations'
			WHEN agency='OMB' THEN 'Office of Management and Budget'
			WHEN agency='OPA' THEN 'Office of Payroll Administration'
			WHEN agency='PA-BK' THEN 'Public Administrators Office - Brooklyn'
			WHEN agency='PA-BX' THEN 'Public Administrators Office - Bronx'
			WHEN agency='PA-MN' THEN 'Public Administrators Office - Manhattan'
			WHEN agency='PA-QN' THEN 'Public Administrators Office - Queens'
			WHEN agency='PA-SI' THEN 'Public Administrators Office - Staten Island'
			WHEN agency='PARKS' THEN 'Department of Parks and Recreation'
			WHEN agency='PBADV' THEN 'Office of Public Advocate'
			WHEN agency='PLAN' THEN 'Department of City Planning'
			WHEN agency='PRIV' THEN 'Private'
			WHEN agency='PROB' THEN 'Department of Probation'
			WHEN agency='QPL' THEN 'Queens Borough Public Library'
			WHEN agency='SANIT' THEN 'Department of Sanitation'
			WHEN agency='TAXCM' THEN 'Tax Commission'
			WHEN agency='TBTA' THEN 'Triborough Bridge & Tunnel Authority'
			WHEN agency='TLC' THEN 'Taxi and Limousine Commission'
			WHEN agency='UNKN' THEN 'Unknown'
		END),
	-- oversightabbrev
		(CASE
			WHEN agency LIKE 'SANIT' THEN 'NYCDSNY'
			WHEN agency LIKE 'AGING' THEN 'NYCDFTA'
			WHEN agency LIKE 'EDUC' THEN 'NYCDOE'
			WHEN agency LIKE 'CULT' THEN 'NYCDCLA'
			WHEN agency LIKE 'CORR' THEN 'NYCDOC'
			WHEN agency LIKE 'FIRE' THEN 'NYCFDNY'
			WHEN agency LIKE 'HLTH' THEN 'NYCODHMH'
			ELSE CONCAT('NYC',agency)
		END),
	-- dateactive
	NULL,
	-- dateinactive
	NULL,
	-- inactivestatus
	NULL,
	-- tags
	NULL,
	-- notes
	NULL,
	-- datesourcereceived
	'2016-10-20',
	-- datesourceupdated
	'2016-10-20',
	-- datecreated
	CURRENT_TIMESTAMP,
	-- dateedited
	CURRENT_TIMESTAMP,
	-- creator
	'Hannah Kates',
	-- editor
	'Hannah Kates',
	-- geom
	-- ST_SetSRID(ST_MakePoint(long, lat),4326)
		(CASE
			WHEN xcoord <> ' ' THEN ST_Transform(ST_SetSRID(ST_MakePoint(xcoord::numeric, ycoord::numeric),2263),4326)
		END),
	-- agencysource
	'NYCDCAS',
	-- sourcedatasetname
	'City Owned and Leased Properties',
	-- linkdata
	'NA',
	-- linkdownload
	'NA',
	-- datatype
	'CSV with Address',
	-- refreshmeans
	'Geocode - Request from Agency',
	-- refreshfrequency
	'Annually',
	-- buildingid
	NULL,
	-- buildingname
	NULL,
	-- schoolorganizationlevel
	NULL,
	-- children
	FALSE,
	-- youth
	FALSE,
	-- senior
	FALSE,
	-- family
	FALSE,
	-- disabilities
	FALSE,
	-- dropouts
	FALSE,
	-- unemployed
	FALSE,
	-- homeless
	FALSE,
	-- immigrants
	FALSE,
	-- groupquarters
		(CASE WHEN use_type LIKE '%RESIDENTIAL%' THEN TRUE
			ELSE FALSE
		END)
FROM 
	dcas_facilities_colp
WHERE
	agency <> 'NYCHA'
	AND agency <> 'HPD'
	AND use_type <> 'ROAD/HIGHWAY'
	AND use_type <> 'TRANSIT WAY'
