CREATE TABLE bank_account
(
	id             NUMBER,
	first_name     VARCHAR(20),
	middle_name    VARCHAR(20),
	last_name      VARCHAR(20),
	age            NUMBER,
	address        VARCHAR(50),
	cell           NUMBER,
)

INSERT INTO bank_account
VALUES 
(
	id             
	,first_name     
	,middle_name    
	,last_name      
	,age            
	,address        
	,cell           
	,up_date        
)

INSERT INTO bank_account
VALUES 
(
	1001,
	'MAKRAM',
	'AYAD_YACOUB',
	'IBRAHIM',
	32,
	'2152_N_40_W_PROVO_UTAH',
	3854249924,
	'SYSDATE'
);