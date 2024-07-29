/*===================================================================*/
/* Enter Customer Specific Target Source Connection Values - Oracle  */
/*===================================================================*/

%let path = <Oracle TNS Entry> ;  /* From tnsnames.ora     */
%let user = <User Name> ;         /* Oracle User/Schema    */
%let pass = <Password> ;          /* Oracle Password       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 3.0         */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ORACLE (USER=&USER PASS=&PASS PATH=&PATH);

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE cdm_response_history ADD (response_dttm_tz TIMESTAMP NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_response_history ADD (audience_id VARCHAR2(36) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_response_history ADD (audience_occur_id VARCHAR2(36) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_response_history ADD (context_type_nm VARCHAR2(256) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_response_history ADD (context_val VARCHAR2(256) NULL)) BY ORACLE;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE cdm_contact_history ADD (contact_dttm_tz TIMESTAMP NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_contact_history ADD (audience_id VARCHAR2(36) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_contact_history ADD (audience_occur_id VARCHAR2(36) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_contact_history ADD (context_type_nm VARCHAR2(256) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_contact_history ADD (context_val VARCHAR2(256) NULL)) BY ORACLE;

/*** cdm_content_detail ***/
EXECUTE (ALTER TABLE cdm_content_detail MODIFY owner_nm VARCHAR2(256)) BY ORACLE;
EXECUTE (ALTER TABLE cdm_content_detail MODIFY created_user_nm VARCHAR2(256)) BY ORACLE;

/*** cdm_task_detail ***/
EXECUTE (ALTER TABLE cdm_task_detail MODIFY owner_nm VARCHAR2(256)) BY ORACLE;
EXECUTE (ALTER TABLE cdm_task_detail MODIFY created_user_nm VARCHAR2(256)) BY ORACLE;

/*** cdm_audience_detail ***/

EXECUTE (CREATE TABLE cdm_audience_detail
(
	audience_id          VARCHAR2(36) NOT NULL ,
	audience_nm          VARCHAR2(128) NULL ,
	audience_desc        VARCHAR2(1332) NULL ,
	created_user_nm      VARCHAR2(256) NULL ,
	audience_schedule_flg CHAR(1) NULL ,
	audience_source_nm   VARCHAR2(100) NULL ,
	audience_data_source_nm VARCHAR2(100) NULL ,
	create_dttm          TIMESTAMP NULL ,
	delete_dttm          TIMESTAMP NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_audience_detail
	ADD CONSTRAINT  audience_detail_pk PRIMARY KEY (audience_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk4 FOREIGN KEY (audience_id) REFERENCES cdm_audience_detail (audience_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk8 FOREIGN KEY (audience_id) REFERENCES cdm_audience_detail (audience_id) DISABLE ) BY ORACLE;

/*** cdm_audience_occur_detail ***/

EXECUTE (CREATE TABLE cdm_audience_occur_detail
(
	audience_occur_id    VARCHAR2(36) NOT NULL ,
	audience_id          VARCHAR2(36) NULL ,
	execution_status_cd  VARCHAR2(100) NULL ,
	audience_size_cnt    INTEGER NULL ,
	started_by_nm        VARCHAR2(256) NULL ,
	occurrence_type_nm   VARCHAR2(100) NULL ,
	start_dttm           TIMESTAMP NULL ,
	end_dttm             TIMESTAMP NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_audience_occur_detail
	ADD CONSTRAINT  audience_occur_detail_pk PRIMARY KEY (audience_occur_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_audience_occur_detail
	ADD CONSTRAINT audience_occur_detail_fk1 FOREIGN KEY (audience_id) REFERENCES cdm_audience_detail (audience_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk5 FOREIGN KEY (audience_occur_id) REFERENCES cdm_audience_occur_detail (audience_occur_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk9 FOREIGN KEY (audience_occur_id) REFERENCES cdm_audience_occur_detail (audience_occur_id) DISABLE ) BY ORACLE;

/*** Modify All CLOB Columns to VARCHAR2 ***/

/*** Add new varchar column to replace existing clob column ***/
EXECUTE(ALTER TABLE cdm_activity_detail ADD (new_activity_desc VARCHAR2(1500) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_campaign_detail ADD (new_campaign_desc VARCHAR2(1500) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_content_detail ADD (new_contact_content_desc VARCHAR2(1500) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_identity_attr ADD (new_user_identifier_val VARCHAR2(4000) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_task_detail ADD (new_task_desc VARCHAR2(1500) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_segment_detail ADD (new_segment_desc VARCHAR2(1500) NULL)) BY ORACLE;
EXECUTE(ALTER TABLE cdm_segment_map ADD (new_segment_map_desc VARCHAR2(1500) NULL)) BY ORACLE;
 
/*** Update new varchar column from old clob column ***/
EXECUTE(UPDATE cdm_activity_detail SET new_activity_desc = activity_desc) BY ORACLE;
EXECUTE(UPDATE cdm_campaign_detail SET new_campaign_desc = campaign_desc) BY ORACLE;
EXECUTE(UPDATE cdm_content_detail SET new_contact_content_desc = contact_content_desc) BY ORACLE;
EXECUTE(UPDATE cdm_identity_attr SET new_user_identifier_val = user_identifier_val) BY ORACLE;
EXECUTE(UPDATE cdm_task_detail SET new_task_desc = task_desc) BY ORACLE;
EXECUTE(UPDATE cdm_segment_detail SET new_segment_desc = segment_desc) BY ORACLE;
EXECUTE(UPDATE cdm_segment_map SET new_segment_map_desc = segment_map_desc) BY ORACLE;
 
/*** Rename existing clob column to old_* ***/
EXECUTE(ALTER TABLE cdm_activity_detail RENAME COLUMN activity_desc TO old_activity_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_campaign_detail RENAME COLUMN campaign_desc TO old_campaign_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_content_detail RENAME COLUMN contact_content_desc TO old_contact_content_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_identity_attr RENAME COLUMN user_identifier_val TO old_user_identifier_val) BY ORACLE;
EXECUTE(ALTER TABLE cdm_task_detail RENAME COLUMN task_desc TO old_task_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_segment_detail RENAME COLUMN segment_desc TO old_segment_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_segment_map RENAME COLUMN segment_map_desc TO old_segment_map_desc) BY ORACLE;
 
/*** Rename new varchar column to existing column name ***/ 
EXECUTE(ALTER TABLE cdm_activity_detail RENAME COLUMN new_activity_desc TO activity_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_campaign_detail RENAME COLUMN new_campaign_desc TO campaign_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_content_detail RENAME COLUMN new_contact_content_desc TO contact_content_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_identity_attr RENAME COLUMN new_user_identifier_val TO user_identifier_val) BY ORACLE;
EXECUTE(ALTER TABLE cdm_task_detail RENAME COLUMN new_task_desc TO task_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_segment_detail RENAME COLUMN new_segment_desc TO segment_desc) BY ORACLE;
EXECUTE(ALTER TABLE cdm_segment_map RENAME COLUMN new_segment_map_desc TO segment_map_desc) BY ORACLE;
 
DISCONNECT FROM ORACLE;
QUIT;