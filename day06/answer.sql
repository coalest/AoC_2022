begin;

create schema if not exists day06;

set search_path to day06;

create table raw_signal (
    id serial,
    signal text
);

\COPY raw_signal (signal) FROM 'day06/input.txt' WITH (FORMAT 'csv');

-- Part 1
-- Separate input string into individual characters
with chars(chr) as (
    select unnest(string_to_array(signal, null)) as chr
    from raw_signal
),

-- Add row numbers to keep order of chars
with_row_numbers as (
    select
        chr,
        row_number() over () as id
    from chars
),

-- Group individual chars into 4 char long substrings
char_groups_1(four_chars, n) as (
    select
        string_agg(chr, null)
        over (order by id range between 0 following and 3 following)
        as four_chars,
        row_number() over () + 3 as n
    from with_row_numbers
),

-- Find the first string that has 4 unique characters
part_1 as (
    select n as part1_answer
    from char_groups_1, unnest(string_to_array(four_chars, null)) as chrs
    group by n
    having count(distinct chrs) = 4
    order by n
    limit 1
),

-- Part 2
-- Same as part 1 but with 14 character long substrings

char_groups_2(fourteen_chars, n) as (
    select
        string_agg(chr, null)
        over (order by id range between 0 following and 13 following)
        as fourteen_chars,
        row_number() over () + 13 as n
    from with_row_numbers
),

part_2 as (
    select n as part2_answer
    from char_groups_2, unnest(string_to_array(fourteen_chars, null)) as chrs
    group by n
    having count(distinct chrs) = 14
    order by n
    limit 1
)

select *
from part_1, part_2;

rollback;
