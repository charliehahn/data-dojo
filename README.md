# data-dojo

Sandbox dbt project for testing Snowflake-native dbt Projects.

## Structure

```
models/
  staging/        # views — clean + rename raw seed data
  intermediate/   # views — join and enrich
  marts/          # tables — final aggregated outputs
seeds/
  raw_patients    # 10 dummy patient records
  raw_orders      # 12 dummy order records
```

## Running locally

```bash
dbt deps
dbt seed
dbt run
dbt test
```

## Targets

- `dev`  — writes to `ANALYTICS_DEV.dbt_dojo_dev` (personal, externalbrowser)
- `prod` — writes to `ANALYTICS_DEV.dbt_dojo` (Snowflake Task execution)
