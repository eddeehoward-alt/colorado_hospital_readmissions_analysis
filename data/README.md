# Data Sources

This project uses publicly available data from the Centers for Medicare & Medicaid Services (CMS).

## Dataset 1: Hospital General Information

Used to provide hospital-level characteristics including:

- Facility ID
- Facility Name
- City/Town
- State
- Hospital Type
- Hospital Ownership
- Emergency Services
- CMS Overall Hospital Rating

The analysis was filtered to Colorado hospitals.

## Dataset 2: Hospital Readmissions Reduction Program

Used to analyze hospital readmission performance across six HRRP measures:

- Acute Myocardial Infarction (AMI)
- Coronary Artery Bypass Graft (CABG)
- Chronic Obstructive Pulmonary Disease (COPD)
- Heart Failure (HF)
- Hip/Knee Replacement
- Pneumonia (PN)

Important fields include:

- Facility ID
- Measure Name
- Number of Discharges
- Excess Readmission Ratio
- Predicted Readmission Rate
- Expected Readmission Rate
- Number of Readmissions

## Joining the Data

The two datasets were joined using:

`Facility ID`

This created a relational dataset containing both hospital characteristics and readmission performance.

## Data Handling

The original CMS CSV files were imported into SQLite for analysis.

The raw source files are not included in this repository because they can be downloaded directly from CMS and may change over time.

Values reported as `N/A` in the Excess Readmission Ratio field were excluded from numerical calculations.

## Scope

The analysis focuses on Colorado hospitals with available HRRP data.

Not every Colorado hospital participates in or reports data through the Hospital Readmissions Reduction Program, so results should not be interpreted as representative of all Colorado hospitals.
