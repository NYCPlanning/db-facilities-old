UPDATE facdb_bin 
    SET 
        bin = NULL
    WHERE
        bin = '1000000'
        OR bin = '2000000'
        OR bin = '3000000'
        OR bin = '4000000'
        OR bin = '5000000'
        OR bin = ''
        OR bin = '0'
        OR bin = '0000000000'
    ;