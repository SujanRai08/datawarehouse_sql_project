\echo ============================
\echo Loading Bronze Layer 
\echo ============================

\timing on

\echo ============================
\echo Loading CRM Tables 
\echo ============================

\echo >> Truncating Table: bronze.crm_cust_info
TRUNCATE TABLE bronze.crm_cust_info;

\echo >> Inserting Data Into: bronze.crm_cust_info
\COPY bronze.crm_cust_info FROM 'C:/Users/Acer/Documents/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

\echo >> Truncating Table: bronze.crm_prd_info
TRUNCATE TABLE bronze.crm_prd_info;

\echo >> Inserting Data Into: bronze.crm_prd_info
\COPY bronze.crm_prd_info FROM 'C:/Users/Acer/Documents/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

\echo >> Truncating Table: bronze.crm_sales_details
TRUNCATE TABLE bronze.crm_sales_details;

\echo >> Inserting Data Into: bronze.crm_sales_details
\COPY bronze.crm_sales_details FROM 'C:/Users/Acer/Documents/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

\echo ============================
\echo Loading ERP Tables 
\echo ============================

\echo >> Truncating Table: bronze.erp_cust_az12
TRUNCATE TABLE bronze.erp_cust_az12;

\echo >> Inserting Data Into: bronze.erp_cust_az12
\COPY bronze.erp_cust_az12 FROM 'C:/Users/Acer/Documents/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

\echo >> Truncating Table: bronze.erp_loc_a101
TRUNCATE TABLE bronze.erp_loc_a101;

\echo >> Inserting Data Into: bronze.erp_loc_a101
\COPY bronze.erp_loc_a101 FROM 'C:/Users/Acer/Documents/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');

\echo >> Truncating Table: bronze.erp_px_cat_g1v2
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

\echo >> Inserting Data Into: bronze.erp_px_cat_g1v2
\COPY bronze.erp_px_cat_g1v2 FROM 'C:/Users/Acer/Documents/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' WITH (FORMAT csv, HEADER true, DELIMITER ',');
