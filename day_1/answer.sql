begin;

create schema if not exists day01;

set search_path to day01;

create table inputs (
    id SERIAL,
    input INTEGER
);

\COPY inputs (input) FROM 'day_1/input.txt' WITH (FORMAT 'csv');

-- Part 1
with starts as (
    select
        id,
        input,
        case when input is null then 1 else 0 end as island_start
    from inputs
),

islands as (
    select
        input,
        SUM(island_start) over (order by id asc) as island
    from starts
)

select
    SUM(COALESCE(input, 0)) over (partition by island) as answer
from islands
order by answer desc
limit 1;

-- Part 2
with starts as (
    select
        id,
        input,
        case when input is null then 1 else 0 end as island_start
    from inputs
),

islands as (
    select
        starts.input,
        SUM(island_start) over (order by id asc) as island
    from starts
)

select SUM(top_three.sum) as answer
from (select distinct
    island,
    SUM(
        COALESCE(input, 0)
    ) over (partition by island) as sum
    from islands
    order by sum desc
    limit 3) as top_three;

rollback;
