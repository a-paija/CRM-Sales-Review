# 📊 Project Background

MavenTech is a company that specializes in selling computer hardware to large businesses. The organization recently implemented a CRM system to track sales opportunities across its pipeline; however, it lacks visibility into the data outside of the platform, making it difficult to evaluate sales performance and identify areas for improvement.

The dataset used in this project consists of CRM records from October 2016 to December 2017, containing detailed information on sales opportunities, including deal stages, product categories, account information, sales ownership, and deal outcomes (Won or Lost).

Without structured analysis, MavenTech is unable to answer critical business questions such as:
-  Where deals are getting stuck in the pipeline
- Which sales agents or products are driving revenue
- How effectively opportunities are being converted into closed deals

This project aims to bridge that gap by transforming raw CRM data into actionable insights that provide clarity into pipeline health, sales performance, and overall business efficiency.

---

An interactive Tableau Dashboard can be found [here](https://public.tableau.com/app/profile/ajin.paija/viz/SalesPerformancePricingAnalytics/Story1)

Targeted SQL Queries regarding various business questions can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/SQL_CRM_Pipeline_Analysis.sql)

The SQL queries used to inspect and perform quality checks can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/Exploratory%20Data%20Analysis.sql)

---

# 🎯 Business Objective and Data Structure

The primary objective of this analysis is to evaluate the effectiveness of MavenTech’s sales pipeline and identify opportunities to improve conversion rates, revenue generation, and sales efficiency.

Specifically, this project seeks to:

1. Assess pipeline health and identify bottlenecks
2. Measure win rate and conversion performance
3. Analyze revenue contribution across agents, managers, and products
4. Evaluate sales cycle efficiency
5. Identify trends in deal activity over time

---

# 🗂️ Data Structure & Initial Checks

MavenTech's database structure as seen below consists of four tables: sales_pipeline, sales_team, account, and product, with a total row count of 8,800 records. Each record represents a single deal (opportunity) with associated attributes describing its progression, ownership, and outcome.

<img src="images/EDB1.png" alt="ED1" width="500" height="450"/>

---

Before analysis, data quality checks were conducted to ensure accuracy and build familiarity with the dataset. Key observations, data issues, and inconsistencies were documented in an issue log, using excel pivot tables, while potential outliers and anomalies were identified and flagged for further review.

Excel was then used to clean and prepare the dataset for analysis in SQL. This included handling missing values, standardizing categorical fields such as deal stages, and ensuring consistent formats for dates and numerical values. These steps ensured the data could be efficiently imported into SQL and enabled accurate querying and analysis.

<img src="images/Issues_log.png" alt="Issue_log" width="750" height="850"/>

<img src="images/Flagged_Row.png" alt="Flagged" width="450" height="350"/>

## 🚫 Handling Missing & Incomplete Data

- Missing/incomplete values identified, flagged, and recorded using pivot tables
- No imputation performed; original dataset preserved to avoid bias
- Product/account fields not filled → prevents unsupported categorical assumptions
- Missing deal values not estimated → protects revenue, AOV, and win rate integrity
- Records with critical missing fields excluded from sensitive analyses (e.g., revenue)
- Retained only where impact on accuracy was minimal

## Executive Summary

### 🌍 Regional Sales Performance

![Regional Dashboard](./assets/regional_dashboard.png)

| Region  | Revenue | Key Insight |
|--------|--------|------------|
| West   | $3.56M | Highest total revenue |
| Central| $3.32M | Highest deal volume (1,629 deals) |
| East   | $3.08M | Highest avg deal size ($2,637) |

**Insight:**  
Revenue is driven by different strategies:
- West = scale  
- Central = volume (efficiency challenges)  
- East = premium deal potential  

👉 **Opportunity:** Scale East region performance to increase high-value revenue.

---

### 💰 Product Performance & Pricing Strategy

![Product Dashboard](./assets/product_dashboard.png)

#### Revenue Leaders

| Product        | Revenue |
|---------------|--------|
| GTX Pro       | $3.46M |
| GTX Plus Pro  | $2.62M |
| MG Advanced   | $2.21M |

These account for **~83% of total revenue**

---

#### Pricing Power & Discounting

| Product          | Pricing Behavior |
|------------------|-----------------|
| GTX Plus Pro     | +$7 above list price |
| GTX Pro          | Near list price |
| MG Advanced      | Near list price |
| GTX Plus Basic   | -$15.89 deviation |
| GTK 500          | -$60.53 deviation |

**Insight:**  
- Premium products maintain pricing integrity  
- Lower-tier and high-ticket products rely on discounting → margin risk  

---

### ⚠️ Revenue Leakage (Missed Opportunities)

| Product        | Lost Revenue |
|---------------|-------------|
| GTX Pro       | ~$2.0M |
| MG Advanced   | ~$1.46M |
| GTX Plus Pro  | ~$1.46M |

**Total Identified Lost Revenue: ~$5.9M**

**Insight:**  
Revenue loss is concentrated in the **same products driving revenue**

👉 This is not a product issue—it is an **execution and conversion problem**

---

### ⏱️ Sales Cycle Efficiency

| Duration   | Win Rate |
|------------|----------|
| <30 days   | 57.4% |
| 30–60 days | 66.3% |
| 60–90 days | 66.7% |
| 90+ days   | 70.9% |

**Insight:**  
- Longer deals close at significantly higher rates  
- Short-cycle deals are less effective  

👉 Indicates better qualification and relationship-building in longer cycles  

---

### 🧠 Sales Agent Performance (Advanced Scoring Model)

| Rank | Agent Name         | Score |
|------|------------------|------|
| 1    | Darcel Schlecht  | 0.841 |
| 2    | James Ascencio   | 0.729 |
| 3    | Corliss Cosme    | 0.708 |
| 4    | Reed Clapper     | 0.705 |
| 5    | Maureen Marcano  | 0.701 |

**Insight:**  
Top performers are defined by **balanced performance**, not just revenue.

👉 This model corrects for:
- Small sample bias  
- Over-reliance on volume metrics  

---

## 🔗 SQL Queries (Click to Expand)

<details>
<summary><strong>View SQL Code</strong></summary>

---

### 🧮 Revenue by Region

```sql
SELECT 
    region,
    SUM(revenue) AS total_revenue,
    COUNT(deal_id) AS total_deals,
    AVG(revenue) AS avg_deal_size
FROM sales_data
GROUP BY region
ORDER BY total_revenue DESC;

