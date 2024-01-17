-- Description: The SQL query obtains the patient demographics and vital sign records for hospitalised patients receiving invasive ventilation, including demographics, admission information, ventilation details, and measures, as well as identifying with random datetime in 24 hours and selecting the most recent record.
-- Author: Madhushree SV
-- Date: 25-Nov-2023
-- LatestVitalRecords is a Common Table Expression (CTE) to gather relevant information
WITH LatestVitalRecords AS (
  SELECT 
    vs.*, 
    -- select all columns from the 'vitalsign' table.
    vent.random_date as `Random Date`, 
    wt.weight AS Weight, 
    pat.gender as Gender, 
    adm.race as Ethnicity, 
    adm.admission_type AS `Admit Type`, 
    pat.anchor_age + (
      EXTRACT(
        YEAR 
        FROM 
          icu.intime
      ) - pat.anchor_year
    ) AS Age, 
    ROW_NUMBER() OVER (
      PARTITION BY vs.stay_id, 
      vent.random_date 
      ORDER BY 
        vs.charttime DESC
    ) AS rn -- row number
  FROM 
    (
      -- Subquery to calculate random_date from the 'ventilation' table
      SELECT 
        *, 
        DATETIME_ADD(
          v2.starttime, 
          INTERVAL CAST(
            DATETIME_DIFF(v2.endtime, v2.starttime, SECOND) * RAND() * 0.9 AS INT64
          ) SECOND
        ) as random_date 
      FROM 
        `physionet-data.mimiciv_derived.ventilation` AS v2 
      WHERE 
        v2.ventilation_status = "InvasiveVent"
    ) AS vent 
    INNER JOIN `physionet-data.mimiciv_derived.vitalsign` vs ON vent.stay_id = vs.stay_id 
    INNER JOIN `physionet-data.mimiciv_hosp.patients` pat ON vs.subject_id = pat.subject_id 
    INNER JOIN `physionet-data.mimiciv_hosp.admissions` adm ON pat.subject_id = adm.subject_id 
    INNER JOIN `physionet-data.mimiciv_icu.icustays` icu ON adm.hadm_id = icu.hadm_id 
    INNER JOIN `physionet-data.mimiciv_derived.weight_durations` wt ON icu.stay_id = wt.stay_id 
  where 
    vs.charttime < vent.random_date
), 
-- Selecting the relevant columns from the CTE
final as (
  SELECT 
    distinct lvr.subject_id as `Subject_Id`, 
    lvr.stay_id as `Stay_Id`, 
    lvr.`Random Date`, 
    lvr.charttime, 
    lvr.Weight, 
    lvr.Age, 
    lvr.Gender, 
    lvr.Ethnicity, 
    lvr.`Admit Type`, 
    lvr.heart_rate as `Heart Rate`, 
    lvr.resp_rate as `Respiratory Rate`, 
    lvr.sbp as `Systolic Blood Pressure`, 
    lvr.dbp as `Diastolic Blood Pressure`, 
    lvr.mbp as `Mean Blood Pressure`, 
    lvr.sbp_ni as `Non Invasive Blood Pressure systolic`, 
    lvr.dbp_ni as `Non Invasive Blood Pressure diastolic`, 
    lvr.mbp_ni as `Non Invasive Blood Pressure mean`, 
    lvr.spo2 as `O2 Saturation Pulse Oximetry - SpO2`, 
    lvr.glucose as `Glucose`, 
    lvr.temperature as `Temperature`, 
    lvr.temperature as `Temperature site`, 
    sofa_data.sofa_24hours 
  FROM 
    LatestVitalRecords as lvr 
    INNER JOIN `physionet-data.mimiciv_derived.sofa` as sofa_data on sofa_data.stay_id = lvr.stay_id 
  where 
    TIMESTAMP(lvr.`Random Date`) BETWEEN TIMESTAMP(sofa_data.starttime) 
    AND TIMESTAMP(sofa_data.endtime) + INTERVAL 24 HOUR 
    and rn = 1
) 
SELECT 
  * 
FROM 
  (
    SELECT 
      *, 
      row_number() over (
        partition BY stay_id 
        ORDER BY 
          `Random Date` desc
      ) seqnum 
    FROM 
      final
  ) 
WHERE 
  seqnum = 1
