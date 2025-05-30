# Library Management System

## Overview

This project implements an **Online Library Management System** using **PL/SQL** for backend logic, enabling seamless interaction with an **Oracle Database**. The system automates and enhances library tasks such as book rentals, book returns, and management of customer data, making library operations more efficient.

### Features

* **Stored Procedures**: The system uses stored procedures to manage key functionalities such as book rentals and book returns.

  * **Book Rental**: The stored procedure `sub` is responsible for processing book rentals, ensuring that the customer has enough rental cards (`no_card`) available, and updating the database when a book is rented.
  * **Book Return**: The stored procedure `ret` handles the return of rented books, including checking for fines based on overdue returns and updating the status of the rented books.

* **Triggers**: The system includes triggers to maintain the integrity of the data.

  * **Trigger for Preventing Multiple Rentals of the Same Book**: The trigger `trg_no_duplicate_rent` ensures that a user cannot rent the same book multiple times if they have already rented it.
  * **Subscription Status Update**: A trigger is also used to log updates to subscription statuses after books are returned.

* **Functions**: Functions are used to handle specific tasks, such as retrieving the image associated with each book based on its name. This allows dynamic and efficient display of book details.

### How It Works

* **Book Rentals**: When a user wants to rent a book, the system checks if the book is available by looking at the `books` table and checking the `available` status. If the user has a valid rental card, the procedure `sub` is called, and the book is marked as rented.
* **Book Returns**: After a book is returned, the system uses the `ret` stored procedure to update the status of the book and calculate any overdue fines.
* **Triggers**: A trigger ensures that a user cannot rent a book they have already rented without returning it first, enforcing business rules directly within the database.

### Database Structure

The database consists of four main tables:

1. **lib**: Stores information about the library books.

   * `bookname`
   * `author`
   * `publication`
   * `noofcopies`

2. **customer**: Stores information about library customers.

   * `rollno`
   * `name`
   * `no_card`

3. **books**: Stores information about the copies of each book.

   * `bookno`
   * `bookname`
   * `available`
   * `subscribed_to`

4. **subscription**: Manages the relationships between books and customers.

   * `bookno`
   * `rollno`
   * `do_sub` (Date of rental)
   * `do_return` (Date of return)
   * `fineamount`
   * `status` (Rented/Returned)

### PL/SQL Features Used

1. **Stored Procedures**:

   * `sub`: Handles the logic for renting a book, including checking for available rental cards and updating the `subscription` and `books` tables.
   * `ret`: Handles book returns, updating the `subscription` and `books` tables and calculating any applicable fines for overdue returns.

2. **Triggers**:

   * `trg_no_duplicate_rent`: Prevents a user from renting the same book more than once without returning it.
   * A trigger is also used to log any updates to the subscription status whenever a book is returned.

3. **Functions**:

   * A function is used to dynamically generate the correct image path for each book based on its name, which is displayed on the user interface.

### Installation

1. **Database Setup**:

   * Ensure you have access to an Oracle Database.
   * Create the necessary tables and triggers using the provided SQL scripts.
   * Populate the tables with sample data.

2. **Backend Setup**:

   * Ensure your PHP environment has the necessary configurations to interact with Oracle Database (`OCI8` extension in PHP).

3. **Frontend Setup**:

   * The front-end is a simple HTML and PHP interface that allows users to interact with the system.

4. **Testing**:

   * Access the system via a web browser.
   * Log in with a valid customer roll number.
   * Test renting and returning books, and ensure that the system updates correctly.

### Conclusion

This **Library Management System** leverages the power of **PL/SQL** to create a strong and efficient backend system for managing books, rentals, and returns. The use of **stored procedures**, **triggers**, and **functions** ensures that the system is both robust and efficient, automating many library tasks and reducing manual work.
