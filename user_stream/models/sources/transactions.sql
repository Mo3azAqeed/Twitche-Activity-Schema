WITH source AS (
    SELECT * FROM {{ source('src_user_streams', 'TRANSACTIONS') }}
)
SELECT 
    id AS transaction_id,
    receiverUserID AS streamer_id,
    userID AS user_id,
    TO_TIMESTAMP(REPLACE(utcTimestamp::VARCHAR, 'UTC', '')) AS transaction_timestamp,
    type AS transaction_type,
    giftID AS gift_id,
    point AS gift_points,
    TO_TIMESTAMP(timestamp) AS gift_timestamp,
    isCanceled::BOOLEAN AS is_canceled,
    recordPoint AS transaction_points
FROM 
    source
