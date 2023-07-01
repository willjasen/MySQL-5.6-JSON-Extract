DELIMITER $$
/*
 * JSON extract - returns the value associated with the first match of a given key
 */
DROP FUNCTION IF EXISTS `json_extract_1`$$
CREATE FUNCTION `json_extract_1`(json_txt TEXT, search_key TEXT) 
    RETURNS TEXT
BEGIN
    -- This statement returns the value of the first key matched
    RETURN (SELECT TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX(txt,':',-1), '"', 2), '"', -1)) AS val
    FROM (
    
        -- This statement returns the nth pair, starting with 0 (which returns nothing), then iterates to 1 (which returns the first key/value pair), and so on
        SELECT TRIM('\r\n' FROM SUBSTRING_INDEX(SUBSTRING_INDEX(SUBSTRING_INDEX( SUBSTRING_INDEX(json_txt , ',', n), ',',  -1 ), '}', 1), '{', -1)) AS txt

        -- Generate a table of one column with rows from 0 to 99
        FROM (SELECT t1.v + t2.v*10 AS n
            FROM (SELECT 0 AS v UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
                 (SELECT 0 AS v UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2) numbers
        WHERE CHAR_LENGTH(json_txt ) - CHAR_LENGTH(REPLACE(json_txt , ',', '')) >= n - 1
        AND n>0 ) sp
    WHERE TRIM(SUBSTRING_INDEX(txt,':',1)) = CONCAT('"',search_key,'"')
    LIMIT 1
    );
END$$
DELIMITER ;
