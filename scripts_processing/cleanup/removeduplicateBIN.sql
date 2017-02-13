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