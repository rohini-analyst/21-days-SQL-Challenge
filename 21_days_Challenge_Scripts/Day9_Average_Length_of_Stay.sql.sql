-- 1. Extract the year from all patient arrival dates.
SELECT 
	patient_id, arrival_date, 
    YEAR(arrival_date) AS arrival_year
FROM patients;

-- 2. Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT 
	patient_id, 
    DATEDIFF(departure_date, arrival_date) AS stay_period
FROM patients;

-- 3. Find all patients who arrived in a specific month.
SELECT 
	patient_id, arrival_date
FROM patients
WHERE MONTH(arrival_date) = 01;

-- Bonus question: Find total number of patients who arrived in a specific month.
SELECT 
    EXTRACT(MONTH FROM arrival_date) AS month,
    COUNT(*) AS total_patients
FROM patients
GROUP BY month
ORDER BY month;

-- Daily Challenge  
 
 /* Calculate the average length of stay (in days) for each service, showing only services where the average stay is more than 7 days. 
 Also show the count of patients and order by average stay descending. */

SELECT 
    service, 
    ROUND(AVG(DATEDIFF(departure_date, arrival_date)), 0) AS avg_stay_period,
    COUNT(patient_id) AS patient_count
FROM patients
GROUP BY service
HAVING avg_stay_period > 7
ORDER BY avg_stay_period DESC;
