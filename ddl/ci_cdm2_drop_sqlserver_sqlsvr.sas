 
/*======================================================================*/
/* Enter Customer Specific Target Source Connection Values - SQL Server */
/*======================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pwd  = <Password> ;          /* SQL Server Password     */
%let dsn  = <Data Source>;        /* SQL Server Data Source  */
%let schema = <Schema>;           /* SQL Server Schema       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SQLSVR (USER=&USER PWD=&PWD DSN=&DSN);

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test_x_segment) BY SQLSVR;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test) BY SQLSVR;

DISCONNECT FROM SQLSVR;
QUIT;


