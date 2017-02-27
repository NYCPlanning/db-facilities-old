UPDATE facilities AS f
    SET 
        agencysource = ARRAY[j.agencysource],
        sourcedatasetname = ARRAY[CONCAT(j.agencysource, ': ', j.sourcedatasetname)],
        linkdata = ARRAY[CONCAT(j.agencysource, ': ', j.linkdata)],
        linkdownload = ARRAY[CONCAT(j.agencysource, ': ', j.linkdownload)],
        datatype = ARRAY[CONCAT(j.agencysource, ': ', j.datatype)],
        refreshmeans = ARRAY[CONCAT(j.agencysource, ': ', j.refreshmeans)],
        refreshfrequency = ARRAY[CONCAT(j.agencysource, ': ', j.refreshfrequency)],
        datesourceupdated = ARRAY[CONCAT(j.agencysource, ': ', j.datesourceupdated)]
    FROM
        (SELECT DISTINCT ON (pgtable)
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
        f.pgtable = j.pgtable
        AND f.pgtable <> ARRAY['togeocode']
        AND f.pgtable <> ARRAY['dcp_facilities_sfpsd']
    ;

UPDATE facilities AS f
    SET 
        sourcedatasetname = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.sourcedatasetname)],
        linkdata = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.linkdata)],
        linkdownload = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.linkdownload)],
        datatype = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.datatype)],
        refreshmeans = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.refreshmeans)],
        refreshfrequency = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.refreshfrequency)],
        datesourceupdated = ARRAY[CONCAT(array_to_string(f.agencysource,','), ': ', j.datesourceupdated)]
    FROM
        (SELECT DISTINCT ON (pgtable)
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
        f.pgtable = j.pgtable
        AND f.oversightagency = j.oversightagency
        AND (f.pgtable = ARRAY['togeocode']
        OR f.pgtable = ARRAY['dcp_facilities_sfpsd'])
    ;