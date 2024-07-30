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
/*  Note:  This code Drops the CI360 Common Data Model 3.0          */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO OLEDB (USER=&USER PWD=&PWD DSN=&DSN PROMPT=NO
                  PROVIDER=SQLOLEDB PROPERTIES=("Initial Catalog"=&CATALOG));

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD response_dttm_tz DATETIME2 NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD audience_id VARCHAR(36) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD audience_occur_id VARCHAR(36) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD context_type_nm VARCHAR(256) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_response_history ADD context_val VARCHAR(256) NULL) BY BY OLEDB;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD contact_dttm_tz DATETIME2 NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD audience_id VARCHAR(36) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD audience_occur_id VARCHAR(36) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD context_type_nm VARCHAR(256) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_contact_history ADD context_val VARCHAR(256) NULL) BY BY OLEDB;

/*** cdm_content_detail ***/
EXECUTE (ALTER TABLE &schema..cdm_content_detail ALTER COLUMN owner_nm VARCHAR(256)) BY BY OLEDB;
EXECUTE (ALTER TABLE &schema..cdm_content_detail ALTER COLUMN created_user_nm VARCHAR(256)) BY BY OLEDB;

/*** cdm_task_detail ***/
EXECUTE (ALTER TABLE &schema..cdm_task_detail ALTER COLUMN owner_nm VARCHAR(256)) BY BY OLEDB;
EXECUTE (ALTER TABLE &schema..cdm_task_detail ALTER COLUMN created_user_nm VARCHAR(256)) BY BY OLEDB;

/*** cdm_audience_detail ***/ 

EXECUTE (CREATE TABLE &schema..cdm_audience_detail
(
	audience_id          VARCHAR(36) NOT NULL ,
	audience_nm          VARCHAR(128) NULL ,
	audience_desc        VARCHAR(1332) NULL ,
	created_user_nm      VARCHAR(256) NULL ,
	audience_schedule_flg CHAR(1) NULL ,
	audience_source_nm   VARCHAR(100) NULL ,
	audience_data_source_nm VARCHAR(100) NULL ,
	create_dttm          DATETIME2 NULL ,
	delete_dttm          DATETIME2 NULL ,
	updated_dttm         DATETIME2 NULL 
)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_audience_detail
	ADD CONSTRAINT  audience_detail_pk PRIMARY KEY (audience_id)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_contact_history
	ADD CONSTRAINT contact_history_fk4 FOREIGN KEY (audience_id) REFERENCES &schema..cdm_audience_detail (audience_id)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_response_history
	ADD CONSTRAINT response_history_fk8 FOREIGN KEY (audience_id) REFERENCES &schema..cdm_audience_detail (audience_id)) BY BY OLEDB;

/*** cdm_audience_occur_detail ***/

EXECUTE (CREATE TABLE &schema..cdm_audience_occur_detail
(
	audience_occur_id    VARCHAR(36) NOT NULL ,
	audience_id          VARCHAR(36) NULL ,
	execution_status_cd  VARCHAR(100) NULL ,
	audience_size_cnt    INTEGER NULL ,
	started_by_nm        VARCHAR(256) NULL ,
	occurrence_type_nm   VARCHAR(100) NULL ,
	start_dttm           DATETIME2 NULL ,
	end_dttm             DATETIME2 NULL ,
	updated_dttm         DATETIME2 NULL 
)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_audience_occur_detail
	ADD CONSTRAINT  audience_occur_detail_pk PRIMARY KEY (audience_occur_id)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_audience_occur_detail
	ADD CONSTRAINT audience_occur_detail_fk1 FOREIGN KEY (audience_id) REFERENCES &schema..cdm_audience_detail (audience_id)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_contact_history
	ADD CONSTRAINT contact_history_fk5 FOREIGN KEY (audience_occur_id) REFERENCES &schema..cdm_audience_occur_detail (audience_occur_id)) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_response_history
	ADD CONSTRAINT response_history_fk9 FOREIGN KEY (audience_occur_id) REFERENCES &schema..cdm_audience_occur_detail (audience_occur_id)) BY BY OLEDB;

/* DISABLE FOREIGN KEY CONSTRAINTS */

EXECUTE ( ALTER TABLE &schema..cdm_contact_history
	NOCHECK CONSTRAINT contact_history_fk4 ) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_response_history
	NOCHECK CONSTRAINT response_history_fk8 ) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_audience_occur_detail
	NOCHECK CONSTRAINT audience_occur_detail_fk1 ) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_contact_history
	NOCHECK CONSTRAINT contact_history_fk5 ) BY BY OLEDB;

EXECUTE ( ALTER TABLE &schema..cdm_response_history
	NOCHECK CONSTRAINT response_history_fk9 ) BY BY OLEDB;

/*** Modify All TEXT Columns to VARCHAR ***/

/*** Add new varchar column to replace existing text column ***/
EXECUTE(ALTER TABLE &schema..cdm_activity_detail ADD new_activity_desc VARCHAR(1500) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_campaign_detail ADD new_campaign_desc VARCHAR(1500) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_content_detail ADD new_contact_content_desc VARCHAR(1500) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_identity_attr ADD new_user_identifier_val VARCHAR(4000) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_task_detail ADD new_task_desc VARCHAR(1500) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_segment_detail ADD new_segment_desc VARCHAR(1500) NULL) BY BY OLEDB;
EXECUTE(ALTER TABLE &schema..cdm_segment_map ADD new_segment_map_desc VARCHAR(1500) NULL) BY BY OLEDB;
 
/*** Update new varchar column from old text column ***/
EXECUTE(UPDATE &schema..cdm_activity_detail SET new_activity_desc = activity_desc) BY BY OLEDB;
EXECUTE(UPDATE &schema..cdm_campaign_detail SET new_campaign_desc = campaign_desc) BY BY OLEDB;
EXECUTE(UPDATE &schema..cdm_content_detail SET new_contact_content_desc = contact_content_desc) BY BY OLEDB;
EXECUTE(UPDATE &schema..cdm_identity_attr SET new_user_identifier_val = user_identifier_val) BY BY OLEDB;
EXECUTE(UPDATE &schema..cdm_task_detail SET new_task_desc = task_desc) BY BY OLEDB;
EXECUTE(UPDATE &schema..cdm_segment_detail SET new_segment_desc = segment_desc) BY BY OLEDB;
EXECUTE(UPDATE &schema..cdm_segment_map SET new_segment_map_desc = segment_map_desc) BY BY OLEDB;
 
/*** Rename existing text column to old_* ***/
EXECUTE({call sp_rename('cdm_activity_detail.activity_desc', 'old_activity_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_campaign_detail.campaign_desc', 'old_campaign_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_content_detail.contact_content_desc', 'old_contact_content_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_identity_attr.user_identifier_val', 'old_user_identifier_val', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_task_detail.task_desc', 'old_task_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_segment_detail.segment_desc', 'old_segment_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_segment_map.segment_map_desc', 'old_segment_map_desc', 'COLUMN')}) BY BY OLEDB;
 
/*** Rename new varchar column to existing column name ***/
EXECUTE({call sp_rename('cdm_activity_detail.new_activity_desc', 'activity_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_campaign_detail.new_campaign_desc', 'campaign_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_content_detail.new_contact_content_desc', 'contact_content_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_identity_attr.new_user_identifier_val', 'user_identifier_val', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_task_detail.new_task_desc', 'task_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_segment_detail.new_segment_desc', 'segment_desc', 'COLUMN')}) BY BY OLEDB;
EXECUTE({call sp_rename('cdm_segment_map.new_segment_map_desc', 'segment_map_desc', 'COLUMN')}) BY BY OLEDB;

DISCONNECT FROM OLEDB;
QUIT;


