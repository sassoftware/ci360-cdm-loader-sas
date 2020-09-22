		 
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
/*  Note:  This code Drops the CI360 Common Data Model 2.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOSNF (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type) BY SASIOSNF;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type) BY SASIOSNF;

DISCONNECT FROM SASIOSNF;
QUIT;

