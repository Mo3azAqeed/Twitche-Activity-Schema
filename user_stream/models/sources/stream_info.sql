WITH source AS (
    SELECT * FROM {{ source('src_user_streams', 'LOGS') }}
)

SELECT 
    liveStreamID AS stream_id,
    TO_TIMESTAMP(REPLACE(BEGINTIME::VARCHAR, 'UTC', '')) AS start_time,
    TO_TIMESTAMP(REPLACE(ENDTIME::VARCHAR, 'UTC', '')) AS end_time,
    CEIL(duration::INT/ 60) AS stream_duration,
    CASE 
        WHEN closeBy IS NULL THEN 'Other'  
        ELSE closeBy
    END  AS stream_closed_by,
    maxLiveViewerCount AS max_live_viewers,
    TO_TIMESTAMP(REPLACE(maxLiveViewerTime::VARCHAR, 'UTC', '')) AS max_live_viewer_time,
    privateLiveStream::Boolean AS is_private_stream,
    receivedLikeCount AS total_likes_received,
    isShow::Boolean AS is_show_stream,
    userID AS streamer_id,
    TO_TIMESTAMP(REPLACE(registerTime::VARCHAR, 'UTC', '')) AS streamer_register_time,
    registerCountry AS streamer_register_country,
    uniqueViewerCount::INT AS unique_viewer_count,
    ios::INT AS ios_viewer_count,
    android::INT AS android_viewer_count,
    durationGTE5sec AS viewers_gt_5sec,
    durationGTE2min AS viewers_gt_2min,
    durationGTE10min AS viewers_gt_10min,
    CEIL(totalViewerDuration::INT/60) AS total_viewed_minutes,
    CEIL(avgViewerDuration::INT/60) AS avg_viewer_watch_time,
    CEIL(avgStreamJoinDuration::INT/60) AS avg_stream_join_time,
    count AS total_comments,
    CASE 
        WHEN followIncreaseEstimated < 0 THEN followIncreaseEstimated * -1 
        ELSE followIncreaseEstimated 
    END AS follower_change,
    receivePointEstimated AS total_gift_points_received
FROM source
