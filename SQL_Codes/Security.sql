create or replace role Purix;
create or replace role Winkies;
create or replace role Peacock;
create or replace user aditi password = 'aditi123' default_Role = 'market1';
grant role Purix to user aditi;
create or replace user sarita password = 'siri123' default_Role = 'market2';
grant role Winkies to user sarita;
create or replace user natalya password = 'natayla123' default_Role = 'market3';
grant role Peacock to user natalya;
SELECT CURRENT_USER();
grant role Purix to user ADITI12;
grant role Winkies to user ADITI12;
grant role Peacock to user ADITI12;
--------------------2---------------------------------
create or replace table product(prod_index number , prod_role_name varchar);
insert into product values (2001, 'Purix'),
 (2002,'Winkies'),
 (2003,'Peacock');
select * from product;
grant usage on warehouse "WAREHOUSE2" TO role Purix;
grant usage on warehouse "WAREHOUSE2" TO role Winkies;
grant usage on warehouse "WAREHOUSE2" TO role Peacock;
grant usage on database SNOWFLAKE_PRACTICE TO role Purix;
grant usage on database SNOWFLAKE_PRACTICE TO role Winkies;
grant usage on database SNOWFLAKE_PRACTICE TO role Peacock ;
grant usage on SCHEMA PUBLIC TO role Purix;
grant usage on SCHEMA PUBLIC TO role Winkies;
grant usage on SCHEMA PUBLIC TO role Peacock ;
-------------------3-----------------------------------------
create or replace secure view vw_prod as
select p.*
from bigbasket_table p
where (p.brand) in (select (prod_role_name)
 from product
 where upper(prod_role_name) = upper(current_role()));

select current_role();

grant select on view "SNOWFLAKE_PRACTICE"."PUBLIC".VW_PROD to role Purix ;
grant select on view "SNOWFLAKE_PRACTICE"."PUBLIC".VW_PROD to role Winkies;
grant select on view "SNOWFLAKE_PRACTICE"."PUBLIC"."VW_PROD" to role Peacock;
--------------------4------------------------------------------------
use role PURIX;
use database SNOWFLAKE_PRACTICE;
use schema PUBLIC;
select * from VW_PROD;
use role Winkies ;
use database SNOWFLAKE_PRACTICE;
use schema PUBLIC;
select * from VW_PROD;
-----------------------columnlevel--------------------------------------------
CREATE or replace MASKING POLICY MaskingPolicy AS (VAL STRING) RETURNS STRING ->
 CASE
 WHEN CURRENT_ROLE() IN ('PROD_ADMIN') THEN VAL
 ELSE '**'
 END;
create role prod_admin;
alter table if exists target_t modify column product set masking policy MaskingPolicy;

 select current_role();
 select current_user();


GRANT SELECT ON target_t TO ROLE prod_admin ;
grant usage on warehouse warehouse2 to role prod_admin;
 grant usage on database snowflake_practice to role prod_admin;

 grant usage on schema public to role prod_admin;

 grant role prod_admin to user ADITI12;
 use role prod_admin;
 select * from target_t;