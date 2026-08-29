'''sql
-- 02 · Daily users and events
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: how do user and event counts move day by day across the three months?
-- Note    : this query takes 3 months of data dynamically, considering minimum date as starting day  

WITH date_range AS (
  SELECT
    MIN(_TABLE_SUFFIX) AS start_date,
    MAX(_TABLE_SUFFIX) AS end_date
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
)

SELECT
  event_date,count(distinct(user_pseudo_id)) AS user_count,count(*) AS event_count
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  _TABLE_SUFFIX >= (SELECT start_date FROM date_range)
  AND _TABLE_SUFFIX < FORMAT_DATE(
    '%Y%m%d',
    DATE_ADD(
      PARSE_DATE('%Y%m%d', (SELECT start_date FROM date_range)),
      INTERVAL 3 MONTH
    )
  )
  group by event_date
  order by event_date asc;
