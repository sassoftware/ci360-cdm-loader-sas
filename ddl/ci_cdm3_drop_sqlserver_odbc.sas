/*=============================================================================*/
/* Enter Customer Specific Target Source Connection Values - SQL Server (ODBC) */
/*=============================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pwd  = <Password> ;          /* SQL Server Password     */
%let dsn  = <Data Source>;        /* SQL Server Data Source  */
%let schema = <Schema>;           /* SQL Server Schema       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 3.0          */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ODBC (USER=&USER PWD=&PWD DSN=&DSN);

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test_x_segment) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_audience_occur_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_audience_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map) BY ODBC;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type) BY ODBC;

DISCONNECT FROM ODBC;
QUIT;


