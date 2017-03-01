-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab10.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql
SPOOL @appy_oracle_lab10.txt

-- -----------------------------------------------------------------------
-- Step #1 : The first SELECT statement uses a query that relies on a mapping -- and translation table. This step requires you to create a query that take -- records from the TRANSACTION_UPLOAD table and inserts them into the RENTAL -- table. You’ll use this query inside a SELECT statement in Lab #11.
-- ------------------------------------------------------------------------

SELECT DISTINCT 
        r.rental_id 
,       c.contact_id
,       tu.check_out_date AS check_out_date
,       tu.return_date    As return_date
,       3                 AS created_by
,       TURNC(SYSDATE)    AS creation_date 
,       3                 AS last_update_by
,       TURNC(SYSDATE)    AS last_update_date
FROM    member m INNER JOiN contact c
ON      m.member_id = c.member_id INNER JOIN transaction_upload tu
ON      c.first_name = tu.first_name
AND     NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND     c.last_name = tu.last_name
AND     tu.account_number = m.account_number LEFT JOIN rental r
ON      c.contact_id = r.customer_id
AND     TURNC(tu.check_out_date) = TURNC(r.check_out_date)
AND     TURNC(tu.return_date) = TURNC(r.reatun_date);


-- COUNT RENTALS BEFROE INSERT --

SELECT COUNT(*) AS "Rental before count"
FROM RENTAL; 

--A) Check the join condition between the MEMBER and CONTACT table, which 
-- should return 15 rows. If this is not correct, fix the foreign key 
-- values in the CONTACT table.

SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id;


-- B) Check the join condition between the CONTACT and TRANSACTION_UPLOAD -- tables. It should return 11,520 rows. If this is not correct, fix the -- FIRST_NAME, MIDDLE_NAME, or LAST_NAME values in the CONTACT table or -- check whether you have the current *.csv file.

SELECT   COUNT(*)
FROM     contact c INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name;

-- C) Check the join condition between both the MEMBER and CONTACT tables -- and the join of those two tables with the TRANSACTION_UPLOAD table.
-- This should return 11,520 rows. If this is not correct, fix the
-- ACCOUNT_NUMBER column values in the MEMBER table.

SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
AND      m.account_number = tu.account_number;

-- use the following formatting instructions --

SET NULL '<null>'
COLUMN rental_id          FORMAT 9999 HEADING "Rental|ID #"
COLUMN customer_id        FORMAT 9999 HEADING "Customer|ID #"
COLUMN check_out_date     FORMAT A9   HEADING "Check out|Date"
COLUMN return_date        FORMAT A10  HEADING "Return|Date"
COLUMN created_by         FORMAT 9999 HEADING "Created|By"     
COLUMN creation_date      FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by    FORMAT 9999 HEADING "Last|Updated|Date"
COLUMN last_updated_date  FORMAT A10  HEADING "Last|Updated"

-- After you query the rows, you query a count from the RENTAL table
-- before you insert the rows from your query. This SELECT statement 
-- gets you the before value:

SELECT   COUNT(*) AS "Rental before count"
FROM     rental;

-- -----------------------------------
-- INSERT INTO RENTAL TABLE --
-- ------------------------------------

INSERT INTO rental
SELECT  NVL(r.rental_id, rental_s1.NEXTVAL) AS rental_id
,       r.contact_id
,       r.check_out_date
,       r.return_date
,       r.created_by
,       r.creation_date
,       r.last_updated_by
,       r.last_updated_date
FROM    (SELECT DISTICT
,       r.rental_id 
,       c.contact_id
,       tu.check_out_date AS check_out_date
,       3                 AS created_by
,       TRUNC(SYSDATE)    AS creation_date 
,       3                                 AS last_update_by
,       TURNC(SYSDATE)                    AS last_update_date
ON      c.first_name = tu.first_name
AND     NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND     c.last_name = tu.last_name
AND     tu.account_number = m.account_number LEFT JOIN rental r
ON      c.contact_id = r.customer_id
AND     TURNC(tu.check_out_date) = TURNC(r.check_out_date)
AND     TURNC(tu.return_date) = TURNC(r.reatun_date)) r;


-- After you insert the records from the query, you re-query a count from -- the RENTAL table. The same SELECT statement gets you the after value:

SELECT COUNT(*) "Rental after count"
FROM   rental;

-- ----------------------------------------------------------------------
-- Step #2  The second SELECT statement requires that you inserted values into -- the RENTAL table in the last step. It leverages the joins that you worked -- out in the first SELECT statement. Don’t try to re-invent the wheel because -- it isn’t profitable in this case.
-- ------------------------------------------------------------------------
SELECT COUNT(*)
FROM 
(SELECT r.rental_item_id 
,       r.rental_id
,       tu.return_date - r.check_out_date As rental_item_price
,       cl.common_lookup_i                AS rental_item_type
,       3                                 AS created_by
,       TURNC(SYSDATE)                    AS creation_date 
,       3                                 AS last_update_by
,       TURNC(SYSDATE)                    AS last_update_date
FROM    member m INNER JOiN contact c
ON      m.member_id = c.member_id INNER JOIN transaction_upload tu
ON      c.first_name = tu.first_name
AND     NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND     c.last_name = tu.last_name
AND     tu.account_number = m.account_number LEFT JOIN rental r
ON      c.contact_id = r.customer_id
AND     TURNC(tu.check_out_date) = TURNC(r.check_out_date)
AND     TURNC(tu.return_date) = TURNC(r.reatun_date) INNER JOIN common_lookup cl
ON      cl.common_lookup_table  = 'RENTAL_ITEM'
AND     cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND     cl.common_lookup_type   = tu.rental_item_type   LEFT JOIN rentl_item ri
ON      r.rental_id             = ri.rental_id);


 -- Use the following formatting instructions: --

SET NULL '<Null>'
COLUMN rental_item_id     FORMAT 99999 HEADING "Rental|Item ID #"
COLUMN rental_id          FORMAT 99999 HEADING "Rental|ID #"
COLUMN item_id            FORMAT 99999 HEADING "Item|ID #"
COLUMN rental_item_price  FORMAT 99999 HEADING "Rental|Item|Price"
COLUMN rental_item_type   FORMAT 99999 HEADING "Rental|Item|Type"


-- After you query the rows, you query a count from the RENTAL_ITEM table -- before you insert the rows from your query. This SELECT statement gets -- you the before value:

SELECT   COUNT(*) AS "Rental Item Before Count"
FROM     rental_item;

-- INSERT NEW ROWS FROM THE EXTERNAL FILE --

INSERT INTO rental_item
(SELECT NVL(ri.rental_item_id, rental_item_s1.NEXTVAL)
,       r.rental_id
,       tu.item_id
,       3 AS created_by
,       TURNC(SYSDATE)                    AS creation_date 
,       3                                 AS last_update_by
,       TURNC(SYSDATE)                    AS last_update_date
,       cl.common_lookup_id               AS rental_item_type
,       r.return_date - r.check_out_date  AS rental_item_price
FROM    member m INNER JOiN contact c
ON      m.member_id = c.member_id INNER JOIN transaction_upload tu
ON      c.first_name = tu.first_name
AND     NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND     c.last_name = tu.last_name
AND     tu.account_number = m.account_number LEFT JOIN rental r
ON      c.contact_id = r.customer_id
AND     TURNC(tu.check_out_date) = TURNC(r.check_out_date)
AND     TURNC(tu.return_date) = TURNC(r.reatun_date) INNER JOIN common_lookup cl
ON      cl.common_lookup_table  = 'RENTAL_ITEM'
AND     cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
AND     cl.common_lookup_type   = tu.rental_item_type   LEFT JOIN rental_item fi ri
ON      r.rental_id             = ri.rental_id);

-- After you insert the records from the query, you re-query a count from -- the RENTAL_ITEM table. The same SELECT statement gets you the after
-- value:

SELECT   COUNT(*) AS "Rental Item After Count"
FROM     rental_item;



SELECT COUNT (*)
FROM    (SELECT t.transaction_id
,               tu.payment_account_number AS transaction_account
,               cl1.common_lookup_id      AS transaction_type 
,               tu.transaction_date 
,               (SUM(tu.transaction_amount) / 1.06) AS transaction_amount 
,               r.rental_id
,               cl2.common_lookup_id       AS payment_method_type
,               m.credit_card_nummer       AS payment_account_number
,               3                          AS creaded_by
,               TRUNC(SYSDATE)             AS creation_date
,               3                          AS last_updated_by
,               TURNC(SYSDATE)             AS last_update_date
FROM            member m INNER JOIN contact c
ON              m.member_id = c.member_id INNER JOIN transaction_upload tu
ON              c.first_name = tu.first_name
AND             NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND             c.last_name = tu.last_name
AND             tu.account_number = m.account_number INNER JOIN rental r
ON              c.contact_id = r.customer_id
AND             TURNC(tu.check_out_date) = TURNC(r.check_out_date)
AND             TURNC(tu.return_date) = TURNC(r.reatun_date)  INNER JOIN common_lookup cl1
ON              cl1.common_lookup_table  = 'TRANSACTION'
AND             cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND             cl1.common_lookup_type   = tu.rental_item_type INNER JOIN common_lookup cl2

ON              cl2.common_lookup_table  = 'TRANSACTION'
AND             cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND             cl2.common_lookup_type   = tu.payment_method_type LEFT JOIN transaction t
ON              t.transaction_account = tu.payment_account_number
AND             t.rental_id = r.rental_id
AND             t.transaction_type = cl1.common_lookup_id
AND             t.transaction_date = tu.transaction_date
AND             t.payment_method_type = cl2.common_lookup_id
AND             t.payment_account_number = m.credit_card_number

GROUP BY        t.transaction.id
,               tu.payment_account_number
,               cl1.common_lookup_id
,               tu.transaction_date
,               r.rental_id
,               cl2.common_lookup_id
,               m.credit_card_number
,               3
,               TRUNC(SYSDATE)
,               3
,               TRUNC(SYSDATE) ri);       

-- --------------------------------------------------------------------
--3)The third SELECT statement requires that you inserted values into the -- RENTAL_ITEM table in the last step. It also leverages the joins that -- you worked out in the first and secondSELECT statements. Don’t try to -- re-invent the wheel because it isn’t profitable, especially in this
-- case.
-- -----------------------------------------------------------------------
INSERT INTO rental_item
(SELECT NVL(ri.rental_item_id, rental_item_s1.NEXTVAL)
,       r.rental_id
,       tu.item_id
,       3 AS created_by
,       TURNC(SYSDATE)                    AS creation_date 
,       3                                 AS last_update_by
,       TURNC(SYSDATE)                    AS last_update_date
,       cl.common_lookup_id               AS rental_item_type
,       r.return_date - r.check_out_date  AS rental_item_price
FROM    member m INNER JOiN contact c
ON      m.member_id = c.member_id INNER JOIN transaction_upload tu
ON      c.first_name = tu.first_name
AND     NVL(c.middle_name, 'x') = NVL(tu.middle_name, 'x')
AND     c.last_name = tu.last_name
AND     tu.account_number = m.account_number LEFT JOIN rental r
ON      c.contact_id = r.customer_id
AND     TURNC(tu.check_out_date) = TURNC(r.check_out_date)
AND     TURNC(tu.return_date) = TURNC(r.reatun_date) INNER JOIN common_lookup cl
ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = 'Check mapping table to find the correct type value'
 rental_item fi ri

ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = 'Check mapping table to find the correct type value'
JOIN transaction t
ON              t.transaction_account = tu.payment_account_number
AND             t.rental_id = r.rental_id
AND             t.transaction_type = cl1.common_lookup_id
AND             t.transaction_date = tu.transaction_date
AND             t.payment_method_type = cl2.common_lookup_id
AND             t.payment_account_number = m.credit_card_number

GROUP BY        t.transaction.id
,               tu.payment_account_number
,               cl1.common_lookup_id
,               tu.transaction_date
,               r.rental_id
,               cl2.common_lookup_id
,               m.credit_card_number
,               3
,               TRUNC(SYSDATE)
,               3
,               TRUNC(SYSDATE) ri); 


SPOOL OFF
