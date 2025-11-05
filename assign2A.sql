create database university;
use university;

-- Department table( dept_no, dept_name, building_name )
	-- Apply Unique constraint on name field.
create table Department(
	dept_no int,
    dept_name varchar(15),
    bldg_name varchar(15),
    unique(dept_no)
);

-- Instructor table( ins_id, ins_name, dept_no, salary, mob_no )
	-- Apply NOT NULL constraint on name field.
create table Instructor(
	ins_id int,
    ins_name varchar(15) not null,
    dept_no int,
    salary int,
    mob_no int,
    primary key(ins_id)
);

-- Course table( course_id, title, dept_no, credits )
create table Course(
	course_id int,
    title varchar(30),
    dept_no int,
    credits int,
    primary key(course_id)
);

-- Teaches table( teacher_id, course_id, semester, year )
create table Teacher(
	teacher_id int,
    course_id int,
    semester int,
    year year,
    foreign key(teacher_id) references Instructor(ins_id),
    foreign key(course_id) references Course(course_id)
);

insert into Department values
(101, 'ComputerSci', 'Block-A'),
(102, 'Mathematics', 'Block-B'),
(103, 'Physics', 'Block-C'),
(104, 'Chemistry', 'Block-D'),
(105, 'English', 'Block-E');


insert into Instructor values
(1, 'Alice', 101, 85000, 9876),
(2, 'Bob', 102, 78000, 9123),
(3, 'Charlie', 103, 72000, 998),
(4, 'David', 104, 69000, 9090),
(5, 'Eva', 105, 75000, 987);


insert into Course values
(201, 'Data Structures', 101, 4),
(202, 'Calculus I', 102, 3),
(203, 'Quantum Mechanics', 103, 4),
(204, 'Organic Chemistry', 104, 3),
(205, 'British Literature', 105, 3),
(206, 'Operating Systems', 101, 4);


insert into Teacher values
(1, 201, 1, 2024),
(1, 206, 2, 2024),
(2, 202, 1, 2023),
(3, 203, 2, 2023),
(4, 204, 1, 2024),
(5, 205, 2, 2024);

-- Quieries :
-- 1 Add the primary key in department table.
alter table Department
add primary key(dept_no);

-- 2 Add the foreign key in instructor table.
alter table Instructor
add foreign key(dept_no) references Department(dept_no);

-- 3 Modify the table department by adding a column budget.
alter table Department
add column budget int;

-- 4 Create unique index on mobile number of instructor table.
create unique index sr
on Instructor(mob_no);

-- 5 Create a view of instructor relation except the salary field.
create view inst_view as
select ins_id,ins_name,dept_no,mob_no from Instructor;

select * from inst_view;

-- 6 Insert record into instructor table using newly created viewname.
insert into Department values(4,"Elect","D",null);
select * from inst_view;
select * from Department;

 7 select * from inst_view;

--  Update the department number of particular instructor using update view.
-- insert into Instructor values
-- (1,"test1",4,20000,7070);

-- 7 Update the department number of particular instructor using update view.
update inst_view 
set ins_name='test2'
where ins_id=4;
select * from inst_view;

-- 8 Delete record of particular instructor from instructor table using newly created viewname.
delete from inst_view
where ins_id = 1;

 -- 9 Delete the last view.
drop view inst_view;

-- 10 Remove the Budget from department table.
alter table Department 
drop budget;

-- 11 Increase the size of the title field of course relation.
alter table Course
modify title varchar(35);

-- 12 Create a view by showing a instructor name with a department name and its salary.
create view newview1 as
select inst.ins_name, dept.dept_name, inst.salary
from Instructor inst
JOIN Department dept
ON inst.dept_no = dept.dept_no;

select * from newview1;

-- 13 Update salary of particular instructor using update view.
update newview1 
set salary=50000
where ins_name='Bob';

-- 14 Delete the index from the instructor table.
alter table Instructor
drop index sr;

desc Instructor;

-- 15 Rename the course table to another table name.
rename table Course to Coursetable;

-- 16 Create a view by showing a instructor name and title of course he teaches.
create view newview2 as 
select ins_name,title from Instructor,Coursetable 
where Instructor.dept_no=Coursetable.dept_no;

select * from newview2;


-- 17 Delete the primary key from the department table.
-- SHOW CREATE TABLE Department;
-- SHOW CREATE TABLE Instructor;

ALTER TABLE Instructor
DROP FOREIGN KEY Instructor_ibfk_1;

ALTER TABLE Department
DROP primary key;


-- 18 create the table student having field student id,student
-- name,dept_no,birth date. student id should be auto_increment.
-- Dept_no is foreign key.

		-- alter table Department add primary key(dept_no);
create table Student(
	stud_id int auto_increment,
	stud_name varchar(10),
    dept_no int,
    DOB date,
    foreign key(dept_no) references Department(dept_no),
    primary key(stud_id)
);

-- 19 Change the sequence of your auto increment field.
alter table Student auto_increment=5;
select * from Student;

-- 20 Create the view of computer department teachers name who teaches in 5th semester.
create view new1 as 
select dept_name,semester,ins_name 
from
Department,teachers,instructor where teachers.semester=2 and
Department.dept_name="comp" and instructor.ins_id=teachers.teacher_id and
instructor.dept_no=Department.dept_no;





