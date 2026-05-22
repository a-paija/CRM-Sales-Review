# 📊 Project Background

MavenTech is a company that specializes in selling computer hardware to large businesses. The organization recently implemented a CRM system to track sales opportunities across its pipeline; however, it lacks visibility into the data outside of the platform, making it difficult to evaluate sales performance and identify areas for improvement.

The dataset used in this project consists of CRM records from October 2016 to December 2017, containing detailed information on sales opportunities, including deal stages, product categories, account information, sales ownership, and deal outcomes (Won or Lost).

Without structured analysis, MavenTech is unable to answer critical business questions such as:
-  Where deals are getting stuck in the pipeline
- Which sales agents or products are driving revenue
- How effectively opportunities are being converted into closed deals

This project aims to bridge that gap by transforming raw CRM data into actionable insights that provide clarity into pipeline health, sales performance, and overall business efficiency through the use of Excel, SQL, and Tableau.

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

## 📊 Executive Summary

MavenTech has generated approximately **$9.5M in total revenue**, supported by a solid **63% overall win rate**, indicating a generally healthy pipeline. However, deeper analysis reveals that performance is uneven across regions, highly concentrated in a few products and agents, and significantly impacted by conversion inefficiencies and pricing inconsistencies.

Below is a the Manager & Sales Pipeline Efficiency page from the Tableau Visualization and more examples will be included throughout the report. The entire interactive Tableau Dashboard can be found [here](https://public.tableau.com/app/profile/ajin.paija/viz/SalesPerformancePricingAnalytics/Story1)

<img src="images/Manager.png" alt="Flagged" width="750" height="850"/>

---

## 🌍 Regional Performance Insights

Revenue distribution across regions is relatively balanced, with the **West leading at $3.56M**, followed by the **Central region at $3.32M**, and the **East at $3.08M**.

However, each region exhibits a different performance dynamic:

- The **West** is driven by overall revenue scale  
- The **Central region** leads in deal volume but underperforms in efficiency  
- The **East region** delivers the **highest average deal size (~$2,637)**  

This suggests that while total revenue is similar, the **quality of deals varies significantly**, with the East showing strong potential for high-value sales.

**Key takeaway:**  
Growth should not focus equally across regions—there is a clear opportunity to **scale high-value deal strategies from the East region**.

---

<img src="images/Product.png" alt="Flagged" width="750" height="850"/>

Above is an overview of Product Performance from the Tableau Visualisations. The entire interactive Tableau Dashboard can be found [here](https://public.tableau.com/app/profile/ajin.paija/viz/SalesPerformancePricingAnalytics/Story1)

## 💰 Product Performance & Revenue Concentration

Revenue is heavily concentrated in three products:

- **GTX Pro (~$3.46M)**  
- **GTX Plus Pro (~$2.62M)**  
- **MG Advanced (~$2.21M)**  

Together, these products account for approximately **83% of total revenue**, indicating a strong reliance on a narrow product set.

While this concentration reflects strong product-market fit at the top end, it also introduces **portfolio risk** and limits diversification.

**Key takeaway:**  
MavenTech’s growth is disproportionately dependent on a small number of high-performing products.

---

## ⚠️ Revenue Leakage & Conversion Gaps

Despite strong revenue generation, the business is losing approximately **$5.9M in potential revenue**, primarily from the same top-performing products:

- GTX Pro alone accounts for **~$2.0M in lost revenue**  
- MG Advanced and GTX Plus Pro each contribute **~$1.46M in losses**

This indicates that **demand is not the issue**—instead, the business is failing to convert high-value opportunities.

**Key takeaway:**  
The core problem is not pipeline generation, but **conversion inefficiency in high-value deals**.

Even a modest **10% improvement in conversion rates** across these products could yield an estimated **$600K+ in incremental revenue**.

---

## 💸 Pricing Strategy & Discounting Behavior

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

---

## ⏱️ Sales Cycle Effectiveness

Sales cycle duration has a direct relationship with success rates:

- Deals under 30 days close at **~57.4% win rate**  
- Deals between 30–90 days close at **~66–67%**  
- Deals over 90 days achieve the highest win rate at **~70.9%**

This suggests that **longer, more developed sales cycles lead to better outcomes**, likely due to improved qualification, relationship building, and deal maturity.

**Key takeaway:**  
Short sales cycles may be sacrificing deal quality for speed.

---

## 🧠 Sales Performance & Execution Quality

A weighted performance model incorporating win rate, deal volume, and revenue highlights the importance of **balanced performance**.

Top-performing agents consistently demonstrate:
- Strong conversion rates  
- High deal participation  
- Sustainable revenue contribution  

This approach avoids overvaluing agents who rely solely on volume or a few large deals.

**Key takeaway:**  
Sales success is driven by **consistency and efficiency**, not just output.

---

## 🔗 SQL + Dashboard Integration

The dashboards provide a high-level view of performance trends, while SQL enables deeper diagnostic analysis.

- Dashboards highlight **where performance varies**  
- SQL explains **why those differences exist**  

Together, they enable both **monitoring and decision-making**, bridging the gap between reporting and strategy.

---

## 🚀 Strategic Recommendations

### 1. Improve Conversion on High-Value Products
Focus on GTX Pro, MG Advanced, and GTX Plus Pro, where the largest revenue gaps exist.

---

### 2. Strengthen Pricing Discipline
Reduce reliance on discounting in lower-tier products and reinforce value-based selling.

---

### 3. Scale High-Value Sales Strategies
Replicate successful deal patterns from the East region across other regions.

---

### 4. Optimize Sales Cycle Management
Encourage longer, more deliberate deal cycles for higher win rates and better outcomes.

---

### 5. Standardize Sales Performance Frameworks
Adopt weighted performance metrics to improve coaching, evaluation, and team consistency.

---

## 🛠️ Tools & Techniques

- SQL (CTEs, aggregations, window functions)  
- Tableau / Power BI (dashboard development)  
- Data modeling (performance scoring)  
- Business analysis (revenue optimization)

---

## ✅ Final Takeaway

MavenTech has a strong revenue foundation and healthy conversion rates, but its growth is constrained by:

- Heavy reliance on a small number of products  
- Significant revenue leakage (~$6M)  
- Inconsistent pricing strategies  
- Variability in sales execution  

The largest opportunity lies not in increasing pipeline volume, but in **improving conversion efficiency, pricing discipline, and strategic focus on high-value opportunities**.
