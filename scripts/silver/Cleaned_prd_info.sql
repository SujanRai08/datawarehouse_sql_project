SELECT prd_id,
COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

DROP TABLE IF EXISTS silver.crm_prd_info;
CREATE TABLE silver.crm_prd_info(
	prd_id INT,
	cat_id VARCHAR(50),
	prd_key VARCHAR(50),
	prd_nm VARCHAR(50),
	prd_cost INT,
	prd_line VARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATE DEFAULT CURRENT_DATE
);

INSERT INTO silver.crm_prd_info (
    prd_id,
    prd_key,
    cat_id,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    prd_nm,
    COALESCE(prd_cost, 0) AS prd_cost,
    CASE 
        WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
        WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
        WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
        WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line,
    prd_start_dt::DATE AS prd_start_dt,
    (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) - INTERVAL '1 day')::DATE AS prd_end_dt
FROM bronze.crm_prd_info;  

SELECT * from silver.crm_prd_info limit 10;
 
