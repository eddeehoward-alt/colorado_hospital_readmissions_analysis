# Key Findings

## Project Overview

This project analyzes Colorado hospital readmission performance using two Centers for Medicare & Medicaid Services datasets:

- Hospital General Information
- Hospital Readmissions Reduction Program

The analysis focuses on hospitals participating in the Hospital Readmissions Reduction Program and compares excess readmission ratios across six measures.

## Data Validation Findings

- Colorado had 97 hospitals in the Hospital General Information dataset.
- 51 hospitals had matching HRRP readmission records.
- 306 Colorado readmission measure records were available.
- All 306 readmission records successfully matched to the hospital reference table using Facility ID.
- No duplicate Colorado Facility IDs were found in the hospital table.
- 183 records had usable excess readmission ratios.
- 123 records were reported as `N/A`.
- Overall excess readmission ratio availability was 59.8%.

### Ratio Availability by Measure

| Measure | Usable Ratios | Availability |
|---|---:|---:|
| Pneumonia | 43 | 84.3% |
| Heart Failure | 41 | 80.4% |
| Heart Attack | 32 | 62.7% |
| COPD | 30 | 58.8% |
| Hip/Knee Replacement | 24 | 47.1% |
| CABG | 13 | 25.5% |

Readmission data completeness varied substantially by measure. Pneumonia and heart failure had the highest availability, while CABG had the lowest.

## Statewide Readmission Performance

Average excess readmission ratios were below 1.00 for all six HRRP measures.

| Measure | Average Excess Readmission Ratio |
|---|---:|
| COPD | 0.9803 |
| Pneumonia | 0.9797 |
| Hip/Knee Replacement | 0.9743 |
| CABG | 0.9743 |
| Heart Failure | 0.9528 |
| Heart Attack | 0.9492 |

This indicates that participating Colorado hospitals, on average, had lower-than-expected readmissions across all six measures.

## Measures With Above-Expected Readmissions

Pneumonia had the largest number of hospitals with above-expected readmission ratios.

| Measure | Hospitals Above Expected | Above-Expected Percentage |
|---|---:|---:|
| Pneumonia | 14 | 32.6% |
| CABG | 4 | 30.8% |
| COPD | 9 | 30.0% |
| Hip/Knee Replacement | 7 | 29.2% |
| Heart Attack | 7 | 21.9% |
| Heart Failure | 8 | 19.5% |

Pneumonia was the most widespread above-expected readmission issue, while heart failure had the smallest percentage of hospitals above expected.

## Frequency vs. Severity

Pneumonia had the most hospitals above expected, but Hip/Knee Replacement had the most extreme ratios among hospitals performing above expected.

- Pneumonia:
  - 14 hospitals above expected
  - Average ratio among above-expected hospitals: 1.0289
  - Highest ratio: 1.0900

- Hip/Knee Replacement:
  - 7 hospitals above expected
  - Average ratio among above-expected hospitals: 1.1660
  - Highest ratio: 1.3313

This suggests that pneumonia was a more widespread readmission challenge, while Hip/Knee Replacement had fewer affected hospitals but greater severity among those hospitals.

## Highest Individual Excess Readmission Ratios

The highest observed Hip/Knee readmission ratios included:

1. Centura Health-Penrose St. Francis Health Services — 1.3313
2. Sky Ridge Medical Center — 1.3284
3. HCA HealthONE Rose — 1.1714
4. AdventHealth Porter — 1.1377
5. AdventHealth Littleton — 1.0997

These hospitals may represent higher-priority opportunities for condition-specific readmission review.

## Readmission Performance by CMS Star Rating

Higher CMS overall hospital ratings were associated with better readmission performance.

| CMS Rating | Average Ratio | Above-Expected Percentage |
|---|---:|---:|
| 2 Stars | 1.0395 | 100.0% |
| 3 Stars | 0.9974 | 42.1% |
| 4 Stars | 0.9677 | 26.1% |
| 5 Stars | 0.9444 | 14.0% |

Five-star hospitals had the lowest average excess readmission ratio and the lowest percentage of above-expected records.

The two-star category should be interpreted cautiously because it contained only three usable readmission records.

## Readmission Performance by Ownership

| Ownership Group | Hospitals | Average Ratio | Above-Expected Percentage |
|---|---:|---:|---:|
| Government | 5 | 0.9647 | 30.0% |
| Nonprofit | 36 | 0.9656 | 24.1% |
| For-profit | 4 | 0.9849 | 44.4% |

For-profit hospitals had the highest average ratio and the largest share of above-expected records.

However, the government and for-profit groups contained relatively few hospitals, so these results should not be generalized broadly.

## Hospital Risk Scorecard

To improve comparability, the hospital scorecard was limited to facilities with at least four usable readmission measures.

The highest-ranked hospitals for readmission risk were:

| Rank | Hospital | Usable Measures | Above Expected | Above-Expected % | Average Ratio |
|---:|---|---:|---:|---:|---:|
| 1 | HCA HealthONE Rose | 5 | 5 | 100.0% | 1.0579 |
| 2 | AdventHealth Littleton | 5 | 4 | 80.0% | 1.0365 |
| 3 | HCA HealthONE Mountain Ridge | 4 | 3 | 75.0% | 1.0276 |

HCA HealthONE Rose stood out because all five usable measures were above expected.

## Consistently Strong Performers

Ten Colorado hospitals had at least four usable HRRP measures with no above-expected ratios.

Notable examples include:

| Hospital | Usable Measures | Average Ratio | Highest Ratio |
|---|---:|---:|---:|
| Poudre Valley Hospital | 5 | 0.8859 | 0.9410 |
| Intermountain Health St. Mary's Regional Hospital | 6 | 0.9098 | 0.9814 |
| Lutheran Medical Center | 4 | 0.9262 | 0.9658 |
| AdventHealth Parker | 5 | 0.9283 | 0.9779 |
| UCH-Memorial Health System | 6 | 0.9312 | 0.9888 |

Poudre Valley Hospital had the lowest average excess readmission ratio among hospitals with at least four usable measures.

## Main Conclusions

The analysis identified several important patterns:

- Participating Colorado hospitals performed below expected on average across all six HRRP measures.
- Pneumonia was the most widespread above-expected readmission issue.
- Hip/Knee Replacement produced the most severe individual excess readmission ratios.
- Higher CMS star ratings were associated with better readmission performance.
- Hospital-level analysis revealed meaningful differences that were not visible in statewide averages.
- Several hospitals had no above-expected measures across four or more conditions, while others showed consistently elevated ratios.

## Limitations

This analysis has several limitations:

- Only 51 of 97 Colorado hospitals had HRRP readmission records.
- HRRP participation does not include every hospital type.
- Many Critical Access, psychiatric, children's, VA, and military hospitals were not represented.
- Only 59.8% of Colorado readmission records had usable excess readmission ratios.
- Data availability differed substantially by measure.
- Some ownership and rating groups had small sample sizes.
- This analysis identifies associations and patterns but does not establish causation.
- Excess readmission ratios should not be treated as the only measure of hospital quality.
