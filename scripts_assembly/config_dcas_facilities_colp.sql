-- Custom insert statement

INSERT INTO
facilities (
	pgtable,
	hash,
	geom,
	idagency,
	facilityname,
	addressnumber,
	streetname,
	address,
	borough,
	zipcode,
	bbl,
	bin,
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
	operatortype,
	operatorname,
	operatorabbrev,
	oversightagency,
	oversightabbrev,
	datecreated,
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
	-- pgtable
	ARRAY['dcas_facilities_colp'],
	-- hash,
	md5(CAST((dcas_facilities_colp.*) AS text)),
	-- geom
	geom,
	-- idagency
	NULL,
	-- facilityname
		(CASE
			WHEN name <> ' ' THEN initcap(name)
			ELSE 'Unnamed'
		END),
	-- addressnumber
	split_part(trim(both ' ' from initcap(Address)), ' ', 1),
	-- streetname
	trim(both ' ' from substr(trim(both ' ' from initcap(Address)), strpos(trim(both ' ' from initcap(Address)), ' ')+1, (length(trim(both ' ' from initcap(Address)))-strpos(trim(both ' ' from initcap(Address)), ' ')))),
	-- address
	initcap(Address),
	-- borough
	initcap(boro),
	-- zipcode
	NULL,
	-- bbl
	(CASE
		WHEN boro = 'MANHATTAN' THEN ARRAY[CONCAT('1',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text]
		WHEN boro = 'BRONX' THEN ARRAY[CONCAT('2',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text]
		WHEN boro = 'BROOKLYN' THEN ARRAY[CONCAT('3',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text]
		WHEN boro = 'QUEENS' THEN ARRAY[CONCAT('4',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text]
		WHEN boro = 'STATEN ISLAND' THEN ARRAY[CONCAT('5',LPAD(block::text, 5, '0'),LPAD(lot::text, 4, '0'))::text]
	END),
	-- bin
	NULL,
	-- facilitytype
	initcap(usedec),
	-- domain
		(CASE
			-- Admin of Gov
			WHEN usedec LIKE '%AGREEMENT%'
				OR usedec LIKE '%DISPOSITION%'
				OR usedec LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Administration of Government'
			WHEN usedec LIKE '%SECURITY%' THEN 'Administration of Government'
			WHEN (usedec LIKE '%PARKING%'
				OR usedec LIKE '%PKNG%')
				AND usedec NOT LIKE '%MUNICIPAL%'
				THEN 'Administration of Government'
			WHEN usedec LIKE '%STORAGE%' OR usedec LIKE '%STRG%' THEN 'Administration of Government'
			WHEN usedec LIKE '%CUSTODIAL%' THEN 'Administration of Government'
			WHEN usedec LIKE '%GARAGE%' THEN 'Administration of Government'
			WHEN usedec LIKE '%OFFICE%' THEN 'Administration of Government'
			WHEN usedec LIKE '%MAINTENANCE%' THEN 'Administration of Government'
			WHEN usedec LIKE '%NO USE%' THEN 'Administration of Government'
			WHEN usedec LIKE '%MISCELLANEOUS USE%' THEN 'Administration of Government'
			WHEN usedec LIKE '%OTHER HEALTH%' AND name LIKE '%ANIMAL%' THEN 'Administration of Government'
			WHEN agency LIKE '%DCA%' and usedec LIKE '%OTHER%' THEN 'Administration of Government'
			WHEN usedec LIKE '%UNDEVELOPED%' THEN 'Administration of Government'
			WHEN (usedec LIKE '%TRAINING%' 
				OR usedec LIKE '%TESTING%')
				AND usedec NOT LIKE '%LABORATORY%'
				THEN 'Administration of Government'


			-- Trans and Infra
			WHEN usedec LIKE '%MUNICIPAL PARKING%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%MARKET%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%MATERIAL PROCESSING%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%ASPHALT%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%AIRPORT%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%ROAD/HIGHWAY%'
				OR usedec LIKE '%TRANSIT WAY%'
				OR usedec LIKE '%OTHER TRANSPORTATION%'
				THEN 'Core Infrastructure and Transportation'
			WHEN agency LIKE '%DEP%'
				AND (usedec LIKE '%WATER SUPPLY%'
				OR usedec LIKE '%RESERVOIR%'
				OR usedec LIKE '%AQUEDUCT%')
				THEN 'Core Infrastructure and Transportation'
			WHEN agency LIKE '%DEP%'
				AND usedec NOT LIKE '%NATURE AREA%'
				AND usedec NOT LIKE '%NATURAL AREA%'
				AND usedec NOT LIKE '%OPEN SPACE%'
				THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%WASTEWATER%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%LANDFILL%' 
				OR usedec LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND usedec LIKE '%SANITATION SECTION%')
				THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%ANTENNA%' OR usedec LIKE '%TELE/COMP%' THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%PIER - MARITIME%'
				OR usedec LIKE '%FERRY%' 
				OR usedec LIKE '%WATERFRONT TRANSPORTATION%'
				OR usedec LIKE '%MARINA%'
				THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%RAIL%'
				OR (usedec LIKE '%TRANSIT%'
					AND usedec NOT LIKE '%TRANSITIONAL%')
				THEN 'Core Infrastructure and Transportation'
			WHEN usedec LIKE '%BUS%' THEN 'Core Infrastructure and Transportation'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Health and Human Services'
			WHEN usedec LIKE '%HOSPITAL%' THEN 'Health and Human Services'
			WHEN usedec LIKE '%AMBULATORY HEALTH%' THEN 'Health and Human Services'
			WHEN agency LIKE '%OCME%' THEN 'Health and Human Services'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%HOUSING%' THEN 'Health and Human Services'
			WHEN agency LIKE '%AGING%' THEN 'Health and Human Services'
			WHEN agency LIKE '%DHS%' THEN 'Health and Human Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND usedec LIKE '%RESIDENTIAL%'
				THEN 'Health and Human Services'
			WHEN usedec LIKE '%COMMUNITY CENTER%' THEN 'Health and Human Services'

			-- Parks, Cultural
			WHEN usedec LIKE '%LIBRARY%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%MUSEUM%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%CULTURAL%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%ZOO%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%CEMETERY%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN agency LIKE '%CULT%' AND usedec LIKE '%MUSEUM%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN agency LIKE '%CULT%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%NATURAL AREA%'
				OR (usedec LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%BOTANICAL GARDENS%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%GARDEN%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%PARK%' THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%PLAZA%'
				OR usedec LIKE '%SITTING AREA%' 
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%PLAYGROUND%'
				OR usedec LIKE '%SPORTS%'
				OR usedec LIKE '%TENNIS COURT%'
				OR (usedec LIKE '%RECREATION%'
					AND agency NOT LIKE '%ACS%')
				OR usedec LIKE '%BEACH%'
				OR usedec LIKE '%PLAYING FIELD%'
				OR usedec LIKE '%GOLF COURSE%'
				OR usedec LIKE '%POOL%'
				OR usedec LIKE '%STADIUM%'
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN agency LIKE '%PARKS%'
				AND usedec LIKE '%OPEN SPACE%'
				THEN 'Parks, Cultural, and Other Community Facilities'
			WHEN usedec LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Parks, Cultural, and Other Community Facilities'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%DETENTION%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%CORR%' AND usedec LIKE '%COURT%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%CORR%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%COURT%' AND usedec LIKE '%COURT%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN usedec LIKE '%AMBULANCE%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN usedec LIKE '%EMERGENCY MEDICAL%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN usedec LIKE '%FIREHOUSE%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN usedec LIKE '%POLICE STATION%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN usedec LIKE '%PUBLIC SAFETY%' THEN 'Public Safety, Emergency Services, and Administration of Justice'
			WHEN agency LIKE '%OCME%' THEN 'Public Safety, Emergency Services, and Administration of Justice'

			-- Education, Children, Youth
			WHEN usedec LIKE '%UNIVERSITY%' THEN 'Education, Child Welfare, and Youth'
			WHEN usedec LIKE '%EARLY CHILDHOOD%' THEN 'Education, Child Welfare, and Youth'
			WHEN usedec LIKE '%DAY CARE%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%RESIDENTIAL%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%ACS%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%EDUC%' and usedec LIKE '%PLAY AREA%' THEN 'Education, Child Welfare, and Youth'
			WHEN usedec LIKE '%HIGH SCHOOL%' THEN 'Education, Child Welfare, and Youth'
			WHEN agency LIKE '%CUNY%' THEN 'Education, Child Welfare, and Youth'
			WHEN AGENCY LIKE '%EDUC%' AND usedec LIKE '%SCHOOL%' THEN 'Education, Child Welfare, and Youth'
			WHEN usedec LIKE '%EDUCATIONAL SKILLS%' THEN 'Education, Child Welfare, and Youth'

			ELSE 'Administration of Government'
		END),


	-- facilitygroup
		(CASE
			-- Admin of Gov
			WHEN usedec LIKE '%AGREEMENT%'
				OR usedec LIKE '%DISPOSITION%'
				OR usedec LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Other Property'
			WHEN usedec LIKE '%SECURITY%' THEN 'Other Property'
			WHEN (usedec LIKE '%PARKING%'
				OR usedec LIKE '%PKNG%')
				AND usedec NOT LIKE '%MUNICIPAL%'
				THEN 'Parking, Maintenance, and Storage'
			WHEN usedec LIKE '%STORAGE%' OR usedec LIKE '%STRG%' THEN 'Parking, Maintenance, and Storage'
			WHEN usedec LIKE '%CUSTODIAL%' THEN 'Parking, Maintenance, and Storage'
			WHEN usedec LIKE '%GARAGE%' THEN 'Parking, Maintenance, and Storage'
			WHEN usedec LIKE '%OFFICE%' THEN 'Offices, Training, and Testing'
			WHEN usedec LIKE '%MAINTENANCE%' THEN 'Parking, Maintenance, and Storage'
			WHEN usedec LIKE '%NO USE%' THEN 'Other Property'
			WHEN usedec LIKE '%MISCELLANEOUS USE%' THEN 'Other Property'
			WHEN usedec LIKE '%OTHER HEALTH%' AND name LIKE '%ANIMAL%' THEN 'Other Property'
			WHEN agency LIKE '%DCA%' and usedec LIKE '%OTHER%' THEN 'Other Property'
			WHEN usedec LIKE '%UNDEVELOPED%' THEN 'Other Property'
			WHEN (usedec LIKE '%TRAINING%' 
				OR usedec LIKE '%TESTING%')
				AND usedec NOT LIKE '%LABORATORY%'
				THEN 'Offices, Training, and Testing'


			-- Trans and Infra
			WHEN usedec LIKE '%MUNICIPAL PARKING%' THEN 'Transportation'
			WHEN usedec LIKE '%MARKET%' THEN 'Material Supplies and Markets'
			WHEN usedec LIKE '%MATERIAL PROCESSING%' THEN 'Material Supplies and Markets'
			WHEN usedec LIKE '%ASPHALT%' THEN 'Material Supplies and Markets'
			WHEN usedec LIKE '%AIRPORT%' THEN 'Transportation'
			WHEN usedec LIKE '%ROAD/HIGHWAY%'
				OR usedec LIKE '%TRANSIT WAY%'
				OR usedec LIKE '%OTHER TRANSPORTATION%'
				THEN 'Transportation'
			WHEN agency LIKE '%DEP%'
				AND (usedec LIKE '%WATER SUPPLY%'
				OR usedec LIKE '%RESERVOIR%'
				OR usedec LIKE '%AQUEDUCT%')
				THEN 'Water and Wastewater'
			WHEN agency LIKE '%DEP%'
				AND usedec NOT LIKE '%NATURAL AREA%'
				AND usedec NOT LIKE '%NATURE AREA%'
				AND usedec NOT LIKE '%OPEN SPACE%'
				THEN 'Water and Wastewater'
			WHEN usedec LIKE '%WASTEWATER%' THEN 'Water and Wastewater'
			WHEN usedec LIKE '%LANDFILL%' 
				OR usedec LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Solid Waste'
			WHEN usedec LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND usedec LIKE '%SANITATION SECTION%')
				THEN 'Solid Waste'
			WHEN usedec LIKE '%ANTENNA%' OR usedec LIKE '%TELE/COMP%' THEN 'Telecommunications'
			WHEN usedec LIKE '%PIER - MARITIME%'
				OR usedec LIKE '%FERRY%' 
				OR usedec LIKE '%WATERFRONT TRANSPORTATION%'
				OR usedec LIKE '%MARINA%'
				THEN 'Transportation'
			WHEN usedec LIKE '%RAIL%'
				OR (usedec LIKE '%TRANSIT%'
					AND usedec NOT LIKE '%TRANSITIONAL%')
				THEN 'Transportation'
			WHEN usedec LIKE '%BUS%' THEN 'Transportation'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Health Care'
			WHEN usedec LIKE '%HOSPITAL%' THEN 'Health Care'
			WHEN usedec LIKE '%AMBULATORY HEALTH%' THEN 'Health Care'
			WHEN agency LIKE '%OCME%' THEN 'Health Care'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%HOUSING%' THEN 'Human Services'
			WHEN agency LIKE '%AGING%' THEN 'Human Services'
			WHEN agency LIKE '%DHS%' THEN 'Human Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND usedec LIKE '%RESIDENTIAL%'
				THEN 'Human Services'
			WHEN usedec LIKE '%COMMUNITY CENTER%' THEN 'Human Services'

			-- Parks, Cultural
			WHEN usedec LIKE '%LIBRARY%' THEN 'Libraries'
			WHEN usedec LIKE '%MUSEUM%' THEN 'Cultural Institutions'
			WHEN usedec LIKE '%CULTURAL%' THEN 'Cultural Institutions'
			WHEN usedec LIKE '%ZOO%' THEN 'Cultural Institutions'
			WHEN usedec LIKE '%CEMETERY%' THEN 'Parks and Plazas'
			WHEN agency LIKE '%CULT%' AND usedec LIKE '%MUSEUM%' THEN 'Cultural Institutions'
			WHEN agency LIKE '%CULT%' THEN 'Cultural Institutions'
			WHEN usedec LIKE '%NATURAL AREA%'
				OR (usedec LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Parks and Plazas'
			WHEN usedec LIKE '%BOTANICAL GARDENS%' THEN 'Cultural Institutions'
			WHEN usedec LIKE '%GARDEN%' THEN 'Parks and Plazas'
			WHEN usedec LIKE '%PARK%' THEN 'Parks and Plazas'
			WHEN usedec LIKE '%PLAZA%'
				OR usedec LIKE '%SITTING AREA%' 
				THEN 'Parks and Plazas'
			WHEN usedec LIKE '%PLAYGROUND%'
				OR usedec LIKE '%SPORTS%'
				OR usedec LIKE '%TENNIS COURT%'
				OR (usedec LIKE '%RECREATION%'
					AND agency NOT LIKE '%ACS%')
				OR usedec LIKE '%BEACH%'
				OR usedec LIKE '%PLAYING FIELD%'
				OR usedec LIKE '%GOLF COURSE%'
				OR usedec LIKE '%POOL%'
				OR usedec LIKE '%STADIUM%'
				THEN 'Parks and Plazas'
			WHEN agency LIKE '%PARKS%'
				AND usedec LIKE '%OPEN SPACE%'
				THEN 'Parks and Plazas'
			WHEN usedec LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Cultural Institutions'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%DETENTION%' THEN 'Justice and Corrections'
			WHEN agency LIKE '%CORR%' AND usedec LIKE '%COURT%' THEN 'Justice and Corrections'
			WHEN agency LIKE '%CORR%' THEN 'Justice and Corrections'
			WHEN agency LIKE '%COURT%' AND usedec LIKE '%COURT%' THEN 'Justice and Corrections'
			WHEN usedec LIKE '%AMBULANCE%' THEN 'Emergency Services'
			WHEN usedec LIKE '%EMERGENCY MEDICAL%' THEN 'Emergency Services'
			WHEN usedec LIKE '%FIREHOUSE%' THEN 'Emergency Services'
			WHEN usedec LIKE '%POLICE STATION%' THEN 'Public Safety'
			WHEN usedec LIKE '%PUBLIC SAFETY%' THEN 'Public Safety'
			WHEN agency LIKE '%OCME%' THEN 'Justice and Corrections'

			-- Education, Children, Youth
			WHEN usedec LIKE '%UNIVERSITY%' THEN 'Higher Education'
			WHEN agency LIKE '%CUNY%' THEN 'Higher Education'
			WHEN usedec LIKE '%EARLY CHILDHOOD%' THEN 'Child Care and Pre-Kindergarten'
			WHEN usedec LIKE '%DAY CARE%' THEN 'Child Care and Pre-Kindergarten'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%RESIDENTIAL%' THEN 'Childrens Services'
			WHEN agency LIKE '%ACS%' THEN 'Child Care and Pre-Kindergarten'
			WHEN agency LIKE '%EDUC%' and usedec LIKE '%PLAY AREA%' THEN 'Schools (K-12)'
			WHEN usedec LIKE '%HIGH SCHOOL%' THEN 'Schools (K-12)'
			WHEN AGENCY LIKE '%EDUC%' AND usedec LIKE '%SCHOOL%' THEN 'Schools (K-12)'
			WHEN usedec LIKE '%EDUCATIONAL SKILLS%' THEN 'Schools (K-12)'

			ELSE 'Other Property'
		END),

	-- facilitysubgroup
		(CASE
			-- Admin of Gov
			WHEN usedec LIKE '%AGREEMENT%'
				OR usedec LIKE '%DISPOSITION%'
				OR usedec LIKE '%COMMITMENT%'
				OR agency LIKE '%PRIVATE%'
				THEN 'Properties Leased or Licensed to Non-public Entities'
			WHEN usedec LIKE '%SECURITY%' THEN 'Miscellaneous Use'
			WHEN (usedec LIKE '%PARKING%'
				OR usedec LIKE '%PKNG%')
				AND usedec NOT LIKE '%MUNICIPAL%'
				THEN 'Parking'
			WHEN usedec LIKE '%STORAGE%' OR usedec LIKE '%STRG%' THEN 'Storage'
			WHEN usedec LIKE '%CUSTODIAL%' THEN 'Custodial'
			WHEN usedec LIKE '%GARAGE%' THEN 'Maintenance and Garages'
			WHEN usedec LIKE '%OFFICE%' THEN 'Offices'
			WHEN usedec LIKE '%MAINTENANCE%' THEN 'Maintenance and Garages'
			WHEN usedec LIKE '%NO USE%' THEN 'Undeveloped or No Use'
			WHEN usedec LIKE '%MISCELLANEOUS USE%' THEN 'Miscellaneous Use'
			WHEN usedec LIKE '%OTHER HEALTH%' AND name LIKE '%ANIMAL%' THEN 'Miscellaneous Use'
			WHEN agency LIKE '%DCA%' and usedec LIKE '%OTHER%' THEN 'Miscellaneous Use'
			WHEN usedec LIKE '%UNDEVELOPED%' THEN 'Undeveloped or No Use'
			WHEN (usedec LIKE '%TRAINING%' 
				OR usedec LIKE '%TESTING%')
				AND usedec NOT LIKE '%LABORATORY%'
				THEN 'Training and Testing'

			-- Trans and Infra
			WHEN usedec LIKE '%MUNICIPAL PARKING%' THEN 'Public Parking Lots and Garages'
			WHEN usedec LIKE '%MARKET%' THEN 'Wholesale Markets'
			WHEN usedec LIKE '%MATERIAL PROCESSING%' THEN 'Material Supplies'
			WHEN usedec LIKE '%ASPHALT%' THEN 'Material Supplies'
			WHEN usedec LIKE '%AIRPORT%' THEN 'Airports and Heliports'
			WHEN usedec LIKE '%ROAD/HIGHWAY%'
				OR usedec LIKE '%TRANSIT WAY%'
				OR usedec LIKE '%OTHER TRANSPORTATION%'
				THEN 'Other Transportation'
			WHEN agency LIKE '%DEP%'
				AND (usedec LIKE '%WATER SUPPLY%'
				OR usedec LIKE '%RESERVOIR%'
				OR usedec LIKE '%AQUEDUCT%')
				THEN 'Water Supply'
			WHEN agency LIKE '%DEP%'
				AND usedec NOT LIKE '%NATURE AREA%'
				AND usedec NOT LIKE '%NATURAL AREA%'
				AND usedec NOT LIKE '%OPEN SPACE%'
				THEN 'Wastewater and Pollution Control'
			WHEN usedec LIKE '%WASTEWATER%' THEN 'Wastewater and Pollution Control'
			WHEN usedec LIKE '%LANDFILL%' 
				OR usedec LIKE '%SOLID WASTE INCINERATOR%'
				THEN 'Solid Waste Processing'
			WHEN usedec LIKE '%SOLID WASTE TRANSFER%'
				OR (agency LIKE '%SANIT%' AND usedec LIKE '%SANITATION SECTION%')
				THEN 'Solid Waste Transfer and Carting'
			WHEN usedec LIKE '%ANTENNA%' OR usedec LIKE '%TELE/COMP%' THEN 'Telecommunications'
			WHEN usedec LIKE '%PIER - MARITIME%'
				OR usedec LIKE '%FERRY%' 
				OR usedec LIKE '%WATERFRONT TRANSPORTATION%'
				OR usedec LIKE '%MARINA%'
				THEN 'Ports and Ferry Landings'
			WHEN usedec LIKE '%RAIL%'
				OR (usedec LIKE '%TRANSIT%'
					AND usedec NOT LIKE '%TRANSITIONAL%')
				THEN 'Rail Yards and Maintenance'
			WHEN usedec LIKE '%BUS%' THEN 'Bus Depots and Terminals'

			-- Health and Human
			WHEN agency LIKE '%HHC%' THEN 'Hospitals and Clinics'
			WHEN usedec LIKE '%HOSPITAL%' THEN 'Hospitals and Clinics'
			WHEN usedec LIKE '%AMBULATORY HEALTH%' THEN 'Hospitals and Clinics'
			WHEN agency LIKE '%OCME%' THEN 'Other Health Care'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%HOUSING%' THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%AGING%' THEN 'Senior Services'
			WHEN agency LIKE '%DHS%'
				AND (usedec LIKE '%RESIDENTIAL%'
				OR usedec LIKE '%TRANSITIONAL HOUSING%')
				THEN 'Shelters and Transitional Housing'
			WHEN agency LIKE '%DHS%' THEN 'Non-residential Housing and Homeless Services'
			WHEN (agency LIKE '%NYCHA%' 
				OR agency LIKE '%HPD%')
				AND usedec LIKE '%RESIDENTIAL%'
				THEN 'Public or Affordable Housing'
			WHEN usedec LIKE '%COMMUNITY CENTER%' THEN 'Community Centers and Community School Programs'

			-- Parks, Cultural
			WHEN usedec LIKE '%LIBRARY%' THEN 'Public Libraries'
			WHEN usedec LIKE '%MUSEUM%' THEN 'Museums'
			WHEN usedec LIKE '%CULTURAL%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%ZOO%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%CEMETERY%' THEN 'Cemeteries'
			WHEN agency LIKE '%CULT%' AND usedec LIKE '%MUSEUM%' THEN 'Museums'
			WHEN agency LIKE '%CULT%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%NATURAL AREA%'
				OR (usedec LIKE '%OPEN SPACE%'
					AND agency LIKE '%DEP%')
				THEN 'Preserves and Conservation Areas'
			WHEN usedec LIKE '%BOTANICAL GARDENS%' THEN 'Other Cultural Institutions'
			WHEN usedec LIKE '%GARDEN%' THEN 'Gardens'
			WHEN agency LIKE '%PARKS%'
				AND usedec LIKE '%OPEN SPACE%'
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN usedec = 'MALL/TRIANGLE/HIGHWAY STRIP/PARK STRIP'
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN usedec LIKE '%PARK%' THEN 'Parks'
			WHEN usedec LIKE '%PLAZA%'
				OR usedec LIKE '%SITTING AREA%' 
				THEN 'Streetscapes, Plazas, and Malls'
			WHEN usedec LIKE '%PLAYGROUND%'
				OR usedec LIKE '%SPORTS%'
				OR usedec LIKE '%TENNIS COURT%'
				OR (usedec LIKE '%RECREATION%'
					AND agency NOT LIKE '%ACS%')
				OR usedec LIKE '%BEACH%'
				OR usedec LIKE '%PLAYING FIELD%'
				OR usedec LIKE '%GOLF COURSE%'
				OR usedec LIKE '%POOL%'
				OR usedec LIKE '%STADIUM%'
				THEN 'Recreation and Waterfront Sites'
			WHEN usedec LIKE '%THEATER%' AND agency LIKE '%DSBS%'
				THEN 'Other Cultural Institutions'

			-- Public Safety, Justice etc
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%DETENTION%' THEN 'Detention and Correctional'
			WHEN agency LIKE '%CORR%' AND usedec LIKE '%COURT%' THEN 'Courthouses and Judicial'
			WHEN agency LIKE '%CORR%' THEN 'Detention and Correctional'
			WHEN agency LIKE '%COURT%' AND usedec LIKE '%COURT%' THEN 'Courthouses and Judicial'
			WHEN usedec LIKE '%AMBULANCE%' THEN 'Other Emergency Services'
			WHEN usedec LIKE '%EMERGENCY MEDICAL%' THEN 'Other Emergency Services'
			WHEN usedec LIKE '%FIREHOUSE%' THEN 'Fire Services'
			WHEN usedec LIKE '%POLICE STATION%' THEN 'Police Services'
			WHEN usedec LIKE '%PUBLIC SAFETY%' THEN 'Other Public Safety'
			WHEN agency LIKE '%OCME%' THEN 'Forensics'

			-- Education, Children, Youth
			WHEN usedec LIKE '%UNIVERSITY%' THEN 'Colleges or Universities'
			WHEN usedec LIKE '%EARLY CHILDHOOD%' THEN 'Child Care'
			WHEN usedec LIKE '%DAY CARE%' THEN 'Child Care'
			WHEN agency LIKE '%ACS%' AND usedec LIKE '%RESIDENTIAL%' THEN 'Childrens Services'
			WHEN agency LIKE '%ACS%' THEN 'Child Care'
			WHEN agency LIKE '%EDUC%' and usedec LIKE '%PLAY AREA%' THEN 'Public Schools'
			WHEN usedec LIKE '%HIGH SCHOOL%' THEN 'Public Schools'
			WHEN agency LIKE '%CUNY%' THEN 'Colleges or Universities'
			WHEN AGENCY LIKE '%EDUC%' AND usedec LIKE '%SCHOOL%' THEN 'Public Schools'
			WHEN usedec LIKE '%EDUCATIONAL SKILLS%' THEN 'Public Schools'

			ELSE 'Miscellaneous Use'
		END),
	-- agencyclass1
	usedec,
	-- agencyclass2
		(CASE
			WHEN type='OF' THEN 'City Owned - OF'
			WHEN type='LF' THEN 'City Leased - LF'
		END),
	-- colpusetype
	usedec,
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
	-- operatortype
	'Public',
	-- operatorname
		(CASE
			WHEN agency='ACS' THEN 'New York City Administration for Childrens Services'
			WHEN agency='ACTRY' THEN 'New York City Office of the Actuary'
			WHEN agency='AGING' THEN 'New York City Department for the Aging'
			WHEN agency='BIC' THEN 'New York City Business Integrity Commission'
			WHEN agency='BLDGS' THEN 'New York City Department of Buildings'
			WHEN agency='BP-BK' THEN 'New York City Borough President - Brooklyn'
			WHEN agency='BP-BX' THEN 'New York City Borough President - Bronx'
			WHEN agency='BP-MN' THEN 'New York City Borough President - Manhattan'
			WHEN agency='BP-QN' THEN 'New York City Borough President - Queens'
			WHEN agency='BP-SI' THEN 'New York City Borough President - Staten Island'
			WHEN agency='BPL' THEN 'Brooklyn Public Library'
			WHEN agency='BSA' THEN 'New York City Board of Standards and Appeals'
			WHEN agency LIKE 'CB%' THEN CONCAT('New York City Community Board ', RIGHT(agency,3))
			WHEN agency='CCRB' THEN 'New York City Civilian Complaint Review Board'
			WHEN agency='CEO' THEN 'New York City Center for Economic Opportunity'
			WHEN agency='CFB' THEN 'New York City Campaign Finance Board'
			WHEN agency='CIVIL' THEN 'New York City Civil Service Commission'
			WHEN agency='CLERK' THEN 'New York City Office of the City Clerk'
			WHEN agency='COIB' THEN 'New York City Conflict of Interest Board'
			WHEN agency='COMPT' THEN 'New York City Office of the Comptroller'
			WHEN agency='CORR' THEN 'New York City Department of Correction'
			WHEN agency='COUNC' THEN 'New York City Council'
			WHEN agency='COURT' THEN 'New York State Unified Court System'
			WHEN agency='CULT' THEN 'New York City Department of Cultural Affairs'
			WHEN agency='CUNY' THEN 'City University of New York'
			WHEN agency='DA-BK' THEN 'New York City District Attorney - Brooklyn'
			WHEN agency='DA-BX' THEN 'New York City District Attorney - Bronx '
			WHEN agency='DA-MN' THEN 'New York City District Attorney - Manhattan'
			WHEN agency='DA-QN' THEN 'New York City District Attorney - Queens'
			WHEN agency='DA-SI' THEN 'New York City District Attorney - Staten Island'
			WHEN agency='DA-SP' THEN 'New York City District Attorney - Office Special Narcotics'
			WHEN agency='DCA' THEN 'New York City Department of Consumer Affairs'
			WHEN agency='DCAS' THEN 'New York City Department of Citywide Administrative Services'
			WHEN agency='DDC' THEN 'New York City Department of Design and Construction'
			WHEN agency='DEP' THEN 'New York City Department of Environmental Protection'
			WHEN agency='DHS' THEN 'New York City Department of Homeless Services'
			WHEN agency='DOI' THEN 'New York City Department of Investigation'
			WHEN agency='DOITT' THEN 'New York City Department of Information Technology and Telecommunications'
			WHEN agency='DORIS' THEN 'New York City Department of Records and Information Services'
			WHEN agency='DOT' THEN 'New York City Department of Transportation'
			WHEN agency='DSBS' THEN 'New York City Department of Small Business Services'
			WHEN agency='DYCD' THEN 'New York City Department of Youth and Community Development'
			WHEN agency='EDC' THEN 'New York City Economic Development Corporation'
			WHEN agency='EDUC' THEN 'New York City Department of Education'
			WHEN agency='ELECT' THEN 'New York City Board of Elections'
			WHEN agency='FINAN' THEN 'New York City Department of Finance'
			WHEN agency='FIRE' THEN 'New York City Fire Department'
			WHEN agency='FISA' THEN 'New York City Financial Information Services Agency'
			WHEN agency='HHC' THEN 'New York City Health and Hospitals Corporation'
			WHEN agency='HLTH' THEN 'New York City Department of Health and Mental Hygiene'
			WHEN agency='HPD' THEN 'New York City Department of Housing Preservation and Development'
			WHEN agency='HRA' THEN 'New York City Human Resources Administration/Department of Social Services'
			WHEN agency='HUMRT' THEN 'New York City Commission on Human Rights'
			WHEN agency='HYDC' THEN 'Hudson Yards Development Corporation'
			WHEN agency='IBO' THEN 'New York City Independent Budget Office'
			WHEN agency='LAW' THEN 'New York City Law Department'
			WHEN agency='LDMKS' THEN 'New York City Landmarks Preservation Commission'
			WHEN agency='MAYOR' THEN 'New York City Office of the Mayor'
			WHEN agency='MOME' THEN 'New York City Office of the Mayor'
			WHEN agency='MTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYCHA' THEN 'New York City Housing Authority'
			WHEN agency='NYCTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYPD' THEN 'New York City Police Department'
			WHEN agency='NYPL' THEN 'New York Public Library'
			WHEN agency='OATH' THEN 'New York City Office of Administrative Trials and Hearings'
			WHEN agency='OCA' THEN 'New York City Office of Court Administration'
			WHEN agency='OCB' THEN 'New York City Office of Collective Bargaining'
			WHEN agency='OCME' THEN 'New York City Office of the Medical Examiner'
			WHEN agency='OEM' THEN 'New York City Office of Emergency Management'
			WHEN agency='OLR' THEN 'New York City Office of Labor Relations'
			WHEN agency='OMB' THEN 'New York City Office of Management and Budget'
			WHEN agency='OPA' THEN 'New York City Office of Payroll Administration'
			WHEN agency='PA-BK' THEN 'New York City Public Administrators Office - Brooklyn'
			WHEN agency='PA-BX' THEN 'New York City Public Administrators Office - Bronx'
			WHEN agency='PA-MN' THEN 'New York City Public Administrators Office - Manhattan'
			WHEN agency='PA-QN' THEN 'New York City Public Administrators Office - Queens'
			WHEN agency='PA-SI' THEN 'New York City Public Administrators Office - Staten Island'
			WHEN agency='PARKS' THEN 'New York City Department of Parks and Recreation'
			WHEN agency='PBADV' THEN 'New York City Office of Public Advocate'
			WHEN agency='PLAN' THEN 'New York City Department of City Planning'
			WHEN agency='PRIV' THEN 'Private'
			WHEN agency='PROB' THEN 'New York City Department of Probation'
			WHEN agency='QPL' THEN 'Queens Public Library'
			WHEN agency='SANIT' THEN 'New York City Department of Sanitation'
			WHEN agency='TAXCM' THEN 'New York City Tax Commission'
			WHEN agency='TBTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='TLC' THEN 'New York City Taxi and Limousine Commission'
			WHEN agency='UNKN' THEN 'New York City Unknown'
		END),
	-- operatorabbrev
		(CASE
			WHEN agency='HYDC' THEN 'HYDC'
			WHEN agency='MTA' THEN 'MTA'
			WHEN agency='NYCTA' THEN 'MTA'
			WHEN agency='TBTA' THEN 'MTA'
			WHEN agency='PARKS' THEN 'NYCDPR'
			WHEN agency='BLDGS' THEN 'NYCDOB'
			WHEN agency='BPL' THEN 'BPL'
			WHEN agency='NYPL' THEN 'NYPL'
			WHEN agency='QPL' THEN 'QPL'
			WHEN agency='SANIT' THEN 'NYCDSNY'
			WHEN agency='AGING' THEN 'NYCDFTA'
			WHEN agency='EDUC' THEN 'NYCDOE'
			WHEN agency='CULT' THEN 'NYCDCLA'
			WHEN agency='CORR' THEN 'NYCDOC'
			WHEN agency='FIRE' THEN 'NYCFDNY'
			WHEN agency='HLTH' THEN 'NYCDOHMH'
			WHEN agency='ELECT' THEN 'NYCBOE'
			WHEN agency='CIVIL' THEN 'NYCCSC'
			WHEN agency='HUMRT' THEN 'NYCCCHR'
			WHEN agency='COUNC' THEN 'NYCCOUNCIL'
			WHEN agency='PLAN' THEN 'NYCDCP'
			WHEN agency='FINAN' THEN 'NYCDOF'
			WHEN agency='PROB' THEN 'NYCDOP'
			WHEN agency='DSBS' THEN 'NYCSBS'
			WHEN agency='FIRE' THEN 'FDNY'
			WHEN agency='NYPD' THEN 'NYPD'
			WHEN agency='HRA' THEN 'NYCHRA/DSS'
			WHEN agency='DA-SP' THEN 'NYCDA-SNP'
			WHEN agency='LDMKS' THEN 'NYCLPC'
			WHEN agency='OEM' THEN 'NYCEM'
			WHEN agency='PBADV' THEN 'NYCPA'
			WHEN agency='ACTRY' THEN 'NYCACT'
			WHEN agency='COMPT' THEN 'NYCCOMP'
			WHEN agency='MAYOR' THEN 'NYCMO'
			WHEN agency='MOME' THEN 'NYCMO'
			WHEN agency='TAX' THEN 'NYCTC'
			WHEN agency='COURT' THEN 'NYCOURTS'
			WHEN agency='CUNY' THEN 'CUNY'
			ELSE CONCAT('NYC',agency)
		END),
	-- oversightagency
		ARRAY[(CASE
			WHEN agency='ACS' THEN 'New York City Administration for Childrens Services'
			WHEN agency='ACTRY' THEN 'New York City Office of the Actuary'
			WHEN agency='AGING' THEN 'New York City Department for the Aging'
			WHEN agency='BIC' THEN 'New York City Business Integrity Commission'
			WHEN agency='BLDGS' THEN 'New York City Department of Buildings'
			WHEN agency='BP-BK' THEN 'New York City Borough President - Brooklyn'
			WHEN agency='BP-BX' THEN 'New York City Borough President - Bronx'
			WHEN agency='BP-MN' THEN 'New York City Borough President - Manhattan'
			WHEN agency='BP-QN' THEN 'New York City Borough President - Queens'
			WHEN agency='BP-SI' THEN 'New York City Borough President - Staten Island'
			WHEN agency='BPL' THEN 'Brooklyn Public Library'
			WHEN agency='BSA' THEN 'New York City Board of Standards and Appeals'
			WHEN agency LIKE 'CB%' THEN CONCAT('New York City Community Board ', RIGHT(agency,3))
			WHEN agency='CCRB' THEN 'New York City Civilian Complaint Review Board'
			WHEN agency='CEO' THEN 'New York City Center for Economic Opportunity'
			WHEN agency='CFB' THEN 'New York City Campaign Finance Board'
			WHEN agency='CIVIL' THEN 'New York City Civil Service Commission'
			WHEN agency='CLERK' THEN 'New York City Office of the City Clerk'
			WHEN agency='COIB' THEN 'New York City Conflict of Interest Board'
			WHEN agency='COMPT' THEN 'New York City Office of the Comptroller'
			WHEN agency='CORR' THEN 'New York City Department of Correction'
			WHEN agency='COUNC' THEN 'New York City Council'
			WHEN agency='COURT' THEN 'New York State Unified Court System'
			WHEN agency='CULT' THEN 'New York City Department of Cultural Affairs'
			WHEN agency='CUNY' THEN 'City University of New York'
			WHEN agency='DA-BK' THEN 'New York City District Attorney - Brooklyn'
			WHEN agency='DA-BX' THEN 'New York City District Attorney - Bronx '
			WHEN agency='DA-MN' THEN 'New York City District Attorney - Manhattan'
			WHEN agency='DA-QN' THEN 'New York City District Attorney - Queens'
			WHEN agency='DA-SI' THEN 'New York City District Attorney - Staten Island'
			WHEN agency='DA-SP' THEN 'New York City District Attorney - Office Special Narcotics'
			WHEN agency='DCA' THEN 'New York City Department of Consumer Affairs'
			WHEN agency='DCAS' THEN 'New York City Department of Citywide Administrative Services'
			WHEN agency='DDC' THEN 'New York City Department of Design and Construction'
			WHEN agency='DEP' THEN 'New York City Department of Environmental Protection'
			WHEN agency='DHS' THEN 'New York City Department of Homeless Services'
			WHEN agency='DOI' THEN 'New York City Department of Investigation'
			WHEN agency='DOITT' THEN 'New York City Department of Information Technology and Telecommunications'
			WHEN agency='DORIS' THEN 'New York City Department of Records and Information Services'
			WHEN agency='DOT' THEN 'New York City Department of Transportation'
			WHEN agency='DSBS' THEN 'New York City Department of Small Business Services'
			WHEN agency='DYCD' THEN 'New York City Department of Youth and Community Development'
			WHEN agency='EDC' THEN 'New York City Economic Development Corporation'
			WHEN agency='EDUC' THEN 'New York City Department of Education'
			WHEN agency='ELECT' THEN 'New York City Board of Elections'
			WHEN agency='FINAN' THEN 'New York City Department of Finance'
			WHEN agency='FIRE' THEN 'New York City Fire Department'
			WHEN agency='FISA' THEN 'New York City Financial Information Services Agency'
			WHEN agency='HHC' THEN 'New York City Health and Hospitals Corporation'
			WHEN agency='HLTH' THEN 'New York City Department of Health and Mental Hygiene'
			WHEN agency='HPD' THEN 'New York City Department of Housing Preservation and Development'
			WHEN agency='HRA' THEN 'New York City Human Resources Administration/Department of Social Services'
			WHEN agency='HUMRT' THEN 'New York City Commission on Human Rights'
			WHEN agency='HYDC' THEN 'Hudson Yards Development Corporation'
			WHEN agency='IBO' THEN 'New York City Independent Budget Office'
			WHEN agency='LAW' THEN 'New York City Law Department'
			WHEN agency='LDMKS' THEN 'New York City Landmarks Preservation Commission'
			WHEN agency='MAYOR' THEN 'New York City Office of the Mayor'
			WHEN agency='MOME' THEN 'New York City Office of the Mayor'
			WHEN agency='MTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYCHA' THEN 'New York City Housing Authority'
			WHEN agency='NYCTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='NYPD' THEN 'New York City Police Department'
			WHEN agency='NYPL' THEN 'New York Public Library'
			WHEN agency='OATH' THEN 'New York City Office of Administrative Trials and Hearings'
			WHEN agency='OCA' THEN 'New York City Office of Court Administration'
			WHEN agency='OCB' THEN 'New York City Office of Collective Bargaining'
			WHEN agency='OCME' THEN 'New York City Office of the Medical Examiner'
			WHEN agency='OEM' THEN 'New York City Office of Emergency Management'
			WHEN agency='OLR' THEN 'New York City Office of Labor Relations'
			WHEN agency='OMB' THEN 'New York City Office of Management and Budget'
			WHEN agency='OPA' THEN 'New York City Office of Payroll Administration'
			WHEN agency='PA-BK' THEN 'New York City Public Administrators Office - Brooklyn'
			WHEN agency='PA-BX' THEN 'New York City Public Administrators Office - Bronx'
			WHEN agency='PA-MN' THEN 'New York City Public Administrators Office - Manhattan'
			WHEN agency='PA-QN' THEN 'New York City Public Administrators Office - Queens'
			WHEN agency='PA-SI' THEN 'New York City Public Administrators Office - Staten Island'
			WHEN agency='PARKS' THEN 'New York City Department of Parks and Recreation'
			WHEN agency='PBADV' THEN 'New York City Office of Public Advocate'
			WHEN agency='PLAN' THEN 'New York City Department of City Planning'
			WHEN agency='PRIV' THEN 'Private'
			WHEN agency='PROB' THEN 'New York City Department of Probation'
			WHEN agency='QPL' THEN 'Queens Public Library'
			WHEN agency='SANIT' THEN 'New York City Department of Sanitation'
			WHEN agency='TAXCM' THEN 'New York City Tax Commission'
			WHEN agency='TBTA' THEN 'Metropolitan Transportation Authority'
			WHEN agency='TLC' THEN 'New York City Taxi and Limousine Commission'
			WHEN agency='UNKN' THEN 'New York City Unknown'
		END)],
	-- oversightabbrev
		ARRAY[(CASE
			WHEN agency='HYDC' THEN 'HYDC'
			WHEN agency='MTA' THEN 'MTA'
			WHEN agency='NYCTA' THEN 'MTA'
			WHEN agency='TBTA' THEN 'MTA'
			WHEN agency='PARKS' THEN 'NYCDPR'
			WHEN agency='BLDGS' THEN 'NYCDOB'
			WHEN agency='BPL' THEN 'BPL'
			WHEN agency='NYPL' THEN 'NYPL'
			WHEN agency='QPL' THEN 'QPL'
			WHEN agency='SANIT' THEN 'NYCDSNY'
			WHEN agency='AGING' THEN 'NYCDFTA'
			WHEN agency='EDUC' THEN 'NYCDOE'
			WHEN agency='CULT' THEN 'NYCDCLA'
			WHEN agency='CORR' THEN 'NYCDOC'
			WHEN agency='FIRE' THEN 'NYCFDNY'
			WHEN agency='HLTH' THEN 'NYCDOHMH'
			WHEN agency='ELECT' THEN 'NYCBOE'
			WHEN agency='CIVIL' THEN 'NYCCSC'
			WHEN agency='HUMRT' THEN 'NYCCCHR'
			WHEN agency='COUNC' THEN 'NYCCOUNCIL'
			WHEN agency='PLAN' THEN 'NYCDCP'
			WHEN agency='FINAN' THEN 'NYCDOF'
			WHEN agency='PROB' THEN 'NYCDOP'
			WHEN agency='DSBS' THEN 'NYCSBS'
			WHEN agency='FIRE' THEN 'FDNY'
			WHEN agency='NYPD' THEN 'NYPD'
			WHEN agency='HRA' THEN 'NYCHRA/DSS'
			WHEN agency='DA-SP' THEN 'NYCDA-SNP'
			WHEN agency='LDMKS' THEN 'NYCLPC'
			WHEN agency='OEM' THEN 'NYCEM'
			WHEN agency='PBADV' THEN 'NYCPA'
			WHEN agency='ACTRY' THEN 'NYCACT'
			WHEN agency='COMPT' THEN 'NYCCOMP'
			WHEN agency='MAYOR' THEN 'NYCMO'
			WHEN agency='MOME' THEN 'NYCMO'
			WHEN agency='TAX' THEN 'NYCTC'
			WHEN agency='COURT' THEN 'NYCOURTS'
			WHEN agency='CUNY' THEN 'CUNY'
			ELSE CONCAT('NYC',agency)
		END)],
	-- datecreated
	CURRENT_TIMESTAMP,
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
		(CASE WHEN usedec LIKE '%RESIDENTIAL%' AND usedec NOT LIKE '%NON RESIDENTIAL%' THEN TRUE
			ELSE FALSE
		END)
FROM 
	dcas_facilities_colp
WHERE
	agency <> 'NYCHA'
	AND agency <> 'HPD'
	AND usedec <> 'ROAD/HIGHWAY'
	AND usedec <> 'TRANSIT WAY'
