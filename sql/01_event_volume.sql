sql
-- 01 · Event volume by type, single day
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: what is the event mix on a single day, and which events dominate?
-- Note    : _TABLE_SUFFIX limits the wildcard scan to one daily table.
--           Without it, this scans all three months.

SELECT
  event_name,
  COUNT(*) AS events
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE _TABLE_SUFFIX = '20210131'
GROUP BY event_name
ORDER BY events DESC
