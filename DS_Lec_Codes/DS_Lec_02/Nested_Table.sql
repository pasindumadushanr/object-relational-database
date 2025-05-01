 ⚫-- ‘/’ after each type definition omitted to save space 
CREATE TYPE proj_t AS OBJECT (
 projno NUMBER,
 projname VARCHAR (15)); 

CREATE TYPE proj_list AS TABLE OF proj_t;

 CREATE TYPE employee_t AS OBJECT (
 eno number, 
projects proj_list); 
  
CREATE TABLE employees of employee_t (eno primary key)
 NESTED TABLE projects STORE AS employees_proj_table;


 --Inserting and Retrieving
 ⚫ --Insert a row into employees table:

 INSERT INTO employees VALUES(1000, proj_list(
 proj_t(101, 'Avionics'), 
proj_t(102, 'Cruise control')
 ));

 ⚫ --To retrieve the projects of eno 1000:
 SELECT * 

FROM TABLE(SELECT t.projects FROM employees t 
WHERE t.eno = 1000);

--output
 PROJNO PROJNAME-------------------
101   Avionics
 102   Cruise control



 --Collection Unnesting
 ⚫ --Unnest or flatten the collection attribute of a row
 ⚫-- by joining each row of the nested table with the row that 
--contains the nested table. 
⚫ --Example:
 SELECT e.eno, p.* 
FROM employees e, TABLE (e.projects) p;

--output
 ENO   
  PROJNO  
PROJNAME---- ---------- --------------
1000     
101   
1000     
2000     
102   
100   
Avionics
 Cruise control
 Autopilot