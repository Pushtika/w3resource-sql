USE Movie
GO

/*
1. From the movie table, write a query to find the name and year of the movies. Return movie title, movie release year.
*/
SELECT mov_title, mov_year
FROM movie

/*
2. From the movie table, write a query to find when the movie 'American Beauty' released. Return movie release year.
*/
SELECT mov_year
FROM movie
WHERE mov_title = 'American Beauty'

/*
3. From the movie table, write a query to find the movie that was released in 1999. Return movie title.
*/
SELECT mov_title
FROM movie
WHERE mov_year = 1999

/*
4. From the movie table, write a query to find those movies, which were released before 1998. Return movie title.
*/
SELECT mov_title
FROM movie 
WHERE mov_year < 1998

/*
5. From the movie and reviewer tables, write a query to find the name of all reviewers and movies together in a single list.
*/
SELECT rev_name AS [name]
FROM reviewer
UNION
SELECT mov_title
FROM movie

/*
6. From the reviewer table, write a query to find all reviewers who have rated seven or more stars to their rating. Return reviewer name.
*/
SELECT rev_name
FROM reviewer
INNER JOIN rating
ON reviewer.rev_id = rating.rev_id
WHERE rating.rev_stars >= 7
AND reviewer.rev_name IS NOT NULL

/*
7. From the movie and rating tables, write a query to find the movies without any rating. Return movie title.
*/
SELECT mov_title
FROM movie
WHERE mov_id not in (select mov_id from rating)

/*
8. From the movie table, write a query to find the movies with ID 905 or 907 or 917. Return movie title.
*/
SELECT mov_title
FROM movie
WHERE mov_id in (905, 907, 917)

/*
9. From the movie table, write a query to find the movie titles that contain the word 'Boogie Nights'. Sort the result-set in ascending order by movie year.
Return movie ID, movie title and movie release year.
*/
SELECT mov_id, mov_title, mov_year
FROM movie
WHERE mov_title LIKE '%Boogie Nights%'
ORDER BY mov_year

/*
10. From the actor table, write a query to find those actors with the first name 'Woody' and the last name 'Allen'. Return actor ID.
*/
SELECT act_id
FROM actor
WHERE act_fname = 'Woody'
AND act_lname = 'Allen'
