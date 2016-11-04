DROP INDEX IF EXISTS temp_needbbls_gix;
CREATE INDEX temp_needbbls_gix ON temp_needbbls USING GIST (geom);