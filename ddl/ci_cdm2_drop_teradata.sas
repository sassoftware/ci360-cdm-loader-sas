
/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Teradata */
/*====================================================================*/

%let user     = <User Name> ;        /* Teradata User               */
%let pass     = <Password> ;         /* Teradata Password           */
%let server   = <Server>;            /* Teradata Server or TDPID    */
%let database = <Database>;          /* Teradata Database           */
 
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO TERADATA (USER=&USER PASS=&PASS SERVER=&SERVER DATABASE=&DATABASE MODE=TERADATA);

EXECUTE (DROP TABLE cdm_identity_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_identifier_type) BY TERADATA;

EXECUTE (DROP TABLE cdm_content_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_task_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_campaign_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_dyn_content_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_rtc_x_content) BY TERADATA;

EXECUTE (DROP TABLE cdm_activity_x_task) BY TERADATA;

EXECUTE (DROP TABLE cdm_activity_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_activity_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_segment_map_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_segment_custom_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_response_extended_attr) BY TERADATA;

EXECUTE (DROP TABLE cdm_response_history) BY TERADATA;

EXECUTE (DROP TABLE cdm_contact_history) BY TERADATA;

EXECUTE (DROP TABLE cdm_contact_status) BY TERADATA;

EXECUTE (DROP TABLE cdm_response_channel) BY TERADATA;

EXECUTE (DROP TABLE cdm_response_lookup) BY TERADATA;

EXECUTE (DROP TABLE cdm_content_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_rtc_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_occurrence_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_segment_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_segment_map) BY TERADATA;

EXECUTE (DROP TABLE cdm_task_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_contact_channel) BY TERADATA;

EXECUTE (DROP TABLE cdm_business_context) BY TERADATA;

EXECUTE (DROP TABLE cdm_campaign_detail) BY TERADATA;

EXECUTE (DROP TABLE cdm_identity_map) BY TERADATA;

EXECUTE (DROP TABLE cdm_identity_type) BY TERADATA;

EXECUTE (DROP TABLE cdm_response_type) BY TERADATA;

EXECUTE (DROP TABLE cdm_segment_test_x_segment) BY TERADATA;

EXECUTE (DROP TABLE cdm_segment_test) BY TERADATA;

DISCONNECT FROM TERADATA;
QUIT;


