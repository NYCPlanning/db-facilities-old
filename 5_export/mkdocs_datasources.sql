COPY (
	SELECT
		CONCAT('### ',datasourcefull,' (', datasource, ')') AS datasource,
		'| | |' AS header,
		'| -- | -- |' AS divider,
		(CASE
			WHEN dataurl <> 'NA' THEN CONCAT('| Dataset Name: | [',dataname,'](',dataurl,') |')
			WHEN dataurl = 'NA' THEN CONCAT('| Dataset Name:  | ',dataname,' |')
		END) AS datasetandlink,
		CONCAT('| Last Updated: | ', datadate ,' |') AS lastupdated,
		(CASE
			WHEN refreshmeans <> 'NA' THEN CONCAT('| Refresh Method: | ', refreshmeans, ' |')
			WHEN refreshmeans = 'NA' THEN CONCAT('| Refresh Method: | Confirm with agency |')
		END) AS refreshmethod
	FROM
		facdb_datasources
	ORDER BY
		datasourcefull
) TO '/Users/hannahbkates/facilities-db/tables/tables_mkdocs/facdb_datasources_docs.csv' WITH CSV DELIMITER ',' HEADER;