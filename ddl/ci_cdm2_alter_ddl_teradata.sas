
/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Teradata */
/*====================================================================*/

%let user     = <User Name> ;        /* Teradata User               */
%let pass     = <Password> ;         /* Teradata Password           */
%let server   = <Server>;            /* Teradata Server or TDPID    */
%let database = <Database>;          /* Teradata Database           */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO TERADATA (USER=&USER PASS=&PASS SERVER=&SERVER DATABASE=&DATABASE MODE=TERADATA);

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE cdm_activity_custom_attr ADD activity_id VARCHAR(36) NULL) BY TERADATA;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE cdm_content_custom_attr ADD content_id VARCHAR(40) NULL) BY TERADATA;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE cdm_dyn_content_custom_attr ADD content_id VARCHAR(40) NULL) BY TERADATA;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE cdm_task_detail ADD recurring_schedule_flg CHAR(1) NULL) BY TERADATA;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE cdm_task_custom_attr ADD task_id VARCHAR(36) NULL) BY TERADATA;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE cdm_rtc_detail ADD segment_id VARCHAR(36) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_rtc_detail ADD task_id VARCHAR(36) NULL) BY TERADATA;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE cdm_segment_detail ADD segment_map_id VARCHAR(36) NULL) BY TERADATA;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE cdm_segment_custom_attr ADD segment_id VARCHAR(36) NULL) BY TERADATA;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE cdm_segment_map_custom_attr ADD segment_map_id VARCHAR(36) NULL) BY TERADATA;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE cdm_rtc_x_content ADD content_id VARCHAR(40) NULL) BY TERADATA;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE cdm_activity_x_task ADD activity_id VARCHAR(36) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_activity_x_task ADD task_id VARCHAR(36) NULL) BY TERADATA;
 
DISCONNECT FROM TERADATA;
QUIT;

