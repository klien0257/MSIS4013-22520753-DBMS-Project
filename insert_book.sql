SET SERVEROUTPUT ON;
SET VERIFY OFF;

-- book insert

DECLARE

	bookno number;
	bname varchar(15);
	noc number;
	noc1 number;
	author varchar(15);
	publication varchar(10);
	nobooks number;
	lib_rec lib%rowtype;

BEGIN

	bookno:=&bookno;
	bname:='&bookname';
	author:='&author';
	publication:='&publication';
	noc:=&noofcopies;
	noc1:=noc;
	
	SELECT COUNT(*) INTO nobooks FROM lib WHERE bookname=bname;
	
	IF nobooks=0 THEN
	
		INSERT INTO lib VALUES(bname,author,publication,noc);
		
	ELSE
	
		UPDATE lib SET noofcopies=noofcopies+noc WHERE bookname=bname;
		
	END IF;
	
	WHILE noc!=0
	
	LOOP
	
		INSERT INTO books VALUES(bookno,bname,'yes',0);
		noc:=noc-1;
		bookno:=bookno+1;
		
	END LOOP;
END;
/

SELECT * FROM books;