# 📘 Data Dictionary — Logistics Analytics Dataset

This dataset represents 1–2 years of logistics operations across multiple regions, drivers, vehicles, and delivery routes.  
Below are the core fields included in the initial dataset (synthetic).

---

## **Deliveries Table**
| Column Name        | Type      | Description |
|--------------------|-----------|-------------|
| delivery_id        | string    | Unique ID for each delivery |
| delivery_date      | date      | Date of the delivery |
| region             | string    | Geographic region of operation |
| location           | string    | Specific distribution center or service area |
| driver_id          | string    | The driver assigned to the delivery |
| vehicle_id         | string    | The vehicle used |
| distance_miles     | float     | Total route distance |
| planned_duration   | float     | Expected delivery duration (minutes) |
| actual_duration    | float     | Actual delivery duration (minutes) |
| delay_minutes      | float     | Delay beyond planned duration |
| on_time            | boolean   | 1 = on time, 0 = delayed |
| delivery_cost      | float     | Estimated cost for the delivery |
| incident_flag      | boolean   | Whether a safety/operational incident occurred |

---

## **Drivers Table**
| Column Name         | Type    | Description |
|---------------------|---------|-------------|
| driver_id           | string  | Unique ID |
| driver_name         | string  | Driver name |
| region              | string  | Assigned region |
| experience_years    | float   | Years of experience |
| license_type        | string  | License classification (A, B, C, etc.) |
| safety_rating       | float   | Score from 1–5 based on incidents/performance |

---

## **Fleet / Vehicles Table**
| Column Name        | Type    | Description |
|--------------------|----------|-------------|
| vehicle_id         | string   | Unique ID |
| vehicle_type       | string   | Truck, Van, Box Truck, etc. |
| mileage_to_date    | float    | Total vehicle mileage |
| last_service_date  | date     | Last maintenance date |
| maintenance_cost_ytd | float  | Year-to-date maintenance cost |

---

## **Route Intelligence (Generated Fields)**
| Feature Name           | Description |
|------------------------|-------------|
| complexity_score        | Based on distance, region, known congestion |
| seasonal_bucket         | Season or quarter of year |
| risk_factor             | Combined indicator of incidents & delays |
| driver_performance_idx  | Model-based score per driver |

---

This dictionary will grow as feature engineering progresses.
