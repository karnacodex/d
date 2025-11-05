-- Create the database
CREATE DATABASE dbms5;
USE dbms5;

-- Create tables
CREATE TABLE StudentMarks (
    Name VARCHAR(20),
    TotalMarks INT
);

CREATE TABLE Result (
    Roll_No INT,
    Name VARCHAR(20),
    Class VARCHAR(25)
);

-- Create stored procedure
DELIMITER $
CREATE PROCEDURE proc_grade(
    IN rollno INT,
    IN name VARCHAR(15),
    IN marks INT
)
BEGIN
    DECLARE class VARCHAR(25);
    
    IF marks >= 990 AND marks <= 1500 THEN
        SET class = 'Distinction';
    ELSEIF marks <= 989 AND marks >= 900 THEN
        SET class = 'First Class';
    ELSEIF marks <= 899 AND marks >= 825 THEN
        SET class = 'Second Class';
    ELSEIF marks <= 824 AND marks >= 700 THEN
        SET class = 'Pass';
    ELSE
        SET class = 'Fail';
    END IF;

    INSERT INTO StudentMarks VALUES (name, marks);
    INSERT INTO Result VALUES (rollno, name, class);
END $
DELIMITER ;

-- Call the procedure for multiple students
CALL proc_grade(1, 'Aryan', 850);
CALL proc_grade(2, 'Peter', 1000);
CALL proc_grade(3, 'Smith', 834);
CALL proc_grade(4, 'Carol', 750);
CALL proc_grade(5, 'Bob', 950);
CALL proc_grade(6, 'Sam', 650);

-- Display the results
SELECT * FROM Result;
SELECT * FROM StudentMarks;

-- Create function to count total students in a given class
DELIMITER $
CREATE FUNCTION tot_stud(classname VARCHAR(25))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total
    FROM Result
    WHERE Class = classname;
    RETURN total;
END $
DELIMITER ;

-- Example function calls
SELECT tot_stud('Second Class') AS 'Second Class Students';
SELECT tot_stud('Pass') AS 'Pass Students';

