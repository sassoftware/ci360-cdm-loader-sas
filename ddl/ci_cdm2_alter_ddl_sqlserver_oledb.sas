/*==============================================================================*/
/* Enter Customer Specific Target Source Connection Values - SQL Server (OLEDB) */
/*==============================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pwd  = <Password> ;          /* SQL Server Password     */
%let dsn  = <Data Source>;        /* SQL Server Data Source  */
%let schema = <Schema>;           /* SQL Server Schema       */
%let catalog = <Catalog>;         /* SQL Server Catalog      */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO OLEDB (USER=&USER PWD=&PWD DSN=&DSN PROMPT=NO
                  PROVIDER=SQLOLEDB PROPERTIES=("Initial Catalog"=&CATALOG));

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_response_history ADD properties_map_doc VARCHAR(4000) NULL) BY OLEDB;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_contact_history ADD control_group_flg CHAR(1) NULL) BY OLEDB;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD control_group_action_nm VARCHAR(65) NULL) BY OLEDB;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD stratified_sampling_action_nm VARCHAR(65) NULL) BY OLEDB;
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD segments_tests_flg CHAR(1) NULL) BY OLEDB;

/*** cdm_segment_test ***/
EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test
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
	updated_dttm         DATETIME2 NULL 
)) BY OLEDB;

/*** cdm_segment_test_x_segment ***/
EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_test_x_segment
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36) NULL ,
	updated_dttm         DATETIME2 NULL 
)) BY OLEDB;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test
	ADD CONSTRAINT  segment_test_pk PRIMARY KEY (test_cd ASC,task_version_id ASC,task_id ASC)) BY OLEDB;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT  segment_test_x_segment_pk PRIMARY KEY (test_cd ASC,task_version_id ASC,task_id ASC)) BY OLEDB;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	ADD CONSTRAINT segment_test_x_segment_fk1 FOREIGN KEY (test_cd, task_version_id, task_id) REFERENCES cdm_segment_test (test_cd, task_version_id, task_id)) BY OLEDB;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_segment_test_x_segment
	NOCHECK CONSTRAINT segment_test_x_segment_fk1 ) BY OLEDB;
	
DISCONNECT FROM OLEDB;
QUIT;


