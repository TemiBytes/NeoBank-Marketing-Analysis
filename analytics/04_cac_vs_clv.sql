
/* Task: CLV- average margin per user over 60days since install  (CLV vs CAC by channel)*/

WITH acq AS (
    SELECT 
        user_id,
        channel,
        install_time AS cohort_date
    FROM 
        neo.users
),
margin_60d  AS (
    SELECT
        a.user_id,
        a.channel,
        SUM(r.margin) AS total_margin_60d
    FROM 
        acq a
    LEFT JOIN 
        neo.revenue r 
    ON 
        a.user_id = r.user_id
    WHERE 
        r.txn_time >= a.cohort_date
        AND r.txn_time < DATEADD(DAY, 61, a.cohort_date) -- 60days including install day
    GROUP BY 
        a.user_id,
        a.channel
),
clv AS (
    SELECT 
        channel,
        AVG(total_margin_60d) AS clv_60d
    FROM 
        margin_60d
    GROUP BY 
        channel
),
cac AS (
    SELECT 
        c.channel,
        SUM(s.spend) / NULLIF(COUNT(DISTINCT u.user_id), 0 ) AS cac_verified
    FROM 
        neo.users u  
    LEFT JOIN 
        neo.campaigns c ON c.campaign_id = u.campaign_id
    LEFT JOIN 
        neo.spend s ON s.campaign_id = u.campaign_id 
        AND s.date = u.install_time
    WHERE u.kyc_verified_at IS NOT NULL
    GROUP BY c.channel
)
SELECT 
    clv.channel,
    clv.clv_60d,
    cac.cac_verified,
    CAST(clv.clv_60d / NULLIF(cac.cac_verified,0) AS DECIMAL(10,2)) AS clv_cac_ratio
FROM 
    clv  
LEFT JOIN 
    cac 
ON  
    cac.channel = clv.channel
ORDER BY clv_cac_ratio DESC;
