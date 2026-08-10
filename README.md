# Colorado Hospital Readmissions Analysis

## Project Overview

This intermediate SQL portfolio project analyzes Colorado hospital readmission performance using data from the Centers for Medicare & Medicaid Services.

The project combines two CMS datasets:

- Hospital General Information
- Hospital Readmissions Reduction Program

The goal is to evaluate excess readmission ratios across participating Colorado hospitals and identify patterns by condition, CMS star rating, ownership type, and hospital-level performance.

## Business Questions

This project answers the following questions:

1. How many Colorado hospitals have HRRP readmission data?
2. How complete is the excess readmission ratio data?
3. Which readmission measures have the highest average ratios?
4. Which measures have the greatest share of hospitals above expected?
5. Which hospitals have multiple above-expected readmission measures?
6. Which specific conditions are driving hospital-level readmission risk?
7. Do higher CMS star ratings correspond with better readmission performance?
8. Does readmission performance vary by ownership type?
9. Which hospitals appear to have the highest readmission risk?
10. Which hospitals show consistently strong performance across several measures?

## Data Sources

### Hospital General Information

Provides:

- Facility ID
- Hospital name
- City
- Hospital type
- Ownership
- CMS overall hospital rating

### Hospital Readmissions Reduction Program

Provides:

- Facility ID
- HRRP measure name
- Number of discharges
- Excess readmission ratio
- Predicted readmission rate
- Expected readmission rate
- Number of readmissions

The two datasets were joined using `Facility ID`.

## Tools Used

- SQLite
- DB Browser for SQLite
- SQL
- GitHub

## SQL Skills Demonstrated

- `INNER JOIN`
- `LEFT JOIN`
- `SELECT`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `COUNT`
- `COUNT(DISTINCT)`
- `SUM`
- `AVG`
- `MAX`
- `CASE`
- `CAST`
- `ROUND`
- Subqueries
- Common Table Expressions (`WITH`)
- Window functions
- `RANK()`
- Missing-data validation
- Duplicate checks
- One-to-many relational analysis

## Data Validation

The initial hospital dataset contained 97 Colorado hospitals.

The HRRP dataset contained 306 Colorado readmission records representing 51 unique hospitals.

Key validation findings:

- All 306 Colorado HRRP records successfully matched to the hospital table using Facility ID.
- No duplicate Colorado Facility IDs were found in the hospital reference table.
- 183 of 306 readmission records had usable excess readmission ratios.
- 123 records were reported as `N/A`.
- Overall ratio availability was 59.8%.
- Each participating hospital had one row for each of the six HRRP measures, although usable ratios were not available for every measure.

### Ratio Availability by Measure

| Measure | Usable Ratios | Availability |
|---|---:|---:|
| Pneumonia | 43 | 84.3% |
| Heart Failure | 41 | 80.4% |
| Heart Attack | 32 | 62.7% |
| COPD | 30 | 58.8% |
| Hip/Knee Replacement | 24 | 47.1% |
| CABG | 13 | 25.5% |

Data availability varied substantially by measure, so comparisons should consider the number of usable hospital records.

## Statewide Readmission Performance

Average excess readmission ratios were below `1.00` for all six measures.

| Measure | Average Excess Readmission Ratio |
|---|---:|
| COPD | 0.9803 |
| Pneumonia | 0.9797 |
| Hip/Knee Replacement | 0.9743 |
| CABG | 0.9743 |
| Heart Failure | 0.9528 |
| Heart Attack | 0.9492 |

An excess readmission ratio below `1.00` indicates readmissions were lower than expected, while a ratio above `1.00` indicates higher-than-expected readmissions.

At the statewide level, participating Colorado hospitals performed below expected on average across all six measures.

## Above-Expected Readmission Performance

Pneumonia had the largest number of hospitals above expected.

| Measure | Hospitals Above Expected | Above-Expected Percentage |
|---|---:|---:|
| Pneumonia | 14 | 32.6% |
| CABG | 4 | 30.8% |
| COPD | 9 | 30.0% |
| Hip/Knee Replacement | 7 | 29.2% |
| Heart Attack | 7 | 21.9% |
| Heart Failure | 8 | 19.5% |

Pneumonia was the most widespread above-expected readmission issue.

## Frequency vs. Severity

A different pattern appeared when comparing the severity of above-expected ratios.

### Pneumonia

- 14 hospitals above expected
- Average ratio among above-expected hospitals: 1.0289
- Highest ratio: 1.0900

### Hip/Knee Replacement

- 7 hospitals above expected
- Average ratio among above-expected hospitals: 1.1660
- Highest ratio: 1.3313

This suggests pneumonia was the more widespread challenge, while Hip/Knee Replacement produced more extreme excess readmission ratios among affected hospitals.

## Highest Individual Ratios

The highest observed Hip/Knee excess readmission ratios included:

1. Centura Health-Penrose St. Francis Health Services — 1.3313
2. Sky Ridge Medical Center — 1.3284
3. HCA HealthONE Rose — 1.1714
4. AdventHealth Porter — 1.1377
5. AdventHealth Littleton — 1.0997

## CMS Star Rating Comparison

Higher CMS star ratings were associated with progressively better readmission performance.

| CMS Rating | Average Ratio | Above-Expected Percentage |
|---|---:|---:|
| 2 Stars | 1.0395 | 100.0% |
| 3 Stars | 0.9974 | 42.1% |
| 4 Stars | 0.9677 | 26.1% |
| 5 Stars | 0.9444 | 14.0% |

Five-star hospitals had both the lowest average excess readmission ratio and the smallest share of above-expected records.

The two-star category should be interpreted cautiously because it contained only three usable readmission records.

## Ownership Comparison

| Ownership Group | Hospitals | Average Ratio | Above-Expected Percentage |
|---|---:|---:|---:|
| Government | 5 | 0.9647 | 30.0% |
| Nonprofit | 36 | 0.9656 | 24.1% |
| For-profit | 4 | 0.9849 | 44.4% |

For-profit hospitals had the largest share of above-expected records, although the group included only four hospitals.

## Hospital Risk Scorecard

A hospital-level scorecard was created using a Common Table Expression and `RANK()`.

To improve comparability, hospitals were required to have at least four usable HRRP measures.

The highest-ranked hospitals were:

| Rank | Hospital | Usable Measures | Above Expected | Above-Expected % | Average Ratio |
|---:|---|---:|---:|---:|---:|
| 1 | HCA HealthONE Rose | 5 | 5 | 100.0% | 1.0579 |
| 2 | AdventHealth Littleton | 5 | 4 | 80.0% | 1.0365 |
| 3 | HCA HealthONE Mountain Ridge | 4 | 3 | 75.0% | 1.0276 |

HCA HealthONE Rose stood out because all five usable measures were above expected.

## Consistently Strong Performers

Ten Colorado hospitals had at least four usable measures with no above-expected ratios.

Notable examples include:

| Hospital | Usable Measures | Average Ratio | Highest Ratio |
|---|---:|---:|---:|
| Poudre Valley Hospital | 5 | 0.8859 | 0.9410 |
| Intermountain Health St. Mary's Regional Hospital | 6 | 0.9098 | 0.9814 |
| Lutheran Medical Center | 4 | 0.9262 | 0.9658 |
| AdventHealth Parker | 5 | 0.9283 | 0.9779 |
| UCH-Memorial Health System | 6 | 0.9312 | 0.9888 |

Poudre Valley Hospital had the lowest average ratio among hospitals with at least four usable measures.

## Main Findings

The analysis identified several important patterns:

- Participating Colorado hospitals performed below expected on average across all six HRRP measures.
- Pneumonia was the most widespread above-expected readmission issue.
- Hip/Knee Replacement produced the most severe individual excess readmission ratios.
- Higher CMS star ratings were associated with better readmission performance.
- Hospital-level analysis revealed patterns that were not visible in statewide averages.
- Several hospitals had no above-expected measures across four or more conditions.
- Others showed consistently elevated ratios across multiple measures.

## Limitations

This analysis has several limitations:

- Only 51 of 97 Colorado hospitals had HRRP readmission records.
- HRRP data does not represent every hospital type.
- Many Critical Access, psychiatric, children's, military, and VA hospitals were not represented.
- Only 59.8% of Colorado HRRP records had usable excess readmission ratios.
- Data availability varied substantially by measure.
- Some ownership and CMS rating groups had small sample sizes.
- Results describe associations and patterns but do not establish causation.
- Excess readmission ratios should not be treated as the only measure of hospital quality.

## Repository Structure

```text
data/
    README.md

documentation/
    README.md

sql/
    README.md
    01_data_validation.sql
    02_readmission_analysis.sql
    03_hospital_scorecard.sql

results/
    README.md
    key_findings.md

README.md
