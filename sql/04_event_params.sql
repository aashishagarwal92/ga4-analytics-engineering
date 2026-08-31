```sql
-- 04 · Reading event parameters
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: how do you pull page_location and page_title out of the event_params array?
-- Note    : event params have info in key-value pair , to extract extract info individual should know which key value pair to unnest 
```
SELECT DISTINCT event_date,event_name,user_pseudo_id,
  (SELECT value.int_value FROM UNNEST(event_params) WHERE KEY = 'ga_session_id')ga_session_id,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE KEY = 'page_location')page_location,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE KEY = 'page_title')page_title
 FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
