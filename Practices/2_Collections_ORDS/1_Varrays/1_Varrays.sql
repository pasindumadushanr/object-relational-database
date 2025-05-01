CREATE TYPE address_arr AS VARRAY(5) OF VARCHAR(15)
/

CREATE TABLE personal (
id CHAR(3) PRIMARY KEY,
name VARCHAR(2),
address address_arr 

)
/
INSERT INTO personal 
VALUES ('001','SUPUN',address_arr('No.12','Galle Road','Panadura'))
/


CREATE address_arr AS VARRAY(5) OF  VARCHAR2(10) 

CREATE TYPE peronal_t AS OBJECT (
    id CHAR(3),
    name VARCHAR2(15),
    address address_arr
)
/

CREATE TABLE personal_table  AS peronal_t(
    id PRIMARY KEY
)
/

INSERT INTO personal_table
VALUES (peronal_t('001','SUPUN',address_arr('No.12','Galle Road','Panadura')))  

