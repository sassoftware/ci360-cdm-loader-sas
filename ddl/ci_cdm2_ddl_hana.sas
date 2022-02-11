
/*==================================================================================*/
/* Enter Customer Specific Target Source Connection Values - SAP Hana - Column Store*/
/*==================================================================================*/

%let user = <User Name> ;         /* SAP Hana User           */
%let pass = <Password> ;          /* SAP Hana Password       */
%let server = '<Server>' ;        /* SAP Hana Server         */
%let instance = <Instance>;       /* SAP Hana Instance       */
%let schema = <Schema> ;          /* SAP Hana Schema         */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code creates the CI360 Common Data Model 2.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOHNA (USER=&USER PASS=&PASS SERVER=&SERVER
                       INSTANCE=&INSTANCE);

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_activity_detail
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	activity_id          VARCHAR(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	status_cd            VARCHAR(20) NULL ,
	activity_nm          VARCHAR(256) NULL ,
	activity_desc        CLOB NULL ,
	activity_cd          VARCHAR(60) NULL ,
	activity_category_nm VARCHAR(100) NULL ,
	last_published_dttm  TIMESTAMP NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_activity_custom_attr
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	activity_id          VARCHAR(36) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_business_context
(
	business_context_id  VARCHAR(36) NOT NULL ,
	business_context_nm  VARCHAR(256) NULL ,
	business_context_type_cd VARCHAR(40) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_campaign_detail
(
	campaign_id          VARCHAR(36) NOT NULL ,
	campaign_version_no  NUMERIC(6) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	campaign_nm          VARCHAR(60) NULL ,
	campaign_desc        CLOB NULL ,
	campaign_cd          VARCHAR(60) NULL ,
	campaign_owner_nm    VARCHAR(60) NULL ,
	min_budget_offer_amt NUMERIC(14,2) NULL ,
	max_budget_offer_amt NUMERIC(14,2) NULL ,
	min_budget_amt       NUMERIC(14,2) NULL ,
	max_budget_amt       NUMERIC(14,2) NULL ,
	start_dttm           TIMESTAMP NULL ,
	end_dttm             TIMESTAMP NULL ,
	run_dttm             TIMESTAMP NULL ,
	last_modified_dttm   TIMESTAMP NULL ,
	approval_dttm        TIMESTAMP NULL ,
	approval_given_by_nm VARCHAR(60) NULL ,
	last_modified_by_user_nm VARCHAR(60) NULL ,
	current_version_flg  CHAR(1) NULL ,
	deleted_flg          CHAR(1) NULL ,
	campaign_status_cd   VARCHAR(3) NULL ,
	campaign_type_cd     VARCHAR(3) NULL ,
	campaign_folder_txt  VARCHAR(1024) NULL ,
	campaign_group_sk    NUMERIC(15) NULL ,
	deployment_version_no NUMERIC(6) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_campaign_custom_attr
(
	campaign_id          VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	page_nm              VARCHAR(60) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_contact_channel
(
	contact_channel_cd   VARCHAR(60) NOT NULL ,
	contact_channel_nm   VARCHAR(40) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_identity_map
(
	identity_id          VARCHAR(36) NOT NULL ,
	identity_type_cd     VARCHAR(40) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_contact_history
(
	contact_id           VARCHAR(36) NOT NULL ,
	identity_id          VARCHAR(36) NOT NULL ,
	contact_nm           VARCHAR(256) NULL ,
	contact_dt           DATE NULL ,
	contact_dttm         TIMESTAMP NULL ,
	contact_status_cd    VARCHAR(3) NULL ,
	optimization_backfill_flg CHAR(1) NULL ,
	external_contact_info_1_id VARCHAR(32) NULL ,
	external_contact_info_2_id VARCHAR(32) NULL ,
	rtc_id               VARCHAR(36) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_contact_status
(
	contact_status_cd    VARCHAR(3) NOT NULL ,
	contact_status_desc  VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_content_detail
(
	content_version_id   VARCHAR(40) NOT NULL ,
	content_id           VARCHAR(40) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	contact_content_nm   VARCHAR(256) NULL ,
	contact_content_desc CLOB NULL ,
	contact_content_type_nm VARCHAR(50) NULL ,
	contact_content_status_cd VARCHAR(60) NULL ,
	contact_content_category_nm VARCHAR(256) NULL ,
	contact_content_class_nm VARCHAR(100) NULL ,
	contact_content_cd   VARCHAR(60) NULL ,
	active_flg           CHAR(1) NULL ,
	owner_nm             VARCHAR(100) NULL ,
	created_user_nm      VARCHAR(100) NULL ,
	created_dt           DATE NULL ,
	external_reference_txt VARCHAR(1024) NULL ,
	external_reference_url_txt VARCHAR(1024) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_content_custom_attr
(
	content_version_id   VARCHAR(40) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	content_id           VARCHAR(40) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_dyn_content_custom_attr
(
	content_version_id   VARCHAR(40) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	content_hash_val     VARCHAR(32) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	content_id           VARCHAR(40) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_identifier_type
(
	identifier_type_id   VARCHAR(36) NULL ,
	identifier_type_desc VARCHAR(100) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_identity_attr
(
	identity_id          VARCHAR(36) NOT NULL ,
	identifier_type_id   VARCHAR(36) NOT NULL ,
	valid_from_dttm      TIMESTAMP NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	user_identifier_val  CLOB NULL ,
	entry_dttm           TIMESTAMP NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_identity_type
(
	identity_type_cd     VARCHAR(40) NOT NULL ,
	identity_type_desc   VARCHAR(100) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_occurrence_detail
(
	occurrence_id        VARCHAR(36) NOT NULL ,
	start_dttm           TIMESTAMP NULL ,
	end_dttm             TIMESTAMP NULL ,
	occurrence_no        INTEGER NULL ,
	occurrence_type_cd   VARCHAR(30) NULL ,
	occurrence_object_id VARCHAR(36) NULL ,
	occurrence_object_type_cd VARCHAR(60) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	execution_status_cd  VARCHAR(30) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_response_channel
(
	response_channel_cd  VARCHAR(40) NOT NULL ,
	response_channel_nm  VARCHAR(60) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_response_history
(
	response_id          VARCHAR(36) NOT NULL ,
	response_cd          VARCHAR(256) NULL ,
	response_dt          TIMESTAMP NULL ,
	response_dttm        TIMESTAMP NULL ,
	external_contact_info_1_id VARCHAR(32) NULL ,
	external_contact_info_2_id VARCHAR(32) NULL ,
	response_type_cd     VARCHAR(60) NULL ,
	response_channel_cd  VARCHAR(40) NULL ,
	conversion_flg       CHAR(1) NULL ,
	inferred_response_flg CHAR(1) NULL ,
	content_id           VARCHAR(40) NULL ,
	identity_id          VARCHAR(36) NULL ,
	rtc_id               VARCHAR(36) NOT NULL ,
	content_version_id   VARCHAR(40) NULL ,
	response_val_amt     NUMERIC(12,2) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	contact_id           VARCHAR(36) NULL ,
	content_hash_val     VARCHAR(32) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_response_extended_attr
(
	response_id          VARCHAR(36) NOT NULL ,
	response_attribute_type_cd VARCHAR(10) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NULL ,
	attribute_val        VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_response_lookup
(
	response_cd          VARCHAR(256) NOT NULL ,
	response_nm          VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_response_type
(
	response_type_cd     VARCHAR(60) NOT NULL ,
	response_type_desc   VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_task_detail
(
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	task_nm              VARCHAR(256) NULL ,
	task_desc            CLOB NULL ,
	task_type_nm         VARCHAR(40) NULL ,
	task_status_cd       VARCHAR(20) NULL ,
	task_subtype_nm      VARCHAR(100) NULL ,
	task_cd              VARCHAR(60) NULL ,
	task_delivery_type_nm VARCHAR(60) NULL ,
	active_flg           CHAR(1) NULL ,
	saved_flg            CHAR(1) NULL ,
	published_flg        CHAR(1) NULL ,
	owner_nm             VARCHAR(40) NULL ,
	modified_status_cd   VARCHAR(20) NULL ,
	created_user_nm      VARCHAR(40) NULL ,
	created_dt           DATE NULL ,
	scheduled_start_dttm TIMESTAMP NULL ,
	scheduled_end_dttm   TIMESTAMP NULL ,
	scheduled_flg        CHAR(1) NULL ,
	maximum_period_expression_cnt INTEGER NULL ,
	limit_period_unit_cnt INTEGER NULL ,
	limit_by_total_impression_flg CHAR(1) NULL ,
	export_dttm          TIMESTAMP NULL ,
	update_contact_history_flg CHAR(1) NULL ,
	subject_type_nm      VARCHAR(60) NULL ,
	min_budget_offer_amt NUMERIC(14,2) NULL ,
	max_budget_offer_amt NUMERIC(14,2) NULL ,
	min_budget_amt       NUMERIC(14,2) NULL ,
	max_budget_amt       NUMERIC(14,2) NULL ,
	budget_unit_cost_amt NUMERIC(14,2) NULL ,
	recurr_type_cd       VARCHAR(3) NULL ,
	budget_unit_usage_amt NUMERIC(14,2) NULL ,
	standard_reply_flg   CHAR(1) NULL ,
	staged_flg           CHAR(1) NULL ,
	contact_channel_cd   VARCHAR(60) NULL ,
	campaign_id          VARCHAR(36) NULL ,
	business_context_id  VARCHAR(36) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	recurring_schedule_flg CHAR(1) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_task_custom_attr
(
	task_version_id      VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR(256) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	task_id              VARCHAR(36) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_activity_x_task
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	activity_id          VARCHAR(36) NULL ,
	task_id              VARCHAR(36) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_rtc_detail
(
	rtc_id               VARCHAR(36) NOT NULL ,
	task_occurrence_no   INTEGER NULL ,
	processed_dttm       TIMESTAMP NOT NULL ,
	response_tracking_flg CHAR(1) NULL ,
	segment_version_id   VARCHAR(36) NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	execution_status_cd  VARCHAR(30) NULL ,
	deleted_flg          CHAR(1) NULL ,
	occurrence_id        VARCHAR(36) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_id           VARCHAR(36) NULL ,
	task_id              VARCHAR(36) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_rtc_x_content
(
	rtc_x_content_sk     VARCHAR(36) NOT NULL ,
	rtc_id               VARCHAR(36) NOT NULL ,
	content_version_id   VARCHAR(40) NOT NULL ,
	content_hash_val     VARCHAR(32) NULL ,
	sequence_no          INTEGER NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	content_id           VARCHAR(40) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_segment_detail
(
	segment_version_id   VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36) NULL ,
	segment_map_version_id VARCHAR(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	segment_nm           VARCHAR(256) NULL ,
	segment_desc         CLOB NULL ,
	segment_category_nm  VARCHAR(100) NULL ,
	segment_cd           VARCHAR(60) NULL ,
	segment_src_nm       VARCHAR(40) NULL ,
	segment_status_cd    VARCHAR(20) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_map_id       VARCHAR(36) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_segment_custom_attr
(
	segment_version_id   VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_id           VARCHAR(36) NULL 
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_segment_map
(
	segment_map_version_id VARCHAR(36) NOT NULL ,
	segment_map_id       VARCHAR(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	segment_map_nm       VARCHAR(256) NULL ,
	segment_map_desc     CLOB NULL ,
	segment_map_category_nm VARCHAR(100) NULL ,
	segment_map_cd       VARCHAR(60) NULL ,
	segment_map_src_nm   VARCHAR(40) NULL ,
	segment_map_status_cd VARCHAR(20) NULL ,
	source_system_cd     VARCHAR(10) NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY SASIOHNA;

/** INSERT RECORD INTO CDM_SEGMENT_MAP TABLE **/

EXECUTE (insert into &SCHEMA..cdm_segment_map (
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
)) BY SASIOHNA;

EXECUTE (CREATE COLUMN TABLE &SCHEMA..cdm_segment_map_custom_attr
(
	segment_map_version_id VARCHAR(36) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30) NOT NULL ,
	attribute_val        VARCHAR(1500) NOT NULL ,
	attribute_character_val VARCHAR(1500) NULL ,
	attribute_numeric_val NUMERIC(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	updated_by_nm        VARCHAR(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_map_id       VARCHAR(36) NULL 
)) BY SASIOHNA;

/*=================================================================*/
/*=========  B E G I N   A L T E R   T A B L E   S E C T I O N  ===*/
/*=================================================================*/
/*  The following code creates the CI360 Common Data Model 2.0     */
/*    Primary Key and Foreign Key Constraints.                     */
/*=================================================================*/

EXECUTE (ALTER TABLE &SCHEMA..cdm_activity_detail
	ADD CONSTRAINT  activity_detail_pk PRIMARY KEY (activity_version_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_activity_custom_attr
	ADD CONSTRAINT  activity_custom_attr_pk PRIMARY KEY (activity_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_business_context
	ADD CONSTRAINT  business_context_pk PRIMARY KEY (business_context_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_campaign_detail
	ADD CONSTRAINT  campaign_pk PRIMARY KEY (campaign_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_campaign_custom_attr
	ADD CONSTRAINT  campaign_custom_attribute_pk PRIMARY KEY (campaign_id,attribute_nm,page_nm,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_contact_channel
	ADD CONSTRAINT  contact_channel_pk PRIMARY KEY (contact_channel_cd)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_identity_map
	ADD CONSTRAINT  identity_pk PRIMARY KEY (identity_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_contact_history
	ADD CONSTRAINT  contact_pk PRIMARY KEY (contact_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_contact_status
	ADD CONSTRAINT  contact_status_pk PRIMARY KEY (contact_status_cd)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_content_detail
	ADD CONSTRAINT  contact_content_pk PRIMARY KEY (content_version_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_content_custom_attr
	ADD CONSTRAINT  content_custom_attribute_pk PRIMARY KEY (content_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_dyn_content_custom_attr
	ADD CONSTRAINT  dynamic_content_custom_attr_pk PRIMARY KEY (content_version_id,attribute_nm,content_hash_val,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_identity_attr
	ADD CONSTRAINT  identity_user_pk PRIMARY KEY (identity_id,identifier_type_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_identity_type
	ADD CONSTRAINT  identity_type_pk PRIMARY KEY (identity_type_cd)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_occurrence_detail
	ADD CONSTRAINT  occurrence_detail_pk PRIMARY KEY (occurrence_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_response_channel
	ADD CONSTRAINT  response_channel_pk PRIMARY KEY (response_channel_cd)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_response_history
	ADD CONSTRAINT  response_pk PRIMARY KEY (response_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_response_extended_attr
	ADD CONSTRAINT  response_extended_attr_pk PRIMARY KEY (response_id,response_attribute_type_cd,attribute_nm)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_response_lookup
	ADD CONSTRAINT  response_lookup_pk PRIMARY KEY (response_cd)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_response_type
	ADD CONSTRAINT  response_type_pk PRIMARY KEY (response_type_cd)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_task_detail
	ADD CONSTRAINT  task_pk PRIMARY KEY (task_version_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_task_custom_attr
	ADD CONSTRAINT  task_custom_attribute_pk PRIMARY KEY (task_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_activity_x_task
	ADD CONSTRAINT  activity_x_task_pk PRIMARY KEY (activity_version_id,task_version_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_rtc_detail
	ADD CONSTRAINT  rtc_detail_pk PRIMARY KEY (rtc_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_rtc_x_content
	ADD CONSTRAINT  rtc_x_content_pk PRIMARY KEY (rtc_x_content_sk)) BY SASIOHNA;

EXECUTE ( ALTER TABLE &SCHEMA..cdm_rtc_x_content 
	ADD CONSTRAINT rtc_x_content_uk UNIQUE (rtc_id, content_version_id, content_hash_val, sequence_no )) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_segment_detail
	ADD CONSTRAINT  segment_detail_pk PRIMARY KEY (segment_version_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_segment_custom_attr
	ADD CONSTRAINT  segment_custom_attr_pk PRIMARY KEY (segment_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_segment_map
	ADD CONSTRAINT  segment_map_pk PRIMARY KEY (segment_map_version_id)) BY SASIOHNA;

EXECUTE (ALTER TABLE &SCHEMA..cdm_segment_map_custom_attr
	ADD CONSTRAINT  segment_map_custom_attr_pk PRIMARY KEY (segment_map_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY SASIOHNA;

DISCONNECT FROM SASIOHNA;
QUIT;

