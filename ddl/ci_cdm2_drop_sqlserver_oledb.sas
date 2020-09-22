/*==============================================================================*/
/* Enter Customer Specific Target Source Connection Values - SQL Server (OLEDB) */
/*==============================================================================*/

%let user = <User Name> ;         /* Other than Default User */
%let pwd  = <Password> ;          /* SQL Server Password     */
%let dsn  = <Data Source>;        /* SQL Server Data Source  */
%let schema = <Schema>;           /* SQL Server Schema       */
%let catalog = <Catalog>;         /* SQL Server Catalog      */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code Drops the CI360 Common Data Model 2.0          */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO OLEDB (USER=&USER PWD=&PWD DSN=&DSN PROMPT=NO
                  PROVIDER=SQLOLEDB PROPERTIES=("Initial Catalog"=&CATALOG));

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_identifier_type) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_dyn_content_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_x_content) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_x_task) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_activity_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_custom_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_extended_attr) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_history) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_history) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_status) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_channel) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_lookup) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_content_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_rtc_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_occurrence_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_segment_map) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_task_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_contact_channel) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_business_context) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_campaign_detail) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_map) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_identity_type) BY OLEDB;

EXECUTE (DROP TABLE &SCHEMA..cdm_response_type) BY OLEDB;

DISCONNECT FROM OLEDB;
QUIT;


