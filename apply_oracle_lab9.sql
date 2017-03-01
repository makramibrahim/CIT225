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
--   sql> @apply_oracle_lab9.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab8/apply_oracle_lab8.sql

SPOOL apply_oracle_lab9..txt

--=========================================================================

-- 1. [4 points] Create the following TRANSACTION table as per the specification
--========================================================================


CREATE TABLE transaction 
( transaction_id              NUMBER          
, transaction_account         VARCHAR2(15)  NOT NULL 
, transaction_type            NUMBER        NOT NULL
, transaction_date            DATE          NOT NULL
, transaction_amount          FLOAT         NOT NULL
, rental_id                   NUMBER        NOT NULL
, payment_method_type         NUMBER        NOT NULL
, payment_account_number      VARCHAR2(19)  NOT NULL 
, created_by                  NUMBER        NOT NULL
, creation_date               DATE          NOT NULL
, last_updated_by             NUMBER 
, last_update_date            DATE          NOT NULL

);

CREATE SEQUENCE transaction_s1 START WITH 1001;

-- Verify step 1 

COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'TRANSACTION'
ORDER BY 2;

--==========================================================
-- b) creat the NATURAL_KEY unique index as qualified below.
--===========================================================

CREATE UNIQUE INDEX transaction_u1 ON transaction
  (rental_id, transaction_type, transaction_date, payment_method_type, payment_account_number, transaction_account);


-- You should use the following formatting and query to verify completion of this step:

COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'TRANSACTION'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NATURAL_KEY';

--===============================================================
-- 2 points] Insert the following two TRANSACTION_TYPE rows and four PAYMENT_METHOD_TYPE rows into the COMMON_LOOKUP table. They should have valid who-audit column data.
--===============================================================

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, 'CREDIT'
, 'Credit'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_TYPE'
, '');

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, 'DEBIT'
, 'Debit'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_TYPE'
, '');


INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, 'DISCOVER CARD'
, 'Discover Card'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, 'VISA CARD'
, 'Visa Card'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, 'MASTER CARD'
, 'Master Card'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

INSERT INTO common_lookup VALUES
( common_lookup_s1.nextval
, 'CASH'
, 'Cash'
, 1, SYSDATE, 1, SYSDATE
, 'TRANSACTION'
, 'PAYMENT_METHOD_TYPE'
, '');

-- You should use the following formatting and query to verify completion of this step:
COLUMN common_lookup_table  FORMAT A20 HEADING "COMMON_LOOKUP_TABLE"
COLUMN common_lookup_column FORMAT A20 HEADING "COMMON_LOOKUP_COLUMN"
COLUMN common_lookup_type   FORMAT A20 HEADING "COMMON_LOOKUP_TYPE"
SELECT   common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table = 'TRANSACTION'
AND      common_lookup_column IN ('TRANSACTION_TYPE','PAYMENT_METHOD_TYPE')
ORDER BY 1, 2, 3 DESC;

--=============================================================
-- 3 A0 [14 points] Create the following AIRPORT and ACCOUNT_LIST tables as per the specification, but do so understanding the business logic of the model.
--==============================================================
CREATE TABLE airport
( airport_id		NUMBER
, airport_code		VARCHAR2(3)      NOT NULL
, airport_city		VARCHAR2(30)	 NOT NULL
, city			VARCHAR2(30)	 NOT NULL
, state_province	VARCHAR2(30)	 NOT NULL
, created_by		NUMBER
, creation_date		DATE	         NOT NULL
, last_updated_by	NUMBER
, last_update_date	DATE		 NOT NULL
, CONSTRAINT	pk_airport_1 PRIMARY KEY (airport_id)
, CONSTRAINT fk_airport_1 FOREIGN KEY (created_by)
	REFERENCES	system_user(system_user_id)
	 REFERENCES	system_user(system_user_id)
, CONSTRAINT fk_airport_2 FOREIGN KEY (last_updated_by)
	REFERENCES	system_user(system_user_id)
	 REFERENCES	system_user(system_user_id));

CREATE SEQUENCE airport_s1 START WITH 1001;


-- You should use the following formatting and query to verify completion of this step:

COLUMN table_name   FORMAT A14  HEADING "Table Name"
COLUMN column_id    FORMAT 9999 HEADING "Column ID"
COLUMN column_name  FORMAT A22  HEADING "Column Name"
COLUMN nullable     FORMAT A8   HEADING "Nullable"
COLUMN data_type    FORMAT A12  HEADING "Data Type"
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'AIRPORT'
ORDER BY 2;

--========================================================================
-- B)You need to create a unique natural key (named NK_AIRPORT) index for the AIRPORT table. You should create it with the following four columns.
--========================================================================
CREATE UNIQUE INDEX nk_airport ON airport
    (airport_code, airport_city, city, state_province);

-- Verify completion step
COLUMN table_name       FORMAT A12  HEADING "Table Name"
COLUMN index_name       FORMAT A16  HEADING "Index Name"
COLUMN uniqueness       FORMAT A8   HEADING "Unique"
COLUMN column_position  FORMAT 9999 HEADING "Column Position"
COLUMN column_name      FORMAT A24  HEADING "Column Name"
SELECT   i.table_name
,        i.index_name
,        i.uniqueness
,        ic.column_position
,        ic.column_name
FROM     user_indexes i INNER JOIN user_ind_columns ic
ON       i.index_name = ic.index_name
WHERE    i.table_name = 'AIRPORT'
AND      i.uniqueness = 'UNIQUE'
AND      i.index_name = 'NK_AIRPORT';

--======================================================================
-- C)You need to seed the AIRPORT table with at least these cities, and any others that you’ve used for inserted values in the CONTACT table.
--======================================================================

INSERT INTO airport VALUES
( airport_s1.nexval
, 'LAX'
, 'Los Angeles'
, 'Los Angeles'
, 'California'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport VALUES
( airport_s1.nexval
, 'SLC'
, 'Salt Lake City'
, 'Provo'
, 'Utah'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport VALUES
( airport_s1.nexval
, 'SLC'
, 'Salt Lake City'
, 'Spanish Fork'
, 'Utah'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport VALUES
( airport_s1.nexval
, 'SFO'
, 'San Francsico'
, 'San Francsico'
, 'California'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport VALUES
( airport_s1.nexval
, 'SJC'
, 'San Jose'
, 'San Jose'
, 'California'
, 1, SYSDATE, 1, SYSDATE);

INSERT INTO airport VALUES
( airport_s1.nexval
, 'SJC'
, 'San Jose'
, 'San Carlos'
, 'California'
, 1, SYSDATE, 1, SYSDATE);

COLUMN code           FORMAT A4  HEADING "Code"
COLUMN airport_city   FORMAT A14 HEADING "Airport City"
COLUMN city           FORMAT A14 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
SELECT   airport_code AS code
,        airport_city
,        city
,        state_province
FROM     airport;


--=======================================================================
-- D) create the ACCOUNT_LIST table and ACCOUNT_LIST_S1 sequence.
--=======================================================================

DROP TABLE IF EXISTS account_list;

CREATE TABLE account_list
( account_list_id   NUMBER 
, account_number    VARCHAR(10)  NOT NULL
, consumed_date     DATE
, consumed_by       NUMBER
, created_by        NUMBER
, creation_date     DATE          NOT NULL
, last_updated_by   NUMBER
, last_update_date  DATE          NOT NULL
, CONSTRAINT fk_account_list_1 FOREIGN KEY (consumed_by)
    REFERENCES  system_user(system_user_id)
, CONSTRAINT fk_account_list_2 FOREIGN KEY (created_by)
    REFERENCES  system_user(system_user_id)
, CONSTRAINT fk_account_list_3 FOREIGN KEY (last_updated_by)
    REFERENCES  system_user(system_user_id));

CREATE SEQUENCE account_list_s1 START WITH 1001;

-- Verify Completion Step


COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ACCOUNT_LIST'
ORDER BY 2;


-- E) 

COLUMN airport FORMAT A7
SELECT   SUBSTR(account_number,1,3) AS "Airport"
,        COUNT(*) AS "# Accounts"
FROM     account_list
WHERE    consumed_date IS NULL
GROUP BY SUBSTR(account_number,1,3)
ORDER BY 1;

--f)

UPDATE address
SET    state_province = 'California'
WHERE  state_province = 'CA';

-- Format the SQL statement display.
COLUMN member_id      FORMAT 999999 HEADING "Member|ID #"
COLUMN last_name      FORMAT A10    HEADING "Last|Name"
COLUMN account_number FORMAT A10 HEADING "Account|Number"
COLUMN city           FORMAT A16 HEADING "City"
COLUMN state_province FORMAT A10 HEADING "State or|Province"
 
-- Query distinct members and addresses.
SELECT   DISTINCT
         m.member_id
,        c.last_name
,        m.account_number
,        a.city
,        a.state_province
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id
ORDER BY 1;

--==============================================================
--
--==============================================================
CREATE TABLE transaction_upload
( account_number          VARCHAR(10)
, first_name              VARCHAR(20)
, middle_name             VARCHAR(20)
, last_name               VARCHAR(20)
, check_out_date          DATE
, return_date             DATE
, rental_item_type        VARCHAR(12)
, transaction_type        VARCHAR(14)
, transaction_amount      FLOAT
, transaction_date        DATE
, item_id                 NUMBER
, payment_method_type     VARCHAR(14)
, payment_account_number  VARCHAR(19))
ORGANIZATION EXTERNAL
  ( TYPE oracle_loader
    DEFAULT DIRECTORY upload
    ACCESS PARAMETERS
    ( RECORDS DELIMITED BY NEWLINE CHARACTERSET US7ASCII
      BADFILE     'UPLOAD':'transaction_upload.bad'
      DISCARDFILE 'UPLOAD':'transaction_upload.dis'
      LOGFILE     'UPLOAD':'transaction_upload.log'
      FIELDS TERMINATED BY ','
      OPTIONALLY ENCLOSED BY "'"
      MISSING FIELD VALUES ARE NULL )
    LOCATION ('transaction_upload.csv'))
REJECT LIMIT UNLIMITED;

SET LONG 200000  -- Enables the display of the full statement.
SELECT   dbms_metadata.get_ddl('TABLE','TRANSACTION_UPLOAD') AS "Table Description"
FROM     dual;

SELECT   COUNT(*) AS "External Rows"
FROM     transaction_upload;

SPOOL OFF 
