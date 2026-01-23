/*
  Expensive Service Analysis (Intermediate Tesla SQL FAANG)

  Write a query to identify vehicles with total service costs above the average across all vehicles, including a flag for high-capacity batteries (above 90 kWh).
  
  Table: tesla_vehicles
  ColumnName		Datatype
  vin				VARCHAR
  customer_id		INT
  model			VARCHAR
  manufacture_date DATE
  battery_capacity DECIMAL
  color			VARCHAR
  status			VARCHAR

  Table: tesla_service_records
  ColumnName		Datatype
  service_id 		INT 
  vin 			VARCHAR
  service_date 	DATE 
  description 	TEXT 
  cost 			DECIMAL
  technician_id 	INT
*/

WITH vehicle_stats AS (
  SELECT
    v.vin,
    v.model,
    SUM(sr.cost) AS total_service_cost,
    (
      CASE
        WHEN v.battery_capacity <= 90 THEN 'Standard Capacity'
        ELSE 'High Capacity'
      END
    ) AS battery_status
  FROM tesla_vehicles AS v JOIN tesla_service_records AS sr
  USING(vin)
  GROUP BY 1
),
average_cost AS (
  SELECT
    AVG(total_service_cost) AS avg_service_cost
  FROM vehicle_stats
)

SELECT
  s.vin,
  s.model,
  s.total_service_cost,
  ROUND(c.avg_service_cost, 2) AS avg_service_cost,
  s.battery_status
FROM vehicle_stats s CROSS JOIN average_cost c
WHERE s.total_service_cost > c.avg_service_cost
-- Note: This is a rare use case where cross join is useful.
-- There was no other way to add the overall average alongside the service cost.
-- Be very careful with cross joins, as they exponentially expand the result set.
-- If you cross join two tables with 1000 rows, it will result in a table with 1,000,000 rows.
-- Here we cross joined a table with 1 row (the overall average) with a table with n rows, resulting in n rows.

/*
  Top Listeners of Each Genre (Advanced Spotify SQL FAANG)

  For countries that have more than 3 registered users, find the top 3 users (by total plays) in each genre.
  Account for ties using RANK(), so more than 3 users may appear per genre.
  Order the results by genre and rank.

  Output: genre, user_id, username, country, total_plays, rnk

  Table: spotify_listens
  ColumnName		  Datatype
  listen_id         INT
  user_id 	      INT
  song_id 	   	  INT
  listen_date 	  DATE

  Table: spotify_tracks
  ColumnName		  Datatype
  song_id           INT
  title 			  VARCHAR
  album_id          INT
  duration_seconds  INT
  explicit 	      BOOLEAN

  Table: spotify_albums
  ColumnName		  Datatype
  album_id          INT
  artist_id 	      INT
  album_name 	   	  VARCHAR
  release_date 	  DATE

  Table: spotify_artists
  ColumnName		  Datatype
  artist_id         INT
  artist_name       VARCHAR
  genre             VARCHAR
  country           VARCHAR

  Table: spotify_users
  ColumnName		  Datatype
  user_id           INT
  username 		  VARCHAR
  country           VARCHAR
  signup_date       DATE
*/

WITH stage_1 AS (
  SELECT
    artists.genre,
    listens.user_id,
    COUNT(listens.listen_id) AS total_plays
  FROM spotify_listens AS listens JOIN spotify_tracks AS tracks
  USING(song_id) JOIN spotify_albums AS albums
  USING(album_id) JOIN spotify_artists AS artists
  USING(artist_id)
  GROUP BY 1,2
),
stage_2 AS (
  SELECT
    genre,
    u.user_id,
    u.username,
    u.country,
    s.total_plays,
    RANK() OVER (PARTITION BY genre ORDER BY total_plays DESC) AS rnk
  FROM stage_1 AS s JOIN spotify_users AS u
  USING(user_id)
  WHERE u.country IN (
    SELECT
      country
    FROM spotify_users
    GROUP BY country
    HAVING COUNT(u.user_id) > 3
  )
)

SELECT * FROM stage_2 WHERE rnk <= 3;
-- We needed all of the joins here because the relationship between listening records and artist records is complicated.
-- Grouping by users and genre, then counting the number of listens gives you the total listens for that user for that genre.
-- Only grouping by user would give total listens for that user across all genres.
-- The subquery could have been a CTE, but it's fairly short and straightforward. You would join that CTE on user_id.
-- We couldn't perform the ranking and filter based on that ranking in the same query because of order of operations.
-- For statements like "find the top 3 users (by total plays) in each genre", further break it down into logical steps:
--    First, we found the total plays per genre for all users, then we ranked the users based on that and found the top 3.
--    The statement asks you to find the top total_plays per user in each genre, that's the signal indicating you'd need to group using more than 1 parameter.
