with source as (
    select * from {{ ref('raw_orders') }}
),

renamed as (
    select
        order_id,
        patient_id,
        lower(product_category)            as product_category,
        lower(status)                      as status,
        amount_usd,
        case
            when lower(status) = 'delivered'    then true
            when lower(status) = 'cancelled'    then false
            else null
        end                                as is_complete,
        created_at::timestamp              as created_at,
        updated_at::timestamp              as updated_at,
        datediff('day', created_at::timestamp, updated_at::timestamp) as days_to_resolution
    from source
)

select * from renamed
