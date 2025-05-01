 CREATE TYPE student_t AS OBJECT (
    sno CHAR(5),
    sname VARCHAR2(20),
    gpa FLOAT
 )
 /
 CREATE TABLE students OF student_t 

 INSERT INTO students
    VALUES (student_t('S1', 'John', 3.5))
    /
    --show values as type

    SELECT value(s) FROM students s
    /
       

--part 02

CREATE TYPE dept_t AS OBJECT (
    dno CHAR(5),
    dname VARCHAR2(20)
)
/
CREATE TYPE emp_t AS OBJECT (
    eno CHAR(5),
    ename VARCHAR2(20),
    sal FLOAT,
    workdept REF dept_t
)
/

CREATE TABLE depts OF dept_t
(
    dno PRIMARY KEY
)
/
CREATE TABLE emp OF emp_t
(
    eno PRIMARY KEY
    
)
/
INSERT INTO dept
    VALUES (dept_t('D1', 'CS'))
    /

INSERT INTO emp 
    VALUES (emp_t('E1', 'John', 5000, SELECT REF(d) FROM dept d WHERE d.dno = 'D1')) 
    /
    
--REF(D) is a function that returns a reference to the object d.

--part 03

SELECT e.eno ,e.ename, e.workdept.dname 
FROM emp e
/
