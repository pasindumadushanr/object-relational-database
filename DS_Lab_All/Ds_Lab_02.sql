--Laboratory Worksheet 02
--IT22580108

--1(a) 
-- Define object types
CREATE TYPE dept_t;
/

CREATE TYPE emp_t AS OBJECT (
    empno CHAR(6),
    firstName VARCHAR2(12),
    lastName VARCHAR2(15),
    workdept REF dept_t,
    sex CHAR(1),
    birthDate DATE,
    salary NUMBER(8,2)
);
/

CREATE TYPE dept_t AS OBJECT (
    deptNo CHAR(3),
    deptName VARCHAR(36),
    mgrNo REF emp_t,
    admrDept REF dept_t
);
/

1(b) Create tables
CREATE TABLE OREMP OF emp_t (
    CONSTRAINT tblemp_primarykey PRIMARY KEY (empno),
    CONSTRAINT tblemp_fname CHECK (firstName IS NOT NULL),
    CONSTRAINT tblemp_lname CHECK (lastName IS NOT NULL),
    CONSTRAINT tblemp_check_sex CHECK (sex IN ('M','m','F','f'))
);
/

CREATE TABLE ORDEPT OF dept_t (
    CONSTRAINT tbldept_primarykey PRIMARY KEY (deptNo),
    CONSTRAINT tbldept_mgrnum_fk FOREIGN KEY (mgrNo) REFERENCES OREMP,
    CONSTRAINT tbldept_admin_fk FOREIGN KEY (admrDept) REFERENCES ORDEPT,
    CONSTRAINT tbldept_deptno CHECK (deptNo IS NOT NULL),
    CONSTRAINT tbdept_deptname CHECK (deptName IS NOT NULL)
);
/

ALTER TABLE OREMP ADD 
CONSTRAINT tblemp_workdeptfk FOREIGN KEY (workDept) REFERENCES ORDEPT;
/

1(c) Insert and update data
 First, insert departments with null references
INSERT INTO ORDEPT VALUES (dept_t('A00', 'SPIFFY COMPUTER SERVICE DIV.', NULL, NULL));
/

INSERT INTO ORDEPT VALUES (dept_t('B01', 'PLANNING', NULL, 
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'A00')));
/

INSERT INTO ORDEPT VALUES (dept_t('C01', 'INFORMATION CENTRE', NULL,
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'A00')));
/

INSERT INTO ORDEPT VALUES (dept_t('D01', 'DEVELOPMENT CENTRE', NULL,
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'C01')));
/

-- Update A00's administrative department to itself
UPDATE ORDEPT d 
SET d.admrDept = (
    SELECT REF(d2) FROM ORDEPT d2
    WHERE d2.deptNo = 'A00'
) WHERE d.deptNo = 'A00';
/

-- Insert employees
INSERT INTO OREMP VALUES (
    emp_t('000010', 'CHRISTINE', 'HAAS',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'A00'),
    'F', '14-AUG-53', 72750)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000020', 'MICHAEL', 'THOMPSON',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'B01'),
    'M', '02-FEB-68', 61250)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000030', 'SALLY', 'KWAN',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'C01'),
    'F', '11-MAY-71', 58250)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000060', 'IRVING', 'STERN',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'D01'),
    'M', '07-JUL-65', 55555)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000070', 'EVA', 'PULASKI',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'D01'),
    'F', '26-MAY-73', 56170)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000050', 'JOHN', 'GEYER',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'C01'),
    'M', '15-SEP-55', 60175)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000090', 'EILEEN', 'HENDERSON',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'B01'),
    'F', '15-MAY-61', 49750)
);
/

INSERT INTO OREMP VALUES (
    emp_t('000100', 'THEODORE', 'SPENSER',
    (SELECT REF(d) FROM ORDEPT d WHERE d.deptNo = 'B01'),
    'M', '18-DEC-76', 46150)
);
/

-- Update department managers
UPDATE ORDEPT d
SET d.mgrNo = (
    SELECT REF(e) FROM OREMP e
    WHERE e.empno = '000010'
)
WHERE d.deptNo = 'A00';
/

UPDATE ORDEPT d
SET d.mgrNo = (
    SELECT REF(e) FROM OREMP e
    WHERE e.empno = '000020'
)
WHERE d.deptNo = 'B01';
/

UPDATE ORDEPT d
SET d.mgrNo = (
    SELECT REF(e) FROM OREMP e
    WHERE e.empno = '000030'
)
WHERE d.deptNo = 'C01';
/

UPDATE ORDEPT d
SET d.mgrNo = (
    SELECT REF(e) FROM OREMP e
    WHERE e.empno = '000060'
)
WHERE d.deptNo = 'D01';
/

2. Queries
(a) --Get department name and manager's lastname
SELECT d.deptName, DEREF(d.mgrNo).lastName AS manager
FROM ORDEPT d;
/

(b) Get employee number, lastname and department name
SELECT e.empno, e.lastName, DEREF(e.workdept).deptName AS DepartmentName
FROM OREMP e;
/

(c) Get department info and administrative department name
SELECT d.deptName, d.deptNo, DEREF(d.admrDept).deptName AS admrDName
FROM ORDEPT d;
/

(d) Get department info and administrative department manager
SELECT d.deptName, d.deptNo, 
       DEREF(d.admrDept).deptName AS admrDName,
       DEREF(DEREF(d.admrDept).mgrNo).lastName AS adminManager
FROM ORDEPT d;
/

(e) Get employee info and manager details
SELECT e.empno, e.firstName, e.lastName, e.salary,
       DEREF(DEREF(e.workdept).mgrNo).lastName AS managerName,
       DEREF(DEREF(e.workdept).mgrNo).salary AS managerSalary
FROM OREMP e;
/

 (f)--` Get average salary by gender and department
SELECT d.deptNo, 
       d.deptName,
       AVG(CASE WHEN DEREF(e.workdept).deptNo = d.deptNo AND 
                     UPPER(e.sex) = 'M' THEN e.salary END) as avg_male_salary,
       AVG(CASE WHEN DEREF(e.workdept).deptNo = d.deptNo AND 
                     UPPER(e.sex) = 'F' THEN e.salary END) as avg_female_salary
FROM ORDEPT d, OREMP e
GROUP BY d.deptNo, d.deptName;
/