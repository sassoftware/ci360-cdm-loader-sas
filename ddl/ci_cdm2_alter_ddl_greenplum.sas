
/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - GREENPLUM */
/*=====================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pass = <Password> ;          /* Greenplum Password      */
%let db   = <Database> ;          /* Greenplum Database      */
%let server = <Server> ;          /* Greenplum Server        */
%let port = <Port> ;              /* Greenplum Port          */
%let schema = <Schema>;           /* Greenplum Schema        */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO GREENPLM (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER PORT=&PORT);

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_contact_history ADD control_group_flg CHAR(1) NULL) BY GREENPLM;

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_response_history ADD properties_map_doc VARCHAR(4000) NULL) BY GREENPLM;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD control_group_action_nm VARCHAR(65) NULL) BY GREENPLM;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD stratified_sampling_action_nm VARCHAR(65) NULL) BY GREENPLM;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD segment_tests_flg CHAR(1) NULL) BY GREENPLM;

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
	test_pct             NUMERIC(5,2)  ,
	stratified_sampling_flg CHAR(1)  ,
	stratified_samp_criteria_txt VARCHAR(1024)  ,
	updated_dttm         TIMESTAMP  
) DISTRIBUTED BY (test_cd)) BY GREENPLM;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test_x_segment
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36)  ,
	updated_dttm         TIMESTAMP  
) DISTRIBUTED BY (test_cd)) BY GREENPLM;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test
	ADD CONSTRAINT  segment_test_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY GREENPLM;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT  segment_test_x_segment_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY GREENPLM;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT segment_test_x_segment_fk1 FOREIGN KEY (test_cd,task_version_id,task_id) REFERENCES cdm_segment_test (test_cd,task_version_id,task_id)) BY GREENPLM;

DISCONNECT FROM GREENPLM;
QUIT;

