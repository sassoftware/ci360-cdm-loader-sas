
/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Teradata */
/*====================================================================*/

%let user     = <User Name> ;        /* Teradata User               */
%let pass     = <Password> ;         /* Teradata Password           */
%let server   = <Server>;            /* Teradata Server or TDPID    */
%let database = <Database>;          /* Teradata Database           */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code alters the CI360 Common Data Model 3.0         */
/*         tables to align with Schema16 modifications.             */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO TERADATA (USER=&USER PASS=&PASS SERVER=&SERVER DATABASE=&DATABASE MODE=TERADATA);

/*** cdm_response_history ***/
EXECUTE(ALTER TABLE cdm_response_history ADD response_dttm_tz TIMESTAMP NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_response_history ADD audience_id VARCHAR(36) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_response_history ADD audience_occur_id VARCHAR(36) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_response_history ADD context_type_nm VARCHAR(256) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_response_history ADD context_val VARCHAR(256) NULL) BY TERADATA;

/*** cdm_contact_history ***/
EXECUTE(ALTER TABLE cdm_contact_history ADD contact_dttm_tz TIMESTAMP NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_contact_history ADD audience_id VARCHAR(36) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_contact_history ADD audience_occur_id VARCHAR(36) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_contact_history ADD context_type_nm VARCHAR(256) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_contact_history ADD context_val VARCHAR(256) NULL) BY TERADATA;

/*** cdm_content_detail ***/
EXECUTE (ALTER TABLE cdm_content_detail ADD owner_nm VARCHAR(256)) BY TERADATA;
EXECUTE (ALTER TABLE cdm_content_detail ADD created_user_nm VARCHAR(256)) BY TERADATA;

/*** cdm_task_detail ***/
EXECUTE (ALTER TABLE cdm_task_detail ADD owner_nm VARCHAR(256)) BY TERADATA;
EXECUTE (ALTER TABLE cdm_task_detail ADD created_user_nm VARCHAR(256)) BY TERADATA;

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
        UNIQUE PRIMARY INDEX audience_detail_pi 
 ( 
        audience_id 
 )) BY TERADATA;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk4 FOREIGN KEY (audience_id) REFERENCES WITH NO CHECK OPTION cdm_audience_detail (audience_id)) BY TERADATA;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk8 FOREIGN KEY (audience_id) REFERENCES WITH NO CHECK OPTION cdm_audience_detail (audience_id)) BY TERADATA;

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
	updated_dttm         TIMESTAMP  ,
CONSTRAINT audience_occur_detail_fk1 FOREIGN KEY (audience_id) REFERENCES WITH NO CHECK OPTION cdm_audience_detail (audience_id)
 ) 
        UNIQUE PRIMARY INDEX audience_occur_detail_pi 
 ( 
        audience_occur_id 
 )) BY TERADATA;


EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk5 FOREIGN KEY (audience_occur_id) REFERENCES WITH NO CHECK OPTION cdm_audience_occur_detail (audience_occur_id)) BY TERADATA;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk9 FOREIGN KEY (audience_occur_id) REFERENCES WITH NO CHECK OPTION cdm_audience_occur_detail (audience_occur_id)) BY TERADATA;

/*** Modify All LARGE Columns to VARCHAR ***/

/*** Add new varchar column to replace existing text column ***/
EXECUTE(ALTER TABLE cdm_activity_detail ADD new_activity_desc VARCHAR(1500) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_campaign_detail ADD new_campaign_desc VARCHAR(1500) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_content_detail ADD new_contact_content_desc VARCHAR(1500) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_identity_attr ADD new_user_identifier_val VARCHAR(4000) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_task_detail ADD new_task_desc VARCHAR(1500) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_segment_detail ADD new_segment_desc VARCHAR(1500) NULL) BY TERADATA;
EXECUTE(ALTER TABLE cdm_segment_map ADD new_segment_map_desc VARCHAR(1500) NULL) BY TERADATA;
 
/*** Update new varchar column from old text column ***/
EXECUTE(UPDATE cdm_activity_detail SET new_activity_desc = activity_desc) BY TERADATA;
EXECUTE(UPDATE cdm_campaign_detail SET new_campaign_desc = campaign_desc) BY TERADATA;
EXECUTE(UPDATE cdm_content_detail SET new_contact_content_desc = contact_content_desc) BY TERADATA;
EXECUTE(UPDATE cdm_identity_attr SET new_user_identifier_val = user_identifier_val) BY TERADATA;
EXECUTE(UPDATE cdm_task_detail SET new_task_desc = task_desc) BY TERADATA;
EXECUTE(UPDATE cdm_segment_detail SET new_segment_desc = segment_desc) BY TERADATA;
EXECUTE(UPDATE cdm_segment_map SET new_segment_map_desc = segment_map_desc) BY TERADATA;
 
/*** Rename existing text column to old_* ***/
EXECUTE (ALTER TABLE cdm_activity_detail RENAME activity_desc TO old_activity_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_campaign_detail RENAME campaign_desc TO old_campaign_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_content_detail RENAME contact_content_desc TO old_contact_content_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_identity_attr RENAME user_identifier_val TO old_user_identifier_val) BY TERADATA;
EXECUTE (ALTER TABLE cdm_task_detail RENAME task_desc TO old_task_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_segment_detail RENAME segment_desc TO old_segment_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_segment_map RENAME segment_map_desc TO old_segment_map_desc) BY TERADATA;
 
/*** Rename new varchar column to existing column name ***/
EXECUTE (ALTER TABLE cdm_activity_detail RENAME new_activity_desc TO activity_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_campaign_detail RENAME new_campaign_desc TO campaign_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_content_detail RENAME new_contact_content_desc TO contact_content_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_identity_attr RENAME new_user_identifier_val TO user_identifier_val) BY TERADATA;
EXECUTE (ALTER TABLE cdm_task_detail RENAME new_task_desc TO task_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_segment_detail RENAME new_segment_desc TO segment_desc) BY TERADATA;
EXECUTE (ALTER TABLE cdm_segment_map RENAME new_segment_map_desc TO segment_map_desc) BY TERADATA;

DISCONNECT FROM TERADATA;
QUIT;

