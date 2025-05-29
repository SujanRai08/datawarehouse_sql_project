-- Data transformation and cleansing
-- TRUNCATE TABLE IF EXISTS silver.crm_cust_info;
INSERT INTO silver.crm_cust_info (
    cst_id,
    cust_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    TRIM(cast_key) AS cust_key,
    TRIM(cst_first_name) AS cst_first_name,
    TRIM(cst_lastname) AS cst_lastname,
    CASE 
        WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
        WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE 
        WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'MALE'
        WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'FEMALE'
        ELSE 'n/a'
    END AS cst_gndr,
    cst_create_date
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag_last
    FROM bronze.crm_cust_info
) AS ranked
WHERE flag_last = 1;

-- Verify the output
SELECT * FROM silver.crm_cust_info;