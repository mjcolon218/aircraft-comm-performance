-- 1. Average Response Time by Region
-- Business Context: Identify which regions have slower communication performance.
-- Helps prioritize RF coverage improvements or system audits.

SELECT 
    region, 
    ROUND(AVG(response_time), 2) AS avg_response_time
FROM aircraft_logs
GROUP BY region
ORDER BY avg_response_time DESC;


-- 2. Top 5 Aircraft with Most Errors
-- Business Context: Pinpoint specific aircraft that frequently encounter communication issues.
-- Could indicate equipment malfunctions or model-specific vulnerabilities.

SELECT 
    aircraft_id, 
    COUNT(*) AS error_count
FROM aircraft_logs
WHERE error_code != 0
GROUP BY aircraft_id
ORDER BY error_count DESC
LIMIT 5;


-- 3. Model-Level Error Analysis (Join with Metadata)
-- Business Context: Understand if certain aircraft models are more prone to failure.
-- Useful for fleet maintenance, reporting, and manufacturer collaboration.

SELECT 
    m.model,
    COUNT(*) AS error_events,
    ROUND(AVG(l.signal_strength), 2) AS avg_signal_strength
FROM aircraft_logs l
JOIN aircraft_metadata m ON l.aircraft_id = m.aircraft_id
WHERE l.error_code != 0
GROUP BY m.model
ORDER BY error_events DESC;


-- 4. System Weak Points: Signal vs. RF Coverage
-- Business Context: Tie communication failures to infrastructure issues (not aircraft).
-- Helps prioritize ground system upgrades in low-coverage regions.

SELECT 
    l.region,
    z.coverage_quality,
    COUNT(*) AS total_logs,
    SUM(CASE WHEN l.signal_strength < -90 THEN 1 ELSE 0 END) AS weak_signals
FROM aircraft_logs l
JOIN rf_coverage_zones z ON l.region = z.region
GROUP BY l.region, z.coverage_quality
ORDER BY weak_signals DESC;


-- 5. Most Common Errors with Severity (Join with Error Codes)
-- Business Context: Understand which failures are most common and most severe.
-- Prioritizes engineering response and improves monitoring systems.

SELECT 
    l.error_code,
    e.description,
    e.severity,
    COUNT(*) AS occurrences
FROM aircraft_logs l
JOIN error_codes e ON l.error_code = e.error_code
WHERE l.error_code != 0
GROUP BY l.error_code, e.description, e.severity
ORDER BY occurrences DESC;
