update facilities
set
idagency = ARRAY[REPLACE(array_to_string(idagency,','),CONCAT(array_to_string(agencysource,','),': '),'')],
oversightlevel = ARRAY[REPLACE(array_to_string(oversightlevel,','),CONCAT(array_to_string(agencysource,','),': '),'')],
capacity = ARRAY[REPLACE(array_to_string(capacity,','),CONCAT(array_to_string(agencysource,','),': '),'')],
capacitytype = ARRAY[REPLACE(array_to_string(capacitytype,','),CONCAT(array_to_string(agencysource,','),': '),'')],
utilization = ARRAY[REPLACE(array_to_string(utilization,','),CONCAT(array_to_string(agencysource,','),': '),'')],
utilizationrate = ARRAY[REPLACE(array_to_string(utilizationrate,','),CONCAT(array_to_string(agencysource,','),': '),'')],
area = ARRAY[REPLACE(array_to_string(area,','),CONCAT(array_to_string(agencysource,','),': '),'')],
areatype = ARRAY[REPLACE(array_to_string(areatype,','),CONCAT(array_to_string(agencysource,','),': '),'')]
;

update facilities
set
idagency = ARRAY[REPLACE(array_to_string(idagency,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
oversightlevel = ARRAY[REPLACE(array_to_string(oversightlevel,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
capacity = ARRAY[REPLACE(array_to_string(capacity,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
capacitytype = ARRAY[REPLACE(array_to_string(capacitytype,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
utilization = ARRAY[REPLACE(array_to_string(utilization,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
utilizationrate = ARRAY[REPLACE(array_to_string(utilizationrate,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
area = ARRAY[REPLACE(array_to_string(area,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')],
areatype = ARRAY[REPLACE(array_to_string(areatype,','),CONCAT(array_to_string(oversightabbrev,','),': '),'')]
;