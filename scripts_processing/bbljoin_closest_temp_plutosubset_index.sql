DROP INDEX IF EXISTS temp_plutosubset_gix;
CREATE INDEX temp_plutosubset_gix ON temp_plutosubset USING GIST (geom);