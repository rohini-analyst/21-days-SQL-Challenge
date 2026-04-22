-- 1. Rank patients by satisfaction score within each service.
SELECT 
	name, 
	RANK() OVER (PARTITION BY service ORDER BY satisfaction) AS satisfaction_rank
FROM patients;

-- 2. Assign row numbers to staff ordered by their name.
SELECT 
	staff_id, staff_name,
	ROW_NUMBER() OVER(ORDER BY staff_name) AS s_no
FROM staff;

-- 3. Rank services by total patients admitted.
SELECT 
	service, 
	SUM(patients_admitted) AS total_patients_admitted,
    RANK() OVER(ORDER BY SUM(patients_admitted) DESC) as ranks
FROM services_weekly GROUP BY service;

-- Daily Challenge  
/*  For each service, rank the weeks by patient satisfaction score (highest first). 
Show service, week, patient_satisfaction, patients_admitted, and the rank. Include only the top 3 weeks per service.*/

SELECT * FROM (
SELECT 
	service, week, patient_satisfaction, patients_admitted,
	RANK() OVER(partition by service ORDER BY patient_satisfaction DESC) as patient_satisfaction_ranking
FROM services_weekly
) AS temp
WHERE patient_satisfaction_ranking <= 3;
