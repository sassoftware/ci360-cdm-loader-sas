
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

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD response_dttm_tz TIMESTAMP NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD audience_id VARCHAR(36) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD audience_occur_id VARCHAR(36) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD context_type_nm VARCHAR(256) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD context_val VARCHAR(256) NULL) BY REDSHIFT;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD contact_dttm_tz TIMESTAMP NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD audience_id VARCHAR(36) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD audience_occur_id VARCHAR(36) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD context_type_nm VARCHAR(256) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD context_val VARCHAR(256) NULL) BY REDSHIFT;

/*** cdm_content_detail ***/
EXECUTE (ALTER TABLE &schema..cdm_content_detail ALTER COLUMN owner_nm TYPE VARCHAR(256)) BY REDSHIFT;
EXECUTE (ALTER TABLE &schema..cdm_content_detail ALTER COLUMN created_user_nm TYPE VARCHAR(256)) BY REDSHIFT;

/*** cdm_task_detail ***/
EXECUTE (ALTER TABLE &schema..cdm_task_detail ALTER COLUMN owner_nm TYPE VARCHAR(256)) BY REDSHIFT;
EXECUTE (ALTER TABLE &schema..cdm_task_detail ALTER COLUMN created_user_nm TYPE VARCHAR(256)) BY REDSHIFT;

/*** cdm_audience_detail ***/ 

EXECUTE (CREATE TABLE &SCHEMA..cdm_audience_detail
(
	audience_id          VARCHAR(36) NOT NULL ,
	audience_nm          VARCHAR(128) NULL ,
	audience_desc        VARCHAR(1332) NULL ,
	created_user_nm      VARCHAR(256) NULL ,
	audience_schedule_flg CHAR(1) NULL ,
	audience_source_nm   VARCHAR(100) NULL ,
	audience_data_source_nm VARCHAR(100) NULL ,
	create_dttm          TIMESTAMP NULL ,
	delete_dttm          TIMESTAMP NULL ,
	updated_dttm         TIMESTAMP NULL 
) DISTSTYLE ALL ) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_audience_detail
	ADD CONSTRAINT  audience_detail_pk PRIMARY KEY (audience_id)) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_contact_history
	ADD CONSTRAINT contact_history_fk4 FOREIGN KEY (audience_id) REFERENCES &schema..cdm_audience_detail (audience_id)) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_response_history
	ADD CONSTRAINT response_history_fk8 FOREIGN KEY (audience_id) REFERENCES &schema..cdm_audience_detail (audience_id)) BY REDSHIFT;

/*** cdm_audience_occur_detail ***/

EXECUTE (CREATE TABLE &SCHEMA..cdm_audience_occur_detail
(
	audience_occur_id    VARCHAR(36) NOT NULL ,
	audience_id          VARCHAR(36) NULL ,
	execution_status_cd  VARCHAR(100) NULL ,
	audience_size_cnt    INTEGER NULL ,
	started_by_nm        VARCHAR(256) NULL ,
	occurrence_type_nm   VARCHAR(100) NULL ,
	start_dttm           TIMESTAMP NULL ,
	end_dttm             TIMESTAMP NULL ,
	updated_dttm         TIMESTAMP NULL 
) DISTSTYLE ALL ) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_audience_occur_detail
	ADD CONSTRAINT  audience_occur_detail_pk PRIMARY KEY (audience_occur_id)) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_audience_occur_detail
	ADD CONSTRAINT audience_occur_detail_fk1 FOREIGN KEY (audience_id) REFERENCES &schema..cdm_audience_detail (audience_id)) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_contact_history
	ADD CONSTRAINT contact_history_fk5 FOREIGN KEY (audience_occur_id) REFERENCES &schema..cdm_audience_occur_detail (audience_occur_id)) BY REDSHIFT;

EXECUTE ( ALTER TABLE &schema..cdm_response_history
	ADD CONSTRAINT response_history_fk9 FOREIGN KEY (audience_occur_id) REFERENCES &schema..cdm_audience_occur_detail (audience_occur_id)) BY REDSHIFT;

/*** Modify All LARGE Columns to VARCHAR ***/

/*** Add new varchar column to replace existing text column ***/
EXECUTE(ALTER TABLE &schema..cdm_activity_detail ADD new_activity_desc VARCHAR(1500) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_campaign_detail ADD new_campaign_desc VARCHAR(1500) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_content_detail ADD new_contact_content_desc VARCHAR(1500) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_identity_attr ADD new_user_identifier_val VARCHAR(4000) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_task_detail ADD new_task_desc VARCHAR(1500) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_segment_detail ADD new_segment_desc VARCHAR(1500) NULL) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_segment_map ADD new_segment_map_desc VARCHAR(1500) NULL) BY REDSHIFT;
 
/*** Update new varchar column from old text column ***/
EXECUTE(UPDATE &schema..cdm_activity_detail SET new_activity_desc = activity_desc) BY REDSHIFT;
EXECUTE(UPDATE &schema..cdm_campaign_detail SET new_campaign_desc = campaign_desc) BY REDSHIFT;
EXECUTE(UPDATE &schema..cdm_content_detail SET new_contact_content_desc = contact_content_desc) BY REDSHIFT;
EXECUTE(UPDATE &schema..cdm_identity_attr SET new_user_identifier_val = user_identifier_val) BY REDSHIFT;
EXECUTE(UPDATE &schema..cdm_task_detail SET new_task_desc = task_desc) BY REDSHIFT;
EXECUTE(UPDATE &schema..cdm_segment_detail SET new_segment_desc = segment_desc) BY REDSHIFT;
EXECUTE(UPDATE &schema..cdm_segment_map SET new_segment_map_desc = segment_map_desc) BY REDSHIFT;
 
/*** Rename existing text column to old_* ***/
EXECUTE(ALTER TABLE &schema..cdm_activity_detail RENAME COLUMN activity_desc TO old_activity_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_campaign_detail RENAME COLUMN campaign_desc TO old_campaign_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_content_detail RENAME COLUMN contact_content_desc TO old_contact_content_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_identity_attr RENAME COLUMN user_identifier_val TO old_user_identifier_val) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_task_detail RENAME COLUMN task_desc TO old_task_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_segment_detail RENAME COLUMN segment_desc TO old_segment_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_segment_map RENAME COLUMN segment_map_desc TO old_segment_map_desc) BY REDSHIFT;
 
/*** Rename new varchar column to existing column name ***/ 
EXECUTE(ALTER TABLE &schema..cdm_activity_detail RENAME COLUMN new_activity_desc TO activity_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_campaign_detail RENAME COLUMN new_campaign_desc TO campaign_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_content_detail RENAME COLUMN new_contact_content_desc TO contact_content_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_identity_attr RENAME COLUMN new_user_identifier_val TO user_identifier_val) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_task_detail RENAME COLUMN new_task_desc TO task_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_segment_detail RENAME COLUMN new_segment_desc TO segment_desc) BY REDSHIFT;
EXECUTE(ALTER TABLE &schema..cdm_segment_map RENAME COLUMN new_segment_map_desc TO segment_map_desc) BY REDSHIFT;

DISCONNECT FROM REDSHIFT;
QUIT;


