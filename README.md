# 📊 Project Background

MavenTech is a company that specializes in selling computer hardware to large businesses. The organization recently implemented a CRM system to track sales opportunities across its pipeline; however, it lacks visibility into the data outside of the platform, making it difficult to evaluate sales performance and identify areas for improvement.

The dataset used in this project consists of CRM records from October 2016 to December 2017, containing detailed information on sales opportunities, including deal stages, product categories, account information, sales ownership, and deal outcomes (Won or Lost).

Without structured analysis, MavenTech is unable to answer critical business questions such as:
-  Where deals are getting stuck in the pipeline
- Which sales agents or products are driving revenue
- How effectively opportunities are being converted into closed deals

This project aims to bridge that gap by transforming raw CRM data into actionable insights that provide clarity into pipeline health, sales performance, and overall business efficiency.

---

An interactive Tableau Dashboard can be found here

Targeted SQL Queries regarding various business questions can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/SQL_CRM_Pipeline_Analysis.sql)

The SQL queries used to inspect and perform quality checks can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/Exploratory%20Data%20Analysis.sql)

# 🗂️ Data Structure & Initial Checks

MavenTech's database structure as seen below consists of four tables: sales_pipeline, sales_team, account, and product, with a total row count of 8,800 records. Each record represents a single deal (opportunity) with associated attributes describing its progression, ownership, and outcome.

<img src="images/EDB1.png" alt="ED1" width="750" height="700"/>

---

Prior to beginning the analysis, a series of data quality checks were conducted to ensure accuracy and build familiarity with the dataset. Key observations, data issues, and inconsistencies were documented in an issue log, using excel pivot tables, while potential outliers and anomalies were identified and flagged for further review.

Excel was then used to clean and prepare the dataset for analysis in SQL. This included handling missing values, standardizing categorical fields such as deal stages, and ensuring consistent formats for dates and numerical values. These steps ensured the data could be efficiently imported into SQL and enabled accurate querying and analysis.

<img src="images/Issues_log.png" alt="Issue_log" width="850" height="950"/>

<img src="images/Flagged_Row.png" alt="Flagged" width="550" height="450"/>

## 🚫 Handling Missing & Incomplete Data

During the data preparation phase, missing and incomplete values were identified in key fields such as product name, account name, and deal value. Rather than augmenting or imputing these values, a deliberate decision was made to preserve the original dataset and avoid introducing assumptions that could distort the analysis.

Imputing fields like product or account names would require unsupported guesses about categorical data, which could misrepresent customer or product-level performance. Similarly, estimating missing deal values would directly impact revenue calculations and key metrics such as average deal size and win rate, reducing the reliability of insights.

Given the analytical focus of this project, priority was placed on data integrity over data completeness. As a result, records with missing critical fields were either excluded from specific analyses (e.g., revenue calculations) or retained only where their inclusion would not compromise accuracy.

This approach ensures that all findings and insights are grounded in verifiable data, providing a more trustworthy foundation for evaluating sales performance and pipeline efficiency.

## Executive Summary

Overview findings
