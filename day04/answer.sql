begin;

create schema if not exists day04;

set search_path to day04;

create table raw (
    id SERIAL,
    range_1 TEXT,
    range_2 TEXT
);

\COPY raw (range_1, range_2) FROM 'day04/input.txt' WITH (FORMAT 'csv');

-- Part 1
create table split_ranges as (
    select
        split_part(range_1, '-', 1)::INTEGER as range_1_start,
        split_part(range_1, '-', 2)::INTEGER as range_1_end,
        split_part(range_2, '-', 1)::INTEGER as range_2_start,
        split_part(range_2, '-', 2)::INTEGER as range_2_end
    from raw
);

select count(*) as part1_answer
from split_ranges
where (range_1_start >= range_2_start and range_1_end <= range_2_end)
    or
    (range_2_start >= range_1_start and range_2_end <= range_1_end);

-- Part 2

select count(*) as part2_answer
from split_ranges
where (range_1_start between range_2_start and range_2_end)
    or
    (range_2_start between range_1_start and range_1_end);

rollback;
