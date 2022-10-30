create or replace stream delta_s on table bigbasket_table;


 create or replace table target_t(
    index int,
    product varchar,
    category varchar,
    sub_category varchar,
    brand varchar,
 sale_price number,
 market_price number,
 type string,
 rating number,
 description varchar,
 stream_type string default null,
 rec_version number default 0,
 REC_DATE TIMESTAMP_LTZ);
select * from delta_s;
CREATE or replace TASK t_merge
 WAREHOUSE = warehouse2
 SCHEDULE = '1 minute'
WHEN
 SYSTEM$STREAM_HAS_DATA('delta_s')
AS
merge into target_t t
using delta_s s
on t.index=s.index and (metadata$action='DELETE')
when matched and metadata$isupdate='FALSE' then update set rec_version=9999, stream_type='DELETE'
when matched and metadata$isupdate='TRUE' then update set rec_version=rec_version-1
when not matched then insert (
    index ,
 product ,
 category ,
 sub_category,
 brand ,
 sale_price ,
 market_price ,
 type ,
 rating ,
 description ,
 stream_type,
 rec_version,
 REC_DATE) values(s.index ,
 s.product ,
 s.category ,
 s.sub_category ,
 s.brand ,
 s.sale_price ,
 s.market_price ,
 s.type ,
 s.rating ,
 s.description ,
 metadata$action,
 0,
 CURRENT_TIMESTAMP() );
ALTER TASK t_merge RESUME;
update bigbasket_table set brand='Oral-B' where index=2001;
select * from delta_s;
select * from target_t;