-- cust_az


WHERE CASE WHEN cid like 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
ELSE cid
END NOT IN (SELECT DISTINCT cust_key FROM silver.crm_cust_info)


INSERT INTO silver.erp_cust_az12
( 
cid,
bdate,
gen
)
SELECT
CASE WHEN cid like 'NAS%' THEN SUBSTRING(cid,4,LENGTH(cid))
ELSE cid
END AS cid,
CASE WHEN bdate > CURRENT_DATE THEN NULL
ELSE bdate
END AS bdate,
CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12;



