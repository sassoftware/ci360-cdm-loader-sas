
/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - GREENPLUM */
/*=====================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pass = <Password> ;          /* Greenplum Password      */
%let db   = <Database> ;          /* Greenplum Database      */
%let server = <Server> ;          /* Greenplum Server        */
%let port = <Port> ;              /* Greenplum Port          */
%let schema = <Schema>;           /* Greenplum Schema        */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO GREENPLM (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER PORT=&PORT);

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type CASCADE) BY GREENPLM;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type CASCADE) BY GREENPLM;

DISCONNECT FROM GREENPLM;
QUIT;

