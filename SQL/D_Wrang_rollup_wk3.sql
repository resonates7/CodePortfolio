/*
Data Wrangling, Analysis, and AB Testing
Week 3
Code Portfolio
CREATE A Rollup Table
*/


SELECT
 dr.date
 ,  COALESCE(sum(oo.cnt_orders), 0)       AS orders
 , COALESCE(sum(oo.cnt_order_line), 0)   AS order_ln
 , count(*) AS rows

FROM dsv1069.dates_rollup AS dr
  LEFT OUTER JOIN
  (
    SELECT date(o.paid_at)              AS day
     , COUNT(DISTINCT o.invoice_id)     AS cnt_orders
     , COUNT(DISTINCT line_item_id)              AS cnt_order_line
    FROM dsv1069.orders o 
    GROUP BY date(o.paid_at)
   ) AS oo 
 ON 
  dr.date >= oo.day
 AND
  dr.d7_ago < oo.day
GROUP BY dr.date
ORDER BY dr.date