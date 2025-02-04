{{
  config(
    materialized='ephemeral'
  )
}}

SELECT 
    md5(streamer_id || user_id || transaction_timestamp) AS event_id,
    TO_VARCHAR('gift_received') AS event_type, -- Use TO_VARCHAR here
    TO_VARCHAR(user_id) AS user_id, -- Use TO_VARCHAR here
    TO_TIMESTAMP(transaction_timestamp) AS time, -- Using TO_TIMESTAMP directly
    OBJECT_CONSTRUCT(
        'streamer_id', streamer_id,
        'viewer_id', user_id,
        'gift_id', gift_id,
        'gift_points', gift_points,
        'timestamp', transaction_timestamp
    ) AS event_properties -- Renamed from properties
FROM {{ ref('transactions') }}
