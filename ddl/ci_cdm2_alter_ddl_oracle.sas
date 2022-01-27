/*===================================================================*/
/* Enter Customer Specific Target Source Connection Values - Oracle  */
/*===================================================================*/

%let path = "@ed01-scan.unx.sas.com:1521/exadat12c" ;  /* From tnsnames.ora     */
%let user = cxtora5 ;         /* Oracle User/Schema    */
%let pass = cxtora5 ;          /* Oracle Password       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ORACLE (USER=&USER PASS=&PASS PATH=&PATH);

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE cdm_activity_custom_attr ADD (activity_id VARCHAR2(36) NULL)) BY ORACLE;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE cdm_content_custom_attr ADD (content_id VARCHAR2(40) NULL)) BY ORACLE;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE cdm_dyn_content_custom_attr ADD (content_id VARCHAR2(40) NULL)) BY ORACLE;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE cdm_task_detail ADD (recurring_schedule_flg CHAR(1) NULL)) BY ORACLE;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE cdm_task_custom_attr ADD (task_id VARCHAR2(36) NULL)) BY ORACLE;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE cdm_rtc_detail ADD (segment_id VARCHAR2(36) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_rtc_detail ADD (task_id VARCHAR2(36) NULL)) BY ORACLE;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE cdm_segment_detail ADD (segment_map_id VARCHAR2(36) NULL)) BY ORACLE;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE cdm_segment_custom_attr ADD (segment_id VARCHAR2(36) NULL)) BY ORACLE;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE cdm_segment_map_custom_attr ADD (segment_map_id VARCHAR2(36) NULL)) BY ORACLE;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE cdm_rtc_x_content ADD (content_id VARCHAR2(40) NULL)) BY ORACLE;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE cdm_activity_x_task ADD (activity_id VARCHAR2(36) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_activity_x_task ADD (task_id VARCHAR2(36) NULL)) BY ORACLE;

DISCONNECT FROM ORACLE;
QUIT;


