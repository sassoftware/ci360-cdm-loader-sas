
/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Postgres */
/*====================================================================*/

%let server = <Server> ;          /* Postgres Server         */
%let port = <Port> ;              /* Postgres Port           */
%let user = <User Name> ;         /* Postgres User/Schema    */
%let pass = <Password> ;          /* Postgres Password       */
%let database = <Database> ;      /* Postgres Database       */
%let schema = <Schema> ;          /* Postgres Schema         */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO POSTGRES (USER="&USER" PASS="&PASS" SERVER="&SERVER"
                       DATABASE="&DATABASE" PORT="&PORT");

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type CASCADE) BY POSTGRES;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type CASCADE) BY POSTGRES;

DISCONNECT FROM POSTGRES;
QUIT;


