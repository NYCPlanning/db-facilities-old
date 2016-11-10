DROP INDEX IF EXISTS mappluto_gix;
CREATE INDEX mappluto_gix ON dcp_mappluto USING GIST (geom);
