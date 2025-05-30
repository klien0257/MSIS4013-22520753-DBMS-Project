-- Drop tables nếu đã tồn tại
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE subscription CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE books CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE customer CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE lib CASCADE CONSTRAINTS';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Tạo bảng
CREATE TABLE lib(
  bookname VARCHAR2(50),
  author VARCHAR2(50),
  publication VARCHAR2(50),
  noofcopies NUMBER);

CREATE TABLE customer(
  rollno NUMBER PRIMARY KEY,
  name VARCHAR2(50),
  no_card NUMBER);

CREATE TABLE books(
  bookno NUMBER PRIMARY KEY,
  bookname VARCHAR2(50),
  available VARCHAR2(3),
  subscribed_to NUMBER);

CREATE TABLE subscription(
  bookno NUMBER,
  rollno NUMBER,
  do_sub DATE,
  do_return DATE,
  fineamount NUMBER,
  status VARCHAR2(20));

-- Thủ tục thuê sách
CREATE OR REPLACE PROCEDURE sub(bname IN VARCHAR2, roll_no IN NUMBER)
IS
  stud_rec customer%ROWTYPE;
  book_no NUMBER;
  no_of_books NUMBER;
BEGIN
  SELECT * INTO stud_rec FROM customer WHERE rollno = roll_no;

  IF stud_rec.no_card <= 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'No cards available to rent books');
  END IF;

  SELECT COUNT(*) INTO no_of_books FROM books WHERE bookname = bname AND available = 'yes';

  IF no_of_books = 0 THEN
    RAISE_APPLICATION_ERROR(-20002, bname || ' is not available');
  END IF;

  SELECT MIN(bookno) INTO book_no FROM books WHERE bookname = bname AND available = 'yes';

  INSERT INTO subscription (bookno, rollno, do_sub, do_return, fineamount, status)
  VALUES (book_no, roll_no, SYSDATE, SYSDATE + 7, 0, 'ntreturned');

  UPDATE customer SET no_card = no_card - 1 WHERE rollno = roll_no;

  UPDATE books SET available = 'no', subscribed_to = roll_no WHERE bookno = book_no;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20003, 'Customer does not exist');
END;
/

-- Dữ liệu mẫu
INSERT INTO lib VALUES ('The Great Gatsby', 'F. Scott Fitzgerald', 'Scribner', 3);
INSERT INTO lib VALUES ('1984', 'George Orwell', 'Secker & Warburg', 5);
INSERT INTO lib VALUES ('To Kill a Mockingbird', 'Harper Lee', 'J.B. Lippincott & Co.', 4);
INSERT INTO lib VALUES ('Moby Dick', 'Herman Melville', 'Harper & Brothers', 2);
INSERT INTO lib VALUES ('Pride and Prejudice', 'Jane Austen', 'T. Egerton', 6);
INSERT INTO lib VALUES ('Norwegian Wood', 'Haruki Murakami', 'Kodansha', 3);
INSERT INTO lib VALUES ('Kafka on the Shore', 'Haruki Murakami', 'Shinchosha', 4);

INSERT INTO books VALUES (1, 'The Great Gatsby', 'yes', 0);
INSERT INTO books VALUES (2, 'The Great Gatsby', 'yes', 0);
INSERT INTO books VALUES (3, 'The Great Gatsby', 'yes', 0);
INSERT INTO books VALUES (4, '1984', 'yes', 0);
INSERT INTO books VALUES (5, '1984', 'yes', 0);
INSERT INTO books VALUES (6, '1984', 'yes', 0);
INSERT INTO books VALUES (7, '1984', 'yes', 0);
INSERT INTO books VALUES (8, '1984', 'yes', 0);
INSERT INTO books VALUES (9, 'To Kill a Mockingbird', 'yes', 0);
INSERT INTO books VALUES (10, 'To Kill a Mockingbird', 'yes', 0);
INSERT INTO books VALUES (11, 'To Kill a Mockingbird', 'yes', 0);
INSERT INTO books VALUES (12, 'To Kill a Mockingbird', 'yes', 0);
INSERT INTO books VALUES (13, 'Moby Dick', 'yes', 0);
INSERT INTO books VALUES (14, 'Moby Dick', 'yes', 0);
INSERT INTO books VALUES (15, 'Pride and Prejudice', 'yes', 0);
INSERT INTO books VALUES (16, 'Pride and Prejudice', 'yes', 0);
INSERT INTO books VALUES (17, 'Pride and Prejudice', 'yes', 0);
INSERT INTO books VALUES (18, 'Pride and Prejudice', 'yes', 0);
INSERT INTO books VALUES (19, 'Pride and Prejudice', 'yes', 0);
INSERT INTO books VALUES (20, 'Pride and Prejudice', 'yes', 0);
INSERT INTO books VALUES (21, 'Norwegian Wood', 'yes', 0);
INSERT INTO books VALUES (22, 'Norwegian Wood', 'yes', 0);
INSERT INTO books VALUES (23, 'Norwegian Wood', 'yes', 0);
INSERT INTO books VALUES (24, 'Kafka on the Shore', 'yes', 0);
INSERT INTO books VALUES (25, 'Kafka on the Shore', 'yes', 0);
INSERT INTO books VALUES (26, 'Kafka on the Shore', 'yes', 0);
INSERT INTO books VALUES (27, 'Kafka on the Shore', 'yes', 0);

INSERT INTO customer VALUES (22520753,'Lien',2);
INSERT INTO customer VALUES (32520753,'Neil',3);
INSERT INTO customer VALUES (42520753,'Eiln',4);
INSERT INTO customer VALUES (52520753,'Leni',5);

COMMIT;


-- Sample selects to verify
SELECT * FROM lib;
SELECT * FROM books;
SELECT * FROM customer;

SELECT * FROM subscription WHERE rollno = 22520753 AND status = 'ntreturned';
SELECT * FROM books WHERE subscribed_to = 22520753 AND available = 'no';

BEGIN
  sub('The Great Gatsby', 22520753);
END;
/
COMMIT;

