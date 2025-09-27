/* Task: Kyc pass rate & FTD rate (overall and by device) */

SELECT 
   u.device,
   COUNT(DISTINCT u.user_id) AS total_installs,
   COUNT(u.kyc_verified_at) AS total_verfied,  -- COUNT ignores NULLs
   COUNT(u.first_funding_at) AS total_ftd,
   CAST(100.0 * COUNT(u.kyc_verified_at)/ NULLIF(COUNT(DISTINCT u.user_id),0) AS DECIMAL(10,2)) AS kyc_pass_rate_pct,
   CAST(100.0 * COUNT(u.first_funding_at)/ NULLIF(COUNT(u.kyc_verified_at),0) AS DECIMAL(10,2)) AS ftd_rate_pct
   FROM 
    neo.users u  
GROUP BY 
    u.device
