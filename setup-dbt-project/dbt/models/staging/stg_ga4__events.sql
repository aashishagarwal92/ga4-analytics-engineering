-- stg_ga4__events · one row per GA4 event, common fields flattened
-- Dataset : bigquery-public-data.ga4_obfuscated_sample_ecommerce
-- Question: what does a clean, queryable event table look like once nested fields are unpacked?
-- Note    :

select
    parse_date('%Y%m%d', event_date)      as event_date,
    timestamp_micros(event_timestamp)     as event_timestamp,
    event_name,
    user_pseudo_id,

    (select value.int_value
     from unnest(event_params)
     where key = 'ga_session_id')         as ga_session_id,

    concat(
        user_pseudo_id, '-',
        cast((select value.int_value
              from unnest(event_params)
              where key = 'ga_session_id') as string)
    )                                     as session_key,

    (select value.string_value
     from unnest(event_params)
     where key = 'page_location')         as page_location,

    device.category                       as device_category,
    geo.country                           as country,
    traffic_source.source                 as traffic_source,
    traffic_source.medium                 as traffic_medium

from {{ source('ga4', 'events') }}
where _table_suffix between '20201101' and '20210131'
