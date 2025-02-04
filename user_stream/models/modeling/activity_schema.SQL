{{ config(
    materialized='incremental',
    incremental_strategy='append',
    unique_key='event_id'
) }}
 WITH CTE AS (


SELECT 
    *,
    CURRENT_TIMESTAMP() AS insert_date 
FROM 
    {{ ref('stream_ended') }}

UNION ALL

SELECT
    *,
    CURRENT_TIMESTAMP() AS insert_date 
FROM
    {{ ref('stream_started') }}

UNION ALL

SELECT
    *,
    CURRENT_TIMESTAMP() AS insert_date 
FROM
    {{ ref('gift_received') }}


 )


SELECT
  EVENT_TYPE AS "event_type",
  EVENT_PROPERTIES AS "event_properties",
  DATE_PART(EPOCH_SECOND, TIME) * 1000 AS "time",
  TO_TIMESTAMP_NTZ(INSERT_DATE) AS INSERT_DATE ,
  USER_ID AS "user_id"
FROM CTE