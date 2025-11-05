-- Create student table
CREATE TABLE student (
    roll_no INT PRIMARY KEY,
    name VARCHAR(20),
    marks INT
);

-- Insert sample data
INSERT INTO student VALUES
(1, 'abc', 39),
(2, 'pqr', 35),
(3, 'xyz', 41),
(4, 'cde', 37),
(5, 'lmo', 46);

-- Display before update
SELECT * FROM student;

-- Create procedure to update marks and show affected rows
DELIMITER $$
CREATE PROCEDURE update_marks()
BEGIN
    DECLARE rows_updated INT DEFAULT 0;

    UPDATE student
    SET marks = 40
    WHERE marks BETWEEN 35 AND 39;

    SET rows_updated = ROW_COUNT();

    IF rows_updated = 0 THEN
        SELECT 'No records were updated' AS message;
    ELSE
        SELECT CONCAT('Total records updated: ', rows_updated) AS message;
    END IF;
END$$
DELIMITER ;

-- Run the procedure
CALL update_marks();

-- Check final table
SELECT * FROM student;


-- Create newstudent table
CREATE TABLE newstudent (
    roll_no INT PRIMARY KEY,
    name VARCHAR(20),
    marks INT
);

-- Insert sample data
INSERT INTO newstudent VALUES
(1, 'abc', 45),
(3, 'xyz', 45),
(7, 'xyzr', 95),
(8, 'pqrs', 65);

-- Procedure to copy data from student to newstudent without duplicates
DELIMITER $$
CREATE PROCEDURE copy_students()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE s_roll INT;
    DECLARE s_name VARCHAR(20);
    DECLARE s_marks INT;

    -- Cursor for student table
    DECLARE cur CURSOR FOR SELECT roll_no, name, marks FROM student;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO s_roll, s_name, s_marks;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Check if record exists in newstudent
        IF NOT EXISTS (SELECT 1 FROM newstudent WHERE roll_no = s_roll) THEN
            INSERT INTO newstudent VALUES (s_roll, s_name, s_marks);
        END IF;
    END LOOP;

    CLOSE cur;
END$$
DELIMITER ;

-- Run the procedure
CALL copy_students();

-- View final records
SELECT * FROM newstudent;




-- create database dbms6;
-- use dbms6;

-- CREATE TABLE O_RollCall (
--     Roll_no INT PRIMARY KEY,
--     Name VARCHAR(50),
--     Status VARCHAR(20)
-- );

-- CREATE TABLE N_RollCall (
--     Roll_no INT,
--     Name VARCHAR(50),
--     Status VARCHAR(20)
-- );

-- DELIMITER $$

-- CREATE PROCEDURE merge_rollcall()
-- BEGIN
--     DECLARE done INT DEFAULT 0;
--     DECLARE n_roll INT;
--     DECLARE n_name VARCHAR(50);
--     DECLARE n_status VARCHAR(20);

--     -- Cursor for new table
--     DECLARE cur_new CURSOR FOR
--         SELECT Roll_no, Name, Status FROM N_RollCall;

--     -- Parameterized cursor to check existing record
--     DECLARE cur_old CURSOR FOR
--         SELECT Roll_no FROM O_RollCall WHERE Roll_no = n_roll;

--     DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

--     OPEN cur_new;
--     read_loop: LOOP
--         FETCH cur_new INTO n_roll, n_name, n_status;
--         IF done = 1 THEN
--             LEAVE read_loop;
--         END IF;

--         -- Check if record exists in O_RollCall
--         IF NOT EXISTS (SELECT 1 FROM O_RollCall WHERE Roll_no = n_roll) THEN
--             INSERT INTO O_RollCall (Roll_no, Name, Status)
--             VALUES (n_roll, n_name, n_status);
--         END IF;
--     END LOOP;

--     CLOSE cur_new;
-- END$$

-- DELIMITER ;

-- CALL merge_rollcall();

