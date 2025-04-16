-- 6. Top Airlines with the Most Communication Errors
-- Business Context: Identify which airlines (not just aircraft) have the most issues.
-- Useful for customer support, SLA monitoring, or prioritizing engineering efforts.

SELECT 
    e.airline_name,
    COUNT(*) AS error_count
FROM aircraft_logs l
JOIN aircraft_metadata_enriched e ON l.aircraft_id = e.aircraft_id
WHERE l.error_code != 0
GROUP BY e.airline_name
ORDER BY error_count DESC
LIMIT 5;


-- 7. Hub Airports with Highest Volume of Weak Signals
-- Business Context: Determine which major airline hubs are affected by low signal quality.
-- Helps drive infrastructure upgrades or focused root cause investigations.

SELECT 
    e.hub,
    COUNT(*) AS weak_signal_count
FROM aircraft_logs l
JOIN aircraft_metadata_enriched e ON l.aircraft_id = e.aircraft_id
WHERE l.signal_strength < -90
GROUP BY e.hub
ORDER BY weak_signal_count DESC;


-- 8. Average Response Time by Fleet Size Category
-- Business Context: Examine if larger airlines are experiencing delays compared to smaller ones.
-- Supports load balancing, fairness in service provisioning, or tiered alerting.

SELECT 
    e.airline_name,
    e.fleet_size,
    ROUND(AVG(l.response_time), 2) AS avg_response_time
FROM aircraft_logs l
JOIN aircraft_metadata_enriched e ON l.aircraft_id = e.aircraft_id
GROUP BY e.airline_name, e.fleet_size
ORDER BY avg_response_time DESC;


-- 9. Region vs Model Defect Patterns
-- Business Context: Pinpoint regional and aircraft model combinations with frequent issues.
-- Can guide technician training, documentation updates, or model recall assessments.

SELECT 
    l.region,
    e.model,
    COUNT(*) AS error_events
FROM aircraft_logs l
JOIN aircraft_metadata_enriched e ON l.aircraft_id = e.aircraft_id
WHERE l.error_code != 0
GROUP BY l.region, e.model
ORDER BY error_events DESC
LIMIT 10;


-- 10. Aircraft with Weak Signals and Frequent Errors
-- Business Context: Identify critical aircraft that experience both poor signal and error rates.
-- Use to recommend proactive maintenance or inspection.

SELECT 
    l.aircraft_id,
    COUNT(CASE WHEN l.signal_strength < -90 THEN 1 END) AS weak_signals,
    COUNT(CASE WHEN l.error_code != 0 THEN 1 END) AS errors
FROM aircraft_logs l
GROUP BY l.aircraft_id
HAVING weak_signals > 5 AND errors > 3
ORDER BY errors DESC, weak_signals DESC;
