# Book Track Analysis
 
**Author:** Odongo Babra 
**Date:** 2025-01-9

--- 
 
## Project Background 
Book Track System is a library management system designed to efficiently manage and organize books, members, employees, and library branches. It keeps accurate records of book issues and returns, ensuring that all data is consistent and reliable. The system uses relational database design with primary and foreign keys, allowing tables to be connected through SQL joins for advanced analysis. With this, it can provide insights such as the most active employees, members who borrow the most books, the most popular books, and branch performance. By combining clean, structured data with powerful analysis, Book Track System helps libraries improve operations, make informed decisions, and deliver better services to their members.

--- 
 
## Project Objective 
i.	  Staff currently check overdue books manually, which is time-consuming, prone to errors, and allows members to keep books past the 30-day limit.
ii.	 When members return books, availability updates are delayed, creating bottlenecks at service desks and incorrect information for other members.
iii.	There are no standardized reports to track how each branch is performing, making it difficult to allocate resources or identify best practices.
iv.	 The system cannot distinguish between active and inactive members, leading to inefficient outreach and wasted marketing efforts.
v.	  Staff performance is mostly assessed subjectively, so top performers are not consistently recognized, affecting motivation and retention.
vi.	 The library experiences frequent book damage, but there’s no way to track which members are responsible, resulting in high replacement costs.
vii. Books are sometimes issued to multiple members because the system does not check real-time availability, causing errors and member frustration.




--- 
 
## Datasets 

**members.csv** -  This dataset contains member registration details with columns including member_id, member_name, member_address, and reg_date, supporting analysis of membership records, registration trends, and member distribution.

**branch.csv** - This dataset contains branch information with columns including branch_id, manager_id, branch_address, and contact_no, enabling analysis of branch structure, management assignments, and contact details across locations.

**books.csv** - This dataset contains book inventory details with columns including isbn, book_title, category, rental_price, status, author, and publisher, supporting analysis of catalog composition, pricing, availability, and author or publisher trends.

**employees.csv** - This dataset contains employee records with columns including emp_id, emp_name, position, salary, and branch_id, enabling analysis of staff roles, compensation structure, and employee distribution across branches.

**issued_status.csv** - This dataset contains book issuance records with columns including issued_id, issued_member_id, issued_book_name, issued_date, issued_book_isbn, and issued_emp_id, supporting analysis of borrowing activity, member engagement, book circulation, and staff involvement in the issuing process.

**return_status.csv** - This dataset contains book return records with columns including return_id, issued_id, return_book_name, return_date, return_book_isbn, and book_quality, enabling analysis of return activity, book condition tracking, and overall circulation management.


--- 
## Key Findings
1.	Branch B001 recorded the highest operational performance, with the greatest number of books issued and the highest revenue generated, while Branch B004 reported the lowest issuance and revenue levels, suggesting disparities in branch activity, customer traffic, or service efficiency.
2.	Employee performance data indicates that Justin Baker from Branch B005 processed the highest number of books, while most employees across branches processed between 11 and 15 books, reflecting relatively balanced workloads.
3.	Out of 4,017 registered members, only 420 members have recorded borrowing activity, while 3,597 members have never borrowed any books, demonstrating a significant engagement gap and underutilization of the library’s membership base.
4.	The issuance data indicates that most books are borrowed a limited number of times, with the majority of titles issued twice and only a few reaching three borrowings.
5.	The data shows that member C2567 (Jessica Velazouez) is the most active borrower, with 3 books borrowed, while the majority of members have borrowed 2 books, indicating fairly even borrowing behavior across members.
6.	Each member has only one damaged book return, showing that damage is currently isolated and not repeated.

--- 
## Recommendations 
1.	The library should implement targeted engagement initiatives such as reading challenges, loyalty rewards, and personalized book recommendations to encourage members to increase their borrowing frequency and make fuller use of available resources
2.	Management should analyze the operational practices, staffing levels, and customer outreach strategies used by high-performing branches such as Branch B001, and replicate these best practices at lower-performing branches to improve overall circulation and revenue.
3.	The library should recognize and reward high-performing employees to sustain motivation, while also providing additional training, process optimization, or support to staff in lower-performing branches to ensure consistent service quality across locations.
4.	The library should actively target inactive and first-time members through onboarding programs, awareness campaigns, and incentives such as free rentals or discounts to increase participation and convert registered members into regular borrowers.
5.	The library should use circulation data to refine collection management by increasing visibility of frequently borrowed titles, bundling similar books into thematic recommendations, and reassessing underperforming titles to ensure the catalog better reflects member preferences and reading trends.
6.	The library should introduce targeted engagement initiatives—such as member onboarding programs, borrowing incentives, and personalized outreach—to encourage inactive members to actively borrow books and increase overall participation.
7.	The library should monitor all damaged returns and remind members to handle books carefully to prevent future damage and reduce replacement costs.


 
--- 
 
## Tools & Techniques 
-	Aggregation and Analysis
-	Sorting, Joining and Filtering
-	Data cleaning and transformation in SQL
-	Derived Metrics 
-	Basic descriptive analytics and KPI design 
 
--- 
 
## Project Files (included) 
-	`Book Track Analysis.pdf` -boardroom slide deck(12 Slides)
-	`Library_records SQL Script` — boardroom slide deck (10–12 slides)   
-	`README.md` — this documentation 
-	`MP_SQL_Project_2` – The problem
 
--- 
 
## How to Run / View 
1.	Open `Library_records SQL Script ` in SQL (desktop recommended)   
2.	Open the SQL script file in your SQL editor.  
3.	Analysis was done entirely using SQL queries.
4.	View the results in the query output/results panel for each section of the analysis.
5.	Refer to `Book Track Analysis Presentation.pdf` for a summary of insights and recommended actions 
 
 

 
--- 
 
## Contact 
Babra Odongo
odongobabra5@gmail.com
https://www.linkedin.com/in/babra-odongo-047921268/
