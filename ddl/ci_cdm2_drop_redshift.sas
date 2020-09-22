/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Redshift */
/*====================================================================*/

%let user = <User Name> ;         /* Redshift User     */
%let pwd = <Password> ;           /* Redshift Password */
%let dsn = <Database> ;           /* Redshift Database */
%let schema = <Schema> ;          /* Redshift Schema   */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIORST (USER=&USER PWD=&PWD DSN=&DSN);

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type CASCADE ) BY SASIORST;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type CASCADE ) BY SASIORST;

DISCONNECT FROM SASIORST;
QUIT;



