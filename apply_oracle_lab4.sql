-- ------------------------------------------------------------------
--  Program Name:   seed_oracle_store.sql
--  Lab Assignment: Lab #6
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
-- ------------------------------------------------------------------
-- This seeds data in the video store model. It requires that you run
-- the create_oracle_store.sql script.
-- ------------------------------------------------------------------

-- Open log file.
SPOOL seed_oracle_store.log

-- Set SQL*Plus environment variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Insert statement demonstrates a mandatory-only column override signature.
-- ------------------------------------------------------------------
-- TIP: When a comment ends the last line, you must use a forward slash on
--      on the next line to run the statement rather than a semicolon.
-- ------------------------------------------------------------------
INSERT
INTO system_user_lab
( system_user_lab_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 2                 -- system_user_id
,'DBA'              -- system_user_name
, 2                 -- system_user_group_id
, 2                 -- system_user_type
,'Adams'            -- last_name
,'Samuel'           -- middle_name
, 1                 -- created_by
, SYSDATE           -- creation_date
, 1                 -- last_updated_by
, SYSDATE)          -- last_update_date
/

-- A variation on the override signature.
-- ------------------------------------------------------------------
-- TIP: When omitting column names for values, you may use the semicolon
--      on the last line to execute the query.
-- ------------------------------------------------------------------
INSERT
INTO system_user_lab
( system_user_lab_id
, system_user_name
, system_user_group_id
, system_user_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 3,'DBA', 2, 2,'Henry','Patrick', 1, SYSDATE, 1, SYSDATE);

-- A default signatures must mirror the order of columns in the data catalog.
INSERT
INTO system_user_lab
VALUES
( 4
,'DBA'
, 2
, 2
,'Manmohan'
, NULL              -- Optional parameters must be provided a null value in a default signature.
,'Puri'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ------------------------------------------------------------------
-- This seeds rows in a dependency chain, including the MEMBER, CONTACT
-- ADDRESS, and TELEPHONE tables.
-- ------------------------------------------------------------------
-- Insert record set #1.
-- ------------------------------------------------------------------
INSERT INTO member_lab VALUES
( member_s1.nextval
, NULL
,'B293-71445'
,'1111-2222-3333-4444'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Randi','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Brian','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #2.
-- ------------------------------------------------------------------
INSERT INTO member_lab VALUES
( member_s1.nextval
, NULL
,'B293-71446'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Oscar','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Doreen','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #3.
-- ------------------------------------------------------------------
INSERT INTO member_lab VALUES
( member_s1.nextval
, NULL
,'B293-71447'
,'3333-4444-5555-6666'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'MEMBER'
  AND      common_lookup_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Meaghan','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Matthew','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact VALUES
( contact_s1.nextval
, member_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_context = 'CONTACT'
  AND      common_lookup_type = 'CUSTOMER')
,'Ian','M','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_s1.nextval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_s1.nextval
, address_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_s1.nextval
, address_s1.currval
, contact_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 21 rows in the ITEM table.
-- ------------------------------------------------------------------
INSERT INTO item_lab VALUES
( item_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October','Special Collector''s Edition','PG'
,'02-MAR-90'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'24543-02392'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars I','Phantom Menace','PG'
,'04-MAY-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'DVD_FULL_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'24543-05539'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'24543-20309'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'Star Wars III','Revenge of the Sith','PG13'
,'19-MAY-05'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'86936-70380'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'DVD_WIDE_SCREEN')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'91493-06475'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'XBOX')
,'RoboCop','','Mature'
,'24-JUL-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'93155-11810'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'XBOX')
,'Pirates of the Caribbean','','Teen','30-JUN-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'12725-00173'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'XBOX')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','Everyone','30-JUN-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'45496-96128'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'NINTENDO_GAMECUBE')
,'MarioKart','Double Dash','Everyone','17-NOV-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'08888-32214'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Splinter Cell','Chaos Theory','Teen','08-APR-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'14633-14821'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'PLAYSTATION2')
,'Need for Speed','Most Wanted','Everyone','15-NOV-04'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'10425-29944'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'XBOX')
,'The DaVinci Code','','Teen','19-MAY-06'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'52919-52057'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'XBOX')
,'Cars','','Everyone','28-APR-06'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'9689-80547-3'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Beau Geste','','PG','01-MAR-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'53939-64103'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'I Remember Mama','','NR','05-JAN-98'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'24543-01292'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Tora! Tora! Tora!','The Attack on Pearl Harbor','G','02-NOV-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'43396-60047'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'A Man for All Seasons','','G','28-JUN-94'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'43396-70603'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_SINGLE_TAPE')
,'Hook','','PG','11-DEC-91'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'85391-13213'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Around the World in 80 Days','','G','04-DEC-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_s1.nextval
,'85391-10843'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_type = 'VHS_DOUBLE_TAPE')
,'Camelot','','G','15-MAY-98'
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Inserts 5 rentals with 9 dependent rental items.  This section inserts
-- 5 rows in the RENTAL table, then 9 rows in the RENTAL_ITEM table. The
-- inserts into the RENTAL_ITEM tables use scalar subqueries to find the
-- proper foreign key values by querying the RENTAL table primary keys. 
-- ------------------------------------------------------------------
-- Insert 5 records in the RENTAL table.
-- ------------------------------------------------------------------
INSERT INTO rental_lab VALUES
( rental_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Oscar')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Doreen')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Meaghan')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Ian')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Winn'
  AND      first_name = 'Brian')
, SYSDATE, SYSDATE + 5
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 9 records in the RENTAL_ITEM table.
-- ------------------------------------------------------------------
INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   i.item_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_title = 'Star Wars I'
  AND      i.item_subtitle = 'Phantom Menace'
  AND      i.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r inner join contact_lab c
  ON       r.customer_id = c.contact_id
  WHERE    c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_id
  FROM     item_lab d join common_lookup_lab cl
  ON       d.item_title = 'Star Wars II'
  WHERE    d.item_subtitle = 'Attack of the Clones'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Star Wars III'
  AND      d.item_subtitle = 'Revenge of the Sith'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'I Remember Mama'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'VHS_SINGLE_TAPE')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Camelot'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'VHS_DOUBLE_TAPE')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Meaghan')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Hook'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'VHS_SINGLE_TAPE')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Ian')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'Cars'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'XBOX')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'RoboCop'
  AND      d.item_subtitle IS NULL
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'XBOX')
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_id
, item_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_s1.nextval
,(SELECT   r.rental_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_title = 'The Hunt for Red October'
  AND      d.item_subtitle = 'Special Collector''s Edition'
  AND      d.item_type = cl.common_lookup_id
  AND      cl.common_lookup_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

