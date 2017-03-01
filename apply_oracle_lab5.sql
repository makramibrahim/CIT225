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
--   sql> @apply_oracle_lab5.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

SPOOL appy_oracle.lab5.sql
-- Add your lab here:
-- ----------------------------------------------------------------------
SELECT member_lab_id, contact_lab.contact_lab_id
FROM member_lab INNER JOIN contact_lab 
USING (member_lab_id);


SELECT contact_lab_id, address_lab.address_id
FROM contact_lab INNER JOIN address_lab
USING (contact_lab_id);


SELECT address_lab_id, sa.street_lab_address_lab_id
FROM address_lab INNER JOIN street_lab_address_lab sa
USING (address_lab_id);

SELECT contnact_lab_id, telephone_lab.telephone_lab_id
FROM contact_lab INNER JOIN telephone_lab
USING(contact_lab_id);
-======================================

SELECT contact_lab_id, system_user_lab. system_user_lab_id
FROM contact_lab INNER JOIN system_user_lab
ON contact_lab.create_by  = system_user_lab.system_user_lab_id;


SELECT contact_lab_id, system_user_lab. system_user_lab_id
FROM contact_lab INNER JOIN system_user_lab
ON contact_lab.last_update_by = system_user_lab.system_user_lab_id;


SELECT system_user_lab_id, su2.create_by, su3.system_user_lab_id
FROM system_user_lab, SU1 INNER JOIN system su2
ON su1.create_by = su2.system_user_lab_id
INNER JOIN system_user_lab su3
ON su2.system_user_lab_id = su3.system_user_lab_id
ORDER BY 1;


SELECT system_user_lab_id, su2.last_update_by, su3.system_user_lab_id
FROM system_user_lab, SU1 INNER JOIN system su2
ON su1.last_update_by = su2.system_user_lab_id
INNER JOIN system_user_lab su3
ON su2.system_user_lab_id = su3.system_user_lab_id
ORDER BY 1;

SELECT 
rental_lab.rental_lab_id
, rental_lab.rental_lab_id
, rental_lab.item_lab_id
, item_lab.item_lab_id
FROM 
rental_lab INNER JOIN rental_lab_item_lab
ON rental_lab.rental_lab_id = rental_lab_item.rental_lab_id
INNER JOIN item_lab 
ON rental_lab_item_lab.item_lab_id = item_lab.item_lab_id;



SPOOL OFF 

