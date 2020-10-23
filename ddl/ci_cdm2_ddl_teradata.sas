
/*====================================================================*/
/* Enter Customer Specific Target Source Connection Values - Teradata */
/*====================================================================*/

%let user     = <User Name> ;        /* Teradata User               */
%let pass     = <Password> ;         /* Teradata Password           */
%let server   = <Server>;            /* Teradata Server or TDPID    */
%let database = <Database>;          /* Teradata Database           */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code creates the CI360 Common Data Model 2.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO TERADATA (USER=&USER PASS=&PASS SERVER=&SERVER DATABASE=&DATABASE MODE=TERADATA);

EXECUTE (CREATE TABLE cdm_campaign_detail
(
	campaign_id          VARCHAR(36) NOT NULL ,
	campaign_version_no  NUMERIC(6)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	campaign_nm          VARCHAR(60)  ,
	campaign_desc        CLOB  ,
	campaign_cd          VARCHAR(60)  ,
	campaign_owner_nm    VARCHAR(60)  ,
	min_budget_offer_amt NUMERIC(14,2)  ,
	max_budget_offer_amt NUMERIC(14,2)  ,
	min_budget_amt       NUMERIC(14,2)  ,
	max_budget_amt       NUMERIC(14,2)  ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	run_dttm             TIMESTAMP  ,
	last_modified_dttm   TIMESTAMP  ,
	approval_dttm        TIMESTAMP  ,
	approval_given_by_nm VARCHAR(60)  ,
	last_modified_by_user_nm VARCHAR(60)  ,
	current_version_flg  CHAR(1)  ,
	deleted_flg          CHAR(1)  ,
	campaign_status_cd   VARCHAR(3)  ,
	campaign_type_cd     VARCHAR(3)  ,
	campaign_folder_txt  VARCHAR(1024)  ,
	campaign_group_sk    NUMERIC(15) NOT NULL ,
	deployment_version_no NUMERIC(6)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX campaign_detail_pi 
 ( 
        campaign_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_business_context
(
	business_context_id  VARCHAR(36) NOT NULL ,
	business_context_nm  VARCHAR(256)  ,
	business_context_type_cd VARCHAR(40)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX business_context_pi 
 ( 
        business_context_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_contact_channel
(
	contact_channel_cd   VARCHAR(60) NOT NULL ,
	contact_channel_nm   VARCHAR(40)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX contact_channel_pi 
 ( 
        contact_channel_cd 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_task_detail
(
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	task_nm              VARCHAR(256)  ,
	task_desc            CLOB  ,
	task_type_nm         VARCHAR(40)  ,
	task_status_cd       VARCHAR(20)  ,
	task_subtype_nm      VARCHAR(100)  ,
	task_cd              VARCHAR(60)  ,
	task_delivery_type_nm VARCHAR(60)  ,
	active_flg           CHAR(1)  ,
	saved_flg            CHAR(1)  ,
	published_flg        CHAR(1)  ,
	owner_nm             VARCHAR(40)  ,
	modified_status_cd   VARCHAR(20)  ,
	created_user_nm      VARCHAR(40)  ,
	created_dt           DATE  ,
	scheduled_start_dttm TIMESTAMP  ,
	scheduled_end_dttm   TIMESTAMP  ,
	scheduled_flg        CHAR(1)  ,
	maximum_period_expression_cnt INTEGER  ,
	limit_period_unit_cnt INTEGER  ,
	limit_by_total_impression_flg CHAR(1)  ,
	export_dttm          TIMESTAMP  ,
	update_contact_history_flg CHAR(1)  ,
	subject_type_nm      VARCHAR(60)  ,
	min_budget_offer_amt NUMERIC(14,2)  ,
	max_budget_offer_amt NUMERIC(14,2)  ,
	min_budget_amt       NUMERIC(14,2)  ,
	max_budget_amt       NUMERIC(14,2)  ,
	budget_unit_cost_amt NUMERIC(14,2)  ,
	recurr_type_cd       VARCHAR(3)  ,
	budget_unit_usage_amt NUMERIC(14,2)  ,
	standard_reply_flg   CHAR(1)  ,
	staged_flg           CHAR(1)  ,
	contact_channel_cd   VARCHAR(60)  ,
	campaign_id          VARCHAR(36)  ,
	business_context_id  VARCHAR(36)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT task_detail_fk1 FOREIGN KEY (campaign_id) REFERENCES WITH NO CHECK OPTION cdm_campaign_detail (campaign_id),
CONSTRAINT task_detail_fk2 FOREIGN KEY (business_context_id) REFERENCES WITH NO CHECK OPTION cdm_business_context (business_context_id),
CONSTRAINT task_detail_fk3 FOREIGN KEY (contact_channel_cd) REFERENCES WITH NO CHECK OPTION cdm_contact_channel (contact_channel_cd)
 ) 
        UNIQUE PRIMARY INDEX task_detail_pi 
 ( 
        task_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_task_custom_attr
(
	task_version_id      VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  task_custom_attribute_pk PRIMARY KEY (task_version_id,attribute_nm,attribute_data_type_cd,attribute_val),
CONSTRAINT task_custom_attr_fk1 FOREIGN KEY (task_version_id) REFERENCES WITH NO CHECK OPTION cdm_task_detail (task_version_id)
 ) 
        PRIMARY INDEX task_custom_attr_pi 
 ( 
        task_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_activity_detail 
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	activity_id          VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	status_cd            VARCHAR(20)  ,
	activity_nm          VARCHAR(256)  ,
	activity_desc        CLOB  ,
	activity_cd          VARCHAR(60)  ,
	activity_category_nm VARCHAR(100)  ,
	last_published_dttm  TIMESTAMP  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX activity_detail_pi 
 ( 
        activity_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_activity_x_task
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT activity_x_task_pk PRIMARY KEY (activity_version_id,task_version_id),
CONSTRAINT activity_x_task_fk1 FOREIGN KEY (activity_version_id) REFERENCES WITH NO CHECK OPTION cdm_activity_detail (activity_version_id),
CONSTRAINT activity_x_task_fk2 FOREIGN KEY (task_version_id) REFERENCES WITH NO CHECK OPTION cdm_task_detail (task_version_id)
 ) 
        PRIMARY INDEX activity_x_task_pi 
 ( 
        activity_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_campaign_custom_attr
(
	campaign_id          VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	page_nm              VARCHAR(60) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  campaign_custom_attribute_pk PRIMARY KEY (campaign_id,attribute_nm,page_nm,attribute_data_type_cd,attribute_val),
CONSTRAINT campaign_custom_attr_fk1 FOREIGN KEY (campaign_id) REFERENCES WITH NO CHECK OPTION cdm_campaign_detail (campaign_id)
 ) 
        PRIMARY INDEX campaign_custom_attr_pi 
 ( 
        campaign_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_response_type
(
	response_type_cd     VARCHAR(60) NOT NULL ,
	response_type_desc   VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX response_type_pi 
 ( 
        response_type_cd 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_identity_type
(
	identity_type_cd     VARCHAR(40) NOT NULL ,
	identity_type_desc   VARCHAR(100)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX identity_type_pi 
 ( 
        identity_type_cd 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_identity_map
(
	identity_id          VARCHAR(36) NOT NULL ,
	identity_type_cd     VARCHAR(40)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT identity_map_fk1 FOREIGN KEY (identity_type_cd) REFERENCES WITH NO CHECK OPTION cdm_identity_type (identity_type_cd)
 ) 
        UNIQUE PRIMARY INDEX identity_map_pi 
 ( 
        identity_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_segment_map
(
	segment_map_version_id VARCHAR(36) NOT NULL ,
	segment_map_id       VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	segment_map_nm       VARCHAR(256)  ,
	segment_map_desc     CLOB  ,
	segment_map_category_nm VARCHAR(100)  ,
	segment_map_cd       VARCHAR(60)  ,
	segment_map_src_nm   VARCHAR(40)  ,
	segment_map_status_cd VARCHAR(20)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX segment_map_pi 
 ( 
        segment_map_version_id 
 )) BY TERADATA;

/** INSERT RECORD INTO CDM_SEGMENT_MAP TABLE **/

EXECUTE (insert into cdm_segment_map (
segment_map_version_id,
segment_map_id,
valid_from_dttm,
valid_to_dttm,
segment_map_nm,
segment_map_desc,
segment_map_category_nm,
segment_map_cd,
segment_map_src_nm,
segment_map_status_cd,
source_system_cd,
updated_by_nm,
updated_dttm )
values (
'0',
'0',
current_timestamp,
to_date('9999-12-31:00:00:00','YYYY-MM-DD:HH24:MI:SS'),
'_NO SEGMENT MAP',
'_NO SEGMENT MAP',
'',
'',
'',
'',
'360',
'CDM2.0',
current_timestamp
)) BY TERADATA;

EXECUTE (CREATE TABLE cdm_segment_detail
(
	segment_version_id   VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36)  ,
	segment_map_version_id VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	segment_nm           VARCHAR(256)  ,
	segment_desc         CLOB  ,
	segment_category_nm  VARCHAR(100)  ,
	segment_cd           VARCHAR(60)  ,
	segment_src_nm       VARCHAR(40)  ,
	segment_status_cd    VARCHAR(20)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX segment_detail_pi 
 ( 
        segment_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_occurrence_detail
(
	occurrence_id        VARCHAR(36) NOT NULL ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	occurrence_no        INTEGER  ,
	occurrence_type_cd   VARCHAR(30)  ,
	occurence_object_id  VARCHAR(36)  ,
	occurence_object_type_cd VARCHAR(60)  ,
	source_system_cd     VARCHAR(10)  ,
	execution_status_cd  VARCHAR(30)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX occurrence_detail_pi 
 ( 
        occurrence_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_rtc_detail
(
	rtc_id               VARCHAR(36) NOT NULL ,
	task_occurence_no    INTEGER  ,
	processed_dttm       TIMESTAMP NOT NULL ,
	response_tracking_flg CHAR(1)  ,
	segment_version_id   VARCHAR(36)  ,
	task_version_id      VARCHAR(36) NOT NULL ,
	execution_status_cd  VARCHAR(30)  ,
	deleted_flg          CHAR(1)  ,
	occurrence_id        VARCHAR(36)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT rtc_detail_fk1 FOREIGN KEY (task_version_id) REFERENCES WITH NO CHECK OPTION cdm_task_detail (task_version_id),
CONSTRAINT rtc_detail_fk2 FOREIGN KEY (segment_version_id) REFERENCES WITH NO CHECK OPTION cdm_segment_detail (segment_version_id),
CONSTRAINT rtc_detail_fk3 FOREIGN KEY (occurrence_id) REFERENCES WITH NO CHECK OPTION cdm_occurrence_detail (occurrence_id)
 ) 
        UNIQUE PRIMARY INDEX rtc_detail_pi 
 ( 
        rtc_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_content_detail
(
	content_version_id   VARCHAR(40) NOT NULL ,
	content_id           VARCHAR(40)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	contact_content_nm   VARCHAR(256)  ,
	contact_content_desc CLOB  ,
	contact_content_type_nm VARCHAR(50)  ,
	contact_content_status_cd VARCHAR(60)  ,
	contact_content_category_nm VARCHAR(256)  ,
	contact_content_class_nm VARCHAR(100)  ,
	contact_content_cd   VARCHAR(60)  ,
	active_flg           CHAR(1)  ,
	owner_nm             VARCHAR(100)  ,
	created_user_nm      VARCHAR(100)  ,
	created_dt           DATE  ,
	external_reference_txt VARCHAR(1024)  ,
	external_reference_url_txt VARCHAR(1024)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX content_detail_pi 
 ( 
        content_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_response_lookup
(
	response_cd          VARCHAR(256) NOT NULL ,
	response_nm          VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX response_lookup_pi 
 ( 
        response_cd 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_response_channel
(
	response_channel_cd  VARCHAR(40) NOT NULL ,
	response_channel_nm  VARCHAR(60)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX response_channel_pi 
 ( 
        response_channel_cd 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_contact_status
(
	contact_status_cd    VARCHAR(3) NOT NULL ,
	contact_status_desc  VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX contact_status_pi 
 ( 
        contact_status_cd 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_contact_history
(
	contact_id           VARCHAR(36) NOT NULL ,
	identity_id          VARCHAR(36) NOT NULL ,
	contact_nm           VARCHAR(256)  ,
	contact_dt           DATE  ,
	contact_dttm         TIMESTAMP  ,
	contact_status_cd    VARCHAR(3)  ,
	optimization_backfill_flg CHAR(1)  ,
	external_contact_info_1_id VARCHAR(32)  ,
	external_contact_info_2_id VARCHAR(32)  ,
	rtc_id               VARCHAR(36)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT contact_history_fk3 FOREIGN KEY (identity_id) REFERENCES WITH NO CHECK OPTION cdm_identity_map (identity_id),
CONSTRAINT contact_history_fk1 FOREIGN KEY (rtc_id) REFERENCES WITH NO CHECK OPTION cdm_rtc_detail (rtc_id),
CONSTRAINT contact_history_fk2 FOREIGN KEY (contact_status_cd) REFERENCES WITH NO CHECK OPTION cdm_contact_status (contact_status_cd)
 ) 
        UNIQUE PRIMARY INDEX contact_history_pi 
 ( 
        contact_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_response_history
(
	response_id          VARCHAR(36) NOT NULL ,
	response_cd          VARCHAR(256)  ,
	response_dt          DATE  ,
	response_dttm        TIMESTAMP  ,
	external_contact_info_1_id VARCHAR(32)  ,
	external_contact_info_2_id VARCHAR(32)  ,
	response_type_cd     VARCHAR(60)  ,
	response_channel_cd  VARCHAR(40)  ,
	conversion_flg       CHAR(1)  ,
	inferred_response_flg CHAR(1)  ,
	content_id           VARCHAR(40)  ,
	identity_id          VARCHAR(36)  ,
	rtc_id               VARCHAR(36) NOT NULL ,
	content_version_id   VARCHAR(40)  ,
	response_val_amt     NUMERIC(12,2)  ,
	source_system_cd     VARCHAR(10)  ,
	contact_id           VARCHAR(36)  ,
	content_hash_val     VARCHAR(32)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP ,  
CONSTRAINT response_history_fk7 FOREIGN KEY (response_type_cd) REFERENCES WITH NO CHECK OPTION cdm_response_type (response_type_cd),
CONSTRAINT response_history_fk1 FOREIGN KEY (identity_id) REFERENCES WITH NO CHECK OPTION cdm_identity_map (identity_id),
CONSTRAINT response_history_fk2 FOREIGN KEY (rtc_id) REFERENCES WITH NO CHECK OPTION cdm_rtc_detail (rtc_id),
CONSTRAINT response_history_fk3 FOREIGN KEY (content_version_id) REFERENCES WITH NO CHECK OPTION cdm_content_detail (content_version_id),
CONSTRAINT response_history_fk4 FOREIGN KEY (response_cd) REFERENCES WITH NO CHECK OPTION cdm_response_lookup (response_cd),
CONSTRAINT response_history_fk5 FOREIGN KEY (response_channel_cd) REFERENCES WITH NO CHECK OPTION cdm_response_channel (response_channel_cd),
CONSTRAINT response_history_fk6 FOREIGN KEY (contact_id) REFERENCES WITH NO CHECK OPTION cdm_contact_history (contact_id)
 ) 
        UNIQUE PRIMARY INDEX response_history_pi 
 ( 
        response_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_response_extended_attr
(
	response_id          VARCHAR(36) NOT NULL ,
	response_attribute_type_cd VARCHAR(10) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30)  ,
	attribute_val        VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT response_extended_attr_pk PRIMARY KEY (response_id,response_attribute_type_cd,attribute_nm),
CONSTRAINT response_extended_attr_fk1 FOREIGN KEY (response_id) REFERENCES WITH NO CHECK OPTION cdm_response_history (response_id)
 ) 
        PRIMARY INDEX response_extended_attr_pi 
 ( 
        response_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_identifier_type
(
	identifier_type_id   VARCHAR(36) NOT NULL ,
	identifier_type_desc VARCHAR(100)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
 ) 
        UNIQUE PRIMARY INDEX identifier_type_pi 
 ( 
        identifier_type_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_identity_attr
(
	identity_id          VARCHAR(36) NOT NULL ,
	identifier_type_id   VARCHAR(36) NOT NULL ,
	valid_from_dttm      TIMESTAMP  ,
	valid_to_dttm        TIMESTAMP  ,
	user_identifier_val  VARCHAR(32000)  ,
	entry_dttm           TIMESTAMP  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT identity_user_pk PRIMARY KEY (identity_id,identifier_type_id),
CONSTRAINT identity_attr_fk2 FOREIGN KEY (identity_id) REFERENCES WITH NO CHECK OPTION cdm_identity_map (identity_id)
 ) 
        PRIMARY INDEX identity_attr_pi 
 ( 
        identity_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_content_custom_attr
(
	content_version_id   VARCHAR(40) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  content_custom_attribute_pk PRIMARY KEY (content_version_id,attribute_nm,attribute_data_type_cd,attribute_val),
CONSTRAINT content_custom_attr_fk1 FOREIGN KEY (content_version_id) REFERENCES WITH NO CHECK OPTION cdm_content_detail (content_version_id)
 ) 
        PRIMARY INDEX content_custom_attr_pi 
 ( 
        content_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_dyn_content_custom_attr
(
	content_version_id   VARCHAR(40) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	content_hash_val     VARCHAR(32) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  dynamic_content_custom_attr_pk PRIMARY KEY (content_version_id,attribute_nm,content_hash_val,attribute_data_type_cd,attribute_val),
CONSTRAINT dyn_content_custom_attr_fk1 FOREIGN KEY (content_version_id) REFERENCES WITH NO CHECK OPTION cdm_content_detail (content_version_id)
 ) 
        PRIMARY INDEX content_custom_attr_pi 
 ( 
        content_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_rtc_x_content
(
	rtc_x_content_sk     VARCHAR(36) NOT NULL ,
	rtc_id               VARCHAR(36) NOT NULL ,
	content_version_id   VARCHAR(40) NOT NULL ,
	content_hash_val     VARCHAR(32)  ,
	sequence_no          INTEGER  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  rtc_x_content_pk PRIMARY KEY (rtc_x_content_sk),
CONSTRAINT rtc_x_content_fk1 FOREIGN KEY (content_version_id) REFERENCES WITH NO CHECK OPTION cdm_content_detail (content_version_id),
CONSTRAINT rtc_x_content_fk2 FOREIGN KEY (rtc_id) REFERENCES WITH NO CHECK OPTION cdm_rtc_detail (rtc_id)
 ) 
        PRIMARY INDEX rtc_x_content_pi 
 ( 
        rtc_id,content_version_id,content_hash_val,sequence_no 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_segment_custom_attr
(
	segment_version_id   VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  segment_custom_attr_pk PRIMARY KEY (segment_version_id,attribute_nm,attribute_data_type_cd,attribute_val),
CONSTRAINT segment_custom_attr_fk1 FOREIGN KEY (segment_version_id) REFERENCES WITH NO CHECK OPTION cdm_segment_detail (segment_version_id)
 ) 
        PRIMARY INDEX segment_custom_attr_pi 
 ( 
        segment_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_segment_map_custom_attr
(
	segment_map_version_id VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  segment_map_custom_attr_pk PRIMARY KEY (segment_map_version_id,attribute_nm,attribute_data_type_cd,attribute_val),
CONSTRAINT segment_map_custom_attr_fk1 FOREIGN KEY (segment_map_version_id) REFERENCES WITH NO CHECK OPTION cdm_segment_map (segment_map_version_id) ) 
        PRIMARY INDEX segment_map_custom_attr_pi 
 ( 
        segment_map_version_id 
 )) BY TERADATA;

EXECUTE (CREATE TABLE cdm_activity_custom_attr
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500)  ,
	attribute_numeric_val NUMERIC(17,2)  ,
	attribute_dttm_val   TIMESTAMP  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
CONSTRAINT  activity_custom_attr_pk PRIMARY KEY (activity_version_id,attribute_nm,attribute_data_type_cd,attribute_val),
CONSTRAINT activity_custom_attr_fk1 FOREIGN KEY (activity_version_id) REFERENCES WITH NO CHECK OPTION cdm_activity_detail (activity_version_id)
 ) 
        PRIMARY INDEX activity_custom_attr_pi 
 ( 
        activity_version_id 
 )) BY TERADATA;
 
DISCONNECT FROM TERADATA;
QUIT;

