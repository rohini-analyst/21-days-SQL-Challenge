-- 1. Join patients, staff, and staff_schedule to show patient service and staff availability.
SELECT 
    p.patient_id,
    p.name,
    p.age,
    p.service,
    s.staff_name,
    s.role,
    COALESCE(COUNT(ss.present), 0) AS present_cnt
FROM
    patients p
JOIN
    staff s ON p.service = s.service
LEFT JOIN
    staff_schedule ss ON s.staff_id = ss.staff_id
GROUP BY p.patient_id , p.name , p.age , p.service , s.staff_name , s.role;

-- 2. Combine services_weekly with staff and staff_schedule for comprehensive service analysis.

SELECT 
    sw.service,
    sw.week,
    sw.month,
    sw.available_beds,
    sw.patients_request,
    sw.patients_admitted,
    sw.patients_refused,
    sw.patient_satisfaction,
    sw.staff_morale,
    sw.event,
    s.staff_id,
    s.staff_name,
    s.role,
    ss.present
FROM
    services_weekly sw
    LEFT JOIN
    staff s ON sw.service = s.service
	LEFT JOIN
    staff_schedule ss ON s.staff_id = ss.staff_id;

-- 3. Create a multi-table report showing patient admissions with staff information.
SELECT 
    sw.service,
    sw.patients_request,
    sw.patients_admitted,
    sw.patients_refused,
    s.staff_id,
    s.staff_name,
    s.role,
    COUNT(p.patient_id) AS total_patients
FROM
    services_weekly sw
        JOIN
    staff s ON sw.service = s.service
        JOIN
    patients p ON p.service = sw.service
GROUP BY sw.service , sw.patients_request , sw.patients_admitted , sw.patients_refused , s.staff_id , s.staff_name , s.role;


-- Daily Challenge  

/*Create a comprehensive service analysis report for week 20 showing: service name, total patients admitted that week, total patients refused, 
average patient satisfaction, count of staff assigned to service, and count of staff present that week. Order by patients admitted descending. */

SELECT 
    sw.service,
    sw.patients_admitted,
    sw.patients_refused,
    ROUND(AVG(sw.patient_satisfaction)) AS avg_patient_satisfaction,
    COUNT(ss.staff_id) AS total_staff_assigned,
    COUNT(CASE WHEN ss.present = 1 THEN 1 END) AS staff_present
FROM  services_weekly sw
LEFT JOIN staff s ON s.service = sw.service
LEFT JOIN staff_schedule ss ON ss.staff_id = s.staff_id AND ss.week = sw.week
WHERE sw.week = 20
GROUP BY sw.service,sw.patients_admitted,sw.patients_refused
ORDER BY sw.patients_admitted DESC;
