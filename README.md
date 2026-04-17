# 📊 Project Background

MavenTech is a company that specializes in selling computer hardware to large businesses. The organization recently implemented a CRM system to track sales opportunities across its pipeline; however, it lacks visibility into the data outside of the platform, limiting its ability to extract meaningful insights and make data-driven decisions.

The dataset used in this project consists of CRM records from October 2016 to December 2017. It includes detailed information on sales opportunities, such as product type, customer accounts, deal stages, assigned sales representatives, and whether each opportunity was ultimately won or lost. This project focuses on analyzing and structuring this data to uncover actionable insights that can improve sales performance and pipeline efficiency.

Insights and recommendations are provided on the following key areas:

• Sales Pipeline Health: Evaluation of how opportunities are distributed across different stages to identify inefficiencies and bottlenecks in the sales funnel.

• Win Rate & Conversion Performance: Analysis of deal outcomes to measure sales effectiveness and identify factors influencing successful conversions.

• Revenue & Sales Performance: Breakdown of revenue generation and average deal value across sales agents, managers, and product categories.

• Deal Efficiency Analysis: Assessment of sales cycle duration to understand how quickly deals are being closed and where delays occur.

• Time-Based Trends: Examination of deal activity over time to identify patterns, seasonality, and shifts in sales performance.

---

An interactive Tableau Dashboard can be found here

Targeted SQL Queries regarding various business questions can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/SQL_CRM_Pipeline_Analysis.sql)

The SQL queries used to inspect and perform quality checks can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/Exploratory%20Data%20Analysis.sql)

# 🗂️ Data Structure & Initial Checks

MavenTech's database structure as seen below consists of four tables: sales_pipeline, sales_team, account, and product, with a total row count of 8,800 records. Each record represents a single deal (opportunity) with associated attributes describing its progression, ownership, and outcome.

<img src="https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/images/EDB1.png" alt="ED1"/>
