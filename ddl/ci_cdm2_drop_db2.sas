
/*===================================================================*/
/* Enter Customer Specific Target Source Connection Values - DB2     */
/*===================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pass = <Password> ;          /* DB2 Password            */
%let dsn  = <Data Source>;        /* DB2 Data Source         */
%let schema = <Schema>;           /* DB2 Schema              */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO DB2 (USER=&USER PASS=&PASS DSN=&DSN);

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type) BY DB2;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type) BY DB2;

DISCONNECT FROM DB2;
QUIT;

