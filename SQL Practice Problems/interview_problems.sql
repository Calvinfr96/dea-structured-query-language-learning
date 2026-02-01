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


/*
  Wrong Confirmations (Advanced SQL DE Interview Problem)

  Find the participants who were confirmed in overlapping meetings and also in at least two non-overlapping meetings, and return their participant ID along with the count of their overlapping meetings.
  Columns to Display: participant_id , overlapped_meeting_count

  Table: fact_participations_zoom
  meeting_id
  participant_id
  status

  Table: dim_meetings_zoom
  meeting_id
  organizer_id
  start_timestamp
  end_timestamp
*/

-- Find participants who were confirmed in overlapping meetings.
-- These participants should also be confirmed in >= 2 non-overlapping
-- meetings.
-- Display: participant_id , overlapped_meeting_count
-- Step 1: Get all confirmed meetings with start/end times for all participants.
-- Step 2: Identify every unique meeting_id that is involved in at least one overlap 
-- with another confirmed meeting for the same participant.
-- Step 3: Count the total unique meetings involved in an overlap per participant 
-- (This satisfies the first requirement, provided the participant has at least one
-- overlap).
-- Step 4: Identify participants with at least two meetings that are NOT involved
-- in any overlap.
-- Step 5: Final result - Join the two filtered lists to get participants who satisfy
-- BOTH conditions.

-- SELECT * FROM dim_meetings_zoom LIMIT 20;

WITH confirmed_meetings AS ( -- Step 1
    SELECT
        fpz.participant_id,
        dmz.meeting_id,
        dmz.start_timestamp,
        dmz.end_timestamp
    FROM dim_meetings_zoom dmz JOIN fact_participations_zoom fpz
    ON dmz.meeting_id = fpz.meeting_id
    WHERE fpz.status = 'Confirmed'
),
overlapping_meetings AS ( -- Step 2
    SELECT
        cm1.participant_id,
        cm1.meeting_id AS meeting_id_1,
        cm2.meeting_id AS meeting_id_2
    FROM confirmed_meetings cm1 JOIN confirmed_meetings cm2
    ON cm1.participant_id = cm2.participant_id
    AND cm1.meeting_id < cm2.meeting_id
    WHERE cm1.start_timestamp  < cm2.end_timestamp
    AND cm2.start_timestamp < cm1.end_timestamp
),
overlapping_meeting_count AS ( -- Step 3
    SELECT
        participant_id,
        COUNT(DISTINCT meeting_id_1) +
        COUNT(DISTINCT meeting_id_2) AS overlap_count
    FROM overlapping_meetings
    GROUP BY participant_id
),
non_overlapping_meeting_count AS ( -- Step 4
    SELECT
        cm.participant_id,
        COUNT(DISTINCT cm.meeting_id) AS non_overlap_count
    FROM confirmed_meetings cm LEFT JOIN overlapping_meetings om
    ON cm.participant_id = om.participant_id
    AND (
        cm.meeting_id = om.meeting_id_1
        OR cm.meeting_id = om.meeting_id_2
    )
    WHERE om.participant_id IS NULL
    GROUP BY cm.participant_id
    HAVING COUNT(DISTINCT cm.meeting_id) >= 2
)

SELECT -- Step 5
    omc.participant_id,
    omc.overlap_count
FROM overlapping_meeting_count omc JOIN non_overlapping_meeting_count nomc
ON omc.participant_id = nomc.participant_id;
-- For Step 4, we probably could have done a self join similar to what was done in Step 2, but it would've been more complicated.


/*
  Ascending Responsiveness Rate (Advanced SQL DE Interview Problem)

  Find the users who have logged in for at least 5 months, and who have a strictly increasing monthly responsiveness rate* through the months
  Columns to Display: user_id, month, current_month_responsiveness, previous_month_responsiveness

  Table: dim_users_hinge
  user_id
  gender
  city

  Table: fact_logins_hinge
  login_id
  user_id
  login_date
  messages_sent
  replies
*/

-- Find users who meet the following conditions:
    -- Logged in for at least 5 months
    -- Has a strictly increasing average responsiveness rate.
-- Display: user_id, month, current_month_responsiveness,
-- previous_month_responsiveness
-- Step 1: Join the tables using INNER JOIN
-- Step 2: Group by user ID and month
-- Step 3: Calculate the average responsive rate.
-- Step 4: Filter down to users who have logged in for >= 5 months
-- Step 5: Filter down to users with strictly increasing response rate

WITH monthly_stats AS ( -- Step 1, 2, and 3
    SELECT
        duh.user_id,
        DATE_FORMAT(login_date, '%Y-%m') AS month_key,
        SUM(flh.replies) * 1.0 / SUM(flh.messages_sent) AS current_month_responsiveness
    FROM dim_users_hinge duh
    JOIN fact_logins_hinge flh
        ON duh.user_id = flh.user_id
    GROUP BY duh.user_id, DATE_FORMAT(login_date, '%Y-%m')
),
filtered_monthly_stats AS ( -- Step 4
    SELECT
        user_id,
        month_key,
        current_month_responsiveness,
        LAG(current_month_responsiveness) OVER(PARTITION BY user_id ORDER BY month_key) AS previous_month_responsiveness
    FROM monthly_stats t1
    WHERE (
        SELECT
            COUNT(month_key)
        FROM monthly_stats t2
        WHERE t1.user_id = t2.user_id
        GROUP BY t2.user_id
    ) >= 5
),
increasing_rates AS (
    SELECT
        user_id,
        month_key,
        current_month_responsiveness,
        previous_month_responsiveness,
        (
            CASE
                WHEN previous_month_responsiveness IS NULL THEN 1
                WHEN previous_month_responsiveness < current_month_responsiveness THEN 1
                ELSE 0
            END
        ) AS increasing_rate
    FROM filtered_monthly_stats
),
qualified_users AS (
    SELECT
        user_id
    FROM increasing_rates
    GROUP BY user_id
    HAVING COUNT(month_key) = SUM(increasing_rate)
)

SELECT -- Step 5
   user_id,
   SUBSTRING(month_key, 6, 2) AS month,
   current_month_responsiveness,
   previous_month_responsiveness
FROM filtered_monthly_stats
WHERE user_id IN (
    SELECT * FROM qualified_users
);
-- This problem serves as a good example of how to determine a strictly increasing value in a particular column or partition within a column.
-- Simply use the LAG function to create a increasing_value column. For the first row in the column/partition, default to a 1 (true) since there's
-- no previous value to compare it to. For other rows, compare the current row to the previous and assign a value of 1 or 0 accordingly.
-- For a strictly increasing column/partition, COUNT(*) = SUM(increasing_value)


/*
  Four Consecutive Days of Listening (Advanced SQL DE Interview Problem)

  Find the users who have logged in for at least 5 months, and who have a strictly increasing monthly responsiveness rate* through the months
  Columns to Display: user_id, month, current_month_responsiveness, previous_month_responsiveness

  Table: dim_users_spotify
  user_id
  name
  city

  Table: fact_historical_songs_listens
  user_id
  song_id
  song_plays

  Table: fact_weekly_songs_listens
  listen_id
  user_id
  listen_time
*/

-- Find the names of users who listened to songs on 4 consecutive days.
-- Only use data from recent listens
-- Display: name
-- Step 1: Find users who have recent listened to songs >= 4 times.
-- Step 2: Of those users find those who listened on >= 4 consecutive days.

-- SELECT * FROM fact_weekly_songs_listens LIMIT 20;

WITH user_daily_listens AS (
    SELECT
        dus.user_id,
        dus.name,
        DATE(fwsl.listen_time) AS listen_day,
        COUNT(fwsl.listen_id) AS daily_listens
    FROM dim_users_spotify dus JOIN fact_weekly_songs_listens fwsl
    ON dus.user_id = fwsl.user_id
    GROUP BY dus.user_id, dus.name, DATE(fwsl.listen_time)
    HAVING COUNT(fwsl.listen_id) > 0
),
consecutive_listens AS (
    SELECT
        user_id,
        name,
        listen_day,
        (
            CASE
                WHEN listen_day = LAG(listen_day, 3) OVER(PARTITION BY user_id ORDER BY listen_day) + INTERVAL 3 DAY THEN 1
                ELSE 0
            END
        ) AS is_consecutive_listen
    FROM user_daily_listens
    WHERE user_id IN (
        SELECT
            user_id
        FROM user_daily_listens
        GROUP BY user_id
        HAVING COUNT(DISTINCT listen_day) >= 4
    )
)

SELECT
    DISTINCT name
FROM consecutive_listens
WHERE user_id IN (
    SELECT
        user_id
    FROM consecutive_listens
    GROUP BY user_id
    HAVING SUM(is_consecutive_listen) >= 1
);
-- Good example of how to look back four consecutive days without using a self join, showing that window functions can be a good alternative.