--Connect to database
USE CRM_db;
---Section 1: Pipeline Metrics
--Total number of deals per deal_stage (Prospecting, Engaging, Won, Lost)
SELECT sp.deal_stage,
    COUNT(*) AS total_deals
FROM sales_pipeline sp
GROUP BY sp.deal_stage
ORDER BY total_deals DESC;
---Section 2: Product & Pricing Insights
--Goal: Understand which products and product series drive revenue and how pricing affects performance.
--Revenue + Pricing per product
SELECT sp.product,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_price,
    p.sales_price
FROM sales_pipeline AS sp
    JOIN products AS p ON sp.product = p.product
WHERE sp.deal_stage = 'Won'
GROUP BY sp.product,
    p.sales_price
ORDER BY total_revenue DESC;
--Revenue by product series
SELECT p.series,
    SUM(sp.close_value) AS total_revenue
FROM sales_pipeline AS sp
    JOIN products AS p ON sp.product = p.product
WHERE sp.deal_stage = 'Won'
GROUP BY p.series
ORDER BY total_revenue DESC;
---Section 3: Account / Customer Insights
---Goal: Analyze revenue and deal patterns by customer.
---Top 10 accounts by revenue
SELECT a.account,
    SUM(sp.close_value) AS total_revenue,
    a.sector
FROM sales_pipeline AS sp
    JOIN accounts AS a ON sp.account = a.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.account,
    a.sector
ORDER BY total_revenue DESC
LIMIT 10;
---Average deal_duration by account 
SELECT a.account,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    SUM(sp.close_value) AS total_revenue
FROM sales_pipeline AS sp
    JOIN accounts AS a ON sp.account = a.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.account
ORDER BY total_revenue DESC,
    avg_deal_duration ASC;
---Average deal_duration by sector
SELECT a.sector,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    SUM(sp.close_value) AS total_revenue
FROM sales_pipeline AS sp
    JOIN accounts AS a ON sp.account = a.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.sector
ORDER BY total_revenue DESC,
    avg_deal_duration ASC;
---Revenue + deal metrics per account
SELECT a.account,
    COUNT(*) AS total_deals,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_revenue_per_deal
FROM sales_pipeline AS sp
    JOIN accounts AS a ON sp.account = a.account
WHERE sp.deal_stage = 'Won'
GROUP BY a.account
ORDER BY total_revenue DESC;
---Win rate by company age
SELECT CASE
        WHEN a.year_established < 2000 THEN 'Before 2000'
        WHEN a.year_established BETWEEN 2000 AND 2009 THEN '2000-2009'
        WHEN a.year_established BETWEEN 2010 AND 2019 THEN '2010-2019'
        ELSE '2020+'
    END AS establishment_period,
    COUNT(*) AS total_closed_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN 1
            ELSE 0
        END
    ) AS won_deals,
    ROUND(
        SUM(
            CASE
                WHEN sp.deal_stage = 'Won' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS win_rate_pct
FROM sales_pipeline AS sp
    JOIN accounts AS a ON sp.account = a.account
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY establishment_period
ORDER BY total_closed_deals DESC;
--- Section 4: Pipeline Efficiency
---Goal: Examine timing and trends in the sales pipeline.
---Deals closed per month
SELECT MONTH(sp.close_date) AS month,
    COUNT(*) AS total_closed_deals
FROM sales_pipeline AS sp
WHERE sp.deal_stage = 'Won'
    AND MONTH(sp.close_date) BETWEEN 1 AND 12
GROUP BY month(sp.close_date)
ORDER BY month;
---Deals initiated per month
SELECT MONTH(sp.engage_date) AS month,
    COUNT(*) AS deals_initiated
FROM sales_pipeline AS sp
WHERE sp.engage_date IS NOT NULL
GROUP BY month(sp.engage_date)
ORDER BY month;
--Quarterly performance trends (deals initiated, won, and revenue)
SELECT QUARTER(sp.engage_date) AS quarter,
    COUNT(sp.opportunity_id) AS deals_initiated,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN 1
            ELSE 0
        END
    ) AS deals_closed,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN sp.close_value
            ELSE 0
        END
    ) AS total_revenue
FROM sales_pipeline AS sp
WHERE QUARTER(sp.engage_date) BETWEEN 1 AND 4
GROUP BY QUARTER(sp.engage_date)
ORDER BY quarter ASC;
--Duration vs outcome correlation
SELECT sp.deal_stage AS deal_outcome,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration
FROM sales_pipeline AS sp
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY deal_outcome
ORDER BY avg_deal_duration DESC;
---Average deal_duration by agent
SELECT sp.sales_agent,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    COUNT(*) AS total_closed_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN 1
            ELSE 0
        END
    ) AS won_deals,
    ROUND(
        SUM(
            CASE
                WHEN sp.deal_stage = 'Won' THEN 1
                ELSE 0
            END
        ) / COUNT(*) * 100,
        2
    ) AS win_rate_pct
FROM sales_pipeline AS sp
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.sales_agent
ORDER BY avg_deal_duration ASC;
---Average deal_duration by manager
SELECT st.manager,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration
FROM sales_pipeline AS sp
    JOIN sales_teams AS st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage = 'Won'
GROUP BY st.manager
ORDER BY avg_deal_duration ASC;
---Average product deal duration and close value
SELECT sp.product,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    ROUND(AVG(sp.close_value), 2) AS avg_close_value
FROM sales_pipeline AS sp
WHERE sp.deal_stage = 'Won'
    AND sp.close_value IS NOT NULL
    AND sp.product IS NOT NULL
GROUP BY sp.product
ORDER BY avg_close_value DESC,
    avg_deal_duration ASC;
--- Section 5: Team / Regional Performance
---Goal: Compare regions, teams, and agents.
---Regional Performance (Total revenue and average deal size)
SELECT st.regional_office,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_size
FROM sales_pipeline AS sp
    JOIN sales_teams AS st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage = 'Won'
GROUP BY st.regional_office
ORDER BY total_revenue DESC;
---Compare performance of agents in the same team and region
SELECT st.regional_office,
    sp.sales_agent,
    SUM(sp.close_value) AS total_revenue
FROM sales_pipeline AS sp
    JOIN sales_teams AS st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage = 'Won'
GROUP BY st.regional_office,
    sp.sales_agent
ORDER BY st.regional_office,
    total_revenue DESC;
---Team performance metrics
SELECT st.manager,
    st.regional_office,
    COUNT(DISTINCT st.sales_agent) AS team_size,
    COUNT(sp.opportunity_id) AS total_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN 1
            ELSE 0
        END
    ) AS won_deals,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_size,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    ROUND(
        SUM(
            CASE
                WHEN sp.deal_stage = 'Won' THEN 1
                ELSE 0
            END
        ) / COUNT(sp.opportunity_id) * 100,
        2
    ) AS win_rate_pct
FROM sales_pipeline AS sp
    JOIN sales_teams AS st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY st.manager,
    st.regional_office
ORDER BY total_revenue DESC;
---Sales agent performance metrics with manager and win rate
SELECT sp.sales_agent,
    st.manager,
    COUNT(sp.opportunity_id) AS total_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN 1
            ELSE 0
        END
    ) AS won_deals,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_size,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    ROUND(
        (
            SUM(
                CASE
                    WHEN sp.deal_stage = 'Won' THEN 1
                    ELSE 0
                END
            ) / COUNT(sp.opportunity_id)
        ) * 100,
        2
    ) AS win_rate_pct
FROM sales_pipeline AS sp
    JOIN sales_teams AS st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.sales_agent,
    st.manager
ORDER BY win_rate_pct ASC,
    total_revenue ASC;