-- 1. Create a CTE to calculate service statistics, then query from it.
WITH service_stats AS (
    SELECT 
        sw.service,
        SUM(sw.patients_admitted) AS total_admitted,
        SUM(sw.patients_refused) AS total_refused,
        ROUND(AVG(sw.patient_satisfaction),2) AS avg_satisfaction,
        ROUND(AVG(sw.staff_morale),2) AS avg_staff_morale
    FROM services_weekly sw
    GROUP BY sw.service
)
SELECT *
FROM service_stats;


-- 2. Use multiple CTEs to break down a complex query into logical steps.
WITH service_totals AS (
    SELECT 
        service,
        SUM(patients_admitted) AS total_admitted
    FROM services_weekly
    GROUP BY service
),
overall_avg AS (
    SELECT 
        AVG(total_admitted) AS avg_admitted
    FROM service_totals
)
SELECT 
    st.service,
    st.total_admitted,
    st.total_admitted - oa.avg_admitted AS diff_from_avg,
    CASE
        WHEN st.total_admitted > oa.avg_admitted THEN 'Above Average'
        WHEN st.total_admitted = oa.avg_admitted THEN 'Average'
        ELSE 'Below Average'
    END AS rank_indicator
FROM service_totals st
JOIN overall_avg oa
ORDER BY st.total_admitted DESC;


-- 3. Build a CTE for staff utilization and join it with patient data.


-- Daily Challenge  
/*Create a comprehensive hospital performance dashboard using CTEs. Calculate: 
1) Service-level metrics (total admissions, refusals, avg satisfaction), 
2) Staff metrics per service (total staff, avg weeks present), 
3) Patient demographics per service (avg age, count). 
Then combine all three CTEs to create a final report showing service name, all calculated metrics, 
and an overall performance score (weighted average of admission rate and satisfaction). Order by performance score descending. */

WITH service_stats AS (
    SELECT 
        service,
        SUM(patients_admitted) AS total_admitted,
        SUM(patients_refused) AS total_refused,
        ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction
    FROM services_weekly
    GROUP BY service
),
staff_metrics AS (
    SELECT
        service,
        COUNT(DISTINCT staff_name) AS total_staff,
        AVG(total_weeks_present) AS avg_weeks_present
    FROM (
        SELECT
            service, staff_name,
            SUM(present) AS total_weeks_present
        FROM staff_schedule
        GROUP BY service, staff_name
    ) AS t
    GROUP BY service
),
patient_metrics AS (
	SELECT
		service,
		ROUND(AVG(age),2) AS avg_age,
        COUNT(DISTINCT patient_id) AS total_patients
        FROM patients
        GROUP BY service
        )

SELECT 
	ss.service, ss.total_admitted, ss.total_refused, ss.avg_satisfaction,
    sm.total_staff, sm.avg_weeks_present,
    pm.avg_age, pm.total_patients,
	ROUND((ss.total_admitted * 100.0 / (ss.total_admitted + ss.total_refused)),2) AS admission_rate,
    ROUND(ss.avg_satisfaction,2) AS satisfaction_score,
    ROUND((
        (ss.total_admitted * 100.0 / (ss.total_admitted + ss.total_refused)) 
        +
        ss.avg_satisfaction
    ) / 2,2) AS performance_score
FROM service_stats ss
LEFT JOIN staff_metrics sm ON ss.service  = sm.service
LEFT JOIN patient_metrics pm ON ss.service = pm.service
ORDER BY performance_score DESC;
