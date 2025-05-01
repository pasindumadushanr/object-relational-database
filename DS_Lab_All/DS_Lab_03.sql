--IT22580108  Rajapaksha H.A.P.M  DS Practical 03

-- 01)
CREATE TYPE AddressType AS OBJECT (
STREETNO CHAR(3),
STREETNAME VARCHAR(12),
SUBURB VARCHAR(12),
PIN VARCHAR(12)
);
/

CREATE TYPE Exchanges AS VARRAY(3) OF VARCHAR(12);
/

CREATE TYPE StockType AS OBJECT (
COMPANY VARCHAR(7),
CURRENTPRICE NUMBER(6, 2),
EXCHANGESTRADED Exchanges,
DIVIDEND NUMBER(4, 2),
EPS NUMBER(4, 2)
);
/

CREATE TABLE Stocks OF StockType (
COMPANY NOT NULL PRIMARY KEY
)
/

-- 02)
INSERT INTO Stocks VALUES ('BHP', 10.50, Exchanges('Sydney', 'New York'), 1.50, 3.20);
INSERT INTO Stocks VALUES ('IBM', 70.00, Exchanges('New York', 'London', 'Tokyo'), 4.25, 10.00);
INSERT INTO Stocks VALUES ('INTEL', 76.50, Exchanges('New York', 'London'), 5.00, 12.40);
INSERT INTO Stocks VALUES ('FORD', 40.50, Exchanges('New York'), 2.00, 8.50);
INSERT INTO Stocks VALUES ('GM', 60.00, Exchanges('New York'), 2.50, 9.20);
INSERT INTO Stocks VALUES ('INFOSYS', 45.00, Exchanges('New York'), 3.00, 7.80);

SELECT COMPANY, CURRENTPRICE, DIVIDEND, EPS, E.COLUMN_VALUE FROM Stocks S, TABLE(S.EXCHANGESTRADED) E;

CREATE TYPE InvestmentsType AS OBJECT (
COMPANY REF StockType,
PRICE NUMBER(6, 2),
PDATE DATE,
QTY NUMBER(6)
);
/

CREATE TYPE InvestmentTableType AS TABLE OF InvestmentsType;
/

CREATE TYPE ClientType AS OBJECT (
NAME VARCHAR(12),
ADDRESS AddressType,
INVESTMENTS InvestmentTableType
);
/

CREATE TABLE Clients OF ClientType (
NAME NOT NULL PRIMARY KEY )
NESTED TABLE INVESTMENTS STORE AS INVESTMENT_TABLE;
/

INSERT INTO Clients VALUES (
  'John Smith',
  AddressType('3', 'East AV', 'Bentley', 'WA 6102'),
    InvestmentTableType(
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'BHP'), 12.00, '02-OCT-01', 1000),
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'BHP'), 10.50, '08-JUN-02', 2000),
	InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'IBM'), 58.00, '12-FEB-00', 500),
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'IBM'), 65.00, '10-APR-01', 1200),
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'INFOSYS'), 64.00, '11-AUG-01', 1000))
);
/

INSERT INTO Clients VALUES (
  'Jill Brody',
  AddressType('42', 'Bent St', 'Perth', 'WA 6001'),
    InvestmentTableType(
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'INTEL'), 35.00, '30-JAN-00', 300),
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'INTEL'), 54.00, '30-JUN-02', 400),
	InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'INTEL'), 60.00, '02-OCT-01', 200),
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'FORD'), 40.00, '05-OCT-99', 300),
      InvestmentsType((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'GM'), 55.00, '12-DEC-00', 500))
);
/

SELECT 
  c.name,
  c.address.streetno,
  c.address.streetname,
  c.address.suburb,
  c.address.pin,
  i.COMPANY.COMPANY,
  i.PRICE,
  i.PDATE,
  i.QTY
FROM Clients c, TABLE(c.investments) i;


-- 03)
-- a)
SELECT c.name, i.COMPANY.COMPANY, i.PRICE, i.PDATE, i.QTY, i.COMPANY.CURRENTPRICE, i.COMPANY.DIVIDEND ,i.COMPANY.EPS
FROM Clients c, TABLE(c.investments) i;

-- b)
SELECT c.name, i.company.company, SUM(i.qty) as TOTALSHARES, ROUND(SUM(i.price * i.qty)/SUM(i.qty), 2) AS AVERAGEPRICE
FROM Clients c, TABLE(c.investments) i
GROUP BY c.name, i.company.company;

-- d)
SELECT c.name, SUM(i.price * i.qty) AS TOTALPURCHASEVALUE
FROM Clients c, TABLE(c.investments) i
GROUP BY c.name; 

-- e)
SELECT c.name,  SUM(i.price * i.qty) - SUM(i.qty * i.company.currentprice) AS "PROFIT/LOSS"
FROM Clients c, TABLE(c.investments) i
GROUP BY c.name;


-- 04)
INSERT INTO TABLE(SELECT c.INVESTMENTS FROM Clients c WHERE NAME = 'Jill Brody') VALUES ((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'INFOSYS'), 45.00, CURRENT_DATE, 1000);
INSERT INTO TABLE(SELECT c.INVESTMENTS FROM Clients c WHERE NAME = 'John Smith') VALUES ((SELECT REF(s) FROM Stocks s WHERE COMPANY = 'GM'), 60.00, CURRENT_DATE, 500);

DELETE TABLE(SELECT c.INVESTMENTS FROM Clients c WHERE NAME = 'John Smith') i WHERE i.company.company = 'INFOSYS';
DELETE TABLE(SELECT c.INVESTMENTS FROM Clients c WHERE NAME = 'Jill Brody') i WHERE i.company.company = 'GM';