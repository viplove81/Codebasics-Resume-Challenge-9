/*
4.  Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. 
	Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: 
    category, isu%, and rank order. 
    This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.
	Note: ISU% (Incremental Sold Quantity Percentage) is calculated as the percentage increase/decrease in quantity sold 
    (after promo) compared to quantity sold (before promo)
*/
WITH CTE1 AS
			(SELECT c.campaign_name,p.category,
			ROUND((SUM(
						if(promo_type = "BOGOF",quantity_sold_after_promo * 2 ,quantity_sold_after_promo))
					/SUM(f.quantity_sold_before_promo)-1)*100,2) AS ISU_percent
			FROM dim_products p
			JOIN fact_events f
			USING (product_code)
            JOIN dim_campaigns c
            USING (campaign_id)
            WHERE c.campaign_name='Diwali'
			GROUP BY p.category)
SELECT *,RANK() OVER (order by ISU_percent DESC) AS rank_order
FROM CTE1;
 # CTE1 - used Common_Table_Expression to double the quantities, if the promotion_type = "BOGOf"
 # RANK() - used window function to obtain the ranks of the categories based on their ISU%
