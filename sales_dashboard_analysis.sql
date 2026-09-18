-- =====================================================
-- SALES DASHBOARD SQL ANALYSIS
-- =====================================================


-- =====================================================
-- 1. TIME-BASED ANALYSIS
-- =====================================================

-- Monthly Revenue
SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(price_total) AS revenue
FROM public.od_invoice_rep
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

-- Monthly Profit
SELECT
    DATE_TRUNC('month', date) AS month,
    SUM(profit) AS profit
FROM public.od_invoice_rep
GROUP BY DATE_TRUNC('month', date)
ORDER BY month;

-- Month-over-Month Growth
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', date) AS month,
        SUM(price_total) AS revenue
    FROM public.od_invoice_rep
    GROUP BY DATE_TRUNC('month', date)
)

SELECT
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(
        (
            (revenue - LAG(revenue) OVER (ORDER BY month))
            / NULLIF(LAG(revenue) OVER (ORDER BY month), 0)
        ) * 100,
        2
    ) AS mom_growth_percentage
FROM monthly_sales
ORDER BY month;

-- Yearly Revenue
SELECT
    EXTRACT(YEAR FROM date) AS year,
    SUM(price_total) AS revenue
FROM public.od_invoice_rep
GROUP BY EXTRACT(YEAR FROM date)
ORDER BY year;



-- =====================================================
-- 2. PRODUCT ANALYSIS
-- =====================================================

-- Revenue by Product
SELECT
    od_pdt_type_id,
    SUM(price_total) AS revenue,
    SUM(profit) AS profit,
    SUM(product_qty) AS quantity
FROM public.od_invoice_rep
GROUP BY od_pdt_type_id
ORDER BY revenue DESC;

-- Revenue by Product Group
SELECT
    od_pdt_sub_group_id,
    SUM(price_total) AS revenue,
    SUM(profit) AS profit,
    SUM(product_qty) AS quantity
FROM public.od_invoice_rep
GROUP BY od_pdt_sub_group_id
ORDER BY revenue DESC;


-- =====================================================
-- 3. CUSTOMER ANALYSIS
-- =====================================================

-- Revenue by Customer
SELECT
    partner_customer_id,
    SUM(price_total) AS revenue,
    SUM(profit) AS profit,
    SUM(product_qty) AS quantity
FROM public.od_invoice_rep
GROUP BY partner_customer_id
ORDER BY revenue DESC;

-- Top 10 Customers
SELECT
    partner_customer_id,
    SUM(price_total) AS revenue
FROM public.od_invoice_rep
GROUP BY partner_customer_id
ORDER BY revenue DESC
LIMIT 10;


-- =====================================================
-- 4. SALESPERSON ANALYSIS
-- =====================================================

-- Revenue by Salesperson
SELECT
    salesperson_char AS salesperson,
    SUM(price_total) AS revenue
FROM public.od_invoice_rep
GROUP BY salesperson_char
ORDER BY revenue DESC;

-- Profit by Salesperson
SELECT
    salesperson_char AS salesperson,
    SUM(profit) AS profit
FROM public.od_invoice_rep
GROUP BY salesperson_char
ORDER BY profit DESC;

-- =====================================================
-- 5. CHANNEL / SALES TYPE ANALYSIS
-- =====================================================
-- Profit by Channel
SELECT
    od_sale_type_id,
    SUM(price_total) AS revenue,
    SUM(profit) AS profit,
    SUM(product_qty) AS quantity
FROM public.od_invoice_rep
GROUP BY od_sale_type_id
ORDER BY revenue DESC;


