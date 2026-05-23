## 📊 Project Background

MavenTech is a company that specializes in selling computer hardware to large businesses. The organization recently implemented a CRM system to track sales opportunities across its pipeline; however, it lacks visibility into the data outside of the platform, making it difficult to evaluate sales performance and identify areas for improvement.

The dataset used in this project consists of CRM records from October 2016 to December 2017, containing detailed information on sales opportunities, including deal stages, product categories, account information, sales ownership, and deal outcomes (Won or Lost).

Without structured analysis, MavenTech is unable to answer critical business questions such as:
- Where deals are getting stuck in the pipeline
- Which sales agents or products are driving revenue
- How effectively opportunities are being converted into closed deals

This project aims to bridge that gap by transforming raw CRM data into actionable insights that provide clarity into pipeline health, sales performance, and overall business efficiency through the use of **Excel, SQL, and Tableau**.

---

Targeted SQL Queries regarding various business questions can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/SQL_CRM_Pipeline_Analysis.sql)

The SQL queries used to inspect and perform quality checks can be found [here](https://github.com/a-paija/CRM-Sales-Opportunities/blob/main/Exploratory%20Data%20Analysis.sql)

An interactive Tableau Dashboard can be found [here](https://public.tableau.com/app/profile/ajin.paija/viz/SalesPerformancePricingAnalytics/Story1)

---

## 🎯 Business Objective and Data Structure

The primary objective of this analysis is to evaluate the effectiveness of MavenTech’s sales pipeline and identify opportunities to improve conversion rates, revenue generation, and sales efficiency.

Specifically, this project seeks to:

1. Assess pipeline health and identify bottlenecks
2. Measure win rate and conversion performance
3. Analyze revenue contribution across agents, managers, and products
4. Evaluate sales cycle efficiency
5. Identify trends in deal activity over time

## 🗂️ Data Structure & Initial Checks

MavenTech's database structure as seen below consists of four tables: sales_pipeline, sales_team, account, and product, with a total row count of 8,800 records. Each record represents a single deal (opportunity) with associated attributes describing its progression, ownership, and outcome.

<img src="images/EDB1.png" alt="ED1" width="500" height="450"/>

## 📊 Data Cleaning (Excel)

Before analysis, data quality checks were conducted to ensure accuracy and build familiarity with the dataset. Key observations, data issues, and inconsistencies were documented in an issue log, using excel pivot tables, while potential outliers and anomalies were identified and flagged for further review.

<img src="images/Issues_log.png" alt="Issue_log" width="750" height="950"/>

Excel was then used to clean and prepare the dataset for analysis in SQL. This included handling missing values, standardizing categorical fields such as deal stages, and ensuring consistent formats for dates and numerical values. These steps ensured the data could be efficiently imported into SQL and enabled accurate querying and analysis. Below is an image of the isssue log.

<img src="images/Flagged_Row.png" alt="Flagged" width="450" height="350"/>

## 📊 Executive Summary

MavenTech has generated approximately **$9.5M in total revenue**, supported by a solid **63% overall win rate**, indicating a generally healthy pipeline. However, deeper analysis reveals that performance is uneven across regions, highly concentrated in a few products and agents, and significantly impacted by conversion inefficiencies and pricing inconsistencies.

Below is a the Manager & Sales Pipeline Efficiency page from the Tableau Visualization and more examples will be included throughout the report. The entire interactive Tableau Dashboard can be found [here](https://public.tableau.com/app/profile/ajin.paija/viz/SalesPerformancePricingAnalytics/Story1)

<img src="images/Manager.png" alt="Manger" width="750" height="850"/>


## 📈 Sales Trends & Revenue Momentum

Monthly revenue trends reveal a pattern of **inconsistent performance rather than steady growth**, with total annual revenue of approximately **$9.5M**. Average monthly revenue is estimated at **~$790K**, though actual performance varies significantly due to pronounced peaks and troughs throughout the year.

Peak months outperform the average by a substantial margin, often driven by **high-value enterprise deal closures and end-of-period acceleration**, with top-performing months estimated to generate **1.5x–2x the average monthly revenue**. In contrast, lower-performing months fall well below the mean, highlighting **gaps in pipeline coverage and uneven deal distribution**.

This spread between high and low months suggests a **wide revenue range**, indicating that performance is not evenly distributed and is instead dependent on **timing of large deal closures rather than consistent deal flow**. As a result, revenue volatility introduces challenges in **forecast accuracy, capacity planning, and resource allocation**.

#### **Key Takeaway:**

While MavenTech generates strong annual revenue (~$9.5M), the **wide variance between peak and low months (up to 2x difference)** highlights a critical opportunity to improve **pipeline consistency, deal timing, and revenue predictability**.


#### **Action:**

- Increase **pipeline coverage ratio** to stabilize monthly revenue output  
- Improve **deal distribution across time** to reduce reliance on peak periods  
- Strengthen **forecasting accuracy** by accounting for revenue volatility patterns  
- Encourage **consistent deal flow** through incentive and pipeline management adjustments  

## 🌍 Regional Performance Insights (SQL)

Revenue distribution across regions is relatively balanced, with the **West leading at $3.56M**, followed by the **Central region at $3.32M**, and the **East at $3.08M**.

However, each region exhibits a different performance dynamic:

- The **West** is driven by overall revenue scale  
- The **Central region** leads in deal volume but underperforms in efficiency  
- The **East region** delivers the **highest average deal size (~$2,637)**  

This suggests that while total revenue is similar, the **quality of deals varies significantly**, with the East showing strong potential for high-value sales.

**Key takeaway:**  
Growth should not focus equally across regions—there is a clear opportunity to **scale high-value deal strategies from the East region**.

## 📄 Product Overview

Below is an overview of Product Performance from the Tableau Visualisations. The entire interactive Tableau Dashboard can be found [here](https://public.tableau.com/app/profile/ajin.paija/viz/SalesPerformancePricingAnalytics/Story1)

<img src="images/Product.png" alt="Product" width="750" height="850"/>

## 💰 Product Performance & Revenue Concentration (Tableau)

Revenue is heavily concentrated in three products:

- **GTX Pro (~$3.46M)**  
- **GTX Plus Pro (~$2.62M)**  
- **MG Advanced (~$2.21M)**  

Together, these products account for approximately **83% of total revenue**, indicating a strong reliance on a narrow product set. While this concentration reflects strong product-market fit at the top end, it also introduces **portfolio risk** and limits diversification.

**Key takeaway:**  
MavenTech’s growth is disproportionately dependent on a small number of high-performing products.

## ⚠️ Revenue Leakage & Conversion Gaps (SQL)

Despite strong revenue generation, the business is losing approximately **$5.9M in potential revenue**, primarily from the same top-performing products:

- GTX Pro alone accounts for **~$2.0M in lost revenue**  
- MG Advanced and GTX Plus Pro each contribute **~$1.46M in losses**

This indicates that **demand is not the issue**—instead, the business is failing to convert high-value opportunities.

**Key takeaway:**  
The core problem is not pipeline generation, but **conversion inefficiency in high-value deals**.

Even a modest **10% improvement in conversion rates** across these products could yield an estimated **$600K+ in incremental revenue**.

## 💸 Pricing Strategy & Discounting Behavior (SQL)

Pricing analysis reveals a clear segmentation between premium and lower-tier products:

- **Premium products (e.g., GTX Plus Pro)** maintain strong pricing power, even selling **above list price (~+$7)**  
- Core products (GTX Pro, MG Advanced) remain stable and close to list price  
- Lower-tier and high-ticket products rely heavily on discounting:
  - GTX Plus Basic: **~-$15.89 below list price**  
  - GTK 500: **~-$60.53 below list price**

This indicates inconsistent pricing discipline and potential margin erosion in certain segments.

**Key takeaway:**  
- Strong pricing power exists—but is not consistently leveraged  
- Discounting is being used as a substitute for effective sales execution  

## 🧠 Agent Sales Performance Score (SQL)

<img src="images/AgentScore.png" alt="Score" width="750" height="750"/>

Above is snippet of the calculated Agent Sales Performance Scores

A weighted performance model incorporating win rate, deal volume, and revenue. Performance scores range from **0.248 to 0.841**, representing a **3.4x gap between top and bottom performers**, highlighting significant variation in execution quality across the team.

Top-performing agents (scores **~0.70–0.84**) consistently combine **strong win rates (0.63–0.70)** with above-average deal volume and revenue contribution. Notably, the highest performer (0.8413) does not have the highest win rate, but instead leads in **sales volume (6.32) and revenue score (8.09)**—reinforcing that performance is driven by a **balanced combination of efficiency and output**.

In contrast, lower-performing agents (scores **~0.25–0.50**) often maintain **comparable win rates (0.55–0.66)** but underperform in either **revenue generation or deal volume**, indicating that activity alone is insufficient without effective deal conversion and value capture.

#### **Action:**

- Shift focus from pure activity metrics to **revenue efficiency and deal quality**  
- Use top performers as benchmarks for **replicable sales behaviors and strategies**  
- Identify mid- and low-tier performers with solid win rates but weak revenue as **high-impact coaching opportunities**  
- Reinforce performance evaluation using **composite scoring models** rather than isolated KPIs











## 🔗 SQL + Dashboard Integration

The dashboards provide a high-level view of performance trends, while SQL enables deeper diagnostic analysis.

- Dashboards highlight **where performance varies**  
- SQL explains **why those differences exist**  

Together, they enable both **monitoring and decision-making**, bridging the gap between reporting and strategy.
