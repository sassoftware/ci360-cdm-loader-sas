/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - BigQuery  */
/*=====================================================================*/

%let project = <Project>;      /* ProjectID - Do Not Quote This Value             */
%let schema = <Schema>;        /* BigQuery Schema  - Do Not Quote This Value      */
%let cred_path = <Cred_Path>;  /* Credentials File Path - Do Not Quote This Value */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOGBQ (PROJECT="&PROJECT" CRED_PATH="&CRED_PATH" SCHEMA="&SCHEMA");

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type) BY SASIOGBQ;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type) BY SASIOGBQ;

DISCONNECT FROM SASIOGBQ;
QUIT;


