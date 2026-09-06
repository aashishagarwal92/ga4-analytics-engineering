```sql
-- 09 · Landing pages
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: what is the first page of each session, and which landing pages perform best?
-- Note    :
```

with events as (
    select
        concat(
            user_pseudo_id, '-',
            cast((select value.int_value from unnest(event_params)
                  where key = 'ga_session_id') as string)
        )                                                       as session_key,
        user_pseudo_id,
        event_timestamp,
        event_name,
        (select value.string_value from unnest(event_params)
         where key = 'page_location')                           as page_location
    from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
    where _table_suffix between '20201101' and '20210131'
),

page_views as (
    select
        session_key,
        user_pseudo_id,
        page_location,
        row_number() over (
            partition by session_key
            order by event_timestamp
        ) as page_rank
    from events
    where event_name = 'page_view'
      and session_key is not null
),

landing as (
    select session_key, user_pseudo_id, page_location as landing_page
    from page_views
    where page_rank = 1
),

outcomes as (
    select
        session_key,
        countif(event_name = 'page_view') as pageviews,
        countif(event_name = 'purchase')  as purchases
    from events
    where session_key is not null
    group by session_key
)

select
    l.landing_page,
    count(*)                                              as sessions,
    count(distinct l.user_pseudo_id)                      as users,
    round(avg(o.pageviews), 2)                            as avg_pages_per_session,
    round(countif(o.pageviews = 1) / count(*) * 100, 1)   as bounce_rate_pct,
    sum(o.purchases)                                      as purchases,
    round(sum(o.purchases) / count(*) * 100, 2)           as conversion_rate_pct

from landing l
join outcomes o using (session_key)
group by l.landing_page
having sessions >= 50
order by sessions desc
