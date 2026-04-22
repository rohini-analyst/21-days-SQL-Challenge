-- 1. Categorise patients as 'High', 'Medium', or 'Low' satisfaction based on their scores.
SELECT 
	patient_id, name, satisfaction,
	CASE 	
		WHEN satisfaction BETWEEN 60 AND 70 THEN 'Low'
		WHEN satisfaction BETWEEN 71 AND 85 THEN 'Medium'
		WHEN satisfaction BETWEEN 86 AND 99 THEN 'High'
	END AS satisfaction_category
FROM patients;

-- 2. Label staff roles as 'Medical' or 'Support' based on role type.
SELECT 
    staff_name, role,
    CASE
        WHEN role = 'Doctor' OR role = 'Nurse' THEN 'Medical'
        ELSE 'Support'
    END AS role_type
FROM staff;

-- 3. Create age groups for patients (0-18, 19-40, 41-65, 65+).
SELECT 
    name, age,
    CASE
        WHEN age BETWEEN 0 AND 18 THEN 'Child'
        WHEN age BETWEEN 19 AND 40 THEN 'Young Adult'
        WHEN age BETWEEN 41 AND 65 THEN 'Middle-aged'
        ELSE 'Elderly'
    END AS age_category
FROM patients;

-- Daily Challenge  
/* Create a service performance report showing service name, total patients admitted, and a performance category based on the following: 
'Excellent' if avg satisfaction >= 85, 'Good' if >= 75, 'Fair' if >= 65, otherwise 'Needs Improvement'. 
Order by average satisfaction descending. */

SELECT 
    service, 
    SUM(patients_admitted) AS total_patients_admitted,
    ROUND(AVG(patient_satisfaction)) AS avg_satisfaction,
    CASE
		WHEN ROUND(AVG(patient_satisfaction)) >= 85 THEN 'Excellent'
		WHEN ROUND(AVG(patient_satisfaction))  >= 75 THEN 'Good'
		WHEN ROUND(AVG(patient_satisfaction))  >= 65 THEN 'Fair'
		ELSE 'Needs Improvement'
    END AS performance_category
FROM services_weekly
GROUP BY service
ORDER BY avg_satisfaction DESC;
