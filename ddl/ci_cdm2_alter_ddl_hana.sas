
/*==================================================================================*/
/* Enter Customer Specific Target Source Connection Values - SAP Hana - Column Store*/
/*==================================================================================*/

%let user = <User Name> ;         /* SAP Hana User           */
%let pass = <Password> ;          /* SAP Hana Password       */
%let server = '<Server>' ;        /* SAP Hana Server         */
%let instance = <Instance>;       /* SAP Hana Instance       */
%let schema = <Schema> ;          /* SAP Hana Schema         */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOHNA (USER=&USER PASS=&PASS SERVER=&SERVER
                       INSTANCE=&INSTANCE);

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_contact_history ADD control_group_flg CHAR(1) NULL) BY SASIOHNA;

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_response_history ADD properties_map_doc VARCHAR(4000) NULL) BY SASIOHNA;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD control_group_action_nm VARCHAR(65) NULL) BY SASIOHNA;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD stratified_sampling_action_nm VARCHAR(65) NULL) BY SASIOHNA;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD segment_tests_flg CHAR(1) NULL) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE cdm_segment_test
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	test_nm              VARCHAR(65) NULL ,
	test_type_nm         VARCHAR(10) NULL ,
	test_enabled_flg     CHAR(1) NULL ,
	test_sizing_type_nm  VARCHAR(65) NULL ,
	test_cnt             INTEGER NULL ,
	test_pct             NUMERIC(5,2) NULL ,
	stratified_sampling_flg CHAR(1) NULL ,
	stratified_samp_criteria_txt VARCHAR(1024) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE cdm_segment_test_x_segment
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_segment_test
	ADD CONSTRAINT  segment_test_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT  segment_test_x_segment_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY SASIOHNA;

DISCONNECT FROM SASIOHNA;
QUIT;

