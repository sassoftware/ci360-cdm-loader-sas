/*======================================================================*/
/* Enter Customer Specific Target Source Connection Values - Netezza    */
/*======================================================================*/

%let user = <user>;              /* Netezza User            */
%let pass  = <password>;         /* Netezza Password        */
%let db  = <database>;           /* Netezza Database        */
%let server = <server>;          /* Netezza Server          */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 3.0         */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO NETEZZA (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE cdm_response_history ADD response_dttm_tz TIMESTAMP NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_response_history ADD audience_id VARCHAR(36) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_response_history ADD audience_occur_id VARCHAR(36) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_response_history ADD context_type_nm VARCHAR(256) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_response_history ADD context_val VARCHAR(256) NULL) BY NETEZZA;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE cdm_contact_history ADD contact_dttm_tz TIMESTAMP NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_contact_history ADD audience_id VARCHAR(36) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_contact_history ADD audience_occur_id VARCHAR(36) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_contact_history ADD context_type_nm VARCHAR(256) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_contact_history ADD context_val VARCHAR(256) NULL) BY NETEZZA;

/*** cdm_content_detail ***/
EXECUTE (ALTER TABLE cdm_content_detail ALTER COLUMN owner_nm TYPE VARCHAR(256)) BY NETEZZA;
EXECUTE (ALTER TABLE cdm_content_detail ALTER COLUMN created_user_nm TYPE VARCHAR(256)) BY NETEZZA;

/*** cdm_task_detail ***/
EXECUTE (ALTER TABLE cdm_task_detail ALTER COLUMN owner_nm TYPE VARCHAR(256)) BY NETEZZA;
EXECUTE (ALTER TABLE cdm_task_detail ALTER COLUMN created_user_nm TYPE VARCHAR(256)) BY NETEZZA;

/*** cdm_audience_detail ***/ 

EXECUTE (CREATE TABLE cdm_audience_detail
(
	audience_id          VARCHAR(36) NOT NULL ,
	audience_nm          VARCHAR(128)  ,
	audience_desc        VARCHAR(1332)  ,
	created_user_nm      VARCHAR(256)  ,
	audience_schedule_flg CHAR(1)  ,
	audience_source_nm   VARCHAR(100)  ,
	audience_data_source_nm VARCHAR(100)  ,
	create_dttm          TIMESTAMP  ,
	delete_dttm          TIMESTAMP  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (audience_id)
) 
BY NETEZZA;

/*** cdm_audience_occur_detail ***/ 

EXECUTE (CREATE TABLE cdm_audience_occur_detail
(
	audience_occur_id    VARCHAR(36) NOT NULL ,
	audience_id          VARCHAR(36)  ,
	execution_status_cd  VARCHAR(100)  ,
	audience_size_cnt    INTEGER  ,
	started_by_nm        VARCHAR(256)  ,
	occurrence_type_nm   VARCHAR(100)  ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (audience_occur_id)
) 
BY NETEZZA;

/*** Add new varchar column to replace existing text column ***/
EXECUTE(ALTER TABLE cdm_activity_detail ADD new_activity_desc VARCHAR(1500) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_campaign_detail ADD new_campaign_desc VARCHAR(1500) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_content_detail ADD new_contact_content_desc VARCHAR(1500) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_identity_attr ADD new_user_identifier_val VARCHAR(4000) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_task_detail ADD new_task_desc VARCHAR(1500) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_segment_detail ADD new_segment_desc VARCHAR(1500) NULL) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_segment_map ADD new_segment_map_desc VARCHAR(1500) NULL) BY NETEZZA;
 
/*** Update new varchar column from old text column ***/
EXECUTE(UPDATE cdm_activity_detail SET new_activity_desc = activity_desc) BY NETEZZA;
EXECUTE(UPDATE cdm_campaign_detail SET new_campaign_desc = campaign_desc) BY NETEZZA;
EXECUTE(UPDATE cdm_content_detail SET new_contact_content_desc = contact_content_desc) BY NETEZZA;
EXECUTE(UPDATE cdm_identity_attr SET new_user_identifier_val = user_identifier_val) BY NETEZZA;
EXECUTE(UPDATE cdm_task_detail SET new_task_desc = task_desc) BY NETEZZA;
EXECUTE(UPDATE cdm_segment_detail SET new_segment_desc = segment_desc) BY NETEZZA;
EXECUTE(UPDATE cdm_segment_map SET new_segment_map_desc = segment_map_desc) BY NETEZZA;
 
/*** Rename existing text column to old_* ***/
EXECUTE(ALTER TABLE cdm_activity_detail RENAME COLUMN activity_desc TO old_activity_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_campaign_detail RENAME COLUMN campaign_desc TO old_campaign_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_content_detail RENAME COLUMN contact_content_desc TO old_contact_content_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_identity_attr RENAME COLUMN user_identifier_val TO old_user_identifier_val) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_task_detail RENAME COLUMN task_desc TO old_task_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_segment_detail RENAME COLUMN segment_desc TO old_segment_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_segment_map RENAME COLUMN segment_map_desc TO old_segment_map_desc) BY NETEZZA;
 
/*** Rename new varchar column to existing column name ***/ 
EXECUTE(ALTER TABLE cdm_activity_detail RENAME COLUMN new_activity_desc TO activity_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_campaign_detail RENAME COLUMN new_campaign_desc TO campaign_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_content_detail RENAME COLUMN new_contact_content_desc TO contact_content_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_identity_attr RENAME COLUMN new_user_identifier_val TO user_identifier_val) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_task_detail RENAME COLUMN new_task_desc TO task_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_segment_detail RENAME COLUMN new_segment_desc TO segment_desc) BY NETEZZA;
EXECUTE(ALTER TABLE cdm_segment_map RENAME COLUMN new_segment_map_desc TO segment_map_desc) BY NETEZZA;


DISCONNECT FROM NETEZZA;
QUIT;

