--DECLARE METHOD
CREATE TYPE student_t AS OBJECT (
    id CHAR(5),
    name VARCHAR2(20),
    units NUMBER,
    MEMBER FUNCTION totalSales(units_price FLOAT)
    RETURN FLOAT
)

--DEFINE METHOD

CREATE TYPE BODY student_t AS
    MEMBER FUNCTION totalSales(units_price FLOAT)
    RETURN FLOAT 

    =======

CREATE TYPE sales_t AS OBJECT (
    id CHAR(5),
    name VARCHAR2(20),
    units NUMBER,
    MEMBER FUNCTION totalSales(unit_price FLOAT)
    RETURN FLOAT
)
/
CREATE TYPE BODY sales_t AS
    MEMBER FUNCTION totalSales(unit_price FLOAT)
    RETURN FLOAT IS
     BEGIN 
        RETURN SELF.units * unit_price;
     END totalSales
/
CREATE TABLE Sales_table of sales_t;


ALERT TYPE sales_t 
ADD MEMBER FUNCTION offer(rate FLOAT)
RETURN FLOAT CASCADE
/
CREATE OR REPLACE TYPE BODY sales_t AS
    MEMBER FUNCTION totalSales(rate FLOAT)
    RETURN FLOAT IS
     BEGIN 
        RETURN SELF.units*units_price;
    END totalSales
   MEMBER FUNCTION offer(rate FLOAT)
    RETURN FLOAT IS
     BEGIN 
        RETURN SELF.units*rate;
    END offer
END sales_t
/


        
    