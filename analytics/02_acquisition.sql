/* Task: For the last 60 days of installs, show installs, verified, and FTD by campaign, with step-conversion rates */

WITH cohort_60d AS ( 
    SELECT
        user_id,
        campaign_id,
        install_time,
        kyc_verified_at,
        first_funding_at
    FROM neo.users 
    /* Use midnight today minus 59 to include today as day 60 (inclusive window). */
    WHERE install_time >= DATEADD(DAY, -59, CAST(GETDATE() AS DATE))
),
agg AS (  -- Aggregate by campaign  
    SELECT
        c.campaign_id,
        COUNT(*)                         AS installs,
        COUNT(c.kyc_verified_at)         AS verified,     -- COUNT ignores NULLs
        COUNT(c.first_funding_at)        AS ftd
    FROM cohort_60d AS c
    GROUP BY c.campaign_id
),
rates AS (  -- Compute numeric percentages
    SELECT
        a.*,
        CAST(100.0 * a.verified / NULLIF(a.installs,  0) AS DECIMAL(6,2)) AS kyc_rate_pct,   -- install -> verified
        CAST(100.0 * a.ftd      / NULLIF(a.verified, 0) AS DECIMAL(6,2)) AS ftd_rate_pct,    -- verified -> FTD
        CAST(100.0 * a.ftd      / NULLIF(a.installs, 0) AS DECIMAL(6,2)) AS install_to_ftd_pct -- overall (optional)
    FROM agg AS a
)
SELECT
    r.campaign_id,
    r.installs,
    r.verified,
    r.ftd,
    CONCAT(COALESCE(r.kyc_rate_pct,0), '%')        AS kyc_rate,          -- adds % to the value
    CONCAT(COALESCE(r.ftd_rate_pct,0), '%')        AS ftd_rate,
    CONCAT(COALESCE(r.install_to_ftd_pct,0), '%')  AS install_to_ftd_rate
FROM rates AS r
ORDER BY
    r.kyc_rate_pct DESC;   -- sort numerically
