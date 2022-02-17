		 
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
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOSNF (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_custom_attr ADD activity_id VARCHAR(36) NULL) BY SASIOSNF;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_content_custom_attr ADD content_id VARCHAR(40) NULL) BY SASIOSNF;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_dyn_content_custom_attr ADD content_id VARCHAR(40) NULL) BY SASIOSNF;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD recurring_schedule_flg CHAR(1) NULL) BY SASIOSNF;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_custom_attr ADD task_id VARCHAR(36) NULL) BY SASIOSNF;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD segment_id VARCHAR(36) NULL) BY SASIOSNF;
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD task_id VARCHAR(36) NULL) BY SASIOSNF;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_detail ADD segment_map_id VARCHAR(36) NULL) BY SASIOSNF;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_custom_attr ADD segment_id VARCHAR(36) NULL) BY SASIOSNF;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_map_custom_attr ADD segment_map_id VARCHAR(36) NULL) BY SASIOSNF;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_x_content ADD content_id VARCHAR(40) NULL) BY SASIOSNF;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD activity_id VARCHAR(36) NULL) BY SASIOSNF;
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD task_id VARCHAR(36) NULL) BY SASIOSNF;

DISCONNECT FROM SASIOSNF;
QUIT;

