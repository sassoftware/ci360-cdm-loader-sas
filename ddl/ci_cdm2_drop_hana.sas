
/*==================================================================================*/
/* Enter Customer Specific Target Source Connection Values - SAP Hana - Column Store*/
/*==================================================================================*/

%let user = <User Name> ;         /* SAP Hana User           */
%let pass = <Password> ;          /* SAP Hana Password       */
%let server = '<Server>' ;        /* SAP Hana Server         */
%let instance = <Instance>;       /* SAP Hana Instance       */
%let schema = <Schema> ;          /* SAP Hana Schema         */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOHNA (USER=&USER PASS=&PASS SERVER=&SERVER
                       INSTANCE=&INSTANCE);
EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test_x_segment CASCADE) BY SASIOHNA;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test CASCADE) BY SASIOHNA;

DISCONNECT FROM SASIOHNA;
QUIT;






