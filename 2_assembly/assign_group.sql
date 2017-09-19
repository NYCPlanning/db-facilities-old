-- Based on the facility subgroup classify each facility into a group

-- Education, Child Welfare, and Youth Domain

UPDATE facilities
SET facgroup = 'Schools (K-12)'
WHERE facilitysubgroup = 'Public K-12 Schools'
OR facilitysubgroup = 'Charter K-12 Schools'
OR facilitysubgroup = 'Non-Public K-12 Schools'
OR facilitysubgroup = 'Special Ed and Schools for Students with Disabilities'
OR facilitysubgroup = 'GED and Alternative High School Equivalency'
;

UPDATE facilities
SET facgroup = 'Child Care and Pre-Kindergarten'
WHERE facilitysubgroup = 'DOE Universal Pre-Kindergarten'
OR facilitysubgroup = 'Dual Child Care and Universal Pre-K'
OR facilitysubgroup = 'Child Care'
OR facilitysubgroup = 'Preschools for Students with Disabilities'
;

UPDATE facilities
SET facgroup = 'Child Services and Welfare'
WHERE facilitysubgroup = 'Foster Care Services and Residential Care'
OR facilitysubgroup = 'Preventative Care, Evaluation Services, and Respite'
OR facilitysubgroup = 'Child Nutrition'
;

UPDATE facilities
SET facgroup = 'Youth Services'
WHERE facilitysubgroup = 'Comprehensive After School System (COMPASS) Sites'
OR facilitysubgroup = 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'
;

UPDATE facilities
SET facgroup = 'Camps'
WHERE facilitysubgroup = 'Camps'
;

UPDATE facilities
SET facgroup = 'Higher Education'
WHERE facilitysubgroup = 'Colleges or Universities'
;

UPDATE facilities
SET facgroup = 'Vocational and Proprietary Schools'
WHERE facilitysubgroup = 'Proprietary Schools'
;

-- Parks, Gardens, and Historical Sites Domain

UPDATE facilities
SET facgroup = 'Parks and Plazas'
WHERE facilitysubgroup = 'Parks'
OR facilitysubgroup = 'Recreation and Waterfront Sites'
OR facilitysubgroup = 'Streetscapes, Plazas, and Malls'
OR facilitysubgroup = 'Gardens'
OR facilitysubgroup = 'Privately Owned Public Space'
OR facilitysubgroup = 'Preserves and Conservation Areas'
OR facilitysubgroup = 'Cemeteries'
;

UPDATE facilities
SET facgroup = 'Historical Sites'
WHERE facilitysubgroup = 'Historical Sites'
;

-- Libraries and Cultural Programs Domain

UPDATE facilities
SET facgroup = 'Libraries'
WHERE facilitysubgroup = 'Public Libraries'
OR facilitysubgroup = 'Academic and Special Libraries'
;

UPDATE facilities
SET facgroup = 'Cultural Institutions'
WHERE facilitysubgroup = 'Museums'
OR facilitysubgroup = 'Historical Societies'
OR facilitysubgroup = 'Other Cultural Institutions'
;

-- Public Safety, Emergency Services, and Administration of Justice Domain

UPDATE facilities
SET facgroup = 'Emergency Services'
WHERE facilitysubgroup = 'Fire Services'
OR facilitysubgroup = 'Other Emergency Services'
;

UPDATE facilities
SET facgroup = 'Public Safety'
WHERE facilitysubgroup = 'Police Services'
OR facilitysubgroup = 'School-Based Safety Program'
OR facilitysubgroup = 'Other Public Safety'
;

UPDATE facilities
SET facgroup = 'Justice and Corrections'
WHERE facilitysubgroup = 'Courthouses and Judicial'
OR facilitysubgroup = 'Detention and Correctional'
;

-- Health and Human Services Domain

UPDATE facilities
SET facgroup = 'Health Care'
WHERE facilitysubgroup = 'Hospitals and Clinics'
OR facilitysubgroup = 'Mental Health'
OR facilitysubgroup = 'Residential Health Care'
OR facilitysubgroup = 'Chemical Dependency'
OR facilitysubgroup = 'Health Promotion and Disease Prevention'
OR facilitysubgroup = 'Other Health Care'
;

UPDATE facilities
SET facgroup = 'Human Services'
WHERE facilitysubgroup = 'Senior Services'
OR facilitysubgroup = 'Community Centers and Community School Programs'
OR facilitysubgroup = 'Financial Assistance and Social Services'
OR facilitysubgroup = 'Workforce Development'
OR facilitysubgroup = 'Legal and Intervention Services'
OR facilitysubgroup = 'Programs for People with Disabilities'
OR facilitysubgroup = 'Permanent Supportive SRO Housing'
OR facilitysubgroup = 'Shelters and Transitional Housing'
OR facilitysubgroup = 'Non-residential Housing and Homeless Services'
OR facilitysubgroup = 'Soup Kitchens and Food Pantries'
;

-- Core Infrastructure and Transportation Domain

UPDATE facilities
SET facgroup = 'Solid Waste'
WHERE facilitysubgroup = 'Solid Waste Processing'
OR facilitysubgroup = 'Solid Waste Transfer and Carting'
;

UPDATE facilities
SET facgroup = 'Water and Wastewater'
WHERE facilitysubgroup = 'Wastewater and Pollution Control'
OR facilitysubgroup = 'Water Supply'
;

UPDATE facilities
SET facgroup = 'Transportation'
WHERE facilitysubgroup = 'Parking Lots and Garages'
OR facilitysubgroup = 'Bus Depots and Terminals'
OR facilitysubgroup = 'Rail Yards and Maintenance'
OR facilitysubgroup = 'Ports and Ferry Landings'
OR facilitysubgroup = 'Airports and Heliports'
OR facilitysubgroup = 'Other Transportation'
;

UPDATE facilities
SET facgroup = 'Telecommunications'
WHERE facilitysubgroup = 'Telecommunications'
;

UPDATE facilities
SET facgroup = 'Material Supplies and Markets'
WHERE facilitysubgroup = 'Material Supplies'
OR facilitysubgroup = 'Wholesale Markets'
;

-- Administration of Government Domain

UPDATE facilities
SET facgroup = 'Offices, Training, and Testing'
WHERE facilitysubgroup = 'Offices'
OR facilitysubgroup = 'Training and Testing'
;

UPDATE facilities
SET facgroup = 'City Agency Parking, Maintenance, and Storage'
WHERE facilitysubgroup = 'Custodial'
OR facilitysubgroup = 'Maintenance and Garages'
OR facilitysubgroup = 'City Agency Parking'
OR facilitysubgroup = 'Storage'
;

UPDATE facilities
SET facgroup = 'Other Property'
WHERE facilitysubgroup = 'Miscellaneous Use'
OR facilitysubgroup = 'Properties Leased or Licensed to Non-public Entities'
;






