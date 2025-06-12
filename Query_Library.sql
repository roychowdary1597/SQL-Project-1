create database if not exists Library_Mgmt;
use library_mgmt;

CREATE TABLE tbl_publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

Select * from tbl_publisher;

-- Table: tbl_book
CREATE TABLE tbl_book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES tbl_publisher(publisher_PublisherName)
);

Select * from tbl_book;

-- Table: tbl_book_authors
CREATE TABLE tbl_book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES tbl_book(book_BookID)
);

Select * from tbl_book_authors;

-- Table: tbl_library_branch
CREATE TABLE tbl_library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

select * from tbl_library_branch;

-- Table: tbl_book_copies
CREATE TABLE tbl_book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID)
);

select * from tbl_book_copies;


-- Table: tbl_borrower
CREATE TABLE tbl_borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

select * from tbl_borrower;

-- Table: tbl_book_loans
CREATE TABLE tbl_book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut varchar(255),
    book_loans_DueDate varchar(255),
    FOREIGN KEY (book_loans_BookID) REFERENCES tbl_book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES tbl_library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES tbl_borrower(borrower_CardNo)
);
select * from tbl_book_loans;

-- Task Questions
-- How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

SELECT 
    lbn.library_branch_BranchName AS Branch,
    count(tbc.book_copies_No_Of_Copies) AS Copies
FROM
    tbl_library_branch AS lbn
        INNER JOIN
    tbl_book_copies AS tbc ON lbn.library_branch_BranchID = tbc.book_copies_BranchID
        INNER JOIN
    tbl_book AS tb ON tb.book_BookID = tbc.book_copies_BookID
WHERE
    tb.book_Title = 'The Lost Tribe'
        AND lbn.library_branch_BranchName = 'Sharpstown'
GROUP BY library_branch_BranchName;


-- Answer is Sharpstown copies 10


-- Task Question 2
-- How many copies of the book titled "The Lost Tribe" are owned by each library branch?

SELECT 
    lbn.library_branch_BranchName AS Branch,
    sum(tbc.book_copies_No_Of_Copies) AS Copies
FROM
    tbl_library_branch AS lbn
        INNER JOIN
    tbl_book_copies AS tbc ON lbn.library_branch_BranchID = tbc.book_copies_BranchID
        INNER JOIN
    tbl_book AS tb ON tb.book_BookID = tbc.book_copies_BookID
WHERE
    book_Title = 'The Lost Tribe'
        -- AND lbn.library_branch_BranchName 
GROUP BY library_branch_BranchName;


-- Task 3
-- 3. Retrieve the names of all borrowers who do not have any books checked out.

Select bo.borrower_BorrowerName
			from tbl_borrower as bo
            where bo.borrower_CardNo not in (Select bl.book_loans_CardNo from tbl_book_loans as bl);
													
-- Task 4
/* For each book that is loaned out from the "Sharpstown" branch and whose
DueDate is 2/3/18, retrieve the book title, the borrower's name, and the
borrower's address. */

set sql_safe_updates = 0;
update tbl_book_loans set book_loans_DateOut = str_to_date(book_loans_DateOut,"%d-%m-%Y");

desc tbl_book_loans;

select * from tbl_book_loans;
select str_to_date(book_loans_DueDate,"%d-%m-%Y")as due_date from tbl_book_loans;
update tbl_book_loans set book_loans_DueDate =  str_to_date(book_loans_DueDate,"%d-%m-%Y");

set sql_safe_updates = 1;
/* For each book that is loaned out from the "Sharpstown" branch and whose
DueDate is 2/3/18, retrieve the book title, the borrower's name, and the
borrower's address. */
select * from tbl_borrower;
select * from tbl_book;
select * from tbl_book_loans;



select  tbn.borrower_BorrowerName,
	   tbn.borrower_BorrowerAddress,
       tbo.book_Title
       From tbl_borrower as tbn
       Inner Join tbl_book_loans as tbl
       on tbn.borrower_CardNo = tbl.book_loans_CardNo
			Inner join tbl_book as tbo
			on tbo.book_BookID = tbl.book_loans_BookID
				Inner join tbl_library_branch as tlb 
                on tlb.library_branch_BranchID = tlb.library_branch_BranchID
                Where tlb.library_branch_BranchName = 'Sharpstown'
                and tbl.book_loans_DueDate = '2018-03-02';

-- Task 5
-- For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
Select t1.library_branch_BranchName as Branch_Name, count(t2.book_loans_LoansID) as Books_Sanctioned
       from tbl_library_branch as t1
				inner join tbl_book_loans as t2
				on t2.book_loans_BranchID = t1.library_branch_BranchID
                Group by t1.library_branch_BranchName;
			
-- Task 6
-- Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books checked out.
Select t3.borrower_BorrowerName as `Name`,
	   t3.borrower_BorrowerAddress `Address`,
       count(*) as  Checked_Out
       From tbl_borrower as t3
       Inner join tbl_book_loans as t4
       on t3.borrower_CardNo = t4.book_loans_CardNo
       group by t3.borrower_BorrowerName,t3.borrower_BorrowerAddress,t3.borrower_CardNo
       Having count(*) > 5;
       
select * from tbl_book;
-- Task 7
-- For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
select t5.book_Title as Book_Title,t7.book_copies_No_Of_Copies as Copies
				from tbl_book as t5,tbl_book_authors as t6,tbl_book_copies as t7,tbl_library_branch as t8
                where t5.book_BookID = t6.book_authors_BookID = t7.book_copies_BookID AND t7.book_copies_BranchID = t8.library_branch_BranchID 
                and t6.book_authors_AuthorName = "Stephen King"   and t8.library_branch_BranchName = 'Central'
                group by t5.book_Title,t7.book_copies_No_Of_Copies;
                
Select t5.book_Title as Book_Title
				from tbl_book as t5
                
			  













