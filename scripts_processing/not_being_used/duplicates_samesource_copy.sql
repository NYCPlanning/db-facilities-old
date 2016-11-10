SELECT
a.*,
b.guid as guid_b,
FROM facilities as a
LEFT JOIN facilities as b
ON a.id = b.id
ORDER BY a.agencysource, a.facilitysubgroup, a.bbl, a.facilityname