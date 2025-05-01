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

CREATE TYPE


