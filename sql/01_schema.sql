-- 01_schema.sql
-- Core tables for the logistics analytics project

-- Drop tables if they already exist (optional, depends on DB)
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS vehicles;

-- Deliveries table
CREATE TABLE deliveries (
    delivery_id        VARCHAR(50) PRIMARY KEY,
    delivery_date      DATE NOT NULL,
    region             VARCHAR(100),
    location           VARCHAR(150),
    driver_id          VARCHAR(50),
    vehicle_id         VARCHAR(50),
    distance_miles     DECIMAL(10, 2),
    planned_duration   DECIMAL(10, 2), -- minutes
    actual_duration    DECIMAL(10, 2), -- minutes
    delay_minutes      DECIMAL(10, 2),
    on_time            BOOLEAN,
    delivery_cost      DECIMAL(12, 2),
    incident_flag      BOOLEAN
);

-- Drivers table
CREATE TABLE drivers (
    driver_id         VARCHAR(50) PRIMARY KEY,
    driver_name       VARCHAR(150),
    region            VARCHAR(100),
    experience_years  DECIMAL(4, 1),
    license_type      VARCHAR(20),
    safety_rating     DECIMAL(3, 2)   -- 1.00–5.00
);

-- Vehicles / Fleet table
CREATE TABLE vehicles (
    vehicle_id           VARCHAR(50) PRIMARY KEY,
    vehicle_type         VARCHAR(50),
    mileage_to_date      DECIMAL(12, 2),
    last_service_date    DATE,
    maintenance_cost_ytd DECIMAL(12, 2)
);
