-- Based on the facility group classify each facility into a domain

UPDATE facilities
SET facdomain = 'Education, Child Welfare, and Youth'
WHERE facgroup = 'Schools (K-12)'
OR facgroup = 'Day Care and Pre-Kindergarten'
OR facgroup = 'Child Services and Welfare'
OR facgroup = 'Youth Services'
OR facgroup = 'Camps'
OR facgroup = 'Higher Education'
OR facgroup = 'Vocational and Proprietary Schools'
;

UPDATE facilities
SET facdomain = 'Parks, Gardens, and Historical Sites'
WHERE facgroup = 'Parks and Plazas'
OR facgroup = 'Historical Sites'
;

UPDATE facilities
SET facdomain = 'Libraries and Cultural Programs'
WHERE facgroup = 'Libraries'
OR facgroup = 'Cultural Institutions'
;

UPDATE facilities
SET facdomain = 'Public Safety, Emergency Services, and Administration of Justice'
WHERE facgroup = 'Emergency Services'
OR facgroup = 'Public Safety'
OR facgroup = 'Justice and Corrections'
;

UPDATE facilities
SET facdomain = 'Health and Human Services'
WHERE facgroup = 'Health Care'
OR facgroup = 'Human Services'
;

UPDATE facilities
SET facdomain = 'Core Infrastructure and Transportation'
WHERE facgroup = 'Solid Waste'
OR facgroup = 'Water and Wastewater'
OR facgroup = 'Transportation'
OR facgroup = 'Telecommunications'
OR facgroup = 'Material Supplies and Markets'
;

UPDATE facilities
SET facdomain = 'Administration of Government'
WHERE facgroup = 'Offices, Training, and Testing'
OR facgroup = 'City Agency Parking, Maintenance, and Storage'
OR facgroup = 'Other Property'
;



