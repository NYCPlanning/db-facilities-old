-- Reports how many records for the new version of the facilities table and the old version of the facilities table
-- Calculate the percentage change from the old version to the new version
WITH newfrequency(facdomain,facgroup,facsubgrp) AS (
    SELECT facdomain,
    facgroup,
    facsubgrp,
	 COUNT(facsubgrp) AS newcount
	 FROM facdb
	 GROUP BY facdomain, facgroup, facsubgrp),
oldfrequency(facdomain,facgroup,facsubgrp) AS (
	SELECT facdomain,
    facgroup,
    facsubgrp,
	 COUNT(facsubgrp) AS oldcount
	 FROM facdb_prev
	 GROUP BY facdomain, facgroup, facsubgrp)
SELECT a.facdomain AS facility_domain,
  	a.facgroup AS facility_group,
   	a.facsubgrp AS facility_subgroup,
  	a.newcount,
  	b.oldcount,
  	-- 100.0 * (new- prev) / (new)
  	100.0 * (a.newcount - b.oldcount) / a.newcount AS percentage_change
    INTO frequencychanges
  	FROM newfrequency a
  	JOIN oldfrequency b
  	ON a.facsubgrp = b.facsubgrp
  	GROUP BY a.facdomain, a.facgroup, a.facsubgrp, a.newcount,b.oldcount
  	ORDER BY a.facdomain, a.facgroup, a.facsubgrp;
copy (SELECT * FROM frequencychanges) TO '/Users/tommywang/git/db-facilities/output/qc_frequencychanges.csv' DELIMITER ',' CSV HEADER;
DROP TABLE IF EXISTS frequencychanges;
