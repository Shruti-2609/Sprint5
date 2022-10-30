create or replace table bigbasket_table(
 index int,product varchar,category varchar,sub_category varchar,brand varchar,sale_price number,market_price number,type
string,rating number,description varchar
);
copy into bigbasket_table
from @my_s3_stage
file_format=(type= csv field_optionally_enclosed_by='"' ,SKIP_HEADER=1)
pattern ='.*.csv'
ON_ERROR ='skip_file';
CREATE or replace TASK mytask_minute
 WAREHOUSE = WAREHOUSE2
 //SCHEDULE = 'USING CRON 00 00 * * 4 Asia/Kolkata'
 SCHEDULE = '1 MINUTE'
 TIMESTAMP_INPUT_FORMAT = 'YYYY-MM-DD HH24'
AS
copy INTO bigbasket_table
from(select t.$1,t.$2,t.$3 ,t.$4,t.$5,t.$6,t.$7,t.$8,t.$9,t.$10 from @my_s3_stage/ t)
file_format=(type= csv field_optionally_enclosed_by='"')
pattern = '.*.csv'
on_error='skip_file';
alter task mytask_minute resume;
select * from bigbasket_table