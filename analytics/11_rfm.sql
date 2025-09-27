/* Task: RFM Segmentation */

WITH rfm AS (
    SELECT 
        u.user_id,
        MAX(COALESCE(e.event_time, u.install_time)) AS last_event,
        COUNT(e.user_id) AS frequency,
        SUM(COALESCE(r.margin, 0)) AS monetary,
        DATEDIFF(DAY, MAX(COALESCE(e.event_time, u.install_time)), CAST(GETDATE() AS DATE)) AS recency
    FROM 
        neo.users u
    LEFT JOIN 
        neo.events e ON u.user_id = e.user_id
    LEFT JOIN 
        neo.revenue r ON u.user_id = r.user_id
    GROUP BY 
        u.user_id
),
rfm_scores AS (
    SELECT 
        user_id,
        recency,
        frequency,
        monetary,
        NTILE(5) OVER(ORDER BY recency ) AS recency_score,
        NTILE(5) OVER(ORDER BY frequency ) AS frequency_score,
        NTILE(5) OVER(ORDER BY monetary) AS monetary_score
    FROM 
        rfm
)
SELECT 
    *
FROM 
    rfm_scores
ORDER BY
    recency_score DESC,
    frequency_score DESC,
    monetary_score DESC;
