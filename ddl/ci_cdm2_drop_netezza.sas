 
/*======================================================================*/
/* Enter Customer Specific Target Source Connection Values - Netezza    */
/*======================================================================*/

%let user = <user>;              /* Netezza User            */
%let pass  = <password>;         /* Netezza Password        */
%let db  = <database>;           /* Netezza Database        */
%let server = <server>;          /* Netezza Server          */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables to align with Schema10 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO NETEZZA (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

EXECUTE (DROP TABLE cdm_identity_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_identifier_type) BY NETEZZA;

EXECUTE (DROP TABLE cdm_content_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_task_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_campaign_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_dyn_content_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_rtc_x_content) BY NETEZZA;

EXECUTE (DROP TABLE cdm_activity_x_task) BY NETEZZA;

EXECUTE (DROP TABLE cdm_activity_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_activity_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_segment_map_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_segment_map) BY NETEZZA;

EXECUTE (DROP TABLE cdm_segment_custom_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_response_extended_attr) BY NETEZZA;

EXECUTE (DROP TABLE cdm_response_history) BY NETEZZA;

EXECUTE (DROP TABLE cdm_contact_history) BY NETEZZA;

EXECUTE (DROP TABLE cdm_contact_status) BY NETEZZA;

EXECUTE (DROP TABLE cdm_response_channel) BY NETEZZA;

EXECUTE (DROP TABLE cdm_response_lookup) BY NETEZZA;

EXECUTE (DROP TABLE cdm_content_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_rtc_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_occurrence_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_segment_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_task_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_contact_channel) BY NETEZZA;

EXECUTE (DROP TABLE cdm_business_context) BY NETEZZA;

EXECUTE (DROP TABLE cdm_campaign_detail) BY NETEZZA;

EXECUTE (DROP TABLE cdm_identity_map) BY NETEZZA;

EXECUTE (DROP TABLE cdm_identity_type) BY NETEZZA;

EXECUTE (DROP TABLE cdm_response_type) BY NETEZZA;

EXECUTE (DROP TABLE cdm_segment_test_x_segment) BY NETEZZA;

EXECUTE (DROP TABLE cdm_segment_test) BY NETEZZA;

DISCONNECT FROM NETEZZA;
QUIT;




