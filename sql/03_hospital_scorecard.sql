/*
Hospital Scorecard Query 1: Create a hospital-level readmission scorecard

WITH creates a Common Table Expression, or CTE.

The CTE summarizes each Colorado hospital into one row.

For each hospital, it calculates:
- number of usable readmission measures,
- number of measures above expected,
- percentage of measures above expected,
- average excess readmission ratio,
- highest excess readmission ratio.

The final SELECT ranks hospitals by the percentage of measures
that were above expected.

This is more advanced than the earlier queries because it first
builds a summarized dataset and then analyzes that summary.
*/

WITH hospital_summary AS (

    SELECT
        h."Facility ID",
        h."Facility Name",
        h."City/Town",
        h."Hospital overall rating",

        COUNT(*) AS usable_measures,

        SUM(
            CASE
                WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                    THEN 1
                ELSE 0
            END
        ) AS above_expected_measures,

        ROUND(
            100.0 *
            SUM(
                CASE
                    WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                        THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            1
        ) AS above_expected_percentage,

        ROUND(
            AVG(
                CAST(r."Excess Readmission Ratio" AS REAL)
            ),
            4
        ) AS average_excess_readmission_ratio,

        MAX(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ) AS highest_excess_readmission_ratio

    FROM hospitals AS h

    INNER JOIN readmissions AS r
        ON h."Facility ID" = r."Facility ID"

    WHERE h."State" = 'CO'
      AND r."Excess Readmission Ratio" <> 'N/A'

    GROUP BY
        h."Facility ID",
        h."Facility Name",
        h."City/Town",
        h."Hospital overall rating"
)

SELECT
    *,
    RANK() OVER (
        ORDER BY
            above_expected_percentage DESC,
            average_excess_readmission_ratio DESC
    ) AS performance_risk_rank

FROM hospital_summary

ORDER BY performance_risk_rank;

/*
Hospital Scorecard Query 2: Rank hospitals with at least four usable measures

The CTE summarizes each Colorado hospital into one row.

HAVING COUNT(*) >= 4 keeps only hospitals with at least four
usable readmission measures.

This reduces the risk of over-ranking hospitals based on only
one or two reported measures.

RANK() then orders hospitals by:
1. percentage of measures above expected,
2. average excess readmission ratio,
3. highest excess readmission ratio.
*/

WITH hospital_summary AS (

    SELECT
        h."Facility ID",
        h."Facility Name",
        h."City/Town",
        h."Hospital overall rating",

        COUNT(*) AS usable_measures,

        SUM(
            CASE
                WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                    THEN 1
                ELSE 0
            END
        ) AS above_expected_measures,

        ROUND(
            100.0 *
            SUM(
                CASE
                    WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                        THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            1
        ) AS above_expected_percentage,

        ROUND(
            AVG(
                CAST(r."Excess Readmission Ratio" AS REAL)
            ),
            4
        ) AS average_excess_readmission_ratio,

        MAX(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ) AS highest_excess_readmission_ratio

    FROM hospitals AS h

    INNER JOIN readmissions AS r
        ON h."Facility ID" = r."Facility ID"

    WHERE h."State" = 'CO'
      AND r."Excess Readmission Ratio" <> 'N/A'

    GROUP BY
        h."Facility ID",
        h."Facility Name",
        h."City/Town",
        h."Hospital overall rating"

    HAVING COUNT(*) >= 4
)

SELECT
    *,
    RANK() OVER (
        ORDER BY
            above_expected_percentage DESC,
            average_excess_readmission_ratio DESC,
            highest_excess_readmission_ratio DESC
    ) AS performance_risk_rank

FROM hospital_summary

ORDER BY performance_risk_rank;

/*
Hospital Scorecard Query 3: Identify hospitals with no above-expected measures

The CTE summarizes each Colorado hospital.

HAVING COUNT(*) >= 4 keeps only hospitals with at least four
usable readmission measures.

The final WHERE clause keeps only hospitals where none of
the usable measures were above expected.

ORDER BY average_excess_readmission_ratio ASC places the
lowest average ratios first.
*/

WITH hospital_summary AS (

    SELECT
        h."Facility ID",
        h."Facility Name",
        h."City/Town",
        h."Hospital overall rating",

        COUNT(*) AS usable_measures,

        SUM(
            CASE
                WHEN CAST(r."Excess Readmission Ratio" AS REAL) > 1.00
                    THEN 1
                ELSE 0
            END
        ) AS above_expected_measures,

        ROUND(
            AVG(
                CAST(r."Excess Readmission Ratio" AS REAL)
            ),
            4
        ) AS average_excess_readmission_ratio,

        MAX(
            CAST(r."Excess Readmission Ratio" AS REAL)
        ) AS highest_excess_readmission_ratio

    FROM hospitals AS h

    INNER JOIN readmissions AS r
        ON h."Facility ID" = r."Facility ID"

    WHERE h."State" = 'CO'
      AND r."Excess Readmission Ratio" <> 'N/A'

    GROUP BY
        h."Facility ID",
        h."Facility Name",
        h."City/Town",
        h."Hospital overall rating"

    HAVING COUNT(*) >= 4
)

SELECT *
FROM hospital_summary

WHERE above_expected_measures = 0

ORDER BY
    average_excess_readmission_ratio ASC,
    highest_excess_readmission_ratio ASC;