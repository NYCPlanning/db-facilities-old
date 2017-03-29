## Insert new records in updated source table that aren't in existing FacDB
SELECT * FROM sourcetable
WHERE hash NOT IN (SELECT * FROM copy_backup3 WHERE pgtable @> ARRAY'sourcetable'])

## Archive existing records in FacDB that aren't in updated source table
SELECT * FROM facilities
WHERE hash NOT IN (SELECT * FROM sourcetable)

## Join updated source date
