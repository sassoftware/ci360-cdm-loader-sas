/*=====================================================================*/
/* Enter Customer Specific Target Source Connection Values - BigQuery  */
/*=====================================================================*/

%let project = <Project>;      /* ProjectID - Do Not Quote This Value             */
%let schema = <Schema>;        /* BigQuery Schema - Do Not Quote This Value       */
%let cred_path = <Cred_Path>;  /* Credentials File Path - Do Not Quote This Value */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code creates the CI360 Common Data Model 2.0        */
/*         tables.                                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO SASIOGBQ (PROJECT="&PROJECT" CRED_PATH="&CRED_PATH" SCHEMA="&SCHEMA");

EXECUTE (CREATE TABLE &SCHEMA..cdm_activity_detail
(
	activity_version_id  STRING NOT NULL ,
	activity_id          STRING  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	status_cd            STRING  ,
	activity_nm          STRING  ,
	activity_desc        STRING  ,
	activity_cd          STRING  ,
	activity_category_nm STRING  ,
	last_published_dttm  TIMESTAMP  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_activity_custom_attr
(
	activity_version_id  STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	activity_id          STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_business_context
(
	business_context_id  STRING NOT NULL ,
	business_context_nm  STRING  ,
	business_context_type_cd STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_campaign_detail
(
	campaign_id          STRING NOT NULL ,
	campaign_version_no  NUMERIC  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	campaign_nm          STRING  ,
	campaign_desc        STRING  ,
	campaign_cd          STRING  ,
	campaign_owner_nm    STRING  ,
	min_budget_offer_amt NUMERIC  ,
	max_budget_offer_amt NUMERIC  ,
	min_budget_amt       NUMERIC  ,
	max_budget_amt       NUMERIC  ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	run_dttm             TIMESTAMP  ,
	last_modified_dttm   TIMESTAMP  ,
	approval_dttm        TIMESTAMP  ,
	approval_given_by_nm STRING  ,
	last_modified_by_user_nm STRING  ,
	current_version_flg  STRING  ,
	deleted_flg          STRING  ,
	campaign_status_cd   STRING  ,
	campaign_type_cd     STRING  ,
	campaign_folder_txt  STRING  ,
	campaign_group_sk    NUMERIC  ,
	deployment_version_no NUMERIC  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_campaign_custom_attr
(
	campaign_id          STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	page_nm              STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_contact_channel
(
	contact_channel_cd   STRING NOT NULL ,
	contact_channel_nm   STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_identity_map
(
	identity_id          STRING NOT NULL ,
	identity_type_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_contact_history
(
	contact_id           STRING NOT NULL ,
	identity_id          STRING NOT NULL ,
	contact_nm           STRING  ,
	contact_dt           DATE  ,
	contact_dttm         TIMESTAMP  ,
	contact_status_cd    STRING  ,
	optimization_backfill_flg STRING  ,
	external_contact_info_1_id STRING  ,
	external_contact_info_2_id STRING  ,
	rtc_id               STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_contact_status
(
	contact_status_cd    STRING NOT NULL ,
	contact_status_desc  STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_content_detail
(
	content_version_id   STRING NOT NULL ,
	content_id           STRING  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	contact_content_nm   STRING  ,
	contact_content_desc STRING  ,
	contact_content_type_nm STRING  ,
	contact_content_status_cd STRING  ,
	contact_content_category_nm STRING  ,
	contact_content_class_nm STRING  ,
	contact_content_cd   STRING  ,
	active_flg           STRING  ,
	owner_nm             STRING  ,
	created_user_nm      STRING  ,
	created_dt           DATE  ,
	external_reference_txt STRING  ,
	external_reference_url_txt STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_content_custom_attr
(
	content_version_id   STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	content_id           STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_dyn_content_custom_attr
(
	content_version_id   STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	content_hash_val     STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	content_id           STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_identifier_type
(
	identifier_type_id   STRING ,
	identifier_type_desc STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_identity_attr
(
	identity_id          STRING NOT NULL ,
	identifier_type_id   STRING NOT NULL ,
	valid_from_dttm      TIMESTAMP  ,
	valid_to_dttm        TIMESTAMP  ,
	user_identifier_val  STRING  ,
	entry_dttm           TIMESTAMP  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_identity_type
(
	identity_type_cd     STRING NOT NULL ,
	identity_type_desc   STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_occurrence_detail
(
	occurrence_id        STRING NOT NULL ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	occurrence_no        INT64  ,
	occurrence_type_cd   STRING  ,
	occurrence_object_id STRING  ,
	occurrence_object_type_cd STRING  ,
	source_system_cd     STRING  ,
	execution_status_cd  STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_response_channel
(
	response_channel_cd  STRING NOT NULL ,
	response_channel_nm  STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_response_history
(
	response_id          STRING NOT NULL ,
	response_cd          STRING  ,
	response_dt          DATE  ,
	response_dttm        TIMESTAMP  ,
	external_contact_info_1_id STRING  ,
	external_contact_info_2_id STRING  ,
	response_type_cd     STRING  ,
	response_channel_cd  STRING  ,
	conversion_flg       STRING  ,
	inferred_response_flg STRING  ,
	content_id           STRING  ,
	identity_id          STRING  ,
	rtc_id               STRING NOT NULL ,
	content_version_id   STRING  ,
	response_val_amt     NUMERIC  ,
	source_system_cd     STRING  ,
	contact_id           STRING  ,
	content_hash_val     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_response_extended_attr
(
	response_id          STRING NOT NULL ,
	response_attribute_type_cd STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	attribute_data_type_cd STRING  ,
	attribute_val        STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_response_lookup
(
	response_cd          STRING NOT NULL ,
	response_nm          STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_response_type
(
	response_type_cd     STRING NOT NULL ,
	response_type_desc   STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_task_detail
(
	task_version_id      STRING NOT NULL ,
	task_id              STRING  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	task_nm              STRING  ,
	task_desc            STRING  ,
	task_type_nm         STRING  ,
	task_status_cd       STRING  ,
	task_subtype_nm      STRING  ,
	task_cd              STRING  ,
	task_delivery_type_nm STRING  ,
	active_flg           STRING  ,
	saved_flg            STRING  ,
	published_flg        STRING  ,
	owner_nm             STRING  ,
	modified_status_cd   STRING  ,
	created_user_nm      STRING  ,
	created_dt           DATE  ,
	scheduled_start_dttm TIMESTAMP  ,
	scheduled_end_dttm   TIMESTAMP  ,
	scheduled_flg        STRING  ,
	maximum_period_expression_cnt INT64  ,
	limit_period_unit_cnt INT64  ,
	limit_by_total_impression_flg STRING  ,
	export_dttm          TIMESTAMP  ,
	update_contact_history_flg STRING  ,
	subject_type_nm      STRING  ,
	min_budget_offer_amt NUMERIC  ,
	max_budget_offer_amt NUMERIC  ,
	min_budget_amt       NUMERIC  ,
	max_budget_amt       NUMERIC  ,
	budget_unit_cost_amt NUMERIC  ,
	recurr_type_cd       STRING  ,
	budget_unit_usage_amt NUMERIC  ,
	standard_reply_flg   STRING  ,
	staged_flg           STRING  ,
	contact_channel_cd   STRING  ,
	campaign_id          STRING  ,
	business_context_id  STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	recurring_schedule_flg STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_task_custom_attr
(
	task_version_id      STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	extension_attribute_nm STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	task_id              STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_activity_x_task
(
	activity_version_id  STRING NOT NULL ,
	task_version_id      STRING NOT NULL ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	activity_id          STRING  ,
	task_id              STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_rtc_detail
(
	rtc_id               STRING NOT NULL ,
	task_occurrence_no   INT64  ,
	processed_dttm       TIMESTAMP NOT NULL ,
	response_tracking_flg STRING  ,
	segment_version_id   STRING  ,
	task_version_id      STRING NOT NULL ,
	execution_status_cd  STRING  ,
	deleted_flg          STRING  ,
	occurrence_id        STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	segment_id           STRING  ,
	task_id              STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_rtc_x_content
(
	rtc_x_content_sk     STRING NOT NULL ,
	rtc_id               STRING NOT NULL ,
	content_version_id   STRING NOT NULL ,
	content_hash_val     STRING  ,
	sequence_no          INT64  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	content_id           STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_detail
(
	segment_version_id   STRING NOT NULL ,
	segment_id           STRING  ,
	segment_map_version_id STRING  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	segment_nm           STRING  ,
	segment_desc         STRING  ,
	segment_category_nm  STRING  ,
	segment_cd           STRING  ,
	segment_src_nm       STRING  ,
	segment_status_cd    STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	segment_map_id       STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_custom_attr
(
	segment_version_id   STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	segment_id           STRING  
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_map
(
	segment_map_version_id STRING NOT NULL ,
	segment_map_id       STRING  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	segment_map_nm       STRING  ,
	segment_map_desc     STRING  ,
	segment_map_category_nm STRING  ,
	segment_map_cd       STRING  ,
	segment_map_src_nm   STRING  ,
	segment_map_status_cd STRING  ,
	source_system_cd     STRING  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  
)) BY SASIOGBQ;

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
TIMESTAMP('9999-12-31 00:00:00'),
'_NO SEGMENT MAP',
'_NO SEGMENT MAP',
'',
'',
'',
'',
'360',
'CDM2.0',
current_timestamp
)) BY SASIOGBQ;

EXECUTE (CREATE TABLE &SCHEMA..cdm_segment_map_custom_attr
(
	segment_map_version_id STRING NOT NULL ,
	attribute_nm         STRING NOT NULL ,
	attribute_data_type_cd STRING NOT NULL ,
	attribute_val        STRING NOT NULL ,
	attribute_character_val STRING  ,
	attribute_numeric_val NUMERIC  ,
	attribute_dttm_val   TIMESTAMP  ,
	updated_by_nm        STRING  ,
	updated_dttm         TIMESTAMP  ,
	segment_map_id       STRING  
)) BY SASIOGBQ;

DISCONNECT FROM SASIOGBQ;
QUIT;


