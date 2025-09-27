/* Task: Attribute cohort revenue occuring withing 60days of install to the acquisition campaign and caluculate ROAS */

DECLARE @lookback_days INT = 60;
DECLARE @today DATE  = CAST(GETDATE() AS DATE);
DECLARE @cohort_start DATE = DATEADD(DAY, 1 - @lookback_days, @today);  -- inclusive of today

WITH acq  AS (
    -- Cohort of users who installed in the last full 60 days
    SELECT
        u.user_id,
        u.campaign_id,
        u.install_time
    FROM
        neo.users u     
    WHERE 
        u.install_time >= @cohort_start
    AND
        u.install_time < DATEADD(DAY, 1 , @today)
),
rev_60d AS (
    -- revenue within 60 days of install
    SELECT 
        a.campaign_id,
        COUNT(DISTINCT a.user_id) AS users,
        COALESCE(SUM(r.margin), 0) AS revenue_60d
    FROM
        acq a
    LEFT JOIN 
        neo.revenue r ON r.user_id = a.user_id
    AND 
        r.txn_time >= a.install_time
    AND 
        r.txn_time < DATEADD(DAY, @lookback_days, a.install_time)  -- within 60 days of install
    GROUP BY
        a.campaign_id
),
spend_60d AS (
    -- spend within the same calendar window as the cohorts
    SELECT 
        s.campaign_id,
        SUM(s.spend) AS spend_60d
    FROM
        neo.spend s
    WHERE 
        s.date >= @cohort_start
    AND
        s.date < DATEADD(DAY, 1, @today)
    GROUP BY 
        s.campaign_id
)
SELECT
    r.campaign_id,
    r.users,
    r.revenue_60d AS revenue,
    COALESCE(s.spend_60d, 0) AS spend,
    CAST(ROUND((r.revenue_60d/NULLIF(s.spend_60d,0)),2) AS DECIMAL(12,2)) AS roas_60d
FROM 
    rev_60d r  
LEFT JOIN
    spend_60d s ON s.campaign_id = r.campaign_id
ORDER BY 
    roas_60d DESC

