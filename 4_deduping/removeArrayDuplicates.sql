-- Update BIN arrays with distinct BINs
WITH temp AS (
SELECT 
    hash, 
    unnest(BIN) AS BINs
FROM
    facilities as j
WHERE
    BIN IS NOT NULL
    AND BIN <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct BINs) as BIN
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    BIN = j.BIN
FROM
    temp2 AS j
WHERE f.hash = j.hash;


-- Update BBL arrays with distinct BBLs
WITH temp AS (
SELECT 
    hash, 
    unnest(BBL) AS BBLs
FROM
    facilities as j
WHERE
    BBL IS NOT NULL
    AND BBL <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct BBLs) as BBL
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    BBL = j.BBL
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update capacity type arrays with distinct units
WITH temp AS (
SELECT 
    hash, 
    unnest(capacitytype) AS capacitytypes
FROM
    facilities as j
WHERE
    capacitytype IS NOT NULL
    AND capacitytype <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct capacitytypes) as capacitytype
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    capacitytype = j.capacitytype
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update area type arrays with distinct units
WITH temp AS (
SELECT 
    hash, 
    unnest(areatype) AS areatypes
FROM
    facilities as j
WHERE
    areatype IS NOT NULL
    AND areatype <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct areatypes) as areatype
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    areatype = j.areatype
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update oversighttype arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(oversighttype) AS oversighttypes
FROM
    facilities as j
WHERE
    oversighttype IS NOT NULL
    AND oversighttype <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct oversighttypes) as oversighttype
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    oversighttype = j.oversighttype
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update oversightlevel arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(oversightlevel) AS oversightlevels
FROM
    facilities as j
WHERE
    oversightlevel IS NOT NULL
    AND oversightlevel <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct oversightlevels) as oversightlevel
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    oversightlevel = j.oversightlevel
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update oversightabbrev arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(oversightabbrev) AS oversightabbrevs
FROM
    facilities as j
WHERE
    oversightabbrev IS NOT NULL
    AND oversightabbrev <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct oversightabbrevs) as oversightabbrev
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    oversightabbrev = j.oversightabbrev
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update oversightagency arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(oversightagency) AS oversightagencys
FROM
    facilities as j
WHERE
    oversightagency IS NOT NULL
    AND oversightagency <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct oversightagencys) as oversightagency
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    oversightagency = j.oversightagency
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update agencysource arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(agencysource) AS agencysources
FROM
    facilities as j
WHERE
    agencysource IS NOT NULL
    AND agencysource <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct agencysources) as agencysource
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    agencysource = j.agencysource
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update sourcedatasetname arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(sourcedatasetname) AS sourcedatasetnames
FROM
    facilities as j
WHERE
    sourcedatasetname IS NOT NULL
    AND sourcedatasetname <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct sourcedatasetnames) as sourcedatasetname
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    sourcedatasetname = j.sourcedatasetname
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update linkdata arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(linkdata) AS linkdatas
FROM
    facilities as j
WHERE
    linkdata IS NOT NULL
    AND linkdata <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct linkdatas) as linkdata
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    linkdata = j.linkdata
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update datesourceupdated arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(datesourceupdated) AS datesourceupdateds
FROM
    facilities as j
WHERE
    datesourceupdated IS NOT NULL
    AND datesourceupdated <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct datesourceupdateds) as datesourceupdated
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    datesourceupdated = j.datesourceupdated
FROM
    temp2 AS j
WHERE f.hash = j.hash;

-- Update pgtable arrays with distinct
WITH temp AS (
SELECT 
    hash, 
    unnest(pgtable) AS pgtables
FROM
    facilities as j
WHERE
    pgtable IS NOT NULL
    AND pgtable <> ARRAY['']),

temp2 AS (
SELECT
    hash,
    array_agg(distinct pgtables) as pgtable
FROM
    temp
GROUP BY 
    hash)

UPDATE facilities AS f
SET
    pgtable = j.pgtable
FROM
    temp2 AS j
WHERE f.hash = j.hash;