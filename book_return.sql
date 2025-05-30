SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- Return Book

CREATE OR REPLACE PROCEDURE ret(bno IN NUMBER) 
IS

lib_rec lib%ROWTYPE;
book_rec books%ROWTYPE;
stud_rec customer%ROWTYPE;
sub_rec subscription%ROWTYPE;
book_no NUMBER;
no_of_books NUMBER;
fine NUMBER;

BEGIN

	SELECT * INTO book_rec FROM books WHERE bookno=bno;
	
	IF book_rec.available='yes' THEN
	
		DBMS_OUTPUT.PUT_LINE('book available');
		
	ELSE
	
		UPDATE subscription SET do_return=SYSDATE WHERE bookno=bno AND status='ntreturned';
		
		SELECT do_return-do_sub INTO fine from subscription WHERE bookno=bno AND status='ntreturned';
		
		IF fine>7 then
		
			UPDATE subscription SET fineamount=fine WHERE bookno=bno AND status='ntreturned';
			
			DBMS_OUTPUT.PUT_LINE('u have to pay a fine of||rs||fine||');
			
		END IF;
		
		UPDATE subscription SET status='returned' WHERE bookno=bno;
		
		UPDATE customer SET no_card=no_card+1 WHERE rollno=book_rec.subscribed_to;
		
		UPDATE books SET available='yes' WHERE bookno=bno;
		
		UPDATE books SET subscribed_to=0 WHERE bookno=bno;
		
	END IF;
	
	EXCEPTION
	
	WHEN no_data_found THEN
	
		DBMS_OUTPUT.PUT_LINE('Book does not belong to library');
		
END;
/

CREATE OR REPLACE TRIGGER subs_trig
AFTER UPDATE
OF status 
ON subscription
BEGIN
	DBMS_OUTPUT.PUT_LINE('Subscription status updated');
END;
/

COMMIT;