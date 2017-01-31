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
			replace(facilityname, 'Nycha', 'NYCHA'),
			'Nyc', 'NYC'),
			'Nypd', 'NYPD'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda-Ceo', 'USDA-CEO'),
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
			'Is ', 'IS '),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
			'''S', '''s'),
			'Tlc', 'TLC'),
			'Bx', 'BX'),
			'Mn', 'MN'),
			'Si ', 'SI '),
			'Ccc', 'CCC'),
			'Dcc', 'DCC'),
			'Ura', 'URA'),
			'Ta ', 'TA '),
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
			replace(
			replace(
			replace(facilitytype, 'Nycha', 'NYCHA'),
			'Nyc', 'NYC'),
			'Nypd', 'NYPD'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda-Ceo', 'USDA-CEO'),
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
			'Is ', 'IS '),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
			'''S', '''s'),
			'Tlc', 'TLC'),
			'Bx', 'BX'),
			'Mn', 'MN'),
			'Si ', 'SI '),
			'Ccc', 'CCC'),
			'Dcc', 'DCC'),
			'Ura', 'URA'),
			'Ta ', 'TA '),
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
			replace(
			replace(
			replace(
			replace(
			replace(operatorname, 'Nycha', 'NYCHA'),
			'Nyc', 'NYC'),
			'Nypd', 'NYPD'),
			'Ny', 'NY'),
			'Swd', 'Students with Disabilities'),
			'Usda-Ceo', 'USDA-CEO'),
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
			'Is ', 'IS '),
			'Ii', 'II'),
			'Ymca', 'YMCA'),
			'''S', '''s'),
			'Tlc', 'TLC'),
			'Bx', 'BX'),
			'Mn', 'MN'),
			'Si ', 'SI '),
			'Ccc', 'CCC'),
			'Dcc', 'DCC'),
			'Ura', 'URA'),
			'Ta ', 'TA ');

UPDATE facilities
	SET facilitytype = initcap(facilitytype)
	WHERE
		upper(facilitytype) = facilitytype
		AND facilitytype <> 'IMPACT'
		AND facilitytype <> 'COMPASS'
		AND facilitytype <> 'WIOA CUNY MOU'
	;