select * FROM borrowedbooks2;
-- List all books published before the year 2000.

select * 
FROM book
WHERE PublishedYear < '2000';

-- Find all members who joined in 2023.

select *
FROM members
where JoinDate LIKE '%2023';

-- Joins:
-- Display the names of members and the titles of the books they borrowed.

select members.Name, book.Title
 from borrowedbooks2 
 join book on book.BookID = borrowedbooks2.BookID
 join members on members.MemberID = borrowedbooks2.MemberID
 ;

-- Identify members who borrowed science books.

select members.Name, book.Title
 from borrowedbooks2 
 join book on book.BookID = borrowedbooks2.BookID
 join members on members.MemberID = borrowedbooks2.MemberID
  where book.Genre = "Science" ;


-- Aggregate Functions:
-- Count how many books are borrowed but not yet returned.

select count(*) as BooknotReturned
from borrowedbooks2
where ReturnDate is  null;

-- Find the total number of books borrowed in October 2023.

select count(*) 
from borrowedbooks2
where BorrowDate between '2023-10-01' and '2023-10-31';


-- Subqueries:
-- List the books that were never borrowed.

-- 1
select title from book
where BookID not in (
select distinct BookID
from borrowedbooks2); 

-- 2
select book.title
from book
left join borrowedbooks2 on book.BookID = borrowedbooks2.BookID
where borrowedbooks2.BookID is null;

-- Find members who borrowed more than one book.

select name from members
where MemberID  in (
select BookID
from borrowedbooks2) > 1; 


-- Advanced Queries:
-- Identify the member who borrowed the most books.

select members.Name, count(borrowedbooks2.BookID) as TotalBook
from borrowedbooks2
join members on borrowedbooks2.MemberID = members.MemberID
group by members.MemberID, members.name
order by TotalBook desc
limit 1;



-- Show a report of books borrowed along with the number of days they were borrowed for.




-- Data Modification:
-- Add a new book to the "Books" table and assign a genre.

insert into book (BookID,Title,Author,Genre,PublishedYear)
value(6,'GameOfThrone','GRR_Martin','Fntacy',1998);

delete from
book where BookId = '6';

-- Update the return date for a book that was recently returned.

update borrowedbooks2
set ReturnDate = '2023-11-15'
WHERE BorrowID = 3



