/* Task: Calculate ARPMAU (Average Revenue Per Monthly Active User) */


WITH monthly_revenue AS (
    SELECT
        FORMAT(r.txn_time, 'yyyy-MM') AS revenue_month,
        SUM(COALESCE(r.margin, 0)) AS margin
    FROM 
        neo.revenue r
    GROUP BY 
        FORMAT(r.txn_time, 'yyyy-MM')
),
mau AS (
    SELECT 
        FORMAT(event_time, 'yyyy-MM') AS event_month,
        COUNT(DISTINCT user_id) AS monthly_active_users
    FROM 
        neo.events 
    WHERE event_time IS NOT NULL
    GROUP BY 
        FORMAT(event_time, 'yyyy-MM')
)
SELECT 
    mr.revenue_month AS ym,
    mr.margin,
    m.monthly_active_users,
    CAST((CAST(mr.margin AS FLOAT) / NULLIF(m.monthly_active_users, 0)) AS DECIMAL(10,2)) AS arp_mau
FROM 
    monthly_revenue mr
LEFT JOIN  
    mau m ON mr.revenue_month = m.event_month
ORDER BY ym DESC;

