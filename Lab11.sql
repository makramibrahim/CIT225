@../lab9/apply_oracle_lab9.sql
 

SPOOL apply_oracle_lab11.txt

--====================================================
-- Step #1: MERGE TRANSAACITON DATE INTO RENTAL TABLE.
--====================================================

MERGE INTO rental traget
USING (SELECT DISTINCT
	  r.rental_id
	, c.contact_id
	, tu.check_out_date AS check_out_date
	, tu.check_out_date As return_date
	, 3					AS create_by
	, TRUNC(SYSDATE)	AS creation_date
	, 3 				AS last_updated_by
	, TRUNC(SYSDATE)	AS last_updated_by
	FROM member m INNER JOIN cotnact c 
	ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON   c.first_name = tu.first_name
	AND  NVL(c.middle_name, 'X') = NVL(tu.middle_name, 'X')
	AND  c.last_name = tu.last_name
	AND  tu.contact_number = m.account_number LEFT JOIN rental r 
	ON   c.contact_id = r.customer_id
	AND  tu.check_out_date = r.check_out_date
	AND  tu.return_date = r.return_date) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN 
UPDATE SET last_updated_by = source.last_updated_by
,			last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.nextval
, source.contact_id
, source.check_out_date
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

    -- Use the following query after you run the MERGE statement --
SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental after merge"
FROM     rental;

--=========================================================
-- Step #2: MERGE TRANSAACITON DATE INTO RENTAL_ITEM TABLE
--=========================================================

MERGE INTO rental_item target
USING (SELECT ri.rental_item_id
	,		r.rental_id
	,		tu.item_id
	,		r.return_date - r.check_out_date AS rental_item_price
	,		cl.common_lookup_id	AS rental_item_type
	, 		3 AS last_updated_by
	,		TRUNC(SYSDATE) AS creation_date
	,		3 AS last_updated_by
	, 		TRUNC(SYSDATE) AS last_updated_date
	FROM member m INNER JOIN cotnact c 
	ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON   c.first_name = tu.first_name
	AND  NVL(c.middle_name, 'X') = NVL(tu.middle_name, 'X')
	AND  c.last_name = tu.last_name
	AND  tu.contact_number = m.account_number LEFT JOIN rental r 
	ON   c.contact_id = r.customer_id
	AND  TRUNC(tu.check_out_date) = TRUNC(R.check_out_date)
	AND  TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl
	ON   cl.common_lookup_table = 'RENTAL_ITEM'
	AND  cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
	AND  cl.common_lookup_type = tu.rental_item_type LEFT JOIN rental_item ri
	ON 	 r.rental_id = ri.rental_id) source

ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_updated_date)


VALUES
( rental_item_s1.nextval
, source.rental_id
, source.item_id
, source.rental_item_price
, source.rental_item_type
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

-- Use the following query after you run the MERGE statement --

SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental Item after merge"
FROM     rental_item;

--=========================================================
-- Step #3: MERGE TRANSAACITON DATE INTO TRANSACTION TABLE
--=========================================================
MERGE INTO transaction target
USING ( SELECT	t.transaction_id
	    ,		tu.payment_account_number AS transaction_account
	    ,		cl.common_lookup_id AS transaction_type
	    , 		tu.transaction_date
	    ,		(SUM(tu.transaction_amount) / 1.06) AS transaction_amount
	    ,		r.rental_id
	    , 		cl2.common_lookup_id AS payment_method
	    ,		m.credit_card_nmuber AS payment_account_number
	    ,		3 AS last_updated_by
	    ,		TRUNC(SYSDATE) AS creation_date
	    ,		3 AS last_updated_by
	    , 		TRUNC(SYSDATE) AS last_updated_date
	    FROM member m INNER JOIN cotnact c 
	    ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
	    ON   c.first_name = tu.first_name
	    AND  NVL(c.middle_name, 'X') = NVL(tu.middle_name, 'X')
	    AND  c.last_name = tu.last_name
	    AND  tu.contact_number = m.account_number LEFT JOIN rental r 
	    ON   c.contact_id = r.customer_id
	    AND  TRUNC(tu.check_out_date) = TRUNC(R.check_out_date)
	    AND  TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl1
	    ON   cl1.common_lookup_table = 'RENTAL_ITEM'
	    AND  cl1.common_lookup_column = 'RENTAL_ITEM_TYPE'
	    AND  cl1.common_lookup_type - tu.transaction_type INNER JOIN common_lookup cl2
	    ON   cl2.common_lookup_table = 'RENTAL_ITEM'
	    AND  cl2.common_lookup_column = 'RENTAL_ITEM_TYPE'
	    AND  cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
	    ON   t.transaction_aabout = tu.payment_account_number
	    AND  t.rental_id = r.rental_id
	    AND  t.transaction_type = cl1.common_lookup_id
	    AND  t.transaction_type = tu.transaction_date
	    AND  t.payment_method_type = cl2.common_lookup_id
	    AND  t.payment_account_number = m.credit_card_nmuber
	    GROUP BY t.transaction_id
	    ,		 tu.payment_account_number
	    ,		 cl1.common_lookup_id
	    , 		 tu.transaction_date
	    ,        r.rental_id
	    , 		 cl2.common_lookup_id
	    ,		 m.credit_card_nmuber
	    , 		 3
	    ,        TRUNC(SYSDATE)
	    ,		 3
	    ,		 TRUNC(SYSDATE) source

ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT
( transaction_id
, transaction_id
, transaction_type
, transaction_date
, transaction_amount
, rental_id
, payment_method_type
, payment_account_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
)


VALUES
( transaction_s1.nextval
, source.transaction_account
, source.transaction_type
, source.transaction_date
, source.transaction_amount
, source.rental_id
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

-- Use the following query after you run the MERGE statement --

SELECT   TO_CHAR(COUNT(*),'99,999') AS "Transaction after merge"
FROM     transaction;

--=========================================================
-- Step #4 a) MERGE TRANSAACITON DATE INTO TRANSACTION TABLE
--=========================================================
CREATE OR REPLACE PROCEDURE upload_transaction IS 

-- STE SAVE POINT FOR AN ALL OR NOTHING TRANSACTION.
BEGIN 

SAVEPOINT starting_point;


--INSERT OF UPDATE TABLE--

MERGE INTO rental target 
USING (SELECT DISTINCT
		,		r.rental_id
		,		c.contact_id
		,		tu.check_out_date AS check_out_date
		,		tu.return_date AS return_date
		, 		3 AS created_by
		,	 	TRUNC(SYSDATE) AS creation_date
		,	 	3 AS last_updated_by
		,	 	TRUNC(SYSDATE) AS last_updated_date
		FROM member m INNER JOIN cotnact c 
	    ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
		ON   c.first_name = tu.first_name
		AND  NVL(c.middle_name, 'X') = NVL(tu.middle_name, 'X')
		AND  c.last_name = tu.last_name
		AND  tu.contact_number = m.account_number LEFT JOIN rental r 
		ON   c.contact_id = r.customer_id
		AND  tu.check_out_date = r.check_out_date
		AND  tu.return_date = r.return_date) source
ON (target.rental_id = source.rental_id)
WHEN MATCHED THEN 
UPDATE SET last_updated_by = source.last_updated_by
,			last_update_date = source.last_update_date
WHEN NOT MATCHED THEN
INSERT VALUES
( rental_s1.nextval
, source.contact_id
, source.check_out_date
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

-- INSERT OR UPDATE TABLE --

MERGE INTO rental_item target
USING (SELECT ri.rental_item_id
	,		r.rental_id
	,		tu.item_id
	,		r.return_date - r.check_out_date AS rental_item_price
	,		cl.common_lookup_id	AS rental_item_type
	, 		3 AS last_updated_by
	,		TRUNC(SYSDATE) AS creation_date
	,		3 AS last_updated_by
	, 		TRUNC(SYSDATE) AS last_updated_date
	FROM member m INNER JOIN cotnact c 
	ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
	ON   c.first_name = tu.first_name
	AND  NVL(c.middle_name, 'X') = NVL(tu.middle_name, 'X')
	AND  c.last_name = tu.last_name
	AND  tu.contact_number = m.account_number LEFT JOIN rental r 
	ON   c.contact_id = r.customer_id
	AND  TRUNC(tu.check_out_date) = TRUNC(R.check_out_date)
	AND  TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl
	ON   cl.common_lookup_table = 'RENTAL_ITEM'
	AND  cl.common_lookup_column = 'RENTAL_ITEM_TYPE'
	AND  cl.common_lookup_type = tu.rental_item_type LEFT JOIN rental_item ri
	ON 	 r.rental_id = ri.rental_id) source

ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT
( rental_item_id
, rental_id
, item_id
, rental_item_price
, rental_item_type
, created_by
, creation_date
, last_updated_by
, last_updated_date)


VALUES
( rental_item_s1.nextval
, source.rental_id
, source.item_id
, source.rental_item_price
, source.rental_item_type
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);

-- INERT OR UPDATE THE TABLE --

MERGE INTO transaction target
USING ( SELECT	t.transaction_id
	    ,		tu.payment_account_number AS transaction_account
	    ,		cl.common_lookup_id AS transaction_type
	    , 		tu.transaction_date
	    ,		(SUM(tu.transaction_amount) / 1.06) AS transaction_amount
	    ,		r.rental_id
	    , 		cl2.common_lookup_id AS payment_method
	    ,		m.credit_card_nmuber AS payment_account_number
	    ,		3 AS last_updated_by
	    ,		TRUNC(SYSDATE) AS creation_date
	    ,		3 AS last_updated_by
	    , 		TRUNC(SYSDATE) AS last_updated_date
	    FROM member m INNER JOIN cotnact c 
	    ON   m.member_id = c.member_id INNER JOIN transaction_upload tu
	    ON   c.first_name = tu.first_name
	    AND  NVL(c.middle_name, 'X') = NVL(tu.middle_name, 'X')
	    AND  c.last_name = tu.last_name
	    AND  tu.contact_number = m.account_number LEFT JOIN rental r 
	    ON   c.contact_id = r.customer_id
	    AND  TRUNC(tu.check_out_date) = TRUNC(R.check_out_date)
	    AND  TRUNC(tu.return_date) = TRUNC(r.return_date) INNER JOIN common_lookup cl1
	    ON   cl1.common_lookup_table = 'RENTAL_ITEM'
	    AND  cl1.common_lookup_column = 'RENTAL_ITEM_TYPE'
	    AND  cl1.common_lookup_type - tu.transaction_type INNER JOIN common_lookup cl2
	    ON   cl2.common_lookup_table = 'RENTAL_ITEM'
	    AND  cl2.common_lookup_column = 'RENTAL_ITEM_TYPE'
	    AND  cl2.common_lookup_type = tu.payment_method_type LEFT JOIN transaction t
	    ON   t.transaction_aabout = tu.payment_account_number
	    AND  t.rental_id = r.rental_id
	    AND  t.transaction_type = cl1.common_lookup_id
	    AND  t.transaction_type = tu.transaction_date
	    AND  t.payment_method_type = cl2.common_lookup_id
	    AND  t.payment_account_number = m.credit_card_nmuber
	    GROUP BY t.transaction_id
	    ,		 tu.payment_account_number
	    ,		 cl1.common_lookup_id
	    , 		 tu.transaction_date
	    ,        r.rental_id
	    , 		 cl2.common_lookup_id
	    ,		 m.credit_card_nmuber
	    , 		 3
	    ,        TRUNC(SYSDATE)
	    ,		 3
	    ,		 TRUNC(SYSDATE) source

ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT
( transaction_id
, transaction_id
, transaction_type
, transaction_date
, transaction_amount
, rental_id
, payment_method_type
, payment_account_number
, created_by
, creation_date
, last_updated_by
, last_update_date)
)


VALUES
( transaction_s1.nextval
, source.transaction_account
, source.transaction_type
, source.transaction_date
, source.transaction_amount
, source.rental_id
, source.created_by
, source.creation_date
, source.last_updated_by
, source.last_update_date);


COMMIT;
 
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/


--==================================================
-- Step #4 B) EXECUTE THE PROCEDURE 
--=================================================

-- VERIFY AND EXECUTE 
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 



SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION);

 -- You run the upload_transaction procedure with the following syntax:

 EXECUTE upload_transaction;



--============================================
 -- Step #4 C) VERIFY FIRST MERGE 
--============================================
 
SELECT   rental_count
,        rental_item_count
,        transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION);


--============================================
 -- Step #4 D) RUN THE UPLOAD_TRANSACTION
--============================================
EXECUTE upload_transaction;


--============================================
 -- Step #4 E) RUN THE UPLOAD_TRANSACTION
--============================================

COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"
 
SELECT   il1.rental_count
,        il2.rental_item_count
,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
        (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;


--============================================
 -- Step #5 Demosntrate 
--============================================

SELECT  il.month 
,		il.base    AS "BASE_REVENUE"
,		il.plus10  AS "10_PLUS"
,		il.plus20  AS "20_PLUS"
,		il.only10  AS "10_PLUS_LESS_BASE"
,		il.only20  AS "20_PLUS_LESS_BASE"
FROM   (SELECT CONTACT(TO_CHAR(t.transaction_date. 'MON'), CONTACT('_', EXTRACT(YEAR FROM t.transaction_date))) AS MONTH
       ,	EXTRACT(MONTH FROM t.transaction_date) AS sortkey
       ,	TO_CHAR(SUM(t.transaction_amount) , '$9,999,999.00') AS base
       ,	TO_CHAR(SUM(t.transaction_amount) * 1.1, '$9,999,999.00') AS plus10
       ,	TO_CHAR(SUM(t.transaction_amount) * 1.2, '$9,999,999.00') AS plus20
       ,	TO_CHAR(SUM(t.transaction_amount) * 0.1, '$9,999,999.00') AS only10
       ,	TO_CHAR(SUM(t.transaction_amount) * 0.2, '$9,999,999.00') AS only120

FROM transaction t
WHERE EXTRACT(YEAR FROM t.transaction_date) = 2009
GROUP BY CONTACT(TO_CHAR(t.transaction_date, 'MON'), CONTACT('_', EXTRACT(YEAR FROM t.transaction_date)))
, 		 EXTRACT(MONTH FROM t.transaction_date)) il

ORDER BY il.sortkey;

SPOOL OFF










