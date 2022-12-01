DROP TABLE IF EXISTS inputs;

CREATE TABLE inputs (
    id SERIAL,
    input INTEGER
);

\COPY inputs (input) FROM 'day_1/input.txt' WITH (FORMAT 'csv');

-- Part 1
WITH starts AS (
    SELECT
        id,
        input,
        CASE WHEN input IS NULL THEN 1 ELSE 0 END AS island_start
    FROM inputs
),

islands AS (
    SELECT
        starts.input,
        SUM(starts.island_start) OVER (ORDER BY starts.id ASC) AS island
    FROM starts
)

SELECT SUM(COALESCE(islands.input, 0)) OVER (PARTITION BY islands.island) AS answer
FROM islands
ORDER BY answer DESC
LIMIT 1;

-- Part 2
WITH starts AS (
    SELECT
        id,
        input,
        CASE WHEN input IS NULL THEN 1 ELSE 0 END AS island_start
    FROM inputs
),

islands AS (
    SELECT
        starts.input,
        SUM(starts.island_start) OVER (ORDER BY starts.id ASC) AS island
    FROM starts
)

SELECT SUM(top_three.sum) AS answer
FROM (SELECT DISTINCT
    islands.island,
    SUM(
        COALESCE(islands.input, 0)
    ) OVER (PARTITION BY islands.island) AS sum
    FROM islands
    ORDER BY sum DESC
    LIMIT 3) AS top_three;
