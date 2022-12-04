{{ config(materialized='table') }}

select 10 as col union all
select 11 as col