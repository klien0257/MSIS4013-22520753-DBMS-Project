CREATE OR REPLACE PROCEDURE sub(bname IN VARCHAR2, roll_no IN NUMBER)
IS
    stud_rec customer%ROWTYPE;
    book_no NUMBER;
    no_of_books NUMBER;
BEGIN
    -- Kiểm tra tồn tại khách hàng
    SELECT * INTO stud_rec FROM customer WHERE rollno = roll_no;

    IF stud_rec.no_card <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'No cards available to rent books');
    END IF;

    -- Kiểm tra số sách còn có thể thuê
    SELECT COUNT(*) INTO no_of_books FROM books WHERE bookname = bname AND available = 'yes';

    IF no_of_books = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, bname || ' is not available');
    END IF;

    -- Lấy sách có bookno nhỏ nhất đang còn sẵn
    SELECT MIN(bookno) INTO book_no FROM books WHERE bookname = bname AND available = 'yes';

    -- Thêm bản ghi thuê vào subscription
    INSERT INTO subscription (bookno, rollno, do_sub, do_return, fineamount, status)
    VALUES (book_no, roll_no, SYSDATE, SYSDATE + 7, 0, 'ntreturned');

    -- Cập nhật số thẻ giảm đi 1
    UPDATE customer SET no_card = no_card - 1 WHERE rollno = roll_no;

    -- Cập nhật trạng thái sách
    UPDATE books SET available = 'no', subscribed_to = roll_no WHERE bookno = book_no;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20003, 'Customer does not exist');
END;
/
