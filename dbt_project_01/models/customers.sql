-- Read from Bronze sources and materialize into Silver

{{
    config
    (
        materialized='view'
        )
}}

with customers as (
    select
        id as customer_id,
        first_name,
        last_name
    from {{ source('dev_dbt_bronze', 'jaffle_shop_customers') }}
),

-- ORDERS 
orders as (
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status
    from {{ source('dev_dbt_bronze', 'jaffle_shop_orders') }}
),

customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from orders
    group by 1
),

final as (
    select
        c.customer_id,
        c.first_name,
        c.last_name,
        co.first_order_date,
        co.most_recent_order_date,
        coalesce(co.number_of_orders, 0) as number_of_orders
    from customers c
    left join customer_orders co using (customer_id)
)

select * from final