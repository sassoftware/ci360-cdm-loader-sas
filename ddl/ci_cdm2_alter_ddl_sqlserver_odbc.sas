
/*=============================================================================*/
/* Enter Customer Specific Target Source Connection Values - SQL Server (ODBC) */
/*=============================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pwd  = <Password> ;          /* SQL Server Password     */
%let dsn  = <Data Source>;        /* SQL Server Data Source  */
%let schema = <Schema>;           /* SQL Server Schema       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 2.0         */
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ODBC (USER=&USER PWD=&PWD DSN=&DSN);

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_custom_attr ADD activity_id VARCHAR(36) NULL) BY ODBC;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_content_custom_attr ADD content_id VARCHAR(40) NULL) BY ODBC;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_dyn_content_custom_attr ADD content_id VARCHAR(40) NULL) BY ODBC;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_detail ADD recurring_schedule_flg CHAR(1) NULL) BY ODBC;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_task_custom_attr ADD task_id VARCHAR(36) NULL) BY ODBC;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD segment_id VARCHAR(36) NULL) BY ODBC;
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_detail ADD task_id VARCHAR(36) NULL) BY ODBC;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_detail ADD segment_map_id VARCHAR(36) NULL) BY ODBC;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_custom_attr ADD segment_id VARCHAR(36) NULL) BY ODBC;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_segment_map_custom_attr ADD segment_map_id VARCHAR(36) NULL) BY ODBC;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_rtc_x_content ADD content_id VARCHAR(40) NULL) BY ODBC;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD activity_id VARCHAR(36) NULL) BY ODBC;
EXECUTE(ALTER TABLE &SCHEMA..cdm_activity_x_task ADD task_id VARCHAR(36) NULL) BY ODBC;

DISCONNECT FROM ODBC;
QUIT;


