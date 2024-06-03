-----Question 1 - How may accidents occuredin NYC,AUS,CHI-------------
SELECT
    ds.source_name AS city,
    COUNT(ft.crash_id) AS num_unique_crashes
FROM
    fact ft
JOIN
    dim_source ds ON ft.source_sk = ds.source_sk
WHERE
    ds.source_name IN ('NYC', 'AUS', 'CHI')
GROUP BY
    ds.source_name
ORDER BY
    ds.source_name;

 -------Question 2 top 3 areas in each citites with greatest number of accidents --------
------AUS-------
SELECT TOP 3
   dl.street_name AS area,
   COUNT(ft.crash_id) AS num_unique_crashes
FROM
   fact ft
JOIN
   dim_location dl ON ft.location_sk = dl.location_sk
JOIN
   dim_source ds ON ft.source_sk = ds.source_sk
WHERE
   ds.source_name = 'AUS'
GROUP BY
   dl.street_name
ORDER BY
   num_unique_crashes DESC;

------NYC-----------
SELECT TOP 3
   dl.street_name AS area,
   COUNT(ft.crash_id) AS num_unique_crashes
FROM
   fact  ft
JOIN
   dim_location dl ON ft.location_sk = dl.location_sk
JOIN
   dim_source ds ON ft.source_sk = ds.source_sk
WHERE
   ds.source_name = 'NYC' AND
   dl.street_name IS NOT NULL AND
   dl.street_name LIKE '%[a-zA-Z]%'  
GROUP BY
   dl.street_name
ORDER BY
   num_unique_crashes DESC;

---------CHI-------------------
   SELECT TOP 3
   dl.street_name AS area,
   COUNT(ft.crash_id) AS num_unique_crashes
FROM
   fact ft
JOIN
   dim_location dl ON ft.location_sk = dl.location_sk
JOIN
   dim_source ds ON ft.source_sk = ds.source_sk
WHERE
   ds.source_name = 'CHI'
GROUP BY
   dl.street_name
ORDER BY
   num_unique_crashes DESC;

   ------Question 3 Accidents resulted in injuries ------
SELECT
    'Total' AS city,
    SUM(total_injury_count) AS num_unique_injuries
FROM (
    SELECT
        crash_id,
        total_injury_count
    FROM
        fact
) ft

UNION ALL

SELECT
    ds.source_name AS city,
    SUM(ft.total_injury_count) AS num_unique_injuries
FROM (
    SELECT 
        ft.crash_id,
        ft.total_injury_count,
        ft.source_sk
    FROM
        fact ft
) ft
JOIN
    dim_source ds ON ft.source_sk = ds.source_sk
GROUP BY
    ds.source_name;


----------- Question 4 Pedestrians Involved in accidents------

SELECT
    'Total' AS city,
    SUM(Pedestrians_Involved) AS num_unique_pedestrians
FROM (
    SELECT 
        crash_id,
        Pedestrians_Involved
    FROM
        FACT
) ft

UNION ALL

SELECT
    ds.source_name AS city,
    SUM(ft.Pedestrians_Involved) AS num_unique_pedestrians
FROM (
    SELECT 
        ft.crash_id,
        ft.Pedestrians_Involved,
        ft.source_sk
    FROM
        fact ft
) ft
JOIN
    dim_source ds ON ft.source_sk = ds.source_sk
GROUP BY
    ds.source_name;

------- Question 5  when do most accidents happen seasonality report --------

SELECT
    dd.crash_season AS season,
    COUNT(ft.crash_id) AS num_unique_accidents
FROM
    FACT ft
JOIN
    dim_date dd ON ft.date_sk = dd.date_sk
GROUP BY
    dd.crash_season
ORDER BY
    num_unique_accidents DESC;

    ------ Question 6 How many motorists are injured or killed in accidents --------

SELECT
    ds.source_name AS city,
    SUM(CASE WHEN MOTORISTS_INJURED < 0 THEN 0 ELSE MOTORISTS_INJURED END) AS total_motorists_injured,
    SUM(CASE WHEN Motorists_killed < 0 THEN 0 ELSE Motorists_killed END) AS total_motorists_killed
FROM
    (SELECT crash_id, source_sk, MOTORISTS_INJURED, Motorists_killed 
     FROM fact) AS ft
JOIN
    dim_source ds ON ft.source_sk = ds.source_sk
WHERE
    (ds.source_name != 'CHI' OR (ds.source_name = 'CHI' AND MOTORISTS_INJURED >= 0 AND Motorists_killed >= 0))
GROUP BY
    ds.source_name

UNION ALL

SELECT
    'Overall' AS city,
    SUM(CASE WHEN MOTORISTS_INJURED < 0 THEN 0 ELSE MOTORISTS_INJURED END) AS total_motorists_injured,
    SUM(CASE WHEN Motorists_killed < 0 THEN 0 ELSE Motorists_killed END) AS total_motorists_killed
FROM
    fact
WHERE
    MOTORISTS_INJURED >= 0 AND Motorists_killed >= 0;


-------Question 7 top 5 areas in 3 cities have most fatal number of accidents--------

----AUS-----
SELECT TOP 5
   dl.street_name AS area,
   'AUS' AS city,
   SUM(ft.total_fatal_count) AS total_fatal_count
FROM
   (
       SELECT crash_id, location_SK, source_SK, total_fatal_count
       FROM fact
       WHERE total_fatal_count >= 0
         AND source_SK = (SELECT source_sk FROM dim_source WHERE source_name = 'AUS')
   ) AS ft
JOIN
   dim_location dl ON ft.location_SK = dl.location_sk
WHERE
   dl.street_name NOT LIKE '-%' -- Exclude negative values from street_name
GROUP BY
   dl.street_name
ORDER BY
   SUM(ft.total_fatal_count) DESC;

   -----NYC------

   SELECT TOP 5
   dl.street_name AS area,
   'NYC' AS city,
   SUM(ft.total_fatal_count) AS total_fatal_count
FROM
   (
       SELECT crash_id, location_SK, source_SK, total_fatal_count
       FROM fact
       WHERE total_fatal_count >= 0
         AND source_SK = (SELECT source_sk FROM dim_source WHERE source_name = 'NYC')
   ) AS ft
JOIN
   dim_location dl ON ft.location_SK = dl.location_sk
WHERE
   dl.street_name NOT LIKE '-%' -- Exclude negative values from street_name
GROUP BY
   dl.street_name
ORDER BY
   SUM(ft.total_fatal_count) DESC;

------CHI---------

SELECT TOP 5
   dl.street_name AS area,
   'CHI' AS city,
   SUM(ft.total_fatal_count) AS total_fatal_count
FROM
   (
       SELECT crash_id, location_SK, source_SK, total_fatal_count
       FROM fact
       WHERE total_fatal_count >= 0
         AND source_SK = (SELECT source_sk FROM dim_source WHERE source_name = 'CHI')
   ) AS ft
JOIN
   dim_location dl ON ft.location_SK = dl.location_sk
WHERE
   dl.street_name NOT LIKE '-%' -- Exclude negative values from street_name
GROUP BY
   dl.street_name
ORDER BY
   SUM(ft.total_fatal_count) DESC;


-------- Question 8 Time based analysis (time of the day,day of the week, weekdays or weekends)--------------

WITH TimeAnalysis AS (
    SELECT
        COUNT(ft.crash_id) AS unique_crash_count,
        dt.crash_time AS time_of_day,  
        CASE
            WHEN dd.crash_day_of_week BETWEEN 1 AND 5 THEN 'Weekday'
            WHEN dd.crash_day_of_week IN (6, 7) THEN 'Weekend'
        END AS day_type
    FROM
        fact ft
    JOIN
        dim_date dd ON ft.date_sk = dd.date_sk  -- Linking to dim_date for crash_day_of_week
    JOIN
        dim_time dt ON ft.time_sk = dt.time_sk  -- Linking to dim_time for crash_time
    GROUP BY
        dt.crash_time,
        dd.crash_day_of_week
),
AggregatedByTime AS (
    SELECT
        time_of_day,
        SUM(unique_crash_count) AS crashes_at_time
    FROM
        TimeAnalysis
    GROUP BY
        time_of_day
),
AggregatedByDayType AS (
    SELECT
        day_type,
        SUM(unique_crash_count) AS crashes_by_day_type
    FROM
        TimeAnalysis
    GROUP BY
        day_type
)
SELECT
    'Time of Day' AS category,
    time_of_day AS type,
    crashes_at_time AS count
FROM
    AggregatedByTime

UNION ALL

SELECT
    'Day of Week' AS category,
    day_type AS type,
    crashes_by_day_type AS count
FROM
    AggregatedByDayType
ORDER BY
    category, type;

----- for each day_of_week------------
SELECT
    CASE
        WHEN dd.crash_day_of_week = 1 THEN 'Monday'
        WHEN dd.crash_day_of_week = 2 THEN 'Tuesday'
        WHEN dd.crash_day_of_week = 3 THEN 'Wednesday'
        WHEN dd.crash_day_of_week = 4 THEN 'Thursday'
        WHEN dd.crash_day_of_week = 5 THEN 'Friday'
        WHEN dd.crash_day_of_week = 6 THEN 'Saturday'
        WHEN dd.crash_day_of_week = 7 THEN 'Sunday'
    END AS day_of_week,
    COUNT(ft.crash_id) AS unique_crash_count
FROM
    fact ft
JOIN
    dim_date dd ON ft.date_sk = dd.date_sk
GROUP BY
    dd.crash_day_of_week
ORDER BY
    dd.crash_day_of_week;


----------Question 9 Fatality Analyisis ---------------------
SELECT
   SUM(pedestrians_killed) AS total_pedestrians_killed,
   SUM(CASE WHEN motorists_killed >= 0 THEN motorists_killed ELSE 0 END) AS total_motorists_killed
FROM (
   SELECT crash_id, pedestrians_killed, motorists_killed
   FROM FACT
) AS unique_crashes;

---------Question 10 Common Factors Involved------------------

WITH SplitDescriptions AS (
    SELECT
        CASE
            WHEN CHARINDEX('$', cf.Contributing_factors_description) > 0
            THEN LEFT(cf.Contributing_factors_description, CHARINDEX('$', cf.Contributing_factors_description) - 1)
            ELSE cf.Contributing_factors_description
        END AS part1,
        CASE
            WHEN CHARINDEX('$', cf.Contributing_factors_description) > 0
            THEN SUBSTRING(
                cf.Contributing_factors_description,
                CHARINDEX('$', cf.Contributing_factors_description) + 1,
                CASE WHEN CHARINDEX('$', cf.Contributing_factors_description, CHARINDEX('$', cf.Contributing_factors_description) + 1) > 0
                     THEN CHARINDEX('$', cf.Contributing_factors_description, CHARINDEX('$', cf.Contributing_factors_description) + 1) - CHARINDEX('$', cf.Contributing_factors_description) - 1
                     ELSE LEN(cf.Contributing_factors_description) - CHARINDEX('$', cf.Contributing_factors_description)
                END
            )
            ELSE ''
        END AS part2
    FROM
        dim_CF cf
    JOIN
        fact f ON cf.CF_SK = f.CF_SK
)
SELECT
    part,
    count_occurrences
FROM (
    SELECT
        part,
        COUNT(*) AS count_occurrences,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS rn
    FROM
        (
            SELECT part1 AS part FROM SplitDescriptions WHERE part1 <> 'Unspecified' AND part1 <> '' AND LEFT(part1, 1) <> '-' AND part1 NOT LIKE '%unable to determine%' AND part1 NOT LIKE '%not applicable%' AND part1 <> 'null'
            UNION ALL
            SELECT part2 AS part FROM SplitDescriptions WHERE part2 <> 'Unspecified' AND part2 <> '' AND LEFT(part2, 1) <> '-' AND part2 NOT LIKE '%unable to determine%' AND part2 NOT LIKE '%not applicable%' AND part2 <> 'null'
        ) AS Parts
    GROUP BY
        part
) RankedParts
WHERE rn <= 2;

------Question 11 show number of incidents that involved more than 2 vehicles------------

-----------------AUS------------------------
SELECT
    s.Source_name AS City,
    COUNT(*) AS Unique_Incidents_with_more_than_2_vehicles
FROM
    fact f
JOIN
    dim_source s ON f.Source_SK = s.Source_SK
JOIN
    dim_vehicletype v ON f.Vehicle_Type_SK = v.Vehicle_Type_SK
WHERE
    v.Vehicle_Count > 2
    AND s.Source_name = 'AUS'
    AND v.Vehicle_Count IS NOT NULL
GROUP BY
    s.Source_name;

-------------------NYC----------------------
SELECT
    s.Source_name AS City,
    COUNT(f.Crash_ID) AS Unique_Incidents_with_more_than_2_vehicles
FROM
    fact f
JOIN
    dim_source s ON f.Source_SK = s.Source_SK
JOIN
    dim_vehicletype v ON f.Vehicle_Type_SK = v.Vehicle_Type_SK
WHERE
    v.Vehicle_Count > 2
    AND s.Source_name = 'NYC'
    AND v.Vehicle_Count IS NOT NULL
GROUP BY
    s.Source_name;





