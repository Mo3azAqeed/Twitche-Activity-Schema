--------> Retension 

------

WITH base AS (
    SELECT 
        streamer_id,
        DATE_TRUNC('day', start_time::date) AS stream_date,  
        MIN(start_time::date) OVER (PARTITION BY streamer_id) AS first_time,
        stream_id
    FROM DBT_DB.DBT_SCHEMA_STAGING_LAYER.STREAM_INFO

)
SELECT *,
       DATEDIFF('day', first_time, stream_date) AS cohort_age
FROM base;

-------------------------------------------->>> 
---Partners Growing 

    WITH base AS (
        SELECT 
            streamer_id,
            DATE_TRUNC('day', start_time::date) AS stream_date,  
            MIN(start_time::date) OVER (PARTITION BY streamer_id) AS first_time,
            stream_id
        FROM DBT_DB.DBT_SCHEMA_STAGING_LAYER.STREAM_INFO
    ),
    
    daily_aggregates AS (
        SELECT 
            first_time,
            COUNT(DISTINCT streamer_id) AS new_partners, -- Unique new users per day
            COUNT(stream_id) AS total_streams -- Total streams on that day
        FROM base
        GROUP BY first_time
    )
    
    SELECT 
        first_time,
        new_partners,
        total_streams,
        SUM(new_partners) OVER (ORDER BY first_time ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) 
            AS current_partners_base -- Running total of unique users
    FROM daily_aggregates
    ORDER BY first_time
    ----
