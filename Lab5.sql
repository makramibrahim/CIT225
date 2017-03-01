SELECT member_id, contact.contact_id
FROM member_lab INNER JOIN contact_lab 
USING (member_id);


SELECT contact_id, address.address_id
FROM contact_lab INNER JOIN address_lab
USING (contact_id);


SELECT address_id, sa.street_address_id
FROM address_lab INNER JOIN street_address_lab sa
USING (address_id);

SELECT contnact_id, telephone.telephone_id
FROM contact_lab INNER JOIN telephone_lab
USING(contact_id);
-======================================

SELECT contact_id, system_user_lab. system_user_id
FROM contact_lab INNER JOIN system_user_lab
ON contact.create_by  = system_user_lab.system_user_id;


SELECT contact_id, system_user_lab. system_user_id
FROM contact_lab INNER JOIN system_user_lab
ON contact.last_update_by = system_user_lab.system_user_id;


SELECT system_user_id, su2.create_by, su3.system_user_id
FROM system_user_lab, SU1 INNER JOIN system su2
ON su1.create_by = su2.system_user_id
INNER JOIN system_user_lab su3
ON su2.system_user_id = su3.system_user_id
ORDER BY 1;


SELECT system_user_id, su2.last_update_by, su3.system_user_id
FROM system_user_lab, SU1 INNER JOIN system su2
ON su1.last_update_by = su2.system_user_id
INNER JOIN system_user_lab su3
ON su2.system_user_id = su3.system_user_id
ORDER BY 1;

SELECT 
rental_lab.rental_id
, rental_lab.rental_id
, rental_lab.item_id
, item_lab.item_id
FROM 
rental_lab INNER JOIN rental_lab_item
ON rental_lab.rental_id = rental_lab_item.rental_id
INNER JOIN item 
ON rental_lab_item.item_id = item_lab.item_id;




