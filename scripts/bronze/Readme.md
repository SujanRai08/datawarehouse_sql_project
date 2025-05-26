## storing procedure
==================================================================
stored procedure : load bronze layer (source -> bronze)
=================================================================

script purpose: 
this stored procdure loads data into the 'bronze' schema from external csv files.
it performs the following action
- truncates the bronze tables before loading data
- uses the '\copy FROM '' with ();' command to load data from csv files to bronze tables

  parameter
  - This stored procedure does not accept any params
 
    usages :
    directly load
  =====================================================================
