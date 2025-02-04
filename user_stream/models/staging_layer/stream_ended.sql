{{
  config(
    materialized='ephemeral'
  )
}}

SELECT 
    md5(streamer_id || end_time || stream_id) AS event_id,
    TO_VARCHAR('stream_ended') AS event_type, 
    TO_VARCHAR(streamer_id) AS user_id, 
    TO_TIMESTAMP(end_time) AS time,
    OBJECT_CONSTRUCT(
        'stream_id', stream_id,
        'stream_duration', STREAM_DURATION,
        'ios_viewer_count', IOS_VIEWER_COUNT,
        'android_viewer_count', ANDROID_VIEWER_COUNT,
        'streamer_register_time', STREAMER_REGISTER_TIME,
        'streamer_register_country', STREAMER_REGISTER_COUNTRY,
        'total_viewed_minutes', TOTAL_VIEWED_MINUTES,
        'avg_viewer_watch_time', AVG_VIEWER_WATCH_TIME,
        'avg_stream_join_time', AVG_STREAM_JOIN_TIME,
        'follow_increase_estimated', follower_change,
        'close_by', stream_closed_by,
        'time_to_peak', 
            CASE 
                WHEN max_live_viewer_time IS NOT NULL 
                THEN DATEDIFF(MINUTE, start_time, max_live_viewer_time)
                ELSE NULL 
            END
    ) AS event_properties 
FROM {{ ref('stream_info') }}
