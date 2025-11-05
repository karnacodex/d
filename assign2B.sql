create database medical;
show databases;
use medical;

-- Patient table(patient_id,patient_name,Date of Admit,Age,City)
CREATE TABLE Patient(
	patient_id int primary key,
    patient_name varchar(20),
    DateOfAdmit DATE,
    age int,
    city varchar(30)
);

-- Doctor table(doc_id,doc_name,qualification,experience,dept,city,salary)
CREATE TABLE Doctor(
	doc_id int primary key,
    doc_name varchar(20),
	qualification varchar(15),
    experience int,
    dept varchar(30),
    city varchar(30),
    salary int
);

-- Treats table(doc_id,patient_id,disease) (use on delete cascade )
CREATE TABLE Treats(
	doc_id int,
    patient_id int,
    disease varchar(30),
    foreign key (doc_id) references Doctor(doc_id) on delete cascade,
    foreign key (patient_id) references Patient(patient_id) on delete cascade
);

INSERT INTO Patient VALUES
(0, 'Aryan', '2017-05-11', 20, 'Mumbai'),
(1, 'Amit', '2017-07-21', 39, 'Bangalore'),
(2, 'Anita', '2017-09-25', 49, 'pune'),
(3, 'Sandesh', '2017-07-21', 28, 'pune'),
(4, 'Suyash', '2017-04-17', 29, 'Delhi');
select * from Patient;

INSERT INTO Doctor VALUES
(0,"Suhas","MD",10,"Dental","pune",70000),
(1,"Yogesh","MD",18,"Dental","Delhi",40000),
(2,"Mangesh","MBBS",25,"Cardiology","Bangalore",100000),
(3,"Komal","MBBS",25,"Chemothera","Kolkata",45000),
(4,"Subham","MBBS",10,"Cardiology","Mumbai",60000);
select * from Doctor;

INSERT INTO Treats VALUES
(3,3,"Cancer"),
(3,1,"Cancer"),
(0,2,"Toothache"),
(2,4,"Heart Attack"),
(1,0,"Cavities");
select * from Treats;

-- 2. Display all the patient names between age group 18 to 50.
select patient_name, age from Patient where age between 18 and 50;

-- 3. Display the list of all doctors who are MD
select doc_name from Doctor where qualification="MD";

-- 4. Display the list of all doctors whose experience>20 years.
select doc_name from Doctor where experience>20;

-- 5. Display patient names suffering from cancer
select p.patient_name
FROM Patient p
JOIN Treats t ON p.patient_id = t.patient_id
WHERE t.disease='cancer'; 

-- 6. Display the patient name & doctor name who is treating the cancer patient.
SELECT p.patient_name,d.doc_name
FROM Patient p
JOIN Treats t ON p.patient_id = t.patient_id
JOIN Doctor d ON d.Doc_id = t.doc_id
where t.disease='cancer';

-- 7. Display the patient names whose name starts with letter 'a',end with 'a',having a name having exactly 5 letters.
select patient_name
from Patient
WHERE patient_name LIKE 'a%a'
AND CHAR_LENGTH(patient_name)=5;

-- 8. Remove all the records of patient with patient_id=3.
delete from Patient
where patient_id=3;

-- 9. Remove all the records of doctor Suhas.
delete from Doctor
where doc_name='Suhas';

-- 10. Change the qualification of doctor Shubham from MBBS to MD.
update Doctor 
set qualification="MD"
where doc_name="Subham";

-- 11. Give 5% salary rates to the dentist and 10% raise to cardiologist (in single query).
select * from Doctor;

-- UPDATE Doctor
-- SET salary = CASE
--     WHEN dept = 'dentist' THEN salary * 1.05
--     WHEN dept = 'cardiologist' THEN salary * 1.10
--     ELSE salary
-- END;

update Doctor set salary=case when dept="Dental" then salary+salary*(0.05) when
dept="Cardiology" then salary+salary*(0.1) else salary*1 end;

-- 12. Display dept wise total salary of doctors.
select dept, sum(salary) from Doctor
GROUP BY dept;

-- 13. Find the dept that have the highest avg salary.
-- select dept,avg(salary) from Doctor group by dept having avg(salary)>=all(select
-- avg(salary) from Doctor group by dept);

SELECT 
    dept,
    AVG(salary) AS avg_salary
FROM 
    Doctor
GROUP BY 
    dept
ORDER BY 
    avg_salary DESC
LIMIT 1;

-- 14. Find the avg salary of the doctors in dentist dept.
select avg(salary)
from Doctor
where dept="dental";

-- 15. Find the dept where avg salary of the instructor is more than 50,000.
select dept from Doctor
group by dept 
HAVING avg(salary)>50000;

-- 16. Find how many doctors work in hospital.
select count(doc_id) from Doctor;

-- 17. Find out how many doctors actually treated a patient.
select count(distinct doc_id) from Treats;

-- 18. List the cities in which either doctor or patient lives.
select city from Doctor 
union
select city from Patient;

-- 19. List the cities in which both the patient & the doctor lives.
-- SELECT DISTINCT city
-- FROM Doctor
-- WHERE city IN (SELECT city FROM Patient);

SELECT d.city
FROM Doctor d
INNER JOIN Patient p 
ON p.city = d.city;

-- 20. Find out the doctors who have not treated any patient.
-- select d.doc_name 
-- FROM Doctor d
-- LEFT JOIN Treats t
-- ON d.doc_id = t.doc_id
-- WHERE t.doc_id is NULL;

SELECT doc_name,doc_id FROM Doctor
where doc_id not in(select distinct doc_id from Treats);

