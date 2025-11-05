create database dbms6;
use dbms6;

CREATE TABLE O_RollCall (
    Roll_no INT PRIMARY KEY,
    Name VARCHAR(50),
    Status VARCHAR(20)
);

CREATE TABLE N_RollCall (
    Roll_no INT,
    Name VARCHAR(50),
    Status VARCHAR(20)
);

DELIMITER $$

CREATE PROCEDURE merge_rollcall()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE n_roll INT;
    DECLARE n_name VARCHAR(50);
    DECLARE n_status VARCHAR(20);

    -- Cursor for new table
    DECLARE cur_new CURSOR FOR
        SELECT Roll_no, Name, Status FROM N_RollCall;

    -- Parameterized cursor to check existing record
    DECLARE cur_old CURSOR FOR
        SELECT Roll_no FROM O_RollCall WHERE Roll_no = n_roll;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur_new;
    read_loop: LOOP
        FETCH cur_new INTO n_roll, n_name, n_status;
        IF done = 1 THEN
            LEAVE read_loop;
        END IF;

        -- Check if record exists in O_RollCall
        IF NOT EXISTS (SELECT 1 FROM O_RollCall WHERE Roll_no = n_roll) THEN
            INSERT INTO O_RollCall (Roll_no, Name, Status)
            VALUES (n_roll, n_name, n_status);
        END IF;
    END LOOP;

    CLOSE cur_new;
END$$

DELIMITER ;

CALL merge_rollcall();

