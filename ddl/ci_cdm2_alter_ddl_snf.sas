		 
/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Snowflake */
/*=====================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pass = <Password> ;          /* Snowflake Password      */
%let db  = <Database>;            /* Database                */
%let schema = <Schema>;           /* Snowflake Schema        */
%let server = <Server>;           /* Server                  */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOSNF (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

/*** cdm_contact_history ***/

EXECUTE(ALTER TABLE &SCHEMA..cdm_contact_history ADD control_group_flg CHAR(1) NULL) BY SASIOSNF;

/*** cdm_response_history ***/

EXECUTE(ALTER TABLE &SCHEMA..cdm_response_history ADD properties_map_doc VARCHAR(4000) NULL) BY SASIOSNF;

/*** cdm_task_detail ***/

EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD control_group_action_nm VARCHAR(65) NULL) BY SASIOSNF;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD stratified_sampling_action_nm VARCHAR(65) NULL) BY SASIOSNF;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD segment_tests_flg CHAR(1) NULL) BY SASIOSNF;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	test_nm              VARCHAR(65)  ,
	test_type_nm         VARCHAR(10)  ,
	test_enabled_flg     CHAR(1)  ,
	test_sizing_type_nm  VARCHAR(65)  ,
	test_cnt             INTEGER  ,
	test_pct             NUMBER(5,2)  ,
	stratified_sampling_flg CHAR(1)  ,
	stratified_samp_criteria_txt VARCHAR(1024)  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOSNF;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test_x_segment
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36)  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOSNF;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test
	ADD CONSTRAINT  segment_test_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY SASIOSNF;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT  segment_test_x_segment_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY SASIOSNF;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT segment_test_x_segment_fk1 FOREIGN KEY (test_cd, task_version_id, task_id) REFERENCES cdm_segment_test (test_cd, task_version_id, task_id)) BY SASIOSNF;

DISCONNECT FROM SASIOSNF;
QUIT;

