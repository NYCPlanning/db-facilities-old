SELECT
	CONCAT('### ',agencysourcename,' (', agencysource, ')') AS agencysource,
	'| | |' AS header,
	'| -- | -- |' AS divider,
	(CASE
		WHEN linkdata<>'NA' THEN CONCAT('| Dataset Name: | [',sourcedatasetname,'](',linkdata,') |')
		WHEN linkdata='NA' THEN CONCAT('| Dataset Name:  | ',sourcedatasetname,' |')
	END) AS datasetandlink,
	CONCAT('| Last Updated: | ',datesourceupdated,' |') AS lastupdated,
	(CASE
		WHEN refreshmeans <> 'NA' THEN CONCAT('| Refresh Method: | ', refreshmeans, ' |')
		WHEN refreshmeans = 'NA' THEN CONCAT('| Refresh Method: | Confirm with agency |')
	END) AS refreshmethod
FROM
	facilities_data_sources
ORDER BY
	agencysourcename
