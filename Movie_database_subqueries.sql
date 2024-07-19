USE Movie
GO

/*
1. From the actor table, write a query to find the actors who played a role in the movie 'Annie Hall'. Return all the fields of actor table.
*/
SELECT act_id, act_fname, act_lname, act_gender
FROM actor
WHERE act_id in (SELECT act_id
				 FROM movie_cast
				 WHERE mov_id in (SELECT mov_id 
								  FROM movie 
								  WHERE mov_title = 'Annie Hall')
				);

/*
2. From the director, movie_direction, movie_cast and movie tables, write a query to find the director of a film that cast a role in 'Eyes Wide Shut'.
Return the director first name, last name.
*/
SELECT dir_fname, dir_lname
FROM director
WHERE dir_id in (SELECT dir_id
				 FROM movie_direction
				 WHERE	mov_id IN (SELECT mov_id
								   FROM movie_cast
								   WHERE mov_id IN (SELECT mov_id
													FROM movie
													WHERE mov_title = 'Eyes Wide Shut')
									)
				 );

/*
3. From the movie table, write a query to find those movies that have been released in countries other than the United Kingdom.
Return the movie title, movie year, movie time, and date of release, releasing country.
*/
-- Simple Query
SELECT mov_title, mov_year, mov_time, mov_dt_rel, mov_rel_country
FROM movie
WHERE mov_rel_country <> 'UK'

-- Sub query
SELECT mov_title, mov_year, mov_time, mov_dt_rel, mov_rel_country
FROM movie m
WHERE NOT EXISTS (SELECT 1
				  FROM movie
				  WHERE mov_rel_country = 'UK'
				  AND mov_id = m.mov_id)

/*
4. From the movie, actor, director, movie_direction, movie_cast, reviewer and rating tables, write a query to find for movies whose reviewer is unknown.
Return movie title, year, release date, director first name, last name, actor first name, last name.
*/
SELECT m.mov_title, m.mov_year, m.mov_dt_rel, d.dir_fname, d.dir_lname, a.act_fname, a.act_lname
FROM movie m
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
INNER JOIN director d
ON d.dir_id = md.dir_id
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON mc.act_id = a.act_id
INNER JOIN rating ra
ON ra.mov_id = m.mov_id
INNER JOIN reviewer re
ON ra.rev_id = re.rev_id
WHERE re.rev_name IS NULL;

/*
5. From the movie, director and movie_direction tables, write a query to find those movies directed by the director whose first name is Woody and last name is Allen.
Return movie title.
*/
SELECT mov_title
FROM movie
WHERE mov_id IN (SELECT mov_id
				 FROM movie_direction
				 WHERE dir_id = ( SELECT dir_id
								  FROM director
								  WHERE dir_fname = 'Woody'
								  AND dir_lname = 'Allen')
				 );

/*
6. From the movie and rating tables, write a query to determine those years in which there was at least one movie that received a rating of at least three stars.
Sort the result-set in ascending order by movie year. Return movie year.
*/
SELECT DISTINCT mov_year
FROM movie
WHERE mov_id in (SELECT mov_id
				 FROM rating
				 WHERE rev_stars >= 3)
ORDER BY mov_year

/*
7. From the movie and rating tables, write a query to search for movies that do not have any ratings. Return movie title.
*/
SELECT mov_title
FROM movie
WHERE mov_id not in (select mov_id from rating)

/*
8. From the reviewer and rating tables, write a query to find those reviewers who have not given a rating to certain films. Return reviewer name.
*/
SELECT rev_name
FROM reviewer r
WHERE EXISTS (SELECT 1 
				  FROM rating
				  WHERE rev_id = r.rev_id
				  AND rev_stars IS NULL);

/*
9. From the reviewer, rating and movie tables, write a query to find movies that have been reviewed by a reviewer and received a rating. Sort the result-set in
ascending order by reviewer name, movie title, review stars. Return reviewer name, movie title, review stars.
*/
-- Using inner join
SELECT re.rev_name, m.mov_title, r.rev_stars
FROM reviewer re
INNER JOIN rating r
ON re.rev_id = r.rev_id
INNER JOIN movie m
ON m.mov_id = r.mov_id
WHERE r.rev_stars IS NOT NULL
AND re.rev_name IS NOT NULL
ORDER BY re.rev_name, m.mov_title, r.rev_stars

-- Using subqueries
SELECT re.rev_name, m.mov_title, r.rev_stars
FROM reviewer re
INNER JOIN rating r ON re.rev_id = r.rev_id
INNER JOIN movie m ON m.mov_id = r.mov_id
WHERE EXISTS (
    SELECT 1
    FROM rating r2
    WHERE r2.mov_id = m.mov_id
    AND r2.rev_id = re.rev_id
    AND r2.rev_stars IS NOT NULL
)
AND re.rev_name IS NOT NULL
ORDER BY re.rev_name, m.mov_title, r.rev_stars;

-- Solution given
SELECT r.rev_name, m.mov_title, ra.rev_stars 
FROM (
    SELECT * 
    FROM reviewer 
    WHERE rev_name IS NOT NULL
) r
JOIN (
    SELECT * 
    FROM rating 
    WHERE rev_stars IS NOT NULL
) ra ON r.rev_id = ra.rev_id
JOIN movie m ON m.mov_id = ra.mov_id
ORDER BY r.rev_name, m.mov_title, ra.rev_stars;

/*
10. From the reviewer, rating and movie tables, write a query to find movies that have been reviewed by a reviewer and received a rating. Group the result set on
reviewer's name, movie title. Return reviewer's name, movie title.
*/
SELECT re.rev_name, m.mov_title
FROM reviewer re
INNER JOIN rating r
ON re.rev_id = r.rev_id
INNER JOIN movie m
ON r.mov_id = m.mov_id
INNER JOIN rating ra
ON ra.rev_id = r.rev_id
GROUP BY re.rev_name, m.mov_title
HAVING COUNT(*) > 1

/*
11. From the rating, movie tables, write a query to find those movies, which have received highest number of stars. Group the result set on movie title and sort
the result set in ascending order by movie title. Return movie title and maximum number of review stars.
*/
SELECT m.mov_title, MAX(r.rev_stars) AS [max]
FROM movie m
INNER JOIN rating r 
ON r.mov_id = m.mov_id
WHERE r.rev_stars IS NOT NULL
GROUP BY m.mov_title
ORDER BY m.mov_title

/*
12. From the reviewer, rating and movie tables, write a query to find all reviewers who rated the movie 'American Beauty'. Return reviewer name.
*/
SELECT re.rev_name
FROM reviewer re
WHERE EXISTS ( SELECT 1 
			   FROM rating 
			   WHERE re.rev_id = rev_id
			   AND mov_id IN (SELECT mov_id
							  FROM movie
							  WHERE mov_title = 'American Beauty')
			  );

/*
13. From the reviewer, rating and movie tables, write a query to find the movies that have not been reviewed by any reviewer body other than 'Paul Monks'.
Return movie title.
*/
SELECT m.mov_title
FROM movie m
INNER JOIN rating r
ON m.mov_id = r.mov_id
WHERE r.rev_id NOT IN (SELECT rev_id
					   FROM reviewer 
					   WHERE rev_name = 'Paul Monks');

/*
14. From the reviewer, rating and movie tables, write a query to find the movies with the lowest ratings. Return reviewer name, movie title, and number of stars
for those movies.
*/
SELECT re.rev_name, m.mov_title, r.rev_stars
FROM reviewer re
INNER JOIN rating r
ON re.rev_id = r.rev_id
INNER JOIN movie m
ON r.mov_id = m.mov_id
WHERE r.rev_stars = (SELECT MIN(rev_stars) FROM rating)

/*
15. From the director, movie_direction and movie tables, write a query to find the movies directed by 'James Cameron'. Return movie title.
*/
SELECT m.mov_title
FROM movie m
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
WHERE md.dir_id = (SELECT dir_id 
				   FROM director
				   WHERE dir_fname = 'James'
				   AND dir_lname = 'Cameron');

/*
16. Write a query to find the movies in which one or more actors appeared in more than one film.
*/
SELECT m.mov_title
FROM movie m
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON a.act_id = mc.act_id
WHERE a.act_id IN ( SELECT act_id
					FROM movie_cast
					GROUP BY act_id
					HAVING COUNT(act_id) > 1);