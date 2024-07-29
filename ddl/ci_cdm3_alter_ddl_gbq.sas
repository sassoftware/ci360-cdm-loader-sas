/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - BigQuery  */
/*=====================================================================*/

%let project = <Project>;      /* ProjectID - Do Not Quote This Value             */
%let schema = <Schema>;        /* BigQuery Schema - Do Not Quote This Value       */
%let cred_path = <Cred_Path>;  /* Credentials File Path - Do Not Quote This Value */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 3.0         */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOGBQ (PROJECT="&PROJECT" CRED_PATH="&CRED_PATH" SCHEMA="&SCHEMA");

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE `&schema..cdm_response_history` ADD COLUMN response_dttm_tz TIMESTAMP) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_response_history` ADD COLUMN audience_id STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_response_history` ADD COLUMN audience_occur_id STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_response_history` ADD COLUMN context_type_nm STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_response_history` ADD COLUMN context_val STRING) BY SASIOGBQ;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE `&schema..cdm_contact_history` ADD COLUMN contact_dttm_tz TIMESTAMP) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_contact_history` ADD COLUMN audience_id STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_contact_history` ADD COLUMN audience_occur_id STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_contact_history` ADD COLUMN context_type_nm STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE `&schema..cdm_contact_history` ADD COLUMN context_val STRING) BY SASIOGBQ;

/*** cdm_audience_detail ***/ 

EXECUTE (CREATE TABLE &SCHEMA..cdm_audience_detail
(
	audience_id          STRING NOT NULL ,
	audience_nm          STRING  ,
	audience_desc        STRING  ,
	created_user_nm      STRING  ,
	audience_schedule_flg STRING  ,
	audience_source_nm   STRING  ,
	audience_data_source_nm STRING  ,
	create_dttm          TIMESTAMP  ,
	delete_dttm          TIMESTAMP  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;


/*** cdm_audience_occur_detail ***/

EXECUTE (CREATE TABLE &SCHEMA..cdm_audience_occur_detail
(
	audience_occur_id    STRING NOT NULL ,
	audience_id          STRING  ,
	execution_status_cd  STRING  ,
	audience_size_cnt    INT64  ,
	started_by_nm        STRING  ,
	occurrence_type_nm   STRING  ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

DISCONNECT FROM SASIOGBQ;
QUIT;


