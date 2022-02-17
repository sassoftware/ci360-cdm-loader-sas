/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - BigQuery  */
/*=====================================================================*/

%let project = <Project>;      /* ProjectID - Do Not Quote This Value             */
%let schema = <Schema>;        /* BigQuery Schema - Do Not Quote This Value       */
%let cred_path = <Cred_Path>;  /* Credentials File Path - Do Not Quote This Value */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOGBQ (PROJECT="&PROJECT" CRED_PATH="&CRED_PATH" SCHEMA="&SCHEMA");

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_custom_attr ADD COLUMN activity_id STRING) BY SASIOGBQ;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_content_custom_attr ADD COLUMN content_id STRING) BY SASIOGBQ;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_dyn_content_custom_attr ADD COLUMN content_id STRING) BY SASIOGBQ;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD COLUMN recurring_schedule_flg STRING) BY SASIOGBQ;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_custom_attr ADD COLUMN task_id STRING) BY SASIOGBQ;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD COLUMN segment_id STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD COLUMN task_id STRING) BY SASIOGBQ;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_detail ADD COLUMN segment_map_id STRING) BY SASIOGBQ;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_custom_attr ADD COLUMN segment_id STRING) BY SASIOGBQ;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_map_custom_attr ADD COLUMN segment_map_id STRING) BY SASIOGBQ;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_x_content ADD COLUMN content_id STRING) BY SASIOGBQ;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD COLUMN activity_id STRING) BY SASIOGBQ;
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD COLUMN task_id STRING) BY SASIOGBQ;

DISCONNECT FROM SASIOGBQ;
QUIT;


