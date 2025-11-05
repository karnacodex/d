CREATE TABLE Library(
    B_id INT PRIMARY KEY,
    Title VARCHAR(50),
    Authors VARCHAR(50),
    Edition INT,
    no_of_c INT
);

CREATE TABLE Library_audit(
    B_id INT,
    Title VARCHAR(50),
    Authors VARCHAR(50),
    Edition INT,
    no_of_c INT,
    date_of_mod DATE,
    type_of_op VARCHAR(20),
    username VARCHAR(50)
);

CREATE TABLE Transaction(
    Trans_id INT PRIMARY KEY,
    B_id INT,
    I_R CHAR(1),         -- 'I' for Issue, 'R' for Return
    no_of_c INT
);

INSERT INTO Library VALUES
(1, 'TOC', 'V.V Richard', 2, 4),
(2, 'CN', 'Forouzan', 4, 5),
(3, 'ISEE', 'Rahul De', 3, 5),
(4, 'DBMS', 'Silberschatz', 3, 2),
(5, 'SEPM', 'Pressman', 5, 6);

DELIMITER $$
CREATE TRIGGER trg_update_library
AFTER UPDATE ON Library
FOR EACH ROW
BEGIN
    DECLARE action VARCHAR(10);
    SET action = 'updated';
    INSERT INTO Library_audit
    VALUES (OLD.B_id, OLD.Title, OLD.Authors, OLD.Edition, OLD.no_of_c,
            CURDATE(), action, CURRENT_USER());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_delete_library
AFTER DELETE ON Library
FOR EACH ROW
BEGIN
    DECLARE action VARCHAR(10);
    SET action = 'deleted';
    INSERT INTO Library_audit
    VALUES (OLD.B_id, OLD.Title, OLD.Authors, OLD.Edition, OLD.no_of_c,
            CURDATE(), action, CURRENT_USER());
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_check_copies
BEFORE INSERT ON Transaction
FOR EACH ROW
BEGIN
    DECLARE available INT;
    IF NEW.I_R = 'I' THEN
        SELECT no_of_c INTO available FROM Library WHERE B_id = NEW.B_id;
        IF NEW.no_of_c > available THEN
            SET NEW.no_of_c = available;
        END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_update_library_stock
AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    IF NEW.I_R = 'I' THEN
        UPDATE Library
        SET no_of_c = no_of_c - NEW.no_of_c
        WHERE B_id = NEW.B_id;
    ELSEIF NEW.I_R = 'R' THEN
        UPDATE Library
        SET no_of_c = no_of_c + NEW.no_of_c
        WHERE B_id = NEW.B_id;
    END IF;
END$$
DELIMITER ;

-- Update author (will log to audit table)
UPDATE Library SET Authors = 'Kapil-Mishra' WHERE B_id = 1;

-- Delete record (will log to audit table)
DELETE FROM Library WHERE B_id = 3;

-- Issue books
INSERT INTO Transaction VALUES (10, 2, 'I', 7);

-- Return books
INSERT INTO Transaction VALUES (11, 2, 'R', 3);

-- Check results
SELECT * FROM Library;
SELECT * FROM Library_audit;
SELECT * FROM Transaction;

