/* Task: Calculate churn rate if no event in the last 30 days */

DECLARE @today DATE = CAST(GETDATE() AS DATE);
DECLARE @cutoff DATE = DATEADD(DAY, -30, @today);


WITH last_activity AS (
    SELECT 
        u.user_id,
        u.install_time,
        MAX(e.event_time) AS last_date 
    FROM 
        neo.users u
    LEFT JOIN 
        neo.events e 
    ON u.user_id = e.user_id
    AND e.event_time < DATEADD(DAY, 1, @today) -- guard timezone and future stamps
    GROUP BY u.user_id, u.install_time
),
eligible AS (
    SELECT 
        *
    FROM last_activity
    WHERE DATEDIFF(DAY, install_time, @today) >=30
),
results AS (
    SELECT 
        COUNT(*) AS total_eligible_users,
        SUM(CASE WHEN COALESCE(last_date, install_time) < @cutoff THEN 1 ELSE 0 END) AS churned_30d
    FROM 
        eligible
)
SELECT 
    total_eligible_users,
    churned_30d,
    CAST(CAST(churned_30d AS FLOAT) / NULLIF(total_eligible_users, 0) AS DECIMAL(6, 3)) AS churn_rate_30d
FROM 
    results
