-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--  -- Run the prior lab script.
\. /home/student/Data/cit225/oracle/lab6/apply_mysql_lab6.sql
 
TEE apply_mysql_lab7.txt
 
--- insert code here ---

SPOOL apply_oracle_lab7.txt

--================================================================
--[3 points] Insert two new rows into the COMMON_LOOKUP table to 
--support the ACTIVE_FLAG column in the PRICE table.
--================================================================
SELECT 'step #1' AS "CODE"FROM dual;
 

INSERT INTO common_lookup 
VALUES 
( common_lookup_s1.NEXTVAL
, 'YES'
, 'Yes'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'ACTICE_FLAG'
, 'Y');

INSERT INTO common_lookup 
VALUES 
( common_lookup_s1.NEXTVAL
, 'NO'
, 'No'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'ACTICE_FLAG'
, 'N');


-- VERIFY STEP ONE
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'PRICE'
AND      common_lookup_column = 'ACTIVE_FLAG'
ORDER BY 1, 2, 3 DESC;

--=============================================================
--[3 points] Insert three new rows into the COMMON_LOOKUP table to support the PRICE_TYPE column in the PRICE table.
--============================================================
INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '1-DAY RENTAL'
, '1-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '1');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '3-DAY RENTAL'
, '3-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '3');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '5-DAY RENTAL'
, '5-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'PRICE'
, 'PRICE_TYPE'
, '5');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '1-DAY RENTAL'
, '1-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '1');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '3-DAY RENTAL'
, '3-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '3');

INSERT INTO common_lookup
VALUES
( common_lookup_s1.NEXTVAL
, '5-DAY RENTAL'
, '5-Day Rental'
, 1, SYSDATE, 1, SYSDATE
, 'RENTAL_ITEM'
, 'RENTAL_ITEM_TYPE'
, '5');

-- VERIFY STEP 3

SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN ('PRICE','RENTAL_ITEM')
AND      common_lookup_column IN ('PRICE_TYPE','RENTAL_ITEM_TYPE')
ORDER BY 1, 2, 3;


--===================================================================
-- Update the RENTAL_ITEM_TYPE column with values for all pre-existing 
--rows, and add the NOT NULL constraint for the RENTAL_ITEM_TYPE column.
--(3A)Update the RENTAL_ITEM_TYPE column with values for all pre-existing rows.
--===================================================================

UPDATE   rental_item ri
SET      rental_item_type =
           (SELECT   cl.common_lookup_id
            FROM     common_lookup cl
            WHERE    cl.common_lookup_code =
              (SELECT   r.return_date - r.check_out_date
               FROM     rental r
               WHERE    r.rental_id = ri.rental_id)
            AND      cl.common_lookup_table = 'RENTAL_ITEM'
            AND      cl.common_lookup_column = 'RENTAL_ITEM_TYPE');

-- VERIFY STEP (3A)

SELECT row_count
,      col_count

FROM (SELECT COUNT(*) AS ROW_COUNT
      FROM rental_item) rc CROSS JOIN
      (SELECT COUNT(rental_item_type) AS col_count
       FROM rental_item
       WHERE rental_item_type IS NOT NULL) cc;

--====================================================================
-- (3b)Change the RENTAL_ITEM_TYPE column of the RENTAL_ITEM table from 
-- a null allowed column to a not null constrained column.
--=====================================================================
ALTER TABLE rental_item MODIFY (rental_item_type NUMBER NOT NULL);

SELECT   table_name
,        ordinal_position
,        column_name
,        CASE
           WHEN is_nullable = 'NO' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        column_type
FROM     information_schema.columns
WHERE    table_name = 'rental_item'
AND      column_name = 'rental_item_type';

--================================================================
-- STEP 4
-- You need to write a SELECT statement that returns a data set that
-- you can subsequently insert into the PRICE table. This is a complex -- problem because you must fabricate rows from a base set of rows
-- andthen you must perform mathematical calculations with the CASE 
--statement. (HINT: All computations are performed inside individual  --rows.)
--================================================================
COLUMN item_id     FROM 9999 HEADING "ITEM|ID"
COLUMN active_flag FROM A6   HEADING "ACTIVE|FLAG"
COLUMN price_type  FROM 9999 HEADING "PRICE|TYPE"
COLUMN price_desc  FROM A12  HEADING "PRICE DESC"
COLUMN start_date  FROM A10  HEADING "START|DATE"
COLUMN end_date    FROM A10  HEADING "END|DATE"
COLUMN amount      FROM 9999 HEADING "AMOUNT"


SELECT i.item_id
,      af.active_flag
,      cl.common_lookup_id   AS price_type
,      cl.common_lookup_type AS price_desc
,   CASE 
          WHEN (TRUNC(SYSDATE) - i.release_date) <= 30 OR 
               (TRUNC(SYSDATE) - i.release_date) > 30  AND
               af.active_flag = 'N' THEN 
               i.release_date
          ELSE
               i.release_date * 31
          END AS start_date

,    CASE
          WHEN (TRUNC(SYSDATE) - i.release_date) > 30 AND 
                af.active_flag = 'N' THEN i.release_date + 30
          END AS end_date

,    CASE 
           WHEN (TRUNC(SYSDATE) - i.release_date) <= 30 THEN
           CASE
               WHEN dr.rental_days = 1 THEN 3
               WHEN dr.rental_days = 3 THEN 10
               WHEN dr.rental_days = 5 THEN 15
          END
          WHEN (TRUNC(SYSDATE) - i.release_date) > 30 AND 
                af.active_flag = 'N' THEN
          CASE
               WHEN dr.rental_days = 1 THEN 3
               WHEN dr.rental_days = 3 THEN 10
               WHEN dr.rental_days = 5 THEN 15
          END
      ELSE
           CASE     
               WHEN dr.rental_days = 1 THEN 1
               WHEN dr.rental_days = 3 THEN 3
               WHEN dr.rental_days = 5 THEN 5
             END
        END AS amount
 FROM  item i CROSS JOIN
       (SELECT 'Y' AS active_flag FROM dual
         UNION ALL
          SELECT 'N' AS active_flag FROM dual) af CROSS JOIN
       (SELECT  '1' AS rental_days FROM dual
         UNION ALL 
         SELECT '3' AS rental_days FROM dual
         UNION ALL
            SELECT '5' AS rental_days FROM dual) dr INNER JOIN
         common_lookup cl ON dr.rental_days = SUBSTR 
         (cl.common_lookup_type, 1, 1)

WHERE
 
NOT      (af.active_flag = 'N' AND (TRUNC(SYSDATE)- 30) <   
         i.release_date) 

ORDER BY 1, 2, 3;
 

SPOOL OFF
