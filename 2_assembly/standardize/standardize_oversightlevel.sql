UPDATE facilities AS f
    SET 
		overlevel = 
			(CASE
				WHEN 
					overabbrev LIKE '%NYS%'
					OR overabbrev LIKE '%MTA%'
					OR overabbrev LIKE '%NYCHA%'
					OR overabbrev LIKE '%PANYNJ%'
					OR overabbrev LIKE '%RIOC%'
				THEN 'State'
				WHEN
					overabbrev LIKE '%NYC%'
					OR overabbrev LIKE '%FDNY%'
					OR overabbrev LIKE '%NYPD%'
					OR overabbrev LIKE '%CUNY%'
				THEN 'City'
				WHEN
					overabbrev LIKE '%US%'
					OR overabbrev LIKE '%FBOP%'
					OR overabbrev LIKE '%Amtrak%'
				THEN 'Federal'
				WHEN
					overabbrev LIKE '%HYDC%'
					OR overabbrev LIKE '%HRPT%'
					OR overabbrev LIKE '%BBPC%'
					OR overabbrev LIKE '%TGI%'
				THEN 'City-State'
				ELSE 'Non-public Oversight'
			END);

UPDATE facilities AS f
	SET overlevel = 'NYCDOE: City, NYSED: State'
	WHERE overlevel = 'NYCDOE, NYSED: State';