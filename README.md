# SQL-Project-1
# 📚 Library Management SQL Project

![SQL](https://img.shields.io/badge/SQL-MySQL-blue?style=flat-square)
![Status](https://img.shields.io/badge/Project-Complete-brightgreen?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-lightgrey?style=flat-square)

Welcome to the **Library Management SQL Project**! This project demonstrates the use of SQL to manage, analyze, and retrieve information from a relational database representing a library system. 🏛️✨

---

## 📁 Tables Used

- `tbl_book` 📖 – Contains book titles and IDs
- `tbl_book_copies` 📦 – Tracks how many copies of each book are in each branch
- `tbl_library_branch` 🏢 – Stores library branch information
- `tbl_book_loans` 🗓️ – Records which book was borrowed, by whom, and when
- `tbl_borrower` 👤 – Stores borrower details
- `tbl_book_authors` ✍️ – Associates books with their authors

---

## 🔍 Featured SQL Queries

Here are some key SQL queries included in the project:

### 📌 1. How many copies of *"The Lost Tribe"* are in **Sharpstown**?
```sql
SELECT 
    lbn.library_branch_BranchName AS Branch,
    SUM(tbc.book_copies_No_Of_Copies) AS Copies
FROM tbl_library_branch AS lbn
INNER JOIN tbl_book_copies AS tbc ON lbn.library_branch_BranchID = tbc.book_copies_BranchID
INNER JOIN tbl_book AS tb ON tb.book_BookID = tbc.book_copies_BookID
WHERE tb.book_Title = 'The Lost Tribe'
  AND lbn.library_branch_BranchName = 'Sharpstown'
GROUP BY lbn.library_branch_BranchName;
```

### 📌 2. Borrowers with more than 5 books checked out:
```sql
SELECT 
    t3.borrower_BorrowerName AS Name,
    t3.borrower_BorrowerAddress AS Address,
    COUNT(*) AS Checked_Out
FROM tbl_borrower AS t3
INNER JOIN tbl_book_loans AS t4 ON t3.borrower_CardNo = t4.book_loans_CardNo
GROUP BY t3.borrower_BorrowerName, t3.borrower_BorrowerAddress, t3.borrower_CardNo
HAVING COUNT(*) > 5;
```

### 📌 3. Books by *Stephen King* in the **Central** branch:
```sql
SELECT 
    t5.book_Title AS Book_Title,
    t7.book_copies_No_Of_Copies AS Copies
FROM tbl_book AS t5
JOIN tbl_book_authors AS t6 ON t5.book_BookID = t6.book_authors_BookID
JOIN tbl_book_copies AS t7 ON t5.book_BookID = t7.book_copies_BookID
JOIN tbl_library_branch AS t8 ON t7.book_copies_BranchID = t8.library_branch_BranchID
WHERE t6.book_authors_AuthorName = 'Stephen King'
  AND t8.library_branch_BranchName = 'Central'
GROUP BY t5.book_Title, t7.book_copies_No_Of_Copies;
```

---

## 📊 Outputs & Use Cases

✅ Branch-wise book distribution  
✅ High-frequency borrowers  
✅ Due-date-based tracking  
✅ Author-specific book availability  
✅ Branch-specific book counts

---

## 💻 Tools Used

- 🐬 MySQL
- 📋 SQL Joins, Aggregates, Subqueries
- 💡 Relational database concepts

---

## 🧑‍🎓 Author

**Rajiv Roy Chowdary Pudota**  
🎓 BE in ECE | 💡 Aspiring Data Scientist  
🔗 [LinkedIn](https://www.linkedin.com/in/rajiv-roy-chowdary-pudota/) 


---



## 🌟 Star this repository if you find it helpful!
