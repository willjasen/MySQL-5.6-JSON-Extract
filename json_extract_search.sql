DELIMITER $$
/*
 * JSON extract - returns the value of a particular key based on a matching search key and value
 *
 * This function requires a related function called json_extract_1
 */
 
DROP FUNCTION IF EXISTS `json_extract_search`$$
CREATE FUNCTION `json_extract_search`(json_txt TEXT, search_key TEXT, search_value TEXT, return_key TEXT) 
    RETURNS TEXT
BEGIN
    -- This statement returns the value of a given key in the same object that contains the search key/value pair
    RETURN (SELECT json_extract_1(json_object,return_key)   
    
    -- This section returns the key/value pair that matches the search_key and its associated search_value
    FROM (
      -- Returns the nth JSON object
      SELECT ( TRIM('\r\n' FROM 
        SUBSTRING_INDEX(
          SUBSTRING_INDEX(
            SUBSTRING_INDEX(
              json_txt, '}', n
            ),
          '{', -1*(n+1)
          ),
          '},', -1
        )
        )
      ) AS json_object

      -- Generate a table of one column with rows from 0 to 99
      FROM (SELECT t1.v + t2.v*10 AS n
        FROM (SELECT 0 AS v UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t1,
             (SELECT 0 AS v UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) t2
        ) numbers
      WHERE CHAR_LENGTH(json_txt) - CHAR_LENGTH(REPLACE(json_txt , ',', '')) >= n - 1
        AND n>0) sp
	  
    WHERE json_extract_1(json_object,search_key) = search_value
    LIMIT 1
    );
END$$
DELIMITER ;
