-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--  Makram Ibrahim
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab6.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

-- insert code here --

SPOOL apply_oracle_lab6.txt

-- STEP 1 
-- This occurs by working with the, create_oracle_store.sql script. It -- creates the beginning data model. Change the RENTAL_ITEM table
-- by adding the RENTAL_ITEM_TYPE and RENTAL_ITEM_PRICE columns. Both -- columns should use a NUMBER data type.

SELECT 'step 1' AS code FROM dual;

ALTER TABLE rental_item
ADD (rental_item_type NUMBER)
ADD (rental_item_price NUMBER);

SET NULL ''
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
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

-- STEP 2
-- Create the following PRICE table as per the specification, like the description below.

CREATE TABLE price
( price_id                NUMBER
, item_id                 NUMBER       CONSTRAINT nn_price_1  NOT NULL
, price_type              NUMBER       
, active_flag             VARCHAR(20)  CONSTRAINT nn_price_2 NOT NULL 
, start_date              DATE         CONSTRAINT nn_price_3 NOT NULL 
, end_date                DATE
, amount                  NUMBER       CONSTRAINT nn_price_4 NOT NULL
, created_by              NUMBER       CONSTRAINT nn_price_5 NOT NULL
, creation_date           DATE         CONSTRAINT nn_price_6 NOT NULL
, last_updated_by         NUMBER       CONSTRAINT nn_price_7 NOT NULL 
, last_update_date        DATE         CONSTRAINT nn_price_8 NOT NULL
, CONSTRAINT pk_price_id PRIMARY KEY(price_id)
, CONSTRAINT fk_price_type FOREIGN KEY(price_type) REFERENCES common_lookup(common_lookup_id)
, CONSTRAINT yn_price CHECK(active_flag IN('Y', 'N')) 
, CONSTRAINT fk_created_by FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_last_updated_by FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id)); 

-- STEP 3 
--Insert new data into the model.(Check Step #3 on the referenced web -- page for details).
SELECT 'step 3' AS code FROM dual; 

-- (3a)Rename the ITEM_RELEASE_DATE column of the ITEM table to RELEASE_DATE.

ALTER TABLE item
      RENAME COLUMN item_relase_date TO relase_date;


--(3b)Insert three new DVD releases into the ITEM table. The
-- RELEASE_DATE column’s value for new rows in the ITEM table 
-- should be less than 31 days at all times. The easiest way to 
-- achieve this requirement uses a SYSDATE value in the 
-- RELEASE_DATE column value.


--CREATE OR REPALCE TRIGGER release_date_trig BEFORE INSERT ON ITEM  FOR EACH row 


 BEGIN
    
if (SYSDATE to_date(new.release_date, 'DD-MON-YYYY')) < 31 THEN
       raise_application_erro(20001, 'THE RELEASE_DATE column shoud be less then 31days');
  end if;
    END;

INSERT INTO item
( item_id
, item_barcode
, item_type
, item_title
, item_subtitle
, item_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( item_s1.nextval
, 'BOON1JQQ2UO' 
, (SELECT common_lookup_id
 FROM common_lookup
WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
, 'X-Men Apocalypse'
, NULL
, 'PG-13'
, '28-MAY-2016'
, 1
, SYSDATE
, 1
, SYSDATE
);

INSERT INTO item
VALUES
( item_s1.nextval
, 'BOON1JQQ2UO' 
, (SELECT common_lookup_id
 FROM common_lookup
WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
, 'Through the Looking Class'
, NULL
, 'PG-13'
, '28-MAY-2016'
, 1
, SYSDATE
, 1
, SYSDATE
);

INSERT INTO item
VALUES
( item_s1.nextval
, 'BOON1JQQ2UO' 
, (SELECT common_lookup_id
 FROM common_lookup
WHERE common_lookup_type = 'DVD_WIDE_SCREEN')
, 'The Angry Birds Movie'
, NULL
, 'PG'
, '28-MAY-2016'
, 1
, SYSDATE
, 1
, SYSDATE
);

-- (3c) Insert a new row in the MEMBER table, and three new rows in
--the CONTACT, ADDRESS, STREET_ADDRESS, and TELEPHONE tables. 
--The new contacts should be Harry, Ginny, and Lily Luna Potter.
INSERT INTO member
( member_id
, member_type
, account_number
, credit_card_number
, credit_card_type
, created_by 
, creation_date
, last_updated_by
, last_update_date)
VALUES
( member_s1.nextval
, 1003
, 'X15-500-08'
, '9876-5432-1234-5610'
, (SELECT common_lookup_id
   FROM common_lookup_id
   WHERE common_lookup_context = 'MEMBER'
   AND common_lookup_type = 'DISCOVER_CARD')
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO contact
VALUES 
( contact_s1.nextval
, SELECT m.meber_id
  FROM member m 
  WHERE m.account_number = 'X15-500-08')
, (SELECT cl.common_lookup_id
   FROM common_lookup cl
   WHERE cl.common_lookup_contact = 'CONTACT'
   AND cl.common_lookup_type = 'CUSTOMER')
, 'Harry'
, ''
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO address
VALUES
( address_s1.nextval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, Provo
, Utah
, '84601'
, 1
, SYSDATE
, 1
, SYSDATE);

INSERT INTO street_address
VALUES 
(street_addresss1.nextval
, address_s1.currval
, '448 North 400 West'
, 1
, SYSDATE
, 1
, SYSDATE);


INSERT INTO telephone 
VALUES
(telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
, (SELECT common_lookup_id
   FROM common_lookup
   WHERE common_lookup_type = 'HOME')
, '001'
, '410'
, '782-9724'
, 1
, SYSDATE
, 1 
, SYSDATE);

INSERT INTO contact
VALUES 
( contact_s1.nextval
, (SELECT m.member_id 
   FROM member m 
   WHERE m.account_number = 'X15-500-08')
, (SELECT cl.common_lookup cl
   FROM common_lookup cl 
   WHERE cl.common_lookup_context = 'CONTACT'
   AND cl.common_lookup_type = 'CUSTOMER')
, 'Ginny'
, ''
, 'Potter'
, 1
, SYSDATE
, 1
, SYSDATE);

-- STEP 4
-- Modify the design of the COMMON_LOOKUP table following 
-- the definitions below, and insert new data into the model,
-- and update old non-compliant design data in the model (
-- Check Step #4 on the referenced web page for details).

-- (4a)
ALTER TABLE common_lookup
	ADD (common_lookup_table VARCHAR(20))
	ADD (common_lookup_column VARCHAR(20))
	ADD (common_lookup_code VARCHAR(20));

--(4b)

UPDATE   common_lookup
SET      common_lookup_table = 'SYSTEM_USER'
,        common_lookup_column = 'SYSTEM_USER_GROUP_ID'
WHERE    common_lookup_context = 'SYSTEM_USER';

UPDATE   common_lookup
SET      common_lookup_table = 'CONTACT'
,        common_lookup_column = 'CONTACT_TYPE'
WHERE    common_lookup_context = 'CONTACT';

UPDATE   common_lookup
SET      common_lookup_table = 'MEMBER'
,        common_lookup_column = 'MEMBER_TYPE'
WHERE    common_lookup_context = 'MEMBER' AND common_lookup_type = 'INDIVIDUAL' OR common_lookup_type = 'GROUP';

UPDATE   common_lookup
SET      common_lookup_table = 'MEMBER'
,        common_lookup_column = 'CREDIT_CARD_TYPE'
WHERE    common_lookup_context = 'MEMBER' AND common_lookup_type LIKE '%_CARD';

UPDATE   common_lookup
SET      common_lookup_table = 'ADDRESS'
,        common_lookup_column = 'ADDRESS_TYPE'
WHERE    common_lookup_context = 'MULTIPLE';

UPDATE   common_lookup
SET      common_lookup_table = 'ITEM'
,        common_lookup_column = 'ITEM_TYPE'
WHERE    common_lookup_context = 'ITEM';

--(4c)
INSERT INTO common_lookup
  SELECT common_lookup_s1.NEXTVAL
  , common_lookup_context
  , common_lookup_type
  , common_lookup_meaning
  , 1
  , SYSDATE
  , 1
  , SYSDATE
  ,'TELEPHONE'
  ,'TELEPHONE_TYPE'
  , NULL
  FROM common_lookup
  WHERE common_lookup_table = 'ADDRESS';
--(4d)

UPDATE telephone
	SET telephone_type = (
		SELECT common_lookup_id
		FROM common_lookup
		WHERE common_lookup_type = 'HOME' AND common_lookup_table = 'TELEPHONE')
	WHERE telephone_type = ( 
		SELECT common_lookup_id
		FROM common_lookup
		WHERE common_lookup_type = 'HOME' AND common_lookup_table = 'ADDRESS');
ALTER TABLE common_lookup
	DROP COLUMN common_lookup_context;



 
SPOOL OFF

