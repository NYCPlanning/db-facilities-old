-- Based on the facility subgroup classify each facility into a group

-- Education, Child Welfare, and Youth Domain

UPDATE facilities
SET facgroup = 'Schools (K-12)'
WHERE facsubgrp = 'Public K-12 Schools'
OR facsubgrp = 'Charter K-12 Schools'
OR facsubgrp = 'Non-Public K-12 Schools'
OR facsubgrp = 'Special Ed and Schools for Students with Disabilities'
OR facsubgrp = 'GED and Alternative High School Equivalency'
;

UPDATE facilities
SET facgroup = 'Child Care and Pre-Kindergarten'
WHERE facsubgrp = 'DOE Universal Pre-Kindergarten'
OR facsubgrp = 'Dual Child Care and Universal Pre-K'
OR facsubgrp = 'Child Care'
OR facsubgrp = 'Preschools for Students with Disabilities'
;

UPDATE facilities
SET facgroup = 'Child Services and Welfare'
WHERE facsubgrp = 'Foster Care Services and Residential Care'
OR facsubgrp = 'Preventative Care, Evaluation Services, and Respite'
OR facsubgrp = 'Child Nutrition'
;

UPDATE facilities
SET facgroup = 'Youth Services'
WHERE facsubgrp = 'Comprehensive After School System (COMPASS) Sites'
OR facsubgrp = 'Youth Centers, Literacy Programs, Job Training, and Immigrant Services'
;

UPDATE facilities
SET facgroup = 'Camps'
WHERE facsubgrp = 'Camps'
;

UPDATE facilities
SET facgroup = 'Higher Education'
WHERE facsubgrp = 'Colleges or Universities'
;

UPDATE facilities
SET facgroup = 'Vocational and Proprietary Schools'
WHERE facsubgrp = 'Proprietary Schools'
;

-- Parks, Gardens, and Historical Sites Domain

UPDATE facilities
SET facgroup = 'Parks and Plazas'
WHERE facsubgrp = 'Parks'
OR facsubgrp = 'Recreation and Waterfront Sites'
OR facsubgrp = 'Streetscapes, Plazas, and Malls'
OR facsubgrp = 'Gardens'
OR facsubgrp = 'Privately Owned Public Space'
OR facsubgrp = 'Preserves and Conservation Areas'
OR facsubgrp = 'Cemeteries'
;

UPDATE facilities
SET facgroup = 'Historical Sites'
WHERE facsubgrp = 'Historical Sites'
;

-- Libraries and Cultural Programs Domain

UPDATE facilities
SET facgroup = 'Libraries'
WHERE facsubgrp = 'Public Libraries'
OR facsubgrp = 'Academic and Special Libraries'
;

UPDATE facilities
SET facgroup = 'Cultural Institutions'
WHERE facsubgrp = 'Museums'
OR facsubgrp = 'Historical Societies'
OR facsubgrp = 'Other Cultural Institutions'
;

-- Public Safety, Emergency Services, and Administration of Justice Domain

UPDATE facilities
SET facgroup = 'Emergency Services'
WHERE facsubgrp = 'Fire Services'
OR facsubgrp = 'Other Emergency Services'
;

UPDATE facilities
SET facgroup = 'Public Safety'
WHERE facsubgrp = 'Police Services'
OR facsubgrp = 'School-Based Safety Program'
OR facsubgrp = 'Other Public Safety'
;

UPDATE facilities
SET facgroup = 'Justice and Corrections'
WHERE facsubgrp = 'Courthouses and Judicial'
OR facsubgrp = 'Detention and Correctional'
;

-- Health and Human Services Domain

UPDATE facilities
SET facgroup = 'Health Care'
WHERE facsubgrp = 'Hospitals and Clinics'
OR facsubgrp = 'Mental Health'
OR facsubgrp = 'Residential Health Care'
OR facsubgrp = 'Chemical Dependency'
OR facsubgrp = 'Health Promotion and Disease Prevention'
OR facsubgrp = 'Other Health Care'
;

UPDATE facilities
SET facgroup = 'Human Services'
WHERE facsubgrp = 'Senior Services'
OR facsubgrp = 'Community Centers and Community School Programs'
OR facsubgrp = 'Financial Assistance and Social Services'
OR facsubgrp = 'Workforce Development'
OR facsubgrp = 'Legal and Intervention Services'
OR facsubgrp = 'Programs for People with Disabilities'
OR facsubgrp = 'Permanent Supportive SRO Housing'
OR facsubgrp = 'Shelters and Transitional Housing'
OR facsubgrp = 'Non-residential Housing and Homeless Services'
OR facsubgrp = 'Soup Kitchens and Food Pantries'
;

-- Core Infrastructure and Transportation Domain

UPDATE facilities
SET facgroup = 'Solid Waste'
WHERE facsubgrp = 'Solid Waste Processing'
OR facsubgrp = 'Solid Waste Transfer and Carting'
;

UPDATE facilities
SET facgroup = 'Water and Wastewater'
WHERE facsubgrp = 'Wastewater and Pollution Control'
OR facsubgrp = 'Water Supply'
;

UPDATE facilities
SET facgroup = 'Transportation'
WHERE facsubgrp = 'Parking Lots and Garages'
OR facsubgrp = 'Bus Depots and Terminals'
OR facsubgrp = 'Rail Yards and Maintenance'
OR facsubgrp = 'Ports and Ferry Landings'
OR facsubgrp = 'Airports and Heliports'
OR facsubgrp = 'Other Transportation'
;

UPDATE facilities
SET facgroup = 'Telecommunications'
WHERE facsubgrp = 'Telecommunications'
;

UPDATE facilities
SET facgroup = 'Material Supplies and Markets'
WHERE facsubgrp = 'Material Supplies'
OR facsubgrp = 'Wholesale Markets'
;

-- Administration of Government Domain

UPDATE facilities
SET facgroup = 'Offices, Training, and Testing'
WHERE facsubgrp = 'Offices'
OR facsubgrp = 'Training and Testing'
;

UPDATE facilities
SET facgroup = 'City Agency Parking, Maintenance, and Storage'
WHERE facsubgrp = 'Custodial'
OR facsubgrp = 'Maintenance and Garages'
OR facsubgrp = 'City Agency Parking'
OR facsubgrp = 'Storage'
;

UPDATE facilities
SET facgroup = 'Other Property'
WHERE facsubgrp = 'Miscellaneous Use'
OR facsubgrp = 'Properties Leased or Licensed to Non-public Entities'
;






