-- 1. Show each patient with their service's average satisfaction as an additional column.

SELECT 
    p.name, p.service, s.avg_satisfaction
FROM patients p
JOIN (
    SELECT service, ROUND(AVG(satisfaction),2) AS avg_satisfaction
    FROM patients
    GROUP BY service
) s 
ON p.service = s.service;

-- 2. Create a derived table of service statistics and query from it.

SELECT 
    service,
    total_admitted, total_refused, total_requested, admission_rate, avg_satisfaction
FROM (
    SELECT
        service,
        SUM(patients_admitted) AS total_admitted,
        SUM(patients_refused) AS total_refused,
        SUM(patients_request) AS total_requested,
        ROUND(AVG(patient_satisfaction),2) AS avg_satisfaction,
        AVG(staff_morale) AS avg_staff_morale,
        ROUND(
            SUM(patients_admitted)/SUM(patients_request),2
        ) AS admission_rate
    FROM services_weekly
    GROUP BY service
) AS service_stats;


-- 3. Display staff with their service's total patient count as a calculated field.
SELECT 
    s.staff_id, s.staff_name, s.role, s.service,
    (SELECT COUNT(*)
        FROM patients p
        WHERE p.service = s.service) AS service_patient_count
FROM
    staff s;

-- Daily Challenge  
/* Create a report showing each service with: service name, total patients admitted, the difference between their total admissions 
and the average admissions across all services, and a rank indicator ('Above Average', 'Average', 'Below Average'). 
Order by total patients admitted descending.*/

SELECT 
    ss.service, ss.total_admitted,
    ss.total_admitted - ss.avg_admitted AS diff_from_avg,
    CASE
        WHEN ss.total_admitted > ss.avg_admitted THEN 'Above Average'
        WHEN ss.total_admitted = ss.avg_admitted THEN 'Average'
        ELSE 'Below Average'
    END AS rank_indicator
FROM
    (SELECT service,
            SUM(patients_admitted) AS total_admitted,
            (SELECT AVG(total) FROM
                    (SELECT 
                    SUM(patients_admitted) AS total
                FROM services_weekly
                GROUP BY service) AS x) AS avg_admitted
    FROM services_weekly
    GROUP BY service) AS ss
ORDER BY ss.total_admitted DESC;
