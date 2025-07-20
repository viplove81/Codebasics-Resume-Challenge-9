/*
3.  Generate a report that displays each campaign along with the 
	total revenue generated before and after the campaign? 
    The report includes three key fields: campaign _name, 
    total revenue(before_promotion), total revenue(after_promotion). 
    This report should help in evaluating the financial impact of our promotional campaigns. (Display the values in millions)
*/
ALTER TABLE fact_events RENAME COLUMN `quantity_sold(before_promo)` TO quantity_sold_before_promo;
ALTER TABLE fact_events RENAME COLUMN `quantity_sold(after_promo)` TO quantity_sold_after_promo;

SELECT c.campaign_name,
ROUND(SUM(quantity_sold_before_promo*base_price)/1000000,2) AS total_revenue_million_bp,
ROUND(SUM(CASE 
				WHEN promo_type='BOGOF' THEN base_price*0.5*2*quantity_sold_after_promo
				WHEN promo_type='50% OFF' THEN base_price*0.5*quantity_sold_after_promo
				WHEN promo_type='25% OFF' THEN base_price*0.75*quantity_sold_after_promo
				WHEN promo_type='33% OFF' THEN base_price*0.67*quantity_sold_after_promo
				WHEN promo_type='500 cashback' THEN (base_price-500)*quantity_sold_after_promo
				END)/1000000,2) AS total_revenue_million_ap
FROM dim_campaigns c
JOIN fact_events f
USING (campaign_id)
GROUP BY c.campaign_name;

 # SUM - to add all the revenues obtained before promotion
 # ROUND - to round the number to the specified number of decimals
 # CASE - to calculate revenue after promotion based on different promo_types
 # JOIN - to join dim_campaigns table with facts table to obtain the campaign_name
