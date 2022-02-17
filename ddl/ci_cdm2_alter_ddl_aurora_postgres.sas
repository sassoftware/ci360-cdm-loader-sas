
/*===========================================================================*/
/* Enter Customer Specific Target Source Connection Values - Aurora Postgres */
/*===========================================================================*/

%let server = <Server> ;          /* Postgres Server         */
%let port = <Port> ;              /* Postgres Port           */
%let user = <User Name> ;         /* Postgres User/Schema    */
%let pass = <Password> ;          /* Postgres Password       */
%let database = <Database> ;      /* Postgres Database       */
%let schema = <Schema> ;          /* Postgres Schema         */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO POSTGRES (USER="&USER" PASS="&PASS" SERVER="&SERVER"
                       DATABASE="&DATABASE" PORT="&PORT");

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_custom_attr ADD activity_id VARCHAR(36) NULL) BY POSTGRES;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_content_custom_attr ADD content_id VARCHAR(40) NULL) BY POSTGRES;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_dyn_content_custom_attr ADD content_id VARCHAR(40) NULL) BY POSTGRES;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD recurring_schedule_flg CHAR(1) NULL) BY POSTGRES;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_custom_attr ADD task_id VARCHAR(36) NULL) BY POSTGRES;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD segment_id VARCHAR(36) NULL) BY POSTGRES;
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD task_id VARCHAR(36) NULL) BY POSTGRES;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_detail ADD segment_map_id VARCHAR(36) NULL) BY POSTGRES;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_custom_attr ADD segment_id VARCHAR(36) NULL) BY POSTGRES;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_map_custom_attr ADD segment_map_id VARCHAR(36) NULL) BY POSTGRES;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_x_content ADD content_id VARCHAR(40) NULL) BY POSTGRES;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD activity_id VARCHAR(36) NULL) BY POSTGRES;
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD task_id VARCHAR(36) NULL) BY POSTGRES;

DISCONNECT FROM POSTGRES;
QUIT;


