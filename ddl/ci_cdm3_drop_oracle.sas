/*===================================================================*/
/* Enter Customer Specific Target Source Connection Values - Oracle  */
/*===================================================================*/

%let path = <Oracle TNS Entry> ;  /* From tnsnames.ora     */
%let user = <User Name> ;         /* Oracle User/Schema    */
%let pass = <Password> ;          /* Oracle Password       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 3.0          */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ORACLE (USER=&USER PASS=&PASS PATH=&PATH);

EXECUTE (DROP TABLE cdm_response_extended_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_response_history CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_contact_history CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_audience_occur_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_audience_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_contact_status CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_response_channel CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_response_lookup CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_response_type CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_segment_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_segment_map_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_segment_map CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_activity_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_activity_x_task CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_activity_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_rtc_x_content CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_rtc_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_occurrence_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_segment_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_campaign_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_dyn_content_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_task_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_task_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_contact_channel CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_business_context CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_campaign_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_content_custom_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_content_detail CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_identifier_type CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_identity_attr CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_identity_map CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_identity_type CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_segment_test CASCADE CONSTRAINTS PURGE) BY ORACLE;

EXECUTE (DROP TABLE cdm_segment_test_x_segment CASCADE CONSTRAINTS PURGE) BY ORACLE;

DISCONNECT FROM ORACLE;
QUIT;