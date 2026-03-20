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
        product_category,
        count(order_id)                                     as total_orders,
        count(case when status = 'delivered' then 1 end)    as delivered_orders,
        count(case when status = 'cancelled' then 1 end)    as cancelled_orders,
        round(
            count(case when status = 'delivered' then 1 end)
            / nullif(count(order_id), 0) * 100, 1
        )                                                   as delivery_rate_pct,
        sum(amount_usd)                                     as total_revenue_usd,
        avg(amount_usd)                                     as avg_order_value_usd,
        avg(case when days_to_resolution is not null
                 then days_to_resolution end)               as avg_days_to_resolution
    from base
    group by 1
    order by total_revenue_usd desc
)

final as (
    select
        *,
        case
            when total_revenue_usd >= 3000 then 'high'
            when total_revenue_usd >= 500  then 'medium'
            else                                'low'
        end as revenue_tier
    from summary
)

select * from final
