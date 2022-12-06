--begin;

create schema if not exists day06;

set search_path to day06;

drop table if exists raw_signal;

create table raw_signal (
    id serial,
    signal text
);

\COPY raw_signal (signal) FROM 'day06/input.txt' WITH (FORMAT 'csv');

-- Part 1

-- Separate input string into individual characters
with chars as (
    select
        id,
        unnest(string_to_array(signal, null)) as single_char
    from raw_signal
),

-- Group individual chars into 4 char long strings
char_groups as (
    select
        single_char ||
        lead(single_char, 1) over () ||
        lead(single_char, 2) over () ||
        lead(single_char, 3) over ()
        as four_chars,
        row_number() over () + 3 as n
    from chars
)

-- Find the first string that has 4 unique characters
select n as part1_answer
from char_groups, unnest(string_to_array(four_chars, null)) as chrs
group by n
having count(distinct chrs) = 4
order by n
limit 1;

-- Part 2
-- Same as part 1 but with 14 character long substrings

with chars as (
    select
        id,
        unnest(string_to_array(signal, null)) as single_char
    from raw_signal
),

char_groups as (
    select
        single_char ||
        lead(single_char, 1) over () ||
        lead(single_char, 2) over () ||
        lead(single_char, 3) over () ||
        lead(single_char, 4) over () ||
        lead(single_char, 5) over () ||
        lead(single_char, 6) over () ||
        lead(single_char, 7) over () ||
        lead(single_char, 8) over () ||
        lead(single_char, 9) over () ||
        lead(single_char, 10) over () ||
        lead(single_char, 11) over () ||
        lead(single_char, 12) over () ||
        lead(single_char, 11) over () ||
        lead(single_char, 12) over () ||
        lead(single_char, 13) over ()
        as fourteen_chars,
        row_number() over () + 13 as n
    from chars
)

select n as part2_answer
from char_groups, unnest(string_to_array(fourteen_chars, null)) as chrs
group by n
having count(distinct chrs) = 14
order by n
limit 1;

--rollback;
