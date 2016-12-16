UPDATE facilities 
    SET 
        agencysource = ARRAY[j.agencysource],
        sourcedatasetname = ARRAY[j.sourcedatasetname],
        linkdata = ARRAY[j.linkdata],
        linkdownload = ARRAY[j.linkdownload],
        datatype = ARRAY[j.datatype],
        refreshmeans = ARRAY[j.refreshmeans],
        refreshfrequency = ARRAY[j.refreshfrequency],
        datesourceupdated = ARRAY[j.datesourceupdated]
    FROM
        (SELECT
            f.pgtable,
            d.agencysource,
            d.sourcedatasetname,
            d.linkdata,
            d.linkdownload,
            d.datatype,
            d.refreshmeans,
            d.refreshfrequency,
            d.datesourceupdated::date
            FROM
            facilities AS f
            LEFT JOIN
            facilities_data_sources AS d
            ON
            f.pgtable = ARRAY[d.pgtable]
        ) AS j
    WHERE
        facilities.pgtable = j.pgtable
        AND facilities.agencysource IS NULL
    ;