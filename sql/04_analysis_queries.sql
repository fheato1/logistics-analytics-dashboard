-- 04_analysis_queries.sql
-- Example analytical queries for the logistics dataset

-- 1. Top 10 drivers by performance index
SELECT
    driver_name,
    region,
    total_deliveries,
    on_time_rate,
    total_incidents,
    driver_performance_index
FROM kpi_driver_summary
ORDER BY driver_performance_index DESC NULLS LAST
LIMIT 10;

-- 2. Regions ranked by on-time delivery performance
SELECT
    region,
    total_deliveries,
    on_time_rate,
    avg_delay_minutes,
    avg_cost_per_mile,
    total_incidents
FROM kpi_region_summary
ORDER BY on_time_rate DESC;

-- 3. Vehicles with highest incident counts
SELECT
    vehicle_id,
    vehicle_type,
    total_deliveries,
    total_incidents,
    on_time_rate,
    avg_cost_per_mile
FROM kpi_vehicle_summary
ORDER BY total_incidents DESC
LIMIT 10;

-- 4. Monthly trend of on-time delivery rate
SELECT
    DATE_TRUNC('month', delivery_date) AS month,
    COUNT(*)                                       AS total_deliveries,
    AVG(CASE WHEN on_time THEN 1.0 ELSE 0.0 END)   AS on_time_rate
FROM deliveries_clean
GROUP BY DATE_TRUNC('month', delivery_date)
ORDER BY month;

-- 5. High-risk routes: combinations of region + location with above-average incidents
SELECT
    region,
    location,
    COUNT(*)                                  AS total_deliveries,
    SUM(CASE WHEN incident_flag THEN 1 ELSE 0 END) AS total_incidents,
    AVG(CASE WHEN incident_flag THEN 1.0 ELSE 0.0 END) AS incident_rate
FROM deliveries_clean
GROUP BY region, location
HAVING COUNT(*) >= 50  -- only look at routes with decent volume
ORDER BY incident_rate DESC;
