-- 03_kpi_views.sql
-- KPI-level views for regions, drivers, and fleet

DROP VIEW IF EXISTS kpi_region_summary;
DROP VIEW IF EXISTS kpi_driver_summary;
DROP VIEW IF EXISTS kpi_vehicle_summary;

-- Regional KPIs
CREATE VIEW kpi_region_summary AS
SELECT
    dc.region,
    COUNT(*)                              AS total_deliveries,
    SUM(CASE WHEN dc.on_time THEN 1 ELSE 0 END) AS on_time_deliveries,
    AVG(CASE WHEN dc.on_time THEN 1.0 ELSE 0.0 END) AS on_time_rate,
    AVG(dc.delay_minutes)                 AS avg_delay_minutes,
    AVG(dc.cost_per_mile)                 AS avg_cost_per_mile,
    SUM(CASE WHEN dc.incident_flag THEN 1 ELSE 0 END) AS total_incidents
FROM deliveries_clean dc
GROUP BY dc.region;

-- Driver KPIs
CREATE VIEW kpi_driver_summary AS
SELECT
    dr.driver_id,
    dr.driver_name,
    dr.region,
    dr.experience_years,
    dr.license_type,
    dr.safety_rating,
    COUNT(dc.delivery_id)                                         AS total_deliveries,
    AVG(CASE WHEN dc.on_time THEN 1.0 ELSE 0.0 END)               AS on_time_rate,
    AVG(dc.delay_minutes)                                         AS avg_delay_minutes,
    AVG(dc.cost_per_mile)                                         AS avg_cost_per_mile,
    SUM(CASE WHEN dc.incident_flag THEN 1 ELSE 0 END)             AS total_incidents,
    CASE 
        WHEN COUNT(dc.delivery_id) > 0 THEN 
            (AVG(CASE WHEN dc.on_time THEN 1.0 ELSE 0.0 END) * 0.5) +
            ((1 - (COALESCE(SUM(CASE WHEN dc.incident_flag THEN 1 ELSE 0 END),0) 
                 / NULLIF(COUNT(dc.delivery_id),0)::DECIMAL)) * 0.3) +
            (LEAST(dr.experience_years, 10) / 10.0 * 0.2)
        ELSE NULL
    END                                                           AS driver_performance_index
FROM drivers dr
LEFT JOIN deliveries_clean dc
    ON dr.driver_id = dc.driver_id
GROUP BY 
    dr.driver_id, dr.driver_name, dr.region, 
    dr.experience_years, dr.license_type, dr.safety_rating;

-- Vehicle / Fleet KPIs
CREATE VIEW kpi_vehicle_summary AS
SELECT
    v.vehicle_id,
    v.vehicle_type,
    v.mileage_to_date,
    v.last_service_date,
    v.maintenance_cost_ytd,
    COUNT(dc.delivery_id)                                 AS total_deliveries,
    AVG(dc.cost_per_mile)                                 AS avg_cost_per_mile,
    AVG(CASE WHEN dc.on_time THEN 1.0 ELSE 0.0 END)       AS on_time_rate,
    SUM(CASE WHEN dc.incident_flag THEN 1 ELSE 0 END)     AS total_incidents
FROM vehicles v
LEFT JOIN deliveries_clean dc
    ON v.vehicle_id = dc.vehicle_id
GROUP BY
    v.vehicle_id, v.vehicle_type, v.mileage_to_date, 
    v.last_service_date, v.maintenance_cost_ytd;
