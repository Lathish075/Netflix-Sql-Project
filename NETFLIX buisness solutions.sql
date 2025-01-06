
SELECT * FROM netflix 


select count(*) as totalcontent from netflix  --for identifying total content in database

select distinct(type) from netflix           --for identifying the different type of content

select distinct(country) from netflix





-- 12 BUISNESS PROBLEMS --


-- 1. Count the number of Movies vs TV Shows --

    SELECT type,
    COUNT(*) FROM netflix	 
    group by 1



-- 2. Find the most common rating for movies and TV shows --

  WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating ),
    
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;



-- 3. List all movies released in a specific year (e.g., 2021)

 select title as movies_in_2021 from netflix
 where release_year=2021



-- 4. Find the top 5 countries with the most content on Netflix --

SELECT * FROM
(
SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
       COUNT(show_id) AS total_content
       from netflix
        GROUP BY 1
) as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5


--5. Identify the longest movie--

SELECT type , title , duration FROM netflix
WHERE duration IS NOT NULL 
AND type = 'Movie' 
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC 



--6. Find content added in the last 5 years--

select title, date_added from netflix
where TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


	


--7. Count the number of content items in each genre--

SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
COUNT(show_id) AS total_content from netflix
GROUP BY 1
order by total_content DESC



--8. Find each year and the average numbers of content release by India on netflix
  --and also return top 5 year with highest avg content release !

SELECT country, release_year,
COUNT(show_id) as total_release,
ROUND(COUNT(show_id)::numeric/(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 ,2)
as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release desc
LIMIT 5



--9. Find the top 10 actors who have appeared in the highest number of from India.

SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) as actor, COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--10. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;