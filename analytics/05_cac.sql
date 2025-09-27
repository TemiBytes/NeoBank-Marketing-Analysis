/* Task: Compute CAC at Verified and FTD levels by channel in the last 60 days. */

WITH cohort_60d AS (
    SELECT
        u.user_id,
        u.channel,
        u.install_time AS cohort_date,
        u.kyc_verified_at,
        u.first_funding_at
    FROM
        neo.users u  
    WHERE 
        u.install_time >= DATEADD(DAY, -59, CAST(GETDATE() AS DATE)) -- last 60 days including today
)
, agg_users AS (
    SELECT
        c.channel,
        COUNT(DISTINCT c.user_id) AS no_of_customers,
        COUNT(c.kyc_verified_at) AS verified,
        COUNT(c.first_funding_at) AS ftd
    FROM
        cohort_60d c
    GROUP BY c.channel
),
agg_spend AS (
    SELECT
        ca.channel,
        SUM(s.spend) AS total_spend
    FROM 
        neo.spend s
    INNER JOIN 
        neo.campaigns ca ON ca.campaign_id = s.campaign_id
    WHERE 
        s.date >= DATEADD(DAY, -59, CAST(GETDATE() AS DATE))
    GROUP BY ca.channel
)
SELECT 
    au.channel,
    au.no_of_customers,
    au.verified,
    au.ftd,
    ags.total_spend,
    ROUND((ags.total_spend/ au.no_of_customers),2) AS cac,
    ROUND((ags.total_spend/NULLIF(au.verified,0)),2) AS cac_verified,
    ROUND((ags.total_spend/NULLIF(au.ftd,0)),2) AS cac_ftd
FROM 
    agg_users au
LEFT JOIN 
    agg_spend ags ON ags.channel = au.channel
ORDER BY 
    total_spend DESC
