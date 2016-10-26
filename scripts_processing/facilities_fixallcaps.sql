UPDATE facilities AS f
    SET 
		facilityname =
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(facilityname, 'Nyc', 'NYC'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda', 'USDA'),
			'Ged', 'GED'),
			'Cuny', 'CUNY'),
			'Suny', 'SUNY'),
			'Wep', 'Work Experience Program'),
			'Esl', 'ESL'),
			'Llc', 'LLC'),
			'Ps', 'PS'),
			'Fdny', 'FDNY'),
			'Sped', 'SPED'),
			'Hs', 'HS'),
			'Ps/Is', 'PS/IS'),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
		facilitytype =
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(facilitytype, 'Nyc', 'NYC'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda', 'USDA'),
			'Ged', 'GED'),
			'Cuny', 'CUNY'),
			'Suny', 'SUNY'),
			'Wep', 'Work Experience Program'),
			'Esl', 'ESL'),
			'Llc', 'LLC'),
			'Nypd', 'NYPD'),
			'Fdny', 'FDNY'),
		operatorname =
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(
			replace(operatorname, 'Nyc', 'NYC'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda', 'USDA'),
			'Ged', 'GED'),
			'Cuny', 'CUNY'),
			'Suny', 'SUNY'),
			'Wep', 'Work Experience Program'),
			'Esl', 'ESL'),
			'Llc', 'LLC')