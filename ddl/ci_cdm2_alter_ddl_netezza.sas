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
/*         tables to align with Schema8 modifications.              */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO NETEZZA (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

/*** cdm_activity_custom_attr ***/
EXECUTE(ALTER TABLE cdm_activity_custom_attr ADD activity_id VARCHAR(36) NULL) BY NETEZZA;

/*** cdm_content_custom_attr ***/
EXECUTE(ALTER TABLE cdm_content_custom_attr ADD content_id VARCHAR(40) NULL) BY NETEZZA;

/*** cdm_dyn_content_custom_attr ***/
EXECUTE(ALTER TABLE cdm_dyn_content_custom_attr ADD content_id VARCHAR(40) NULL) BY NETEZZA;

/*** cdm_task_detail ***/
EXECUTE(ALTER TABLE cdm_task_detail ADD recurring_schedule_flg CHAR(1) NULL) BY NETEZZA;

/*** cdm_task_custom_attr ***/
EXECUTE(ALTER TABLE cdm_task_custom_attr ADD task_id VARCHAR(36) NULL) BY NETEZZA;

/*** cdm_rtc_detail ***/
EXECUTE(ALTER TABLE cdm_rtc_detail ADD segment_id VARCHAR(36) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_rtc_detail ADD task_id VARCHAR(36) NULL) BY NETEZZA;

/*** cdm_segment_detail ***/
EXECUTE(ALTER TABLE cdm_segment_detail ADD segment_map_id VARCHAR(36) NULL) BY NETEZZA;

/*** cdm_segment_custom_attr ***/
EXECUTE(ALTER TABLE cdm_segment_custom_attr ADD segment_id VARCHAR(36) NULL) BY NETEZZA;

/*** cdm_segment_map_custom_attr ***/
EXECUTE(ALTER TABLE cdm_segment_map_custom_attr ADD segment_map_id VARCHAR(36) NULL) BY NETEZZA;

/*** cdm_rtc_x_content ***/
EXECUTE(ALTER TABLE cdm_rtc_x_content ADD content_id VARCHAR(40) NULL) BY NETEZZA;

/*** cdm_activity_x_task ***/
EXECUTE(ALTER TABLE cdm_activity_x_task ADD activity_id VARCHAR(36) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_activity_x_task ADD task_id VARCHAR(36) NULL) BY NETEZZA;

DISCONNECT FROM NETEZZA;
QUIT;

