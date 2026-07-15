create database amazon_sales_report;
use amazon_sales_report;
select *from amazon_sales_report_cleaned;
--1. Which specific cities or regions suffer from the highest cancellation and return rates?

SELECT 
    `ship-state` AS state,
    COUNT(`order_id`) AS total_orders,
    ROUND(SUM(CASE WHEN `status` NOT LIKE '%Cancel%' AND `status` NOT LIKE '%Return%' THEN `amount` ELSE 0 END), 2) AS successful_revenue,
    ROUND(SUM(CASE WHEN `status` LIKE '%Cancel%' OR `status` LIKE '%Return%' THEN `amount` ELSE 0 END), 2) AS lost_revenue,
    COUNT(CASE WHEN `status` LIKE '%Cancel%' OR `status` LIKE '%Return%' THEN 1 END) AS failed_order_count,
    ROUND(COUNT(CASE WHEN `status` LIKE '%Cancel%' OR `status` LIKE '%Return%' THEN 1 END) * 100.0 / COUNT(`order_id`), 2) AS order_failure_rate_percentage,
    ROUND(SUM(CASE WHEN `status` LIKE '%Cancel%' OR `status` LIKE '%Return%' THEN `amount` ELSE 0 END) * 100.0 / NULLIF(SUM(`amount`), 0),2 ) AS financial_loss_percentage
FROM amazon_sales_report_cleaned
WHERE `ship-state` IS NOT NULL 
  AND `ship-state` NOT IN ('Unknown', 'Not Provided', 'FBA-Masked')
GROUP BY `ship-state`
HAVING COUNT(`order_id`) >100
ORDER BY financial_loss_percentage DESC;


--Do zero-cost promotional giveaway orders actually trigger an increase in full-priced paid orders for those same styles in the following weeks?

WITH GiveawayWeeks AS (
    SELECT 
        `style`,
        `date` AS giveaway_date,
        DATE_ADD(STR_TO_DATE(`date`, '%Y-%m-%d'), INTERVAL 14 DAY) AS window_end_date
    FROM amazon_sales_report_cleaned
    WHERE `amount` = 0 AND `qty` > 0
    GROUP BY `style`, `date`
),
PostGiveawaySales AS (
    SELECT 
        g.`style`,
        g.giveaway_date,
        COUNT(CASE WHEN r.`amount` > 0 AND r.`status` NOT LIKE '%Cancel%' THEN r.order_id END) AS paid_orders_in_window,
        SUM(CASE WHEN r.`amount` > 0 AND r.`status` NOT LIKE '%Cancel%' THEN r.amount ELSE 0 END) AS paid_revenue_in_window
    FROM GiveawayWeeks g
    INNER JOIN amazon_sales_report_cleaned r 
        ON g.`style` = r.`style`
        AND STR_TO_DATE(r.`date`, '%Y-%m-%d') > STR_TO_DATE(g.giveaway_date, '%Y-%m-%d')
        AND STR_TO_DATE(r.`date`, '%Y-%m-%d') <= g.window_end_date
    GROUP BY g.`style`, g.giveaway_date
)
SELECT 
    p.`style`,
    COUNT(DISTINCT p.giveaway_date) AS total_giveaway_days,
    SUM(p.paid_orders_in_window) AS total_subsequent_paid_orders,
    ROUND(SUM(p.paid_revenue_in_window), 2) AS total_subsequent_revenue,
    ROUND(AVG(p.paid_orders_in_window), 2) AS avg_paid_orders_per_promo_event
FROM PostGiveawaySales p
GROUP BY p.`style`
ORDER BY total_subsequent_revenue DESC;

--What is the exact percentage of sales revenue lost to cart cancellations across each product category?


SELECT 
    category,
    SUM(CASE WHEN LOWER(status) = 'cancelled' THEN amount ELSE 0 END) AS cancelled_revenue,
    SUM(amount) AS total_potential_revenue,
    ROUND(
        (SUM(CASE WHEN LOWER(status) = 'cancelled' THEN amount ELSE 0 END) / NULLIF(SUM(amount), 0)) * 100, 
        2
    ) AS pct_revenue_lost
FROM 
   amazon_sales_report.amazon_sales_report_cleaned
WHERE 
    amount IS NOT NULL 
    AND amount > 0
GROUP BY 
    category
ORDER BY 
    pct_revenue_lost DESC;






