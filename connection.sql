drop database link site1;

create database link site1
 connect to system idenfied by "12345"
 using '(DESCRIPTION = 
	   (ADDRESS_LIST =
	     (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.6.128)
		 (PORT = 1522))
	    )
		(CONNECT_DATA =
		  (SID = XE)
		)
	  )'
;

drop database link site2;

create database link site2
 connect to system idenfied by "12345"
 using '(DESCRIPTION = 
	   (ADDRESS_LIST =
	     (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.6.128)
		 (PORT = 1522))
	    )
		(CONNECT_DATA =
		  (SID = XE)
		)
	  )'
;

drop database link site3;

create database link site3
 connect to system idenfied by "12345"
 using '(DESCRIPTION = 
	   (ADDRESS_LIST =
	     (ADDRESS = (PROTOCOL = TCP)
		 (HOST = 192.168.6.128)
		 (PORT = 1522))
	    )
		(CONNECT_DATA =
		  (SID = XE)
		)
	  )'
;