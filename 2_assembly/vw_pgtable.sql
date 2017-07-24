DROP VIEW IF EXISTS vw_pgtable;
CREATE VIEW vw_pgtable AS (
	SELECT
		facilities.*,
		facdb_pgtable.pgtable
	FROM
		facilities,
		facdb_pgtable
	WHERE facilities.uid = facdb_pgtable.uid
);