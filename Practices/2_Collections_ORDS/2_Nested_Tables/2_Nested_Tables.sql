--01 type creation
CREATE TYPE sales_t AS OBJECT (
    unit_price NUMBER(4,2),
    date DATE,
    qty NUMBER(3)

)
/

--02 type creation
CREATE TYPE sales_list AS TABLE OF sales_t
/

--03 type creation
CREATE TYPE individual_t AS OBJECT (
    id CHAR(3),
    name VARCHAR2(20),
    sales sales_list
)

--4 Table Creation
 CREATE TABLE individual_t AS individual_t(
     id PRIMARY KEY
 )
 NESTED TABLE sales STORE AS sales_table 

--5 Data Insertion
 INSERT INTO individual_t
 VALUES (individual_t('001','SUPUN',sales_list(sales_t(100.00,'01-JAN-2019',10),sales_t(200.00,'02-JAN-2019',20)))

--6 Data Retrieval
 SELECT * FROM TABLE(SELECT a.sales FROM individual_t a WHERE a.id='001');

 --unnesting the nested table

SELECT a.id ,s.*
FROM individual a,
TABLE(a.sales) s

--DML on nested table

INSERT INTO TABLE(SELECT a.sales FROM individual_t a WHERE a.id='001')
VALUES (sales_t(300.00,'03-JAN-2019',30))


--update the nested table

UPDATE TABLE(SELECT a.sales FROM individual_t a WHERE a.id='001') p
SET p.qty=40
WHERE p.date='02-JAN-2019'


---delete from nested table

DELETE FROM TABLE(SELECT a.sales FROM individual_t a WHERE a.id='001') p
WHERE p.date='02-JAN-2019'

--DML on nested tuples(ROWS) DROP NESSTED TABLE
--dISCONNECT FROM THE NESTED TABLE

UPDATE individual a
SET a.sales=NULL
WHERE a.id='001'


-- DML on nested tuples(ROWS) ADD BACK a NESTED TABLE

UPDATE individual a
SET a.sales=sales_list(sales_t(100.00,'01-JAN-2019',10),
WHERE a.id='001'


UPDATE individual a
SET a.sales=sales_list()
WHERE a.id='001';

INSERT INTO TABLE(SELECT a.sales 
                  FROM individual_t a 
                  WHERE a.id='001')

VALUES (sales_t(200.00,'02-JAN-2019',20))

