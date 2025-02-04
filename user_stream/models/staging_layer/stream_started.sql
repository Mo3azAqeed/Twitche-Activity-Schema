{{
  config(
    materialized='ephemeral'
  )
}}

SELECT 
    md5(streamer_id || start_time || stream_id) AS event_id,
    TO_VARCHAR('stream_started') AS event_type, -- Use TO_VARCHAR here
    TO_VARCHAR(streamer_id) AS user_id, -- Use TO_VARCHAR here
    TO_TIMESTAMP(start_time) AS time, -- Using TO_TIMESTAMP directly
    OBJECT_CONSTRUCT(
        'is_show_stream', IS_SHOW_STREAM,
        'is_private_stream', IS_PRIVATE_STREAM,
        'ios_viewer_count', IOS_VIEWER_COUNT,
        'android_viewer_count', ANDROID_VIEWER_COUNT,
        'streamer_register_time', STREAMER_REGISTER_TIME,
        'streamer_register_country', STREAMER_REGISTER_COUNTRY
    ) AS event_properties -- Renamed from properties
FROM {{ ref('stream_info') }}
