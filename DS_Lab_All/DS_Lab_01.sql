
--DS – Worksheet 1 – Y3S1

1)	Client table
create table client(
	clno char(3),
	name varchar(12),
	address varchar(30),
	constraint client_PK primary key(clno)
);

Stock table
create table stock(
	company char(7),
	price number(6,2),
	dividend number(4,2),
	eps number(4,2),
	constraint stock_PK primary key(company)
);

Trading table
create table trading(
	company char(7),
	exchange varchar(12),
	constraint trading_PK primary key (company, exchange),
	constraint trading_FK foreign key (company) references stock
);

Purchase table
create table purchase(
	clno char(3),
	company char(7),
	pdate date,
	qty number(6),
	price number(6,2),
	constraint purchase_PK primary key (clno, company, pdate),
	constraint purchase_FK1 foreign key (clno) references client,
	constraint purchase_FK2 foreign key (company) references stockk
);
2)	Insert data into client table

insert into client values('c01','John Smith','3/East Av/Bentley/W A 6102');
insert into client values('c02','Jill Brody','42/Bent St/Perth/W A 6001');

Insert data into stock table

insert into stock values('BHP',10.50,1.50,3.20);
insert into stock values('IBM',70.00,4.25,10.00);
insert into stock values('INTEL',76.50,5.00,12.40);
insert into stock values('FORD',40.00,2.00,8.50);
insert into stock values('GM',60.00,2.50,9.20);
insert into stock values('INFOSYS',45.00,3.00,7.80);

Insert data into trading table

insert into trading values('BHP','Sydney');
insert into trading values('BHP','New York');
insert into trading values('IBM','New York');
insert into trading values('IBM','London');
insert into trading values('IBM','Tokyo');
insert into trading values('INTEL','New York');
insert into trading values('INTEL','London');
insert into trading values('FORD','New York');
insert into trading values('GM','New York');
insert into trading values('INFOSYS','New York');

Insert data into purchase table

insert into purchase values('c01','BHP',TO_DATE('02/10/01', 'DD/MM/YY'),1000,12.00);
insert into purchase values('c01','BHP',TO_DATE('08/06/02', 'DD/MM/YY'),2000,10.50);
insert into purchase values('c01','IBM',TO_DATE('12/02/00', 'DD/MM/YY'),500,58.00);
insert into purchase values('c01','IBM',TO_DATE('10/04/01', 'DD/MM/YY'),1200,65.00);
insert into purchase values('c01','INFOSYS',TO_DATE('11/08/01', 'DD/MM/YY'),1000,64.00);
insert into purchase values('c02','INTEL',TO_DATE('30/01/00', 'DD/MM/YY'),300,35.00);
insert into purchase values('c02','INTEL',TO_DATE('30/01/01', 'DD/MM/YY'),400,54.00);
insert into purchase values('c02','INTEL',TO_DATE('02/10/01', 'DD/MM/YY'),200,60.00);
insert into purchase values('c02','FORD',TO_DATE('05/10/99', 'DD/MM/YY'),300,40.00);
insert into purchase values('c02','GM',TO_DATE('12/12/00', 'DD/MM/YY'),500,55.50);





3)
(a) select C.name, S.company, S.price, S.dividend, S.eps from client C, stock, purchase P where
C.clno = P.clno and S.company = p.company;

(b) select C.name, S.company, sum(P.qty), avg(P.price) from Client C, purchase P, stock S where
C.clno = P.clno and P.company = S.company group by C.name , S.company;

(c) select S.company, C.name, sum(P.qty), sum(P.qty * S.price) as current_value from client C, purchase P, stock S, trading T where T.exchange = 'New York' and T.company = S.company and S.company = P.company and C.clno = p.clno group by S.company, C.name;

(d) select C.name, sum(P.qty * P.price) as total_purchase_value from client C, purchase P where C.clno = P.clno group by C.name;

(e) select C.name, sum((S.price * P.qty) - (P.price * P.qty)) as book_profit_or_loss from client C, purchase P, stock S where P.company = S.company and C.clno = p.clno group by C.name;
