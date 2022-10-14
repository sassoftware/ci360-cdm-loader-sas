/*===================================================================*/
/* Enter Customer Specific Target Source Connection Values - Oracle  */
/*===================================================================*/

%let path = <Oracle TNS Entry> ;  /* From tnsnames.ora     */
%let user = <User Name> ;         /* Oracle User/Schema    */
%let pass = <Password> ;          /* Oracle Password       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ORACLE (USER=&USER PASS=&PASS PATH=&PATH);

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE cdm_response_history ADD (properties_map_doc VARCHAR2(4000) NULL)) BY ORACLE;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE cdm_contact_history ADD (control_group_flg CHAR(1) NULL)) BY ORACLE;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE cdm_task_detail ADD (control_group_action_nm VARCHAR2(65) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_task_detail ADD (stratified_sampling_action_nm VARCHAR2(65) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_task_detail ADD (segment_tests_flg CHAR(1) NULL)) BY ORACLE;

/*** cdm_segment_test ***/
EXECUTE (CREATE TABLE cdm_segment_test
(
	test_cd              VARCHAR2(60) NOT NULL ,
	task_version_id      VARCHAR2(36) NOT NULL ,
	task_id              VARCHAR2(36) NOT NULL ,
	test_nm              VARCHAR2(65) NULL ,
	test_type_nm         VARCHAR2(10) NULL ,
	test_enabled_flg     CHAR(1) NULL ,
	test_sizing_type_nm  VARCHAR2(65) NULL ,
	test_cnt             INTEGER NULL ,
	test_pct             NUMBER(5,2) NULL ,
	stratified_sampling_flg CHAR(1) NULL ,
	stratified_samp_criteria_txt VARCHAR2(1024) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_test
	ADD CONSTRAINT  segment_test_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY ORACLE;

/*** cdm_segment_test_x_segment ***/
EXECUTE (CREATE TABLE cdm_segment_test_x_segment
(
	test_cd              VARCHAR2(60) NOT NULL ,
	task_version_id      VARCHAR2(36) NOT NULL ,
	task_id              VARCHAR2(36) NOT NULL ,
	segment_id           VARCHAR2(36) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_test_x_segment
	ADD CONSTRAINT  segment_test_x_segment_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_test_x_segment
	ADD CONSTRAINT segment_test_x_segment_fk1 FOREIGN KEY (test_cd, task_version_id, task_id) REFERENCES cdm_segment_test (test_cd, task_version_id, task_id) DISABLE ) BY ORACLE;

DISCONNECT FROM ORACLE;
QUIT;


