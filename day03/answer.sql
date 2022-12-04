begin;

create schema if not exists day03;

set search_path to day03;

create table raw (
    id SERIAL,
    rucksack TEXT
);

\COPY raw (rucksack) FROM 'day03/input.txt' WITH (FORMAT 'csv');

-- Part 1
with halves as (
    select
        left(rucksack, char_length(rucksack) / 2) as left_sack,
        right(rucksack, char_length(rucksack) / 2) as right_sack
    from raw
),

intersections as (
    select (
        select unnest(string_to_array(left_sack, null))
        intersect
        select unnest(string_to_array(right_sack, null))
        ) as intersecting_char
    from halves
),

chars as (
    select
        case
            when ascii(intersecting_char) < 91
                then ascii(intersecting_char) - 64 + 26
            else
                ascii(intersecting_char) - 96
        end as pts
    from intersections
)

select sum(pts) as part1_answer
from chars;

-- Part 2
with group_ids as (
    select
        rucksack,
        coalesce(lag(id / 3) over (), 0) as grp
    from raw
),

groups as (
    select array_agg(rucksack) as arr from group_ids group by grp
),

chars as (
    select (
        select unnest(string_to_array(arr[1], null))
        intersect
        select unnest(string_to_array(arr[2], null))
        intersect
        select unnest(string_to_array(arr[3], null))
        ) as intersecting_char
    from groups
),

points as (
    select case
        when ascii(intersecting_char) < 91
            then ascii(intersecting_char) - 64 + 26
        else
            ascii(intersecting_char) - 96
        end as pts
    from chars
)

select sum(pts) as part2_answer
from points;

rollback;
