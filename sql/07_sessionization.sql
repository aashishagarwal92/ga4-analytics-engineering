```sql
-- 07 · Sessionization
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: how do you build a stable session_id from user_pseudo_id and ga_session_id?
-- Note    : Concatenation of user_pseudo_id and session_id generates a unique session identifier
```
WITH event_data AS (

  SELECT
    event_date,
    event_timestamp,
    event_name,
    user_pseudo_id,

    -- Extract GA4 session ID
    (
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS ga_session_id,

  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    _TABLE_SUFFIX BETWEEN '20201101' AND '20201130'
)
,

session_data AS (

  SELECT

    user_pseudo_id,

    ga_session_id,

    -- Create unique session identifier
    CONCAT(
      user_pseudo_id,
      '-',
      CAST(ga_session_id AS STRING)
    ) AS session_id,

    MIN(event_timestamp) AS session_start_timestamp

  FROM
    event_data

  WHERE
    ga_session_id IS NOT NULL
    group by 1,2,3
)

SELECT *
FROM session_data
ORDER BY session_start_timestamp;
