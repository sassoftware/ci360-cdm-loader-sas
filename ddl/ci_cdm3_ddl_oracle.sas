/*===================================================================*/
/* Enter Customer Specific Target Source Connection Values - Oracle  */
/*===================================================================*/

%let path = <Oracle TNS Entry> ;  /* From tnsnames.ora     */
%let user = <User Name> ;         /* Oracle User/Schema    */
%let pass = <Password> ;          /* Oracle Password       */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code creates the CI360 Common Data Model 3.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO ORACLE (USER=&USER PASS=&PASS PATH=&PATH);


EXECUTE (CREATE TABLE cdm_activity_detail
(
	activity_version_id  VARCHAR2(36) NOT NULL ,
	activity_id          VARCHAR2(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	status_cd            VARCHAR2(20) NULL ,
	activity_nm          VARCHAR2(256) NULL ,
	activity_desc        VARCHAR2(1500) NULL ,
	activity_cd          VARCHAR2(60) NULL ,
	activity_category_nm VARCHAR2(100) NULL ,
	last_published_dttm  TIMESTAMP NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_activity_custom_attr
(
	activity_version_id  VARCHAR2(36) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	activity_id          VARCHAR2(36) NULL 
)) BY ORACLE;

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

EXECUTE (CREATE TABLE cdm_business_context
(
	business_context_id  VARCHAR2(36) NOT NULL ,
	business_context_nm  VARCHAR2(256) NULL ,
	business_context_type_cd VARCHAR2(40) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_campaign_detail
(
	campaign_id          VARCHAR2(36) NOT NULL ,
	campaign_version_no  NUMBER(6) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	campaign_nm          VARCHAR2(60) NULL ,
	campaign_desc        VARCHAR2(1500) NULL ,
	campaign_cd          VARCHAR2(60) NULL ,
	campaign_owner_nm    VARCHAR2(60) NULL ,
	min_budget_offer_amt NUMBER(14,2) NULL ,
	max_budget_offer_amt NUMBER(14,2) NULL ,
	min_budget_amt       NUMBER(14,2) NULL ,
	max_budget_amt       NUMBER(14,2) NULL ,
	start_dttm           TIMESTAMP NULL ,
	end_dttm             TIMESTAMP NULL ,
	run_dttm             TIMESTAMP NULL ,
	last_modified_dttm   TIMESTAMP NULL ,
	approval_dttm        TIMESTAMP NULL ,
	approval_given_by_nm VARCHAR2(60) NULL ,
	last_modified_by_user_nm VARCHAR2(60) NULL ,
	current_version_flg  CHAR(1) NULL ,
	deleted_flg          CHAR(1) NULL ,
	campaign_status_cd   VARCHAR2(3) NULL ,
	campaign_type_cd     VARCHAR2(3) NULL ,
	campaign_folder_txt  VARCHAR2(1024) NULL ,
	campaign_group_sk    NUMBER(15) NULL ,
	deployment_version_no NUMBER(6) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_campaign_custom_attr
(
	campaign_id          VARCHAR2(36) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	page_nm              VARCHAR2(60) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_contact_channel
(
	contact_channel_cd   VARCHAR2(60) NOT NULL ,
	contact_channel_nm   VARCHAR2(40) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_identity_map
(
	identity_id          VARCHAR2(36) NOT NULL ,
	identity_type_cd     VARCHAR2(40) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_identity_attr
(
	identity_id          VARCHAR2(36) NOT NULL ,
	identifier_type_id   VARCHAR2(36) NOT NULL ,
	valid_from_dttm      TIMESTAMP NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	user_identifier_val  VARCHAR2(4000) NULL ,
	entry_dttm           TIMESTAMP NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_contact_history
(
	contact_id           VARCHAR2(36) NOT NULL ,
	identity_id          VARCHAR2(36) NOT NULL ,
	contact_nm           VARCHAR2(256) NULL ,
	contact_dt           DATE NULL ,
	contact_dttm         TIMESTAMP NULL ,
	contact_dttm_tz      TIMESTAMP NULL ,
	contact_status_cd    VARCHAR2(3) NULL ,
	optimization_backfill_flg CHAR(1) NULL ,
	external_contact_info_1_id VARCHAR2(32) NULL ,
	external_contact_info_2_id VARCHAR2(32) NULL ,
	rtc_id               VARCHAR2(36) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	control_group_flg    CHAR(1) NULL ,
	audience_id          VARCHAR2(36) NULL ,
	audience_occur_id    VARCHAR2(36) NULL ,
	context_type_nm      VARCHAR2(256) NULL ,
	context_val          VARCHAR2(256) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_contact_status
(
	contact_status_cd    VARCHAR2(3) NOT NULL ,
	contact_status_desc  VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_content_detail
(
	content_version_id   VARCHAR2(40) NOT NULL ,
	content_id           VARCHAR2(40) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	contact_content_nm   VARCHAR2(256) NULL ,
	contact_content_desc VARCHAR2(1500) NULL ,
	contact_content_type_nm VARCHAR2(50) NULL ,
	contact_content_status_cd VARCHAR2(60) NULL ,
	contact_content_category_nm VARCHAR2(256) NULL ,
	contact_content_class_nm VARCHAR2(100) NULL ,
	contact_content_cd   VARCHAR2(60) NULL ,
	active_flg           CHAR(1) NULL ,
	owner_nm             VARCHAR2(256) NULL ,
	created_user_nm      VARCHAR2(256) NULL ,
	created_dt           DATE NULL ,
	external_reference_txt VARCHAR2(1024) NULL ,
	external_reference_url_txt VARCHAR2(1024) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_content_custom_attr
(
	content_version_id   VARCHAR2(40) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	content_id           VARCHAR2(40) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_dyn_content_custom_attr
(
	content_version_id   VARCHAR2(40) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	content_hash_val     VARCHAR2(32) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	content_id           VARCHAR2(40) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_identifier_type
(
	identifier_type_id   VARCHAR2(36) NOT NULL ,
	identifier_type_desc VARCHAR2(100) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_identity_type
(
	identity_type_cd     VARCHAR2(40) NOT NULL ,
	identity_type_desc   VARCHAR2(100) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_occurrence_detail
(
	occurrence_id        VARCHAR2(36) NOT NULL ,
	start_dttm           TIMESTAMP NULL ,
	end_dttm             TIMESTAMP NULL ,
	occurrence_no        INTEGER NULL ,
	occurrence_type_cd   VARCHAR2(30) NULL ,
	occurrence_object_id VARCHAR2(36) NULL ,
	occurrence_object_type_cd VARCHAR2(60) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	execution_status_cd  VARCHAR2(30) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_response_channel
(
	response_channel_cd  VARCHAR2(40) NOT NULL ,
	response_channel_nm  VARCHAR2(60) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_response_history
(
	response_id          VARCHAR2(36) NOT NULL ,
	response_cd          VARCHAR2(256) NULL ,
	response_dt          DATE NULL ,
	response_dttm        TIMESTAMP NULL ,
	response_dttm_tz     TIMESTAMP NULL ,
	external_contact_info_1_id VARCHAR2(32) NULL ,
	external_contact_info_2_id VARCHAR2(32) NULL ,
	response_type_cd     VARCHAR2(60) NULL ,
	response_channel_cd  VARCHAR2(40) NULL ,
	conversion_flg       CHAR(1) NULL ,
	inferred_response_flg CHAR(1) NULL ,
	content_id           VARCHAR2(40) NULL ,
	identity_id          VARCHAR2(36) NULL ,
	rtc_id               VARCHAR2(36) NOT NULL ,
	content_version_id   VARCHAR2(40) NULL ,
	response_val_amt     NUMBER(12,2) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	contact_id           VARCHAR2(36) NULL ,
	content_hash_val     VARCHAR2(32) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	properties_map_doc   VARCHAR2(4000) NULL ,
	audience_id          VARCHAR2(36) NULL ,
	audience_occur_id    VARCHAR2(36) NULL ,
	context_type_nm      VARCHAR2(256) NULL ,
	context_val          VARCHAR2(256) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_response_extended_attr
(
	response_id          VARCHAR2(36) NOT NULL ,
	response_attribute_type_cd VARCHAR2(10) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NULL ,
	attribute_val        VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_response_lookup
(
	response_cd          VARCHAR2(256) NOT NULL ,
	response_nm          VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_response_type
(
	response_type_cd     VARCHAR2(60) NOT NULL ,
	response_type_desc   VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_segment_test
(
	test_cd              VARCHAR2(60) NOT NULL ,
	task_version_id      VARCHAR2(36) NOT NULL ,
	task_id              VARCHAR2(36) NOT NULL ,
	test_nm              VARCHAR2(65) NULL ,
	test_type_nm         VARCHAR2(10) NULL ,
	test_enabled_flg     CHAR(1) NULL ,
	test_sizing_type_nm  VARCHAR2(65) NULL ,
	test_cnt             INTEGER NULL ,
	test_pct             NUMBER(5,2) NULL ,
	stratified_sampling_flg CHAR(1) NULL ,
	stratified_samp_criteria_txt VARCHAR2(1024) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_segment_test_x_segment
(
	test_cd              VARCHAR2(60) NOT NULL ,
	task_version_id      VARCHAR2(36) NOT NULL ,
	task_id              VARCHAR2(36) NOT NULL ,
	segment_id           VARCHAR2(36) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_task_detail
(
	task_version_id      VARCHAR2(36) NOT NULL ,
	task_id              VARCHAR2(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	task_nm              VARCHAR2(256) NULL ,
	task_desc            VARCHAR2(1500) NULL ,
	task_type_nm         VARCHAR2(40) NULL ,
	task_status_cd       VARCHAR2(20) NULL ,
	task_subtype_nm      VARCHAR2(100) NULL ,
	task_cd              VARCHAR2(60) NULL ,
	task_delivery_type_nm VARCHAR2(60) NULL ,
	active_flg           CHAR(1) NULL ,
	saved_flg            CHAR(1) NULL ,
	published_flg        CHAR(1) NULL ,
	owner_nm             VARCHAR2(256) NULL ,
	modified_status_cd   VARCHAR2(20) NULL ,
	created_user_nm      VARCHAR2(256) NULL ,
	created_dt           DATE NULL ,
	scheduled_start_dttm TIMESTAMP NULL ,
	scheduled_end_dttm   TIMESTAMP NULL ,
	scheduled_flg        CHAR(1) NULL ,
	maximum_period_expression_cnt INTEGER NULL ,
	limit_period_unit_cnt INTEGER NULL ,
	limit_by_total_impression_flg CHAR(1) NULL ,
	export_dttm          TIMESTAMP NULL ,
	update_contact_history_flg CHAR(1) NULL ,
	subject_type_nm      VARCHAR2(60) NULL ,
	min_budget_offer_amt NUMBER(14,2) NULL ,
	max_budget_offer_amt NUMBER(14,2) NULL ,
	min_budget_amt       NUMBER(14,2) NULL ,
	max_budget_amt       NUMBER(14,2) NULL ,
	budget_unit_cost_amt NUMBER(14,2) NULL ,
	recurr_type_cd       VARCHAR2(3) NULL ,
	budget_unit_usage_amt NUMBER(14,2) NULL ,
	standard_reply_flg   CHAR(1) NULL ,
	staged_flg           CHAR(1) NULL ,
	contact_channel_cd   VARCHAR2(60) NULL ,
	campaign_id          VARCHAR2(36) NULL ,
	business_context_id  VARCHAR2(36) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	recurring_schedule_flg CHAR(1) NULL ,
	segment_tests_flg    CHAR(1) NULL ,
	control_group_action_nm VARCHAR2(65) NULL ,
	stratified_sampling_action_nm VARCHAR2(65) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_task_custom_attr
(
	task_version_id      VARCHAR2(36) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	extension_attribute_nm VARCHAR2(256) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	task_id              VARCHAR2(36) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_activity_x_task
(
	activity_version_id  VARCHAR2(36) NOT NULL ,
	task_version_id      VARCHAR2(36) NOT NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	activity_id          VARCHAR2(36) NULL ,
	task_id              VARCHAR2(36) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_rtc_detail
(
	rtc_id               VARCHAR2(36) NOT NULL ,
	task_occurrence_no   INTEGER NULL ,
	processed_dttm       TIMESTAMP NOT NULL ,
	response_tracking_flg CHAR(1) NULL ,
	segment_version_id   VARCHAR2(36) NULL ,
	task_version_id      VARCHAR2(36) NOT NULL ,
	execution_status_cd  VARCHAR2(30) NULL ,
	deleted_flg          CHAR(1) NULL ,
	occurrence_id        VARCHAR2(36) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_id           VARCHAR2(36) NULL ,
	task_id              VARCHAR2(36) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_rtc_x_content
(
	rtc_x_content_sk     VARCHAR(36) NOT NULL ,
	rtc_id               VARCHAR2(36) NOT NULL ,
	content_version_id   VARCHAR2(40) NOT NULL ,
	content_hash_val     VARCHAR2(32) NULL ,
	sequence_no          INTEGER NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	content_id           VARCHAR2(40) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_segment_detail
(
	segment_version_id   VARCHAR2(36) NOT NULL ,
	segment_id           VARCHAR2(36) NULL ,
	segment_map_version_id VARCHAR2(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	segment_nm           VARCHAR2(256) NULL ,
	segment_desc         VARCHAR2(1500) NULL ,
	segment_category_nm  VARCHAR2(100) NULL ,
	segment_cd           VARCHAR2(60) NULL ,
	segment_src_nm       VARCHAR2(40) NULL ,
	segment_status_cd    VARCHAR2(20) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_map_id       VARCHAR2(36) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_segment_custom_attr
(
	segment_version_id   VARCHAR2(36) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_id           VARCHAR2(36) NULL 
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_segment_map
(
	segment_map_version_id VARCHAR2(36) NOT NULL ,
	segment_map_id       VARCHAR2(36) NULL ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP NULL ,
	segment_map_nm       VARCHAR2(256) NULL ,
	segment_map_desc     VARCHAR2(1500) NULL ,
	segment_map_category_nm VARCHAR2(100) NULL ,
	segment_map_cd       VARCHAR2(60) NULL ,
	segment_map_src_nm   VARCHAR2(40) NULL ,
	segment_map_status_cd VARCHAR2(20) NULL ,
	source_system_cd     VARCHAR2(10) NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL 
)) BY ORACLE;

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
)) BY ORACLE;

EXECUTE (CREATE TABLE cdm_segment_map_custom_attr
(
	segment_map_version_id VARCHAR2(36) NOT NULL ,
	attribute_nm         VARCHAR2(256) NOT NULL ,
	attribute_data_type_cd VARCHAR2(30) NOT NULL ,
	attribute_val        VARCHAR2(1500) NOT NULL ,
	attribute_character_val VARCHAR2(1500) NULL ,
	attribute_numeric_val NUMBER(17,2) NULL ,
	attribute_dttm_val   TIMESTAMP NULL ,
	updated_by_nm        VARCHAR2(60) NULL ,
	updated_dttm         TIMESTAMP NULL ,
	segment_map_id       VARCHAR2(36) NULL 
)) BY ORACLE;

/*=================================================================*/
/*=========  B E G I N   A L T E R   T A B L E   S E C T I O N  ===*/
/*=================================================================*/
/*  The following code creates the CI360 Common Data Model 3.0     */
/*    Primary Key and Foreign Key Constraints.                     */
/*=================================================================*/

EXECUTE ( ALTER TABLE cdm_activity_detail
	ADD CONSTRAINT  activity_detail_pk PRIMARY KEY (activity_version_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_activity_custom_attr
	ADD CONSTRAINT  activity_custom_attr_pk PRIMARY KEY (activity_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_audience_detail
	ADD CONSTRAINT  audience_detail_pk PRIMARY KEY (audience_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_audience_occur_detail
	ADD CONSTRAINT  audience_occur_detail_pk PRIMARY KEY (audience_occur_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_business_context
	ADD CONSTRAINT  business_context_pk PRIMARY KEY (business_context_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_campaign_detail
	ADD CONSTRAINT  campaign_detail_pk PRIMARY KEY (campaign_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_campaign_custom_attr
	ADD CONSTRAINT  campaign_custom_attribute_pk PRIMARY KEY (campaign_id,attribute_nm,page_nm,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_channel
	ADD CONSTRAINT  contact_channel_pk PRIMARY KEY (contact_channel_cd)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_identity_map
	ADD CONSTRAINT  identity_map_pk PRIMARY KEY (identity_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_identity_attr
	ADD CONSTRAINT  identity_attr_pk PRIMARY KEY (identity_id,identifier_type_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT  contact_history_pk PRIMARY KEY (contact_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_status
	ADD CONSTRAINT  contact_status_pk PRIMARY KEY (contact_status_cd)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_content_detail
	ADD CONSTRAINT  content_detail_pk PRIMARY KEY (content_version_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_content_custom_attr
	ADD CONSTRAINT  content_custom_attribute_pk PRIMARY KEY (content_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_dyn_content_custom_attr
	ADD CONSTRAINT  dynamic_content_custom_attr_pk PRIMARY KEY (content_version_id,attribute_nm,content_hash_val,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_identifier_type
	ADD CONSTRAINT  identifier_type_pk PRIMARY KEY (identifier_type_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_identity_type
	ADD CONSTRAINT  identity_type_pk PRIMARY KEY (identity_type_cd)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_occurrence_detail
	ADD CONSTRAINT  occurrence_detail_pk PRIMARY KEY (occurrence_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_channel
	ADD CONSTRAINT  response_channel_pk PRIMARY KEY (response_channel_cd)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT  response_history_pk PRIMARY KEY (response_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_extended_attr
	ADD CONSTRAINT  response_extended_attr_pk PRIMARY KEY (response_id,response_attribute_type_cd,attribute_nm)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_lookup
	ADD CONSTRAINT  response_lookup_pk PRIMARY KEY (response_cd)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_type
	ADD CONSTRAINT  response_type_pk PRIMARY KEY (response_type_cd)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_test
	ADD CONSTRAINT  segment_test_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_test_x_segment
	ADD CONSTRAINT  segment_test_x_segment_pk PRIMARY KEY (test_cd,task_version_id,task_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_task_detail
	ADD CONSTRAINT  task_detail_pk PRIMARY KEY (task_version_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_task_custom_attr
	ADD CONSTRAINT  task_custom_attribute_pk PRIMARY KEY (task_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_activity_x_task
	ADD CONSTRAINT  activity_x_task_pk PRIMARY KEY (activity_version_id,task_version_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_detail
	ADD CONSTRAINT  rtc_detail_pk PRIMARY KEY (rtc_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_x_content
	ADD CONSTRAINT  rtc_x_content_pk PRIMARY KEY (rtc_x_content_sk)) BY ORACLE;

EXECUTE (CREATE UNIQUE INDEX rtc_x_content_uk ON cdm_rtc_x_content
(rtc_id   ASC,content_version_id   ASC,content_hash_val   ASC,sequence_no   ASC)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_detail
	ADD CONSTRAINT  segment_detail_pk PRIMARY KEY (segment_version_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_custom_attr
	ADD CONSTRAINT  segment_custom_attr_pk PRIMARY KEY (segment_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_map
	ADD CONSTRAINT  segment_map_pk PRIMARY KEY (segment_map_version_id)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_map_custom_attr
	ADD CONSTRAINT  segment_map_custom_attr_pk PRIMARY KEY (segment_map_version_id,attribute_nm,attribute_data_type_cd,attribute_val)) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_activity_custom_attr
	ADD CONSTRAINT activity_custom_attr_fk1 FOREIGN KEY (activity_version_id) REFERENCES cdm_activity_detail (activity_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_audience_occur_detail
	ADD CONSTRAINT audience_occur_detail_fk1 FOREIGN KEY (audience_id) REFERENCES cdm_audience_detail (audience_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_campaign_custom_attr
	ADD CONSTRAINT campaign_custom_attr_fk1 FOREIGN KEY (campaign_id) REFERENCES cdm_campaign_detail (campaign_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_identity_map
	ADD CONSTRAINT identity_map_fk1 FOREIGN KEY (identity_type_cd) REFERENCES cdm_identity_type (identity_type_cd) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_identity_attr
	ADD CONSTRAINT identity_attr_fk2 FOREIGN KEY (identity_id) REFERENCES cdm_identity_map (identity_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk3 FOREIGN KEY (identity_id) REFERENCES cdm_identity_map (identity_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk1 FOREIGN KEY (rtc_id) REFERENCES cdm_rtc_detail (rtc_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk2 FOREIGN KEY (contact_status_cd) REFERENCES cdm_contact_status (contact_status_cd) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk4 FOREIGN KEY (audience_id) REFERENCES cdm_audience_detail (audience_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_contact_history
	ADD CONSTRAINT contact_history_fk5 FOREIGN KEY (audience_occur_id) REFERENCES cdm_audience_occur_detail (audience_occur_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_content_custom_attr
	ADD CONSTRAINT content_custom_attr_fk1 FOREIGN KEY (content_version_id) REFERENCES cdm_content_detail (content_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_dyn_content_custom_attr
	ADD CONSTRAINT dyn_content_custom_attr_fk1 FOREIGN KEY (content_version_id) REFERENCES cdm_content_detail (content_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk7 FOREIGN KEY (response_type_cd) REFERENCES cdm_response_type (response_type_cd) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk1 FOREIGN KEY (identity_id) REFERENCES cdm_identity_map (identity_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk2 FOREIGN KEY (rtc_id) REFERENCES cdm_rtc_detail (rtc_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk3 FOREIGN KEY (content_version_id) REFERENCES cdm_content_detail (content_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk4 FOREIGN KEY (response_cd) REFERENCES cdm_response_lookup (response_cd) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk5 FOREIGN KEY (response_channel_cd) REFERENCES cdm_response_channel (response_channel_cd) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk6 FOREIGN KEY (contact_id) REFERENCES cdm_contact_history (contact_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk9 FOREIGN KEY (audience_occur_id) REFERENCES cdm_audience_occur_detail (audience_occur_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_history
	ADD CONSTRAINT response_history_fk8 FOREIGN KEY (audience_id) REFERENCES cdm_audience_detail (audience_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_response_extended_attr
	ADD CONSTRAINT response_extended_attr_fk1 FOREIGN KEY (response_id) REFERENCES cdm_response_history (response_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_test_x_segment
	ADD CONSTRAINT segment_test_x_segment_fk1 FOREIGN KEY (test_cd, task_version_id, task_id) REFERENCES cdm_segment_test (test_cd, task_version_id, task_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_task_detail
	ADD CONSTRAINT task_detail_fk1 FOREIGN KEY (campaign_id) REFERENCES cdm_campaign_detail (campaign_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_task_detail
	ADD CONSTRAINT task_detail_fk2 FOREIGN KEY (business_context_id) REFERENCES cdm_business_context (business_context_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_task_detail
	ADD CONSTRAINT task_detail_fk3 FOREIGN KEY (contact_channel_cd) REFERENCES cdm_contact_channel (contact_channel_cd) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_task_custom_attr
	ADD CONSTRAINT task_custom_attr_fk1 FOREIGN KEY (task_version_id) REFERENCES cdm_task_detail (task_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_activity_x_task
	ADD CONSTRAINT activity_x_task_fk1 FOREIGN KEY (activity_version_id) REFERENCES cdm_activity_detail (activity_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_activity_x_task
	ADD CONSTRAINT activity_x_task_fk2 FOREIGN KEY (task_version_id) REFERENCES cdm_task_detail (task_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_detail
	ADD CONSTRAINT rtc_detail_fk1 FOREIGN KEY (task_version_id) REFERENCES cdm_task_detail (task_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_detail
	ADD CONSTRAINT rtc_detail_fk2 FOREIGN KEY (segment_version_id) REFERENCES cdm_segment_detail (segment_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_detail
	ADD CONSTRAINT rtc_detail_fk3 FOREIGN KEY (occurrence_id) REFERENCES cdm_occurrence_detail (occurrence_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_x_content
	ADD CONSTRAINT rtc_x_content_fk1 FOREIGN KEY (content_version_id) REFERENCES cdm_content_detail (content_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_rtc_x_content
	ADD CONSTRAINT rtc_x_content_fk2 FOREIGN KEY (rtc_id) REFERENCES cdm_rtc_detail (rtc_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_custom_attr
	ADD CONSTRAINT segment_custom_attr_fk1 FOREIGN KEY (segment_version_id) REFERENCES cdm_segment_detail (segment_version_id) DISABLE ) BY ORACLE;

EXECUTE ( ALTER TABLE cdm_segment_map_custom_attr
	ADD CONSTRAINT segment_map_custom_attr_fk1 FOREIGN KEY (segment_map_version_id) REFERENCES cdm_segment_map (segment_map_version_id) DISABLE ) BY ORACLE;

DISCONNECT FROM ORACLE;
QUIT;