with patients as (
    select * from {{ ref('stg_patients') }}
),

orders as (
    select * from {{ ref('stg_orders') }}
),

joined as (
    select
        o.order_id,
        o.patient_id,
        p.full_name                        as patient_name,
        p.state,
        p.insurance_type,
        p.age_years,
        o.product_category,
        o.status,
        o.is_complete,
        o.amount_usd,
        o.days_to_resolution,
        o.created_at                       as order_created_at
    from orders o
    left join patients p on o.patient_id = p.patient_id
)

select * from joined
