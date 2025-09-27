/* 
Query Purpose:
---------------
For all user cohorts acquired in the past 60 days, calculate retention rates.
Specifically, compute the percentage of users who were active on:
 - Day 1 after install (D1 retention)
 - Day 7 after install (D7 retention)
 - Day 30 after install (D30 retention)

Activity is defined as performing one of these events:
'app_open', 'transfer_success', or 'card_payment_success'.
*/

DECLARE @lookback_days INT = 60;
DECLARE @today DATE = CAST(GETDATE() AS DATE);
DECLARE @cohort_start DATE = DATEADD(DAY, 1 - @lookback_days, @today);  -- window start (60 days ago, inclusive of today)

WITH cohort_60d AS (   -- 1. Define cohorts (users who installed in last 60 days)
    SELECT
        u.user_id,
        u.install_time AS cohort_date
    FROM neo.users u  
    WHERE u.install_time >= @cohort_start
      AND u.install_time < DATEADD(DAY, 1, @today)
),

active_customers AS (   -- 2. Capture active users by event activity
    SELECT
        e.user_id,
        CAST(e.event_time AS DATE) AS e_date
    FROM neo.events e
    WHERE e.event_name IN ('app_open','transfer_success','card_payment_success')
      AND e.event_time >= @cohort_start
      AND e.event_time < DATEADD(DAY, 1, @today)
)

-- 3. Calculate retention percentages for each cohort date
SELECT
    c.cohort_date,
    COUNT(*) AS users,
    CAST(COUNT(CASE WHEN a.e_date = DATEADD(DAY, 1, c.cohort_date) THEN a.user_id END) AS FLOAT) * 100 
        / NULLIF(COUNT(*), 0) AS D1_retention,
    CAST(COUNT(CASE WHEN a.e_date = DATEADD(DAY, 7, c.cohort_date) THEN a.user_id END) AS FLOAT) * 100 
        / NULLIF(COUNT(*), 0) AS D7_retention,
    CAST(COUNT(CASE WHEN a.e_date = DATEADD(DAY, 30, c.cohort_date) THEN a.user_id END) AS FLOAT) * 100 
        / NULLIF(COUNT(*), 0) AS D30_retention
FROM cohort_60d c  
LEFT JOIN active_customers a  
    ON c.user_id = a.user_id 
GROUP BY c.cohort_date;
