/* 
Purpose:
Measure the incremental lift in 7-day funding for the `funding_nudge` A/B test.
For the treatment and control groups, compute user counts, conversion rates
(within 7 days), and the absolute lift: treat_rate − control_rate.
*/

WITH base AS (  -- Aggregate once per group to avoid repeated calculations later
    SELECT 
        [group],                                 -- 'treatment' or 'control'
        COUNT(DISTINCT user_id) AS users,        -- unique users in the group
        SUM(CASE WHEN converted_within_7d = 1 
                 THEN 1 ELSE 0 END) AS converters -- funded within 7 days
    FROM neo.crm_experiments e
    WHERE experiment = 'funding_nudge'
    GROUP BY [group]
),
results AS (  -- Final results with rates and lift calculations
    SELECT
        t.users       AS treat_users,
        t.converters  AS treat_converters,
        c.users       AS control_users,
        c.converters  AS control_converters,
        -- Rates are proportions (0–1). Multiply by 100 in the presentation layer if % is desired.
        CAST(CAST(t.converters AS FLOAT) / NULLIF(t.users,   0) AS DECIMAL(10,2)) * 100  AS treat_rate,
        CAST(CAST(c.converters AS FLOAT) / NULLIF(c.users,   0) AS DECIMAL(10,2)) * 100 AS control_rate,
        CAST( (CAST(t.converters AS FLOAT) / NULLIF(t.users, 0))
            - (CAST(c.converters AS FLOAT) / NULLIF(c.users, 0)) AS DECIMAL(10,2)) * 100 AS incremental_lift
    FROM base t
    JOIN base c
    ON t.[group] = 'treatment' 
    AND c.[group] = 'control'
)
SELECT 
    treat_users, 
    treat_converters, 
    control_users, 
    control_converters,
    treat_rate, 
    control_rate, 
    incremental_lift,
    CAST((treat_rate - control_rate) / control_rate * 100 AS DECIMAL(10,2)) AS relative_lift
FROM 
    results
