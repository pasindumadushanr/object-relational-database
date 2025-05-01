-- VARRAY EXAMPLE 01

CREATE TYPE price_arr AS VARRAY(10) OF NUMBER(12,2)


--CREATE TABLE pricelist OF price_arr

CREATE TABLE pricelist (
    pno integer,
    prices price_arr
)

--INSERT INTO pricelist

INSERT INTO pricelist
VALUES (1, price_arr(100.00, 200.00, 300.00))
;

--RETRIEVE DATA

SELECT * FROM pricelist ;

--RETRIEVE DATA AS TYPE
SELECT pno, s.COLUMN_VALUE AS price
FROM pricelist p, TABLE(p.prices) s
;

 