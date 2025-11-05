create database bank;
use bank;

-- Branchmaster(branch_id,branch_name)
CREATE TABLE Branchmaster(
	branch_id INT PRIMARY KEY,
    branch_name VARCHAR(30) NOT NULL
);

-- Employee master(emp_no,emp_name,branch_id,salary,Dept,manager_id) (manager_id & branch_id is foreign key)
CREATE TABLE Empmaster(
	emp_id INT PRIMARY KEY,
	emp_name VARCHAR(30),
    branch_id INT,
    salary INT,
    dept VARCHAR(30),
    manager_id INT,
    foreign key (branch_id) references Branchmaster(branch_id) ON DELETE SET NULL,
    foreign key (manager_id) references Empmaster(emp_id) ON DELETE SET NULL
);

-- Conatct details(emp_id,email_id,phone_no) (Apply on delete set null constraint & foreign key on emp_id)
CREATE TABLE contactdetails(
	emp_id INT,
    email_id VARCHAR(30),
    phone_no VARCHAR(10),
    FOREIGN KEY (emp_id) REFERENCES Empmaster(emp_id) ON DELETE SET NULL
);

-- EmpAddress details(emp_id,street,city,state) (Apply on delete set cascade constraint & foreign key on emp_id)
CREATE TABLE Empaddress(
	emp_id INT,
    street VARCHAR(30),
    city VARCHAR(30),
    state VARCHAR(30),
    FOREIGN KEY (emp_id) REFERENCES Empmaster(emp_id) ON DELETE SET NULL
); 

-- Branch address(branch_id,city,state)(branch_id is foreign key)
CREATE TABLE Branchaddress(
	branch_id INT,
    city VARCHAR(30),
    state VARCHAR(30),
    FOREIGN KEY (branch_id) REFERENCES Branchmaster(branch_id) ON DELETE CASCADE
);

-- INSERT DATA
INSERT INTO Branchmaster values
(1,"Vadgaon"),
(2,"Park street"),
(3,"Panvel"),
(4,"Pimpri"),
(5,"Model colony");

INSERT INTO Empmaster Values
(10,"Aryan",2,40000,"Manager",NULL),
(11,"Kiran",4,50000,"Admin",10),
(12,"Carol",1,60000,"Assistant",10),
(13,"Peter",3,120000,"Senior",10),
(14,"Bob",5,110000,"HR",10);

INSERT INTO contactdetails Values
(11,"kiran@gmail.com","9890154761"),
(10,"aryan@gmail.com","8806058754"),
(13,"peter@hotmail.c","9373203456");

INSERT INTO Branchaddress values
(1, "Pune", "Maharastra"),
(2, "Kolkata", "West Bengal"),
(3, "Mumbai", "Maharastra"),
(4, "Bangalore", "Karnataka"),
(5, "Cuttack", "Orissa");

INSERT INTO Empaddress values
(10, "vadgaon" ,"Pune", "Maharashtra"),
(11, "Link Road" ,"Mumbai", "Maharashtra"),
(12, "Park stree" ,"Kolkata", "West Bengal"),
(13, "Roha" ,"Bangalore", "Karnataka"),
(14, "Street roa" ,"Cuttack", "Orissa");

-- 2. List the employee details along with branch name using the inner join and in the order of emp_no
select emp_id,emp_name,branch_name 
FROM Empmaster e
INNER JOIN Branchmaster b 
ON e.branch_id = b.branch_id
ORDER BY emp_id;

-- 3. List the details of employee who belong to admin department along with the branch name to which they belong.
select emp_name,branch_name from Empmaster e
INNER JOIN Branchmaster b
ON e.branch_id = b.branch_id
where e.dept='Admin';

-- 4. List the employee name along with the phone no and city using inner join.
SELECT e.emp_name, c.phone_no, a.city
FROM Empmaster e
INNER JOIN contactdetails c 
ON c.emp_id = e.emp_id
INNER JOIN Empaddress a
ON c.emp_id = a.emp_id;

-- 5. List the employee name with the contact details (if any).
SELECT e.emp_name, c.email_id, c.phone_no 
FROM Empmaster e
LEFT JOIN contactdetails c
ON e.emp_id = c.emp_id;

-- 6. List the employee contact details irrespective of whether they are working or have left.
-- select * from Empmaster;
-- delete from Empmaster where emp_id=12;
-- delete from Empmaster where emp_id=13;

select emp_name,email_id,phone_no from Empmaster e right join contactdetails c on
e.emp_id=c.emp_id;

-- 7. Retrieve the employee name and their respective manager name.
select e.emp_name as Employee,
	   m.emp_name as Manager
FROM Empmaster e
LEFT JOIN Empmaster m
ON e.manager_id = m.emp_id;

-- 8. List the employee details along with branch name using natural join.
SELECT emp_name,dept,branch_name,salary
FROM Empmaster e
NATURAL JOIN Branchmaster;

-- 9. List the employee names who work at the vadgaon branch along with the city of that employee.
SELECT emp_name,city
FROM Empmaster e
INNER JOIN Branchmaster b
ON e.branch_id = b.branch_id
INNER JOIN Branchaddress a
ON e.branch_id = a.branch_id
where b.branch_name='Vadgaon';

-- 10. Find the employee who works at the vadgaon branch with salary>10000 and list the employee names with streets and city they live in.
SELECT e.emp_name,a.street,a.city
FROM Empmaster e
JOIN Branchmaster b
ON b.branch_id = e.branch_id
JOIN Empaddress a
ON a.emp_id = e.emp_id
WHERE e.salary>10000 AND b.branch_name='Vadgaon';

-- 11. Find the employees who live and work in same city.
SELECT e.emp_name
FROM Empmaster e
JOIN Empaddress a
ON e.emp_id = a.emp_id
JOIN Branchaddress b
ON e.branch_id = b.branch_id
WHERE a.city = b.city;

-- 12. Find the employees whose salaries are more than everybody who works at branch vadgaon.
SELECT e.emp_name, e.salary FROM Empmaster e
WHERE e.salary > ALL(
	SELECT e2.salary FROM Empmaster e2
    JOIN Branchmaster b
    ON b.branch_id = e2.branch_id
    WHERE b.branch_name = 'Vadgaon'
);

-- 13. Create a view which will contain total employees at each branch.
CREATE VIEW TotEmp AS
SELECT b.branch_name, count(e.emp_id) as tot_emp
FROM Branchmaster b
LEFT JOIN Empmaster e
ON b.branch_id = e.branch_id
GROUP BY b.branch_name;

-- select * from TotEmp;

-- 14. List the branch names where employee have a salary>100000
SELECT b.branch_name FROM Branchmaster b
JOIN Empmaster e
ON e.branch_id = b.branch_id
WHERE e.salary > 100000;

-- select branch_name from Empmaster e,Branchmaster b where e.branch_id=b.branch_id
-- and salary>100000;

-- 15. Create a view which will show the avg salary and the total salary at each branch.
CREATE VIEW SalBranch AS
SELECT b.branch_name, AVG(e.salary) as avgsal, SUM(salary) as totsal
FROM Branchmaster b
LEFT JOIN Empmaster e
ON b.branch_id = e.branch_id
GROUP BY b.branch_id;

-- select * from SalBranch;

-- 16. Find the employee who do not have a job at vadgaon branch.
SELECT e.emp_name FROM Empmaster e
JOIN Branchmaster b
ON b.branch_id = e.branch_id
WHERE b.branch_name != 'Vadgaon';

-- select emp_name from Empmaster e,Branchmaster b where e.branch_id=b.branch_id and
-- e.branch_id not in(select branch_id from Branchmaster where branch_name="vadgaon");


