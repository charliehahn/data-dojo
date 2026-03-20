with source as (
    select * from {{ ref('raw_patients') }}
),

renamed as (
    select
        patient_id,
        first_name,
        last_name,
        first_name || ' ' || last_name     as full_name,
        date_of_birth::date                as date_of_birth,
        datediff('year', date_of_birth::date, current_date()) as age_years,
        upper(state)                       as state,
        lower(insurance_type)              as insurance_type,
        created_at::timestamp              as created_at
    from source
)

select * from renamed
