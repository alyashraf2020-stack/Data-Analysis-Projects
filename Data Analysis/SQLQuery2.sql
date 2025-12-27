create database sds23_company
create table department(
deptno varchar(2) primary key,
DeptName varchar(50),
location_ varchar(20) 
)

sp_addtype loc,'nchar(2)'

ALTER TABLE department
ALTER COLUMN location_ loc
ALTER TABLE department
ADD CONSTRAINT def_Location DEFAULT 'NY' FOR location_

create rule loc1
as
@l in ('ny','ds','kw')

sp_bindrule loc1,loc
 
 INSERT INTO Department (deptno,DeptName,location_) 
 VALUES ('d1','Research','NY')

 INSERT INTO Department (deptno, DeptName, location_) 
 VALUES ('d2','Accounting','DS')

 INSERT INTO Department (deptno, DeptName, location_) 
 VALUES ('d3','Marketing','KW')

 
CREATE TABLE Employee (
   EmpNo INT,
   Fname VARCHAR(20) NOT NULL,
   Lname VARCHAR(20) NOT NULL,
   DeptNo VARCHAR(2),
   Salary INT,
   CONSTRAINT PK_Employee PRIMARY KEY (EmpNo),
   CONSTRAINT FK_Employee_Department FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo),
   CONSTRAINT UQ_Employee_Salary UNIQUE (Salary),
   CONSTRAINT CK_Employee_Name CHECK (Fname IS NOT NULL AND Lname IS NOT NULL)
)

UPDATE Employee
SET EmpNo = 22222
WHERE EmpNo = 10102;

 
DELETE FROM Employee
WHERE EmpNo = 10102;


ALTER TABLE Employee
ADD TelephoneNumber VARCHAR(12) NULL;


ALTER TABLE Employee
DROP CONSTRAINT UQ_Employee_Salary;

ALTER TABLE Employee
DROP COLUMN TelephoneNumber;


   insert into Employee(EmpNo,Fname,Lname,DeptNo,Salary)
    values(25348,'Mathew','Smith','d3',2500),
   (10102, 'Ann',   'Jones',     'd3', 3000),
   (18316, 'John',  'Barrimore', 'd1', 2400),
   (29346, 'James', 'James',     'd2', 2800),
   (9031,  'Lisa',  'Bertoni',   'd2', 4000),
   (2581,  'Elisa', 'Hansel',    'd2', 3600),
   (28559, 'Sybl',  'Moser',     'd1', 2900)

 create rule sal
 as @s<6000

 sp_bindrule sal,'Employee.Salary'

 create table project
 (
 projectNo int,
 projectName VARCHAR(20),
 budget int null,
 constraint c5 primary key (projectNo),
 constraint c6 check (projectName is not null)
 )
 insert into project(projectNo,projectName,budget)
 values(1,'Apollo',120000),
       (2,'Gemini',95000 ),
       (3,'Mercury',185600 )

create table works_on (
 empNo int not null,
 projectNo int not null,
 job varchar(20) null,
 enter_date datetime not null constraint enterdate default getdate(), 
 constraint PK primary key (empNo, projectNo),
 constraint FK_Employee foreign key (empNo) references Employee(empNo),
 constraint FK_Project foreign key (projectNo) references project(projectNo)
)
insert into works_on(empNo)
values(11111)

update works_on
set empNo=11111
where empNo=10102

INSERT INTO Works_on (EmpNo, projectNo, Job, Enter_Date)
VALUES(10102, '1','Analyst', '2006-10-01'),
(10102, 3, 'Manager','2012-01-01'),
(25348, 2, 'Clerk','2007-02-15'),
(18316, 2, NULL,'2007-06-01'),
(29346, 2, NULL,'2006-12-15'),
(2581,  3, 'Analyst','2007-10-15'),
(9031,  1, 'Manager','2007-04-15'),
(28559, 1, NULL,'2007-08-01'),
(28559, 2, 'Clerk','2012-02-01'),
(9031,  3, 'Clerk','2006-11-15'),
(29346, 1, 'Clerk','2007-01-04')

with ranked_emp as
(select Fname,lname,deptno,salary,ROW_NUMBER()over(PARTITION by deptno order by salary desc) as rankeddept
from employee)
select Fname,Lname,deptno,salary,rankeddept
from ranked_emp
where rankeddept=3

WITH ProjectCounts AS (
    SELECT e.DeptNo,p.ProjectNo,p.ProjectName,COUNT(w.EmpNo) AS TotalEmployees,
    RANK() OVER (PARTITION BY e.DeptNo ORDER BY COUNT(w.EmpNo) DESC) AS ProjectRank
    FROM Works_on as w 
    JOIN Employee as e ON w.EmpNo = e.EmpNo
    JOIN Project as p ON w.ProjectNo = p.ProjectNo
    GROUP BY e.DeptNo, p.ProjectNo,p.ProjectName
)
SELECT DeptNo,projectName,TotalEmployees
FROM ProjectCounts
WHERE ProjectRank = 2

select Fname+''+Lname as employee_name,salary,
case
    when Salary between 2400 and 2500 then 'low salary'
    when Salary between 2800 and 2900 then 'medium salary'
    when Salary between 3000 and 3600 then 'high Salary'
    else 'the highest salary'  
    end as salary_rate
from employee
order by salary desc
