```sql
-- 03 · Traffic by source, medium and campaign
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: which source / medium / campaign combinations bring the most sessions?
-- Note    : Taken 1 day of data to reduce the running cost and checking the results
```
  
  
WITH session_data AS
(
  SELECT event_timestamp,event_name,(SELECT value.int_value FROM UNNEST (event_params)e WHERE e.key = 'ga_session_id') AS ga4_session_id,traffic_source.source AS source, traffic_source.medium,traffic_source.name AS campaign
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20201101`
)

SELECT source,medium,campaign,COUNT(DISTINCT ga4_session_id) session_count
FROM session_data
GROUP BY source,medium,campaign
