--1. How many users have joined Yelp each year since 2010?
SELECT EXTRACT(YEAR FROM JoinDateTime) AS JoinYear, COUNT(*) AS NumUsers
FROM Users
WHERE EXTRACT(YEAR FROM JoinDateTime) >= 2010
GROUP BY JoinYear
ORDER BY JoinYear;

--2. How many users were elite in each of the 10 years from 2012 through 2021? Does it look like the number of elite users is increasing, decreasing,
--or staying about the same?
SELECT Year, COUNT(*) AS NumEliteUsers
FROM (
    SELECT UserID,Year
    FROM UserEliteYears
    WHERE Year BETWEEN 2012 AND 2021
    GROUP BY UserID, Year
) AS EliteYears
GROUP BY Year
ORDER BY Year;
--(OR)
SELECT Year, COUNT(*) AS NumEliteUsers
FROM UserEliteYears
WHERE Year BETWEEN 2012 and 2021
GROUP BY Year
ORDER BY Year;

--3.Which of our users has the most 5-star reviews of all time? Give us the person’s name, when they joined Yelp, how many fans they have, how
--many funny, useful, and cool ratings they’ve gotten. Please also gives us 3-5 examples of recent 5-star reviews they have written.
SELECT u.name, u.JoinDateTime, u.NumFans,
  COUNT(CASE WHEN r.userrating = 5 THEN 1 END) AS five_star_reviews,
  SUM(r.usefulvotes) AS useful_votes,
  SUM(r.funnyvotes) AS funny_votes,
  SUM(r.coolvotes) AS cool_votes,
  STRING_AGG(r.reviewtext, ':')
FROM users u
JOIN reviews r ON u.userid = r.userid
GROUP BY u.name, u.JoinDateTime, u.NumFans
ORDER BY five_star_reviews DESC
LIMIT 5;

--4.We are wondering if there is any relationship between a business’s hours of operation and the reviews they receive. Can you give us a
--spreadsheet giving the following information for every business we have in our database: business id, business category, and total hours of
--operation per week (i.e., the total number of hours each business is open across the entire week).
SELECT b.BusinessID, bc.CategoryName,
       SUM(EXTRACT(HOUR FROM ClosingTime) - EXTRACT(HOUR FROM OpeningTime)) AS TotalHoursPerWeek
FROM Businesses b
INNER JOIN BusinessCategories bc ON b.BusinessID = bc.BusinessID
INNER JOIN BusinessHours bh ON b.BusinessID = bh.BusinessID
GROUP BY b.BusinessID, bc.CategoryName
LIMIT 10;

--5.Which US states have the most businesses in our database? Give us the top 10 states.
SELECT State, COUNT(*) AS NumBusinesses
FROM Businesses
GROUP BY State
ORDER BY NumBusinesses DESC
LIMIT 10;

--6.What are our top ten business categories? In other words, which 10 categories have the most businesses assigned to them?
SELECT CategoryName, COUNT(*) AS NumBusinesses
FROM BusinessCategories
GROUP BY CategoryName
ORDER BY NumBusinesses DESC
LIMIT 10;

--7.What is the average rating of the businesses in each of those top ten categories?
SELECT bc.CategoryName, AVG(b.AvgReviews) AS AverageRating
FROM Businesses b
INNER JOIN BusinessCategories bc ON b.BusinessID = bc.BusinessID
WHERE bc.CategoryName IN (SELECT CategoryName FROM BusinessCategories GROUP BY CategoryName ORDER BY COUNT(*) DESC LIMIT 10)
GROUP BY bc.CategoryName
ORDER BY AVG(b.AvgReviews) DESC;

--8.We’re wondering what makes users tag a Restaurant review as “funny”. Can you give us 5 examples of the funniest Restaurant reviews and 5
--examples of the least funny? We’d also like you to look at a larger set of funny and unfunny reviews and tell us if you see any words or phrases
--that are commonly found in the funniest reviews. (We know the last part is qualitative but tell us anything you see that may be useful.)
-- Examples of funniest Restaurant reviews
SELECT bc.categoryname,r.FunnyVotes, r.reviewtext
FROM reviews r
JOIN businesscategories bc ON r.businessid = bc.businessid
WHERE bc.categoryname = 'Restaurants' AND r.funnyvotes >= 1
ORDER BY r.funnyvotes DESC
LIMIT 5;

-- Examples of least funny Restaurant reviews
SELECT bc.categoryname,r.FunnyVotes, r.reviewtext
FROM reviews r
JOIN businesscategories bc ON r.businessid = bc.businessid
WHERE bc.categoryname = 'Restaurants' AND r.funnyvotes >= 1
ORDER BY r.funnyvotes ASC
LIMIT 5;

--9.We think the compliments that tips receive are mostly based on how long the tip is. Can you compare the average length of the tip text for the
--100 most-complimented tips with the average length of the 100 least-complimented tips and tell us if that seems to be true? (Hint: you will need
--to use computed properties to answer this question)

SELECT 
    (SELECT AVG(LENGTH(TipText)) 
     FROM (SELECT TipText FROM Tips ORDER BY NumCompliments DESC LIMIT 100)
    ) AS AvgLengthMostComplimented,
    (SELECT AVG(LENGTH(TipText)) 
     FROM (SELECT TipText FROM Tips WHERE NumCompliments > 0 ORDER BY NumCompliments ASC, TipDateTime DESC LIMIT 100)
    ) AS AvgLengthLeastComplimented;
	


--10.We are trying to figure out whether restaurant reviews are driven mostly by price range, how many hours the restaurant is open, or the days they
--are open. Can you please give us a spreadsheet with the data we need to answer that question? (Note from Professor Augustyn: You don’t
--actually have to hand in a spreadsheet...just give me a table with 10 rows of sample data returned by your query.)
SELECT businessid, categoryname, Usefulvotes, Funnyvotes, Coolvotes, num_of_hours_open, UserRating, ReviewText
FROM (
    SELECT 
        r.businessid, bc.categoryname,
        SUM(r.Usefulvotes) AS Usefulvotes,
        SUM(r.Funnyvotes) AS Funnyvotes,
        SUM(r.Coolvotes) AS Coolvotes,
	    SUM(EXTRACT(EPOCH FROM (bh.ClosingTime - bh.OpeningTime))/3600) AS num_of_hours_open,
	    AVG(r.UserRating) AS UserRating, ARRAY_AGG(r.ReviewText) AS ReviewText,
        MAX(r.ReviewDatetime) AS ReviewDatetime
    FROM reviews r
    JOIN businesscategories bc ON r.businessid = bc.businessid
    JOIN businesshours bh ON r.businessid = bh.businessid
    WHERE bc.categoryname = 'Restaurants'
    GROUP BY r.businessid, bc.categoryname
) AS subquery
WHERE num_of_hours_open > 0
ORDER BY UserRating DESC, ReviewDatetime DESC
LIMIT 10;