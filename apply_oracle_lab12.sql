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
--   sql> @apply_oracle_lab11.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
--
/home/student/Data/cit225/oracle/lab11/apply_oracle_lab11.sql

SPOOL apply_oracle_lab12.txt
 
--===============================================================
-- Step #1: Create the following CALENDAR table as per the specification.
--===============================================================

CREATE TABLE calender
( calendar_id		 NUMBER      
, calendar_name		 VARCHAR(10) NOT NULL
, calendar_shor_name VARCHAR(3)  NOT NULL
, start_date 		 DATE 		 NOT NULL
, end_date			 DATE 		 NOT NULL 
, created_by         NUMBER      NOT NULL
, creation_date		 DATE 	     NOT NULL
, last_updated_by    NUMBER      NOT NULL
, last_update_by     DATE        NOT NULL 
, CONSTRAINT Pk_calender PRIMARY KEY
, CONSTRAINT fk_calendar1 FOREIGN KEY (created_by)
REFERENCES system_user (system_user_id)
, CONSTRAINT fk_calendar2 FOREIGN KEY (last_updated_by)
REFERENCES system_user (system_user_id) 
);

--===========================================================
-- Step #2 Seed the CALENDAR table with the following data.
--============================================================

-- SEED THE TABEL WITH 10 YEARS OF OF DATA
CALENDAR

  TYPE smonth IS TABLE VARCHAR(3);
  TYPE lmonth IS TABLE VARCHAR2(9);

  --DECLARE MONTH 

  short_month SMONTH := smonth('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN'
  	                         , 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC');
  long_month  LMONTH := lmonth('January', 'February', 'March', 'April', 'May', 'June'
  			       , 'July', 'August', 'September', 'October', 'Novmber', 'December');
  --DECLARE DATES
  start_date DATE := '01-JAN-09';
  end_date   DATE := '31-JAN-09';

  --DECLARE YEARS
  month_id NUMBER;
  years    NUMBER :=1;


  BEGIN 

  -- LOOP THOUGH YEARS AND MONTHS 

  FOR i IN 1..years LOOP
   FOR j IN 1.. short_month.COUNT LOOP

   SELECT calender_s1.nextval INTO month_id FROM dual;

   INSERT INTO calendar VALUES 
   ( month_id
   , long_month(j)
   , short_month(j)
   , add_months(start_date, (j-1)+(12+(i+1)))
   , add_months(end_date, (j-1)+(12+(i-1))) 
   , 3
   , SYSDATE
   , 3
   , SYSDATE);

   END LOOP;
   END LOOP;
   END;

  -- QUERY THE DATA INSERT.
  SELECT 'SELECT * FROM calendar' AS "Statement" FROM dual;
  SELECT  calender_name
  		  calender_short_name 
  		  start_date
  		  end_date
  FROM    calender;

--========================================================
--Step #3 Import and merge the new *.csv files.
--=========================================================


SELECT 'Conditionally drop TRANSACTION_REVERSAL table' AS "Statement" FROM dual
BEGIN
      FOR i IN (SELECT table_name
      			FROM   user_tables
      			WHERE  table_name = 'TRANSACTION_REVERSAL') LOOP
      EXCUTE IMMDITATE 'DROP TABLE' || i.table_name || 'CASCASE CONSTRAINT';
      END LOOP;
 END;

-- CREATE THE TRANSATION_UPLOAD TABLE 

SELECT 'Create TRANSACTION_REVERSAL table.' AS "Statement" FROM dual;

CREATE TABLE transaction_reversal 
( transaction_id	     NUMBER
, transaction_account    VARCHAR2(15)
, transaction_type       VARCHAR2(30)
, transaction_date		 DATE
, transaction_amount     NUMBER
, rental_id				 NUMBER
, payment_method_type    NUMBER
, payment_account_number VARCHAR2(20)
, created_by			 NUMBER
, creation_date  		 DATE
, last_updated_by        NUMBER
, last_update_date       DATE)
ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY upload
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload2.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload2.dis'
      LOGFILE     'UPLOAD':'transaction_upload2.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY ','
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload2.csv'))
REJECT LIMIT UNLIMITED;

SET LONG 100000
SET PAGESIZE 40000

SELECT 'Count rows in TRANSACTION_REVERSAL rable' AS "Statement" FROM dual;
SLECT COUNT(*) FROM transaction_reversal;

SELECT 'Delete credits from TRANSACTION table' AS "Statement" FROM dual;
DELETE FROM transaction WHERE transaction_account = '222-222-222-222';


SELECT 'Insert into TRANSACTION from TRANSACTION_REVERSAL' AS "Statement" FROM dual;
-- Move the data from TRANSACTION_REVERSAL to TRANSACTION.
INSERT INTO transaction
(SELECT transaction_s1.nextval
	,	transaction_account
	, 	transaction_type
	,	transaction_date
	,	transaction_amount
	,	rental_id
	,	payment_method_type
	,	payment_account_number
	,	created_by
	,	creation_date
	, 	last_updated_by
	,	last_update_date

 FROM    transaction_reversal);

COLUMN "Debit Transactions"  FORMAT A20
COLUMN "Credit Transactions" FORMAT A20
COLUMN "All Transactions"    FORMAT A20
 
-- Check current contents of the model.
SELECT 'SELECT record counts' AS "Statement" FROM dual;
SELECT   LPAD(TO_CHAR(c1.transaction_count,'99,999'),19,' ') AS "Debit Transactions"
,        LPAD(TO_CHAR(c2.transaction_count,'99,999'),19,' ') AS "Credit Transactions"
,        LPAD(TO_CHAR(c3.transaction_count,'99,999'),19,' ') AS "All Transactions"
FROM    (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '111-111-111-111') c1 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction WHERE transaction_account = '222-222-222-222') c2 CROSS JOIN
        (SELECT COUNT(*) AS transaction_count FROM transaction) c3;

-- Debit Transactions   Credit Transactions  All Transactions
-------------------- -------------------- --------------------
--           4,681                1,170                5,851

--==============================================================
-- STEP #4 Create the following transformation report by a CROSS
--==============================================================
-- JOIN between the TRANSACTION and CALENDAR tables.

COLUMN Transaction FORMAT A15
COLUMN January   FORMAT A10
COLUMN February  FORMAT A10
COLUMN March     FORMAT A10
COLUMN F1Q       FORMAT A10
COLUMN April     FORMAT A10
COLUMN May       FORMAT A10
COLUMN June      FORMAT A10
COLUMN F2Q       FORMAT A10
COLUMN July      FORMAT A10
COLUMN August    FORMAT A10
COLUMN September FORMAT A10
COLUMN F3Q       FORMAT A10
COLUMN October   FORMAT A10
COLUMN November  FORMAT A10
COLUMN December  FORMAT A10
COLUMN F4Q       FORMAT A10
COLUMN YTD       FORMAT A12



-- Reassign column values.
SELECT  transaction_account AS "Transactions"
,	    january   AS "Jan"	
, 	    february  AS "Feb"
,	    march 	  AS "Mar"
, 	    f1q       AS "F1Q"
,	    april	  AS "Apr"
, 	    may 	  AS "May"
, 		june	  AS "June"
, 		july	  AS "July"
, 		august    AS "August"
, 		september AS "September"
,		f3q		  AS "F3Q"
,		october   AS "October"
, 		novmber   AS "Novmber"
, 		december  AS "Dec"
,       f4q 	  AS F4Q
,       ytd	      AS "YTD"
FROM (
	SELECT CASE 
	WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
	WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
	END AS "TRANSACTION_ACCOUNT"
CASE
	WHEN t.transaction_account = '111-111-111-111' THEN 1
	WHEN t.transaction_account = '222-222-222-222' THEN 2
	END AS "SORTKEY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 1 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "JANUARY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 2 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
    CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "FEBRUARY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 3 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "MARCH"


,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) IN (1,2,3) AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "F1Q"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 4 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "APRIL"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 5 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "MAY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 6 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "JUNE"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 7 AND
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "JULY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 8 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "AUGUST"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 9 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
    CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "SEPTEMBER"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = IN (7,8,9) AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
    CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "F3Q"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 10 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "OCTOBER"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 11 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "NOVMBER" 

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 12 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "DECEMBER"
	
,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = IN (10,11,12) AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "FQ4"

,	LPAD(TO_CHAR (SUM(CASE
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "YTD"

FROM 	transaction t INNER JOIN common_lookup cl
ON 		t.transaction_type = cl.common_lookup_id
WHERE 	cl.common_lookup_table = 'TRANSACTION'
AND 	cl.common_lookup_column = 'TRANSACTION_TYPE'

GROUP BY CASE 

	WHEN t.transaction_account = '111-111-111-111' THEN 'Debit'
	WHEN t.transaction_account = '222-222-222-222' THEN 'Credit'
	END 
,  CASE
	WHEN t.transaction_account = '111-111-111-111' THEN 1
	WHEN t.transaction_account = '222-222-222-222' THEN 2
	END

UNION ALL 

SELECT 'Total' AS "Account"
,		3 AS "Sortkey"
,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 1 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "JANUARY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 2 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
    CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "FEBRUARY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 3 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "MARCH"


,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) IN (1,2,3) AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "F1Q"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 4 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "APRIL"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 5 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "MAY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 6 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "JUNE"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 7 AND
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "JULY"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 8 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "AUGUST"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 9 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
    CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "SEPTEMBER"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = IN (7,8,9) AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
    CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "F3Q"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 10 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "OCTOBER"

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 11 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "NOVMBER" 

,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = 12 AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "DECEMBER"
	
,	LPAD(TO_CHAR (SUM(CASE
		WHEN EXTRACT( MONTH FROM transaction_date) = IN (10,11,12) AND 
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "FQ4"

,	LPAD(TO_CHAR (SUM(CASE
		EXTRACT(YEAR FROM transaction_date) = 2009 THEN
	CASE
		WHEN cl.common_lookup_type = 'DEBIT'
        THEN t.transaction_amount
        ELSE t.transaction_amount = * -1
        END
        END), '99,999,00'),10,' ') AS "YTD"	
FROM 	transaction t INNER JOIN common_lookup cl
ON 		t.transaction_type = cl.common_lookup_id
WHERE 	cl.common_lookup_table = 'TRANSACTION'
AND 	cl.common_lookup_column = 'TRANSACTION_TYPE'
GROUP BY 'Total'
ORDER BY 2);	

SPOOL OFF



