{{
    config(
        materialized='table'
    )
}}

with base as (
    select * from {{ ref('int_patient_orders') }}
),

summary as (
    select
        patient_id,
        patient_name,
        state,
        insurance_type,
        age_years,
        count(order_id)                                     as total_orders,
        count(case when status = 'delivered' then 1 end)    as delivered_orders,
        count(case when status = 'cancelled' then 1 end)    as cancelled_orders,
        count(case when status = 'in_progress' then 1 end)  as in_progress_orders,
        sum(amount_usd)                                     as total_spend_usd,
        avg(amount_usd)                                     as avg_order_value_usd,
        avg(case when days_to_resolution is not null
                 then days_to_resolution end)               as avg_days_to_resolution,
        min(order_created_at)                               as first_order_at,
        max(order_created_at)                               as latest_order_at
    from base
    group by 1, 2, 3, 4, 5
)

select * from summary
