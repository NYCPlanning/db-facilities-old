COPY(
SELECT DISTINCT facdomain, facgroup, facsubgrp, COUNT(*)
FROM facilities
GROUP BY facdomain, facgroup, facsubgrp
ORDER BY facdomain, facgroup, facsubgrp
) TO '/prod/facilities-db/analysis/output/facdb_summarystats_facilityclassifications.csv' DELIMITER ',' CSV HEADER;
