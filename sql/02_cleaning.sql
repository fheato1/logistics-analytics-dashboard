-- 02_cleaning.sql
-- Create a cleaned view of deliveries with derived fields

DROP VIEW IF EXISTS deliveries_clean;

CREATE VIEW deliveries_clean AS
SELECT
    d.delivery_id,
    d.delivery_date,
    UPPER(TRIM(d.region))         AS region,
    TRIM(d.location)              AS location,
    d.driver_id,
    d.vehicle_id,
    d.distance_miles,
    d.planned_duration,
    d.actual_duration,
    COALESCE(d.delay_minutes, 0)  AS delay_minutes,
    -- If on_time is null, treat delayed if delay_minutes > 0
    CASE 
        WHEN d.on_time IS NOT NULL THEN d.on_time
        WHEN COALESCE(d.delay_minutes, 0) > 0 THEN FALSE
        ELSE TRUE
    END                           AS on_time,
    d.delivery_cost,
    d.incident_flag,
    -- Derived fields
    CASE 
        WHEN d.distance_miles > 0 
             THEN d.delivery_cost / d.distance_miles
        ELSE NULL
    END                           AS cost_per_mile,
    CASE 
        WHEN d.planned_duration > 0 
             THEN d.actual_duration - d.planned_duration
        ELSE d.delay_minutes
    END                           AS computed_delay
FROM deliveries d;
