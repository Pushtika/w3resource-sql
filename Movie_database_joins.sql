USE Movie
GO

/*
1. From the reviewer and rating tables, write a query to find all reviewers whose ratings contain a NULL value. Return reviewer name.
*/
SELECT re.rev_name
FROM reviewer re
INNER JOIN rating r
ON re.rev_id = r.rev_id
WHERE r.rev_stars IS NULL

/*
2. From the actor, movie_cast and movie tables, write a query to find out who was cast in the movie 'Annie Hall'. Return actor first name, last name and role.
*/
SELECT a.act_fname, a.act_lname, mc.[role]
FROM actor a
INNER JOIN movie_cast mc
ON a.act_id = mc.act_id
INNER JOIN movie m
ON mc.mov_id = m.mov_id
WHERE m.mov_title = 'Annie Hall'

/*
3. From the director, movie_direction, movie_cast and movie tables, write a query to find the director who directed a movie that featured a role in 'Eyes Wide Shut'.
Return director first name, last name and movie title.
*/
SELECT d.dir_fname, d.dir_lname, m.mov_title
FROM director d
INNER JOIN movie_direction md
ON d.dir_id = md.dir_id
INNER JOIN movie_cast mc
ON md.mov_id = mc.mov_id
INNER JOIN movie m
ON mc.mov_id = m.mov_id
WHERE m.mov_title = 'Eyes Wide Shut'

/*
4. From the director, movie_direction, movie_cast and movie tables, write a query to find the director of a movie that casta role as Sean Maguire. Return director 
first name, last name and movie title.
*/
SELECT d.dir_fname, d.dir_lname, m.mov_title
FROM director d
INNER JOIN movie_direction md
ON d.dir_id = md.dir_id
INNER JOIN movie_cast mc
ON md.mov_id = mc.mov_id
INNER JOIN movie m
ON mc.mov_id = m.mov_id
WHERE mc.[role] = 'Sean Maguire'

/*
5. From the actor, movie_cast and movie tables, write a query to find out which actors have not appeared in any movies between 1990 and 2000 (Begin and end values
are included). Return actor first name, last name, movie title and release year.
*/
SELECT a.act_fname, a.act_lname, m.mov_title, m.mov_year
FROM actor a
INNER JOIN movie_cast mc
ON a.act_id = mc.act_id
INNER JOIN movie m
ON mc.mov_id = m.mov_id
WHERE m.mov_year NOT BETWEEN 1990 and 2000

/*
6. From the director, movie_direction, genres and movie_genres tables, write a query to find the directors who have directed films in a variety of genres. Group the
result set on director first name, last name and generic title. Sort the result set in ascending order by director first name and last name. Return director first
name, last name and number of genres movies.
*/
SELECT d.dir_fname, d.dir_lname, g.gen_title, COUNT(g.gen_id) AS number_of_genres_movies
FROM director d
INNER JOIN movie_direction md
ON d.dir_id = md.dir_id
INNER JOIN movie_genres mg
ON md.mov_id = mg.mov_id
INNER JOIN genres g
ON mg.gen_id = g.gen_id
GROUP BY d.dir_fname, d.dir_lname, g.gen_title
--HAVING COUNT(g.gen_id) > 1
ORDER BY d.dir_fname, d.dir_lname

/*
7. From the movie, genres and movie_genres tables, write a query to find the movies with year and genres. Return movie title, movie year and generic title.
*/
SELECT m.mov_title, m.mov_year, g.gen_title
FROM movie m
INNER JOIN movie_genres mg
ON m.mov_id = mg.mov_id
INNER JOIN genres g
ON mg.gen_id = g.gen_id

/*
8. From the movie, genres, movie_genres, director and movie_direction tables, write a query to find all the movies with year, genres and name of the director.
*/
SELECT m.mov_title, m.mov_year, g.gen_title, d.dir_fname, d.dir_lname
FROM movie m
INNER JOIN movie_genres mg
ON m.mov_id = mg.mov_id
INNER JOIN genres g
ON mg.gen_id = g.gen_id
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
INNER JOIN director d
ON md.dir_id = d.dir_id

/*
9. From the movie, director and movie_direction tables, write a query to find the movies released before 1st January 1989. Sort the result set in descending order
by date of release. Return movie title, release year, date of release, duration, and first and last name of the director.
*/
SELECT m.mov_title, m.mov_year, m.mov_dt_rel, m.mov_time, d.dir_fname, d.dir_lname
FROM movie m
INNER JOIN movie_direction md
ON m.mov_id  = md.mov_id
INNER JOIN director d
ON md.dir_id = d.dir_id
WHERE m.mov_dt_rel < '01-01-1989'
ORDER BY m.mov_dt_rel desc

/*
10. From the movie, genres and movie_genres tables, write a query to calculate the average movie length and count the number of movies in each genre. Return genre 
title, average time and number of movies for each genre.
*/
SELECT g.gen_title, AVG(m.mov_time) AS avg_mov_time, COUNT(g.gen_id) AS gen_count
FROM genres g
INNER JOIN movie_genres mg
ON g.gen_id = mg.gen_id
INNER JOIN movie m
ON mg.mov_id = m.mov_id
GROUP BY g.gen_title

/*
11. From the movie, actor, director, movie_direction and movie_cast tables, write a query to find movies with the shortest duration. Return movie title, movie year,
director first name, last name, actor first name, last name and role.
*/
SELECT m.mov_title, m.mov_year, d.dir_fname, d.dir_lname, a.act_fname, a.act_lname, mc.[role]
FROM movie m
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
INNER JOIN director d
ON md.dir_id = d.dir_id
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON mc.act_id = a.act_id
WHERE m.mov_time = (SELECT MIN(mov_time) FROM movie)

/*
12. From the movie and rating tables, write a query to find the years in which a movie received a rating of 3 or 4. Sort the result in increasing order on movie 
year.
*/
SELECT DISTINCT m.mov_year
FROM movie m
INNER JOIN rating r
ON m.mov_id = r.mov_id
WHERE r.rev_stars in (3, 4)
ORDER BY m.mov_year

/*
13. From the movie, rating and reviewer tables, write a query to get the reviewer name, movie title, and stars in an order that reviewer name will come first, then
by movie title, and lastly by number of stars.
*/
SELECT re.rev_name, m.mov_title, r.rev_stars
FROM reviewer re
INNER JOIN rating r
ON re.rev_id = r.rev_id
INNER JOIN movie m
ON r.mov_id = m.mov_id
WHERE re.rev_name IS NOT NULL
ORDER BY re.rev_name, m.mov_title, r.rev_stars

/*
14. From the movie and rating tables, write a query to find those movies that have at least one rating and received the most stars. Sort the result set on movie
title. Return movie title and maximum review stars.
*/
SELECT m.mov_title, MAX(r.rev_stars) AS max_review_stars
FROM movie m
INNER JOIN rating r
ON m.mov_id = r.mov_id
GROUP BY m.mov_title
HAVING MAX(r.rev_stars) > 0
ORDER BY m.mov_title

/*
15. From the movie, rating, movie_direction and director tables, write a query to find out which movies have received ratings. Return movie title, director first
name, director last name and review stars.
*/
SELECT m.mov_title, d.dir_fname, d.dir_lname, r.rev_stars
FROM movie m
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
INNER JOIN director d
ON md.dir_id = d.dir_id
LEFT JOIN rating r
ON m.mov_id = r.mov_id
WHERE m.mov_id IN (SELECT mov_id FROM rating WHERE rev_stars IS NOT NULL)

/*
16. From the movie, movie_cast and actor tables, write a query to find movies in which one or more actors have acted in more than one film. Return movie title,
actor first and last name, and the role.
*/
SELECT mov_title, act_fname, act_lname, [role]
FROM movie m
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON mc.act_id = a.act_id
WHERE EXISTS( SELECT 1
			  FROM movie_cast mc2
			  WHERE mc2.act_id = a.act_id
			  GROUP BY mc2.act_id
			  HAVING COUNT(*) >= 2
			);

/*
17. From the movie, movie_cast, actor, director and movie_direction tables, write a query to find the actor whose first name is 'Claire' and last name is 'Danes'.
Return director first name, last name, movie title, actor first name and last name, role.
*/
SELECT d.dir_fname, d.dir_lname, m.mov_title, a.act_fname, a.act_lname, mc.[role]
FROM director d
INNER JOIN movie_direction md
ON d.dir_id = md.dir_id
INNER JOIN movie m
ON md.mov_id = m.mov_id
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON mc.act_id = a.act_id
WHERE a.act_fname = 'Claire'
AND a.act_lname = 'Danes'

/*
18. From the movie, movie_cast, actor, director and movie_direction tables, write a query to find for actors whose films have been directed by them. Return actor
first name, last name, movie title and role.
*/
SELECT a.act_fname, a.act_lname, m.mov_title, mc.[role]
FROM actor a
INNER JOIN movie_cast mc
ON a.act_id = mc.act_id
INNER JOIN movie m
ON mc.mov_id = m.mov_id
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
INNER JOIN director d
ON md.dir_id = d.dir_id
WHERE a.act_fname = d.dir_fname 
AND a.act_lname = d.dir_lname

/*
19. From the movie, movie_cast and actor tables, write a query to find the cast list of the movie 'Chinatown'. Return first name, last name.
*/
SELECT act_fname, act_lname
FROM actor a
INNER JOIN movie_cast mc
ON a.act_id = mc.act_id
INNER JOIN movie m
ON mc.mov_id = m.mov_id
WHERE m.mov_title = 'Chinatown'

/*
20. From the movie, movie_cast and actor tables, write a query to find those movies where actor's first name is 'Harrison' and last name is 'Ford'. Return movie 
title.
*/
SELECT mov_title
FROM movie m
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON a.act_id = mc.act_id
WHERE a.act_fname = 'Harrison'
AND a.act_lname = 'Ford'

/*
21. From the movie and rating tables, write a query to find the highest-rated movies. Return movie title, movie year, review stars and releasing country.
*/
SELECT mov_title, mov_year, rev_stars, mov_rel_country
FROM movie m
INNER JOIN rating r
ON m.mov_id = r.mov_id
WHERE r.rev_stars = (SELECT MAX(rev_stars) FROM rating)

/*
22. From the movie, genres, movie_genres and rating tables, write a query to find the highest-rated 'Mystery Movies'. Return the title, year, and rating.
*/
SELECT mov_title, mov_year, rev_stars
FROM movie m
INNER JOIN movie_genres mg
ON m.mov_id = mg.mov_id
INNER JOIN genres g
ON mg.gen_id = g.gen_id
INNER JOIN rating r
ON m.mov_id = r.mov_id
WHERE g.gen_title = 'Mystery'
AND r.rev_stars >= ALL(SELECT rev_stars
					FROM rating r
					INNER JOIN movie_genres mg
					ON r.mov_id = mg.mov_id
					INNER JOIN genres g
					ON mg.gen_id = g.gen_id
					WHERE g.gen_title = 'Mystery')

/*
23. From the movie, genres, movie_genres and rating tables, write a query to find the years when most of the 'Mystery Movies' produced. Count the number of generic
title and compute their average rating. Group the result set on movie release year, generic title. Return movie year, generic title, number of generic title
and average rating.
*/
SELECT mov_year, gen_title, COUNT(gen_title) AS count_gen_title, AVG(rev_stars) AS avg_rating
FROM movie m
INNER JOIN movie_genres mg
ON m.mov_id = mg.mov_id
INNER JOIN genres g
ON mg.gen_id = g.gen_id
INNER JOIN rating r
ON m.mov_id = r.mov_id
WHERE gen_title = 'Mystery'
GROUP BY mov_year, gen_title

/*
24. From the movie, genres, movie_genres, rating, actor, director, movie_direction and movie_cast tables, write a query to generate a report which contains the fields
movie title, name of the female actor, year of the movie, role, movie genres, the director, date of release, and rating of that movie.
*/
SELECT mov_title, act_fname, act_lname, mov_year, [role], gen_title, dir_fname, dir_lname, mov_dt_rel, rev_stars
FROM movie m
INNER JOIN movie_cast mc
ON m.mov_id = mc.mov_id
INNER JOIN actor a
ON mc.act_id = a.act_id
INNER JOIN movie_genres mg
ON m.mov_id = mg.mov_id
INNER JOIN genres g
ON mg.gen_id = g.gen_id
INNER JOIN movie_direction md
ON m.mov_id = md.mov_id
INNER JOIN director d
ON md.dir_id = d.dir_id
INNER JOIN rating r
ON m.mov_id = r.mov_id
WHERE a.act_gender = 'F'
