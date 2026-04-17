--Connect to database
USE CRM_db;
------------------------------------------------------------
-- 1. Pipeline Health
-- What does our funnel look like across all stages?
------------------------------------------------------------
SELECT sp.deal_stage,
    COUNT(*) AS total_deals
FROM sales_pipeline sp
GROUP BY sp.deal_stage
ORDER BY total_deals DESC;
------------------------------------------------------------
-- 2. Win Rate (Closed Deals Only)
-- How effectively are we converting opportunities into wins?
------------------------------------------------------------
SELECT COUNT(*) AS total_closed_deals,
    SUM(deal_stage = 'Won') AS won_deals,
    ROUND(SUM(deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline
WHERE deal_stage IN ('Won', 'Lost');
------------------------------------------------------------
-- 3. Revenue by Region (Won Deals Only)
-- Which regions generate the most revenue and largest deals?
------------------------------------------------------------
SELECT st.regional_office,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_size,
    COUNT(*) AS total_won_deals
FROM sales_pipeline sp
    JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage = 'Won'
GROUP BY st.regional_office
ORDER BY total_revenue DESC;
------------------------------------------------------------
-- 4. Manager Performance (Closed Deals)
-- Which managers drive the highest team performance and outcomes?
------------------------------------------------------------
SELECT st.manager,
    COUNT(DISTINCT st.sales_agent) AS team_size,
    COUNT(*) AS total_closed_deals,
    SUM(sp.deal_stage = 'Won') AS won_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN sp.close_value
            ELSE 0
        END
    ) AS total_revenue,
    ROUND(
        AVG(
            CASE
                WHEN sp.deal_stage = 'Won' THEN sp.close_value
            END
        ),
        2
    ) AS avg_deal_size,
    ROUND(SUM(sp.deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline sp
    JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY st.manager
ORDER BY total_revenue DESC;
------------------------------------------------------------
-- 5. Sales Agent Performance (Closed Deals)
-- Which sales agents are top performers vs underperformers?
------------------------------------------------------------
SELECT sp.sales_agent,
    st.manager,
    COUNT(*) AS total_closed_deals,
    SUM(sp.deal_stage = 'Won') AS won_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN sp.close_value
            ELSE 0
        END
    ) AS total_revenue,
    ROUND(
        AVG(
            CASE
                WHEN sp.deal_stage = 'Won' THEN sp.close_value
            END
        ),
        2
    ) AS avg_deal_size,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    ROUND(SUM(sp.deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline sp
    JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.sales_agent,
    st.manager
ORDER BY total_revenue DESC,
    win_rate_pct DESC;
------------------------------------------------------------
-- 6. Product Revenue & Pricing Power (Won Deals Only)
-- Which products drive revenue and where do we gain or lose pricing power?
------------------------------------------------------------
SELECT sp.product,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_price,
    p.sales_price,
    ROUND(AVG(sp.close_value - p.sales_price), 2) AS avg_price_deviation
FROM sales_pipeline sp
    JOIN products p ON sp.product = p.product
WHERE sp.deal_stage = 'Won'
GROUP BY sp.product,
    p.sales_price
ORDER BY total_revenue DESC;
------------------------------------------------------------
-- 7. Customer Concentration (Top Accounts)
-- Are we overly dependent on a small number of high-value customers?
------------------------------------------------------------
SELECT sp.account,
    COUNT(*) AS total_deals,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_revenue_per_deal,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration
FROM sales_pipeline sp
WHERE sp.deal_stage = 'Won'
GROUP BY sp.account
ORDER BY total_revenue DESC
LIMIT 10;
------------------------------------------------------------
-- 8. Pipeline Efficiency (Outcome vs Duration)
-- Do faster deals close more successfully than longer ones?
------------------------------------------------------------
SELECT sp.deal_stage AS outcome,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    COUNT(*) AS total_deals
FROM sales_pipeline sp
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.deal_stage;
------------------------------------------------------------
-- 9. Win Rate by Deal Duration Bucket
-- What deal duration range yields the highest conversion rates?
------------------------------------------------------------
SELECT CASE
        WHEN deal_duration < 30 THEN '<30 days'
        WHEN deal_duration <= 60 THEN '30-60 days'
        WHEN deal_duration <= 90 THEN '60-90 days'
        ELSE '90+ days'
    END AS duration_bucket,
    COUNT(*) AS total_deals,
    SUM(deal_stage = 'Won') AS won_deals,
    ROUND(SUM(deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY duration_bucket
ORDER BY duration_bucket;
------------------------------------------------------------
-- 10. Revenue Leakage (Lost Deals)
-- Where are we losing the most potential revenue across products?
------------------------------------------------------------
SELECT sp.product,
    COUNT(*) AS lost_deals,
    SUM(p.sales_price) AS potential_revenue_lost
FROM sales_pipeline sp
    JOIN products p ON sp.product = p.product
WHERE sp.deal_stage = 'Lost'
GROUP BY sp.product
ORDER BY potential_revenue_lost DESC;
------------------------------------------------------------
-- 11. Weighted Sales Performance (Volume + Win Rate)
-- Which agents perform best when balancing efficiency and deal volume?
------------------------------------------------------------
SELECT sp.sales_agent,
    COUNT(*) AS total_deals,
    SUM(sp.deal_stage = 'Won') AS wins,
    ROUND(
        (SUM(sp.deal_stage = 'Won') * 1.0 / COUNT(*)) * LOG(COUNT(*) + 1),
        4
    ) AS weighted_score
FROM sales_pipeline sp
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.sales_agent
ORDER BY weighted_score DESC;
------------------------------------------------------------
-- 12. Performance by Quartile (Volume-Controlled)
-- How does performance differ between top and bottom sales tiers?
------------------------------------------------------------
WITH agent_perf AS (
    SELECT sp.sales_agent,
        COUNT(*) AS total_deals,
        SUM(sp.deal_stage = 'Won') * 1.0 / COUNT(*) AS win_rate
    FROM sales_pipeline sp
    WHERE sp.deal_stage IN ('Won', 'Lost')
    GROUP BY sp.sales_agent
    HAVING COUNT(*) >= 10
),
ranked AS (
    SELECT *,
        NTILE(4) OVER (
            ORDER BY win_rate DESC
        ) AS quartile
    FROM agent_perf
)
SELECT quartile,
    ROUND(AVG(win_rate) * 100, 2) AS avg_win_rate,
    ROUND(AVG(total_deals), 1) AS avg_deal_volume
FROM ranked
GROUP BY quartile
ORDER BY quartile;
------------------------------------------------------------
-- 1. Pipeline Health
-- What does our funnel look like across all stages?
-- Insight: Identify bottlenecks where deals accumulate or drop off.
------------------------------------------------------------
SELECT sp.deal_stage,
    COUNT(*) AS total_deals
FROM sales_pipeline sp
GROUP BY sp.deal_stage
ORDER BY total_deals DESC;
------------------------------------------------------------
-- 2. Win Rate (Closed Deals Only)
-- How effectively are we converting opportunities into wins?
-- Insight: Establish baseline sales effectiveness across all closed deals.
------------------------------------------------------------
SELECT COUNT(*) AS total_closed_deals,
    SUM(deal_stage = 'Won') AS won_deals,
    ROUND(SUM(deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline
WHERE deal_stage IN ('Won', 'Lost');
------------------------------------------------------------
-- 3. Revenue by Region (Won Deals Only)
-- Which regions generate the most revenue and largest deals?
-- Insight: Highlight top-performing regions and potential geographic opportunities.
------------------------------------------------------------
SELECT st.regional_office,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_size,
    COUNT(*) AS total_won_deals
FROM sales_pipeline sp
    JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage = 'Won'
GROUP BY st.regional_office
ORDER BY total_revenue DESC;
------------------------------------------------------------
-- 4. Manager Performance (Closed Deals)
-- Which managers drive the highest team performance and outcomes?
-- Insight: Compare leadership effectiveness across teams using win rate and revenue.
------------------------------------------------------------
SELECT st.manager,
    COUNT(DISTINCT st.sales_agent) AS team_size,
    COUNT(*) AS total_closed_deals,
    SUM(sp.deal_stage = 'Won') AS won_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN sp.close_value
            ELSE 0
        END
    ) AS total_revenue,
    ROUND(
        AVG(
            CASE
                WHEN sp.deal_stage = 'Won' THEN sp.close_value
            END
        ),
        2
    ) AS avg_deal_size,
    ROUND(SUM(sp.deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline sp
    JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY st.manager
ORDER BY total_revenue DESC;
------------------------------------------------------------
-- 5. Sales Agent Performance (Closed Deals)
-- Which sales agents are top performers vs underperformers?
-- Insight: Identify high-impact reps and those needing support or coaching.
------------------------------------------------------------
SELECT sp.sales_agent,
    st.manager,
    COUNT(*) AS total_closed_deals,
    SUM(sp.deal_stage = 'Won') AS won_deals,
    SUM(
        CASE
            WHEN sp.deal_stage = 'Won' THEN sp.close_value
            ELSE 0
        END
    ) AS total_revenue,
    ROUND(
        AVG(
            CASE
                WHEN sp.deal_stage = 'Won' THEN sp.close_value
            END
        ),
        2
    ) AS avg_deal_size,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    ROUND(SUM(sp.deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline sp
    JOIN sales_teams st ON sp.sales_agent = st.sales_agent
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.sales_agent,
    st.manager
ORDER BY total_revenue DESC,
    win_rate_pct DESC;
------------------------------------------------------------
-- 6. Product Revenue & Pricing Power (Won Deals Only)
-- Which products drive revenue and where do we gain or lose pricing power?
-- Insight: Detect products with strong pricing leverage vs discount dependency.
------------------------------------------------------------
SELECT sp.product,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_deal_price,
    p.sales_price,
    ROUND(AVG(sp.close_value - p.sales_price), 2) AS avg_price_deviation
FROM sales_pipeline sp
    JOIN products p ON sp.product = p.product
WHERE sp.deal_stage = 'Won'
GROUP BY sp.product,
    p.sales_price
ORDER BY total_revenue DESC;
------------------------------------------------------------
-- 7. Customer Concentration (Top Accounts)
-- Are we overly dependent on a small number of high-value customers?
-- Insight: Assess revenue concentration risk and key account dependency.
------------------------------------------------------------
SELECT sp.account,
    COUNT(*) AS total_deals,
    SUM(sp.close_value) AS total_revenue,
    ROUND(AVG(sp.close_value), 2) AS avg_revenue_per_deal,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration
FROM sales_pipeline sp
WHERE sp.deal_stage = 'Won'
GROUP BY sp.account
ORDER BY total_revenue DESC
LIMIT 10;
------------------------------------------------------------
-- 8. Pipeline Efficiency (Outcome vs Duration)
-- Do faster deals close more successfully than longer ones?
-- Insight: Understand whether shorter or longer sales cycles drive better outcomes.
------------------------------------------------------------
SELECT sp.deal_stage AS outcome,
    ROUND(AVG(sp.deal_duration), 2) AS avg_deal_duration,
    COUNT(*) AS total_deals
FROM sales_pipeline sp
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.deal_stage;
------------------------------------------------------------
-- 9. Win Rate by Deal Duration Bucket
-- What deal duration range yields the highest conversion rates?
-- Insight: Identify the optimal sales cycle window for maximizing win rates.
------------------------------------------------------------
SELECT CASE
        WHEN deal_duration < 30 THEN '<30 days'
        WHEN deal_duration <= 60 THEN '30-60 days'
        WHEN deal_duration <= 90 THEN '60-90 days'
        ELSE '90+ days'
    END AS duration_bucket,
    COUNT(*) AS total_deals,
    SUM(deal_stage = 'Won') AS won_deals,
    ROUND(SUM(deal_stage = 'Won') * 100.0 / COUNT(*), 2) AS win_rate_pct
FROM sales_pipeline
WHERE deal_stage IN ('Won', 'Lost')
GROUP BY duration_bucket
ORDER BY duration_bucket;
------------------------------------------------------------
-- 10. Revenue Leakage (Lost Deals)
-- Where are we losing the most potential revenue across products?
-- Insight: Quantify missed revenue opportunities and prioritize recovery areas.
------------------------------------------------------------
SELECT sp.product,
    COUNT(*) AS lost_deals,
    SUM(p.sales_price) AS potential_revenue_lost
FROM sales_pipeline sp
    JOIN products p ON sp.product = p.product
WHERE sp.deal_stage = 'Lost'
GROUP BY sp.product
ORDER BY potential_revenue_lost DESC;
------------------------------------------------------------
-- 11. Weighted Sales Performance (Volume + Win Rate)
-- Which agents perform best when balancing efficiency and deal volume?
-- Insight: Highlight consistently strong performers while reducing small-sample bias.
------------------------------------------------------------
SELECT sp.sales_agent,
    COUNT(*) AS total_deals,
    SUM(sp.deal_stage = 'Won') AS wins,
    ROUND(
        (SUM(sp.deal_stage = 'Won') * 1.0 / COUNT(*)) * LOG(COUNT(*) + 1),
        4
    ) AS weighted_score
FROM sales_pipeline sp
WHERE sp.deal_stage IN ('Won', 'Lost')
GROUP BY sp.sales_agent
ORDER BY weighted_score DESC;
------------------------------------------------------------
-- 12. Performance by Quartile (Volume-Controlled)
-- How does performance differ between top and bottom sales tiers?
-- Insight: Measure performance gaps across tiers to identify coaching opportunities.
------------------------------------------------------------
WITH agent_perf AS (
    SELECT sp.sales_agent,
        COUNT(*) AS total_deals,
        SUM(sp.deal_stage = 'Won') * 1.0 / COUNT(*) AS win_rate
    FROM sales_pipeline sp
    WHERE sp.deal_stage IN ('Won', 'Lost')
    GROUP BY sp.sales_agent
    HAVING COUNT(*) >= 10
),
ranked AS (
    SELECT *,
        NTILE(4) OVER (
            ORDER BY win_rate DESC
        ) AS quartile
    FROM agent_perf
)
SELECT quartile,
    ROUND(AVG(win_rate) * 100, 2) AS avg_win_rate,
    ROUND(AVG(total_deals), 1) AS avg_deal_volume
FROM ranked
GROUP BY quartile
ORDER BY quartile;