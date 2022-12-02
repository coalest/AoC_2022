begin;

create schema if not exists day02;

set search_path to day02;

create table raw (
    id SERIAL,
    opponent TEXT,
    you TEXT
);

\COPY raw (opponent, you) FROM 'day_2/input.txt' WITH (FORMAT 'csv' ,DELIMITER ' ');

-- Part 1
with points as (
    select
        case
            when you = 'X' then 1
            when you = 'Y' then 2
            when you = 'Z' then 3
        end as choice_pts,
        case when opponent = 'A' then
                case when you = 'X' then 3
                    when you = 'Y' then 6
                    when you = 'Z' then 0
                end
            when opponent = 'B' then
                case when you = 'X' then 0
                    when you = 'Y' then 3
                    when you = 'Z' then 6
                end
            when opponent = 'C' then
                case when you = 'X' then 6
                    when you = 'Y' then 0
                    when you = 'Z' then 3
                end
        end as result_pts
    from raw
)

select SUM(choice_pts) + SUM(result_pts) as part1_answer
from points;

-- Part 2
with outcomes as (
    select
        opponent,
        you as outcome,
        case when opponent = 'A' then
                case when you = 'X' then 'Z'
                    when you = 'Y' then 'X'
                    when you = 'Z' then 'Y'
                end
            when opponent = 'B' then
                case when you = 'X' then 'X'
                    when you = 'Y' then 'Y'
                    when you = 'Z' then 'Z'
                end
            when opponent = 'C' then
                case when you = 'X' then 'Y'
                    when you = 'Y' then 'Z'
                    when you = 'Z' then 'X'
                end
        end as your_choice
    from raw
),

points as (
    select
        case
            when outcome = 'X' then 0
            when outcome = 'Y' then 3
            when outcome = 'Z' then 6
        end as result_pts,
        case
            when your_choice = 'X' then 1
            when your_choice = 'Y' then 2
            when your_choice = 'Z' then 3
        end as choice_pts
    from outcomes
)

select SUM(result_pts) + SUM(choice_pts) as part2_answer
from points;

rollback;
