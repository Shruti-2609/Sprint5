create or replace storage integration s3_int
 type = external_stage
 storage_provider = s3
 enabled = true
 storage_aws_role_arn = 'arn:aws:iam::584656942548:role/role-5'
 storage_allowed_locations = ('s3://bucketgroup-5/');
 DESC INTEGRATION s3_int;

 create or replace file format my_csv_format
type = csv field_delimiter = ',' skip_header = 1 null_if = ('NULL', 'null') empty_field_as_null = true
field_optionally_enclosed_by='"';
desc file format snowflake_practice.public.my_csv_format;
create or replace stage my_s3_stage
 storage_integration = s3_int
 url = 's3://bucketgroup-5/'
 file_format = my_csv_format;
select t.$1 as index
,t.$2 product,t.$3 category ,t.$4 sub_category,t.$5 brand, t.$6 sale_price,t.$7 market_price,t.$8 type,t.$9 rating,t.$10 description
from @snowflake_practice.public.my_s3_stage/ t;
list @my_s3_stage;
