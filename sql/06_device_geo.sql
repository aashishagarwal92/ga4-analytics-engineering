```sql
-- 06 · Device and geography breakdown
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: how does traffic split by device category, operating system and country?
-- Note    : Group by columns can be arranged as per output requirement, bottleneck was to identify which column value has required info
```
WITH device_geo AS(
SELECT event_date,user_pseudo_id,(select value.int_value from unnest (event_params) where key = 'ga_session_id') as ga_session_id,device.category as device_category,device.operating_system as operating_system,geo.country as country
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT
  event_date,
  device_category,
  operating_system,
  country,
  COUNT(DISTINCT CONCAT(user_pseudo_id, '-', CAST(ga_session_id AS STRING))) AS unique_sessions
FROM
  device_geo
WHERE
  ga_session_id IS NOT NULL
GROUP BY
  event_date,
  device_category,
  operating_system,
  country
ORDER BY
  unique_sessions DESC;
