/*======================================================================*/
/* Enter Customer Specific Target Source Connection Values - Netezza    */
/*======================================================================*/

%let user = <user>;              /* Netezza User            */
%let pass  = <password>;         /* Netezza Password        */
%let db  = <database>;           /* Netezza Database        */
%let server = <server>;          /* Netezza Server          */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO NETEZZA (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE cdm_contact_history ADD control_group_flg CHAR(1) NULL) BY NETEZZA;

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE cdm_response_history ADD properties_map_doc VARCHAR(4000) NULL) BY NETEZZA;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE cdm_task_detail ADD control_group_action_nm VARCHAR(65) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_task_detail ADD stratified_sampling_action_nm VARCHAR(65) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_task_detail ADD segment_tests_flg CHAR(1) NULL) BY NETEZZA;

EXECUTE (CREATE TABLE cdm_segment_test
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
)
DISTRIBUTE ON (test_cd)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_segment_test_x_segment
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (test_cd)
) 
BY NETEZZA;

DISCONNECT FROM NETEZZA;
QUIT;

