DROP TABLE IF EXISTS facdb_uid_key;
CREATE TABLE facdb_uid_key (
	hash text UNIQUE, 
	uid SERIAL PRIMARY KEY
);


-- INSERT INTO facdb_uid_key
-- SELECT hash
-- FROM facilities
-- WHERE hash NOT IN (
-- SELECT hash FROM facdb_uid_key
-- );
-- -- JOIN uid FROM KEY ONTO DATABASE
-- UPDATE facilities AS f
-- SET uid = k.uid
-- FROM facdb_uid_key AS k
-- WHERE k.hash = f.hash;
