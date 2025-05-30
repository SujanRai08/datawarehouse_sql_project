--- business logic 
-- =========================================================================
-- creating dim_customer gold layers 
CREATE VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cust_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the mast for gender info
	ELSE COALESCE(ca.gen, 'n/a') 
	END AS gender,
	ci.cst_marital_status marital_status,
	la.cntry AS country,
	ca.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cust_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cust_key = la.cid;


-- checking
SELECT DISTINCT 
ci.cst_gndr,
ca.gen,
CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the mast for gender info
ELSE COALESCE(ca.gen, 'n/a') 
END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cust_key = ca.cid
ORDER BY 1,2;


SELECT distinct gender FROM gold.dim_customers;

-- prd key quality checking
select * from silver.crm_prd_info;
SELECT * FROM silver.crm_prd_info;

SELECT pn.cat_id
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
  ON pn.cat_id = pc.id
WHERE pc.id IS NULL;

SELECT COUNT(*) 
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
  ON pn.cat_id = pc.id
WHERE pc.id IS NULL;
SELECT prd_key,COUNT(*) FROM silver.crm_prd_info GROUP BY prd_key HAVING COUNT(*) > 1;
-- ============================================================================================
-- gold layers for product 
CREATE VIEW gold.dim_product AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_dt,pn.prd_key) AS Product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL; -- current 


-- ==============================================================
-- sales details this is only from crm fact table
-- join the surrogate key
CREATE VIEW gold.fact_sales AS 
SELECT 
	sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS ship_date,
    sd.sls_due_dt due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS Quantity,
    sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_product pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id;


-- checking quality
SELECT * FROM gold.fact_sales;

-- foreign key integration dimension testing
SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_product p
ON p.product_key = f.product_key 
WHERE p.product_key is NULL;
