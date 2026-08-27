# GA4 Analytics Engineering

SQL and analytics engineering on Google's public GA4 ecommerce dataset in BigQuery —
sessionization, funnels, attribution, retention, and the dbt models built on top of them.

## Dataset

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

Google's public sample of a real GA4 BigQuery export, covering 1 Nov 2020 – 31 Jan 2021.

## Structure

- **`/sql`** — standalone queries against the raw event export, one file each
- **`/dbt`** — dbt project turning those queries into tested, documented models *(in progress)*

## Queries

| File | What it answers |
|---|---|
| `01_event_volume.sql` | Event mix on a single day |

## About

Aashish Agarwal — digital and marketing analytics. Seven years across ecommerce, retail
and financial services. GA4, GA360, BigQuery, Tealium, SQL, Python.

[LinkedIn](https://www.linkedin.com/in/aashish-agarwal1993)
