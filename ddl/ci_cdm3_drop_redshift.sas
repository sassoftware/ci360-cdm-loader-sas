/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Redshift */
/*====================================================================*/

%let user = ;      /* Redshift User     */
%let pwd = ;       /* Redshift Password */
%let server = ;    /* Redshift Server */
%let database = ;  /* Redshift Database */
%let schema = ;    /* Redshift Schema   */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 3.0          */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO REDSHIFT (USER=&USER PWD=&PWD SERVER=&SERVER DATABASE=&DATABASE);

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test_x_segment CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_test CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_audience_occur_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_audience_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map CASCADE ) BY REDSHIFT;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type CASCADE ) BY REDSHIFT;

DISCONNECT FROM REDSHIFT;
QUIT;



