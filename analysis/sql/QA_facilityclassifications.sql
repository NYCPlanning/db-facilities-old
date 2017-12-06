COPY(
SELECT DISTINCT facdomain, facgroup, facsubgrp, COUNT(*)
FROM facilities
GROUP BY facdomain, facgroup, facsubgrp
ORDER BY facsubgrp, facgroup, facdomain
) TO '/prod/db-facilities/analysis/output/facdb_summarystats_facilityclassifications.csv' DELIMITER ',' CSV HEADER;

COPY(
	SELECT DISTINCT pgtable, factype, facsubgrp, facgroup, facdomain, COUNT(*)
	FROM facilities
	GROUP BY pgtable, factype, facsubgrp, facgroup, facdomain
	ORDER BY facsubgrp, facgroup, facdomain
) TO '/prod/db-facilities/analysis/output/facdb_qaqc_facilityclassifications.csv' DELIMITER ',' CSV HEADER;
