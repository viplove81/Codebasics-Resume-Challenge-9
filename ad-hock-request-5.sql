/*
5.	Create a report featuring the Top 5 products, 
	ranked by Incremental Revenue Percentage (IR%), across all campaigns. 
    The report will provide essential information including product name, 
    category, and ir%. This analysis helps identify the most successful products
    in terms of incremental revenue across our campaigns, assisting in product optimization.
*/

WITH CTE1 AS(
				SELECT p.product_name,p.category,
				ROUND((SUM(CASE 
								WHEN promo_type='BOGOF' THEN base_price*0.5*2*quantity_sold_after_promo
								WHEN promo_type='50% OFF' THEN base_price*0.5*quantity_sold_after_promo
								WHEN promo_type='25% OFF' THEN base_price*0.75*quantity_sold_after_promo
								WHEN promo_type='33% OFF' THEN base_price*0.67*quantity_sold_after_promo
								WHEN promo_type='500 cashback' THEN (base_price-500)*quantity_sold_after_promo
								END)/SUM(f.quantity_sold_before_promo*f.base_price)-1)*100,2) AS IR_percent
				FROM dim_products p
				JOIN fact_events f
				USING (product_code)
				GROUP BY p.product_name,p.category)
SELECT *, 
RANK() OVER (ORDER BY IR_percent DESC) AS rank_no 
FROM cte1 LIMIT 5;

 # RANK() - used window function to obtain the ranks of the categories based on their IR%
