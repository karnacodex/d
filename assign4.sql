create database dbms4;
use dbms4;

CREATE TABLE Borrower (
    Roll_no INT,
    Name VARCHAR(50),
    DateofIssue DATE,
    NameofBook VARCHAR(50),
    Status CHAR(1)
);

CREATE TABLE Fine (
    Roll_no INT,
    Date DATE,
    Amt INT
);

DELIMITER $$

CREATE PROCEDURE proc_calculate_fine (
    IN p_roll INT,
    IN p_bookname VARCHAR(50)
)
BEGIN
    DECLARE issue_date DATE;
    DECLARE days_diff INT DEFAULT 0;
    DECLARE fine_amt INT DEFAULT 0;
    DECLARE not_found CONDITION FOR SQLSTATE '02000'; -- User-defined exception

    -- Exception handler
    DECLARE EXIT HANDLER FOR not_found 
    BEGIN
        SELECT 'No record found for given Roll No or Book Name' AS Message;
    END;

    -- Try to get issue date
    SELECT dateofissue INTO issue_date 
    FROM Borrower 
    WHERE roll_no = p_roll AND NameofBook = p_bookname;

    -- Calculate no. of days
    SET days_diff = DATEDIFF(CURDATE(), issue_date);

    -- Calculate fine amount
    IF days_diff BETWEEN 15 AND 30 THEN
        SET fine_amt = (days_diff - 15) * 5;
    ELSEIF days_diff > 30 THEN
        SET fine_amt = (15 * 5) + ((days_diff - 30) * 50);
    ELSE
        SET fine_amt = 0;
    END IF;

    -- Update status to 'R' (Returned)
    UPDATE Borrower 
    SET Status = 'R' 
    WHERE roll_no = p_roll AND NameofBook = p_bookname;

    -- Insert into fine table if fine exists
    IF fine_amt > 0 THEN
        INSERT INTO Fine (roll_no, Date, Amt) 
        VALUES (p_roll, CURDATE(), fine_amt);
    END IF;

    -- Output message
    SELECT CONCAT('Book returned successfully. Fine = Rs ', fine_amt) AS Result;

END$$

DELIMITER ;

-- Sample data
INSERT INTO Borrower VALUES (1, 'Harsh', '2025-09-20', 'Harry Potter', 'I');

-- Run the procedure
CALL proc_calculate_fine(1, 'Harry Potter');

-- Check result
SELECT * FROM Fine;
SELECT * FROM Borrower;


