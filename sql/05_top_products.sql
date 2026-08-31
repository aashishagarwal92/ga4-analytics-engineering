```sql
-- 05 · Top products by revenue
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: which items generate the most revenue, and how do you unnest the items array?
-- Note    : event_params contains attributes of an event, whereas items contains entities/products associated with the event. 
  items changes it to itemlevel, hence we need to define which event to consider while identifying product info.  
```
SELECT event_date,item.item_name,SUM(item.item_revenue) AS total_revenue
FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
UNNEST (items) AS item
WHERE event_name = 'purchase'
GROUP BY event_date,item.item_name
ORDER BY total_revenue DESC
