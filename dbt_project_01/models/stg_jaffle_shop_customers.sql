{{
    config
    (
        materialized='table',
        catalog='dev'
    )
}}

SELECT 
    CAST(ID AS BIGINT) as ID, 
    CAST(FIRST_NAME AS STRING) as FIRST_NAME,
    CAST(LAST_NAME AS STRING) as LAST_NAME
FROM
    external.`s3://s3reddyvari/dbt-setup/jaffle_shop_customers.csv`