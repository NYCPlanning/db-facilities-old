DROP INDEX IF EXISTS facilities_gix;
CREATE INDEX facilities_gix ON facilities USING GIST (geom);
