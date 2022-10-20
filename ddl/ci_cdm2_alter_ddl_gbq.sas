/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - BigQuery  */
/*=====================================================================*/

%let project = <Project>;      /* ProjectID - Do Not Quote This Value             */
%let schema = <Schema>;        /* BigQuery Schema - Do Not Quote This Value       */
%let cred_path = <Cred_Path>;  /* Credentials File Path - Do Not Quote This Value */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOGBQ (PROJECT="&PROJECT" CRED_PATH="&CRED_PATH" SCHEMA="&SCHEMA");

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_contact_history ADD COLUMN control_group_flg STRING) BY SASIOGBQ;

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_response_history ADD COLUMN properties_map_doc STRING) BY SASIOGBQ;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD COLUMN control_group_action_nm STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD COLUMN stratified_sampling_action_nm STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD COLUMN segment_tests_flg STRING) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test
(
	test_cd              STRING NOT NULL ,
	task_version_id      STRING NOT NULL ,
	task_id              STRING NOT NULL ,
	test_nm              STRING  ,
	test_type_nm         STRING  ,
	test_enabled_flg     STRING  ,
	test_sizing_type_nm  STRING  ,
	test_cnt             INT64  ,
	test_pct             NUMERIC  ,
	stratified_sampling_flg STRING  ,
	stratified_samp_criteria_txt STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test_x_segment
(
	test_cd              STRING NOT NULL ,
	task_version_id      STRING NOT NULL ,
	task_id              STRING NOT NULL ,
	segment_id           STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

DISCONNECT FROM SASIOGBQ;
QUIT;


