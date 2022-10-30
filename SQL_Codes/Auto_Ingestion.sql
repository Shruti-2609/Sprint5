create or replace pipe snowpipe auto_ingest=true as
 copy into bigbasket_table
from (select t.$1,t.$2 ,t.$3 ,t.$4 ,t.$5, t.$6,t.$7 ,t.$8,t.$9,t.$10 from @my_s3_stage/ t)
file_format=(type= csv field_optionally_enclosed_by='"' ,SKIP_HEADER=1)
pattern='.*.csv'
ON_ERROR='skip_file';
desc pipe snowpipe;
alter pipe snowpipe refresh;
show pipes;
select SYSTEM$PIPE_STATUS ('snowpipe');
select * from table (validate_pipe_load(
pipe_name=>'snowpipe',
start_time=>dateadd(minute, -5, current_timestamp())));
select *
from table(information_schema.copy_history(table_name=>'bigbasket_table', start_time=> dateadd(hours, -1, current_timestamp())));
select * from bigbasket_table;