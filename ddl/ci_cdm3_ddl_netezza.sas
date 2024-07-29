/*======================================================================*/
/* Enter Customer Specific Target Source Connection Values - Netezza    */
/*======================================================================*/

%let user = <user>;              /* Netezza User            */
%let pass  = <password>;         /* Netezza Password        */
%let db  = <database>;           /* Netezza Database        */
%let server = <server>;          /* Netezza Server          */

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
/*                                                                  */
/*  Note:  This code creates the CI360 Common Data Model 3.0        */
/*         tables and constraints.                                  */
/*                                                                  */
/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

PROC SQL NOERRORSTOP;

CONNECT TO NETEZZA (USER=&USER PASS=&PASS DB=&DB SERVER=&SERVER);

EXECUTE (CREATE TABLE cdm_activity_detail
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	activity_id          VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	status_cd            VARCHAR(20)  ,
	activity_nm          VARCHAR(256)  ,
	activity_desc        VARCHAR(1500)  ,
	activity_cd          VARCHAR(60)  ,
	activity_category_nm VARCHAR(100)  ,
	last_published_dttm  TIMESTAMP  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (activity_version_id)
) 
BY NETEZZA;

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
	activity_id          VARCHAR(36)  
)
DISTRIBUTE ON (activity_version_id)
) 
BY NETEZZA;

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

EXECUTE (CREATE TABLE cdm_business_context
(
	business_context_id  VARCHAR(36) NOT NULL ,
	business_context_nm  VARCHAR(256)  ,
	business_context_type_cd VARCHAR(40)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (business_context_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_campaign_detail
(
	campaign_id          VARCHAR(36) NOT NULL ,
	campaign_version_no  NUMERIC(6)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	campaign_nm          VARCHAR(60)  ,
	campaign_desc        VARCHAR(1500)  ,
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
	campaign_group_sk    NUMERIC(15)  ,
	deployment_version_no NUMERIC(6)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (External Campaign ID)
) 
BY NETEZZA;

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
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (External Campaign ID)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_contact_channel
(
	contact_channel_cd   VARCHAR(60) NOT NULL ,
	contact_channel_nm   VARCHAR(40)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (contact_channel_cd)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_identity_map
(
	identity_id          VARCHAR(36) NOT NULL ,
	identity_type_cd     VARCHAR(40)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (Identity ID)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_identity_attr
(
	identity_id          VARCHAR(36) NOT NULL ,
	identifier_type_id   VARCHAR(36) NOT NULL ,
	valid_from_dttm      TIMESTAMP  ,
	valid_to_dttm        TIMESTAMP  ,
	user_identifier_val  VARCHAR(4000)  ,
	entry_dttm           TIMESTAMP  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (Identity ID)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_contact_history
(
	contact_id           VARCHAR(36) NOT NULL ,
	identity_id          VARCHAR(36) NOT NULL ,
	contact_nm           VARCHAR(256)  ,
	contact_dt           TIMESTAMP  ,
	contact_dttm         TIMESTAMP  ,
	contact_dttm_tz      TIMESTAMP  ,
	contact_status_cd    VARCHAR(3)  ,
	optimization_backfill_flg CHAR(1)  ,
	external_contact_info_1_id VARCHAR(32)  ,
	external_contact_info_2_id VARCHAR(32)  ,
	rtc_id               VARCHAR(36)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
	control_group_flg    CHAR(1)  ,
	audience_id          VARCHAR(36)  ,
	audience_occur_id    VARCHAR(36)  ,
	context_type_nm      VARCHAR(256)  ,
	context_val          VARCHAR(256)  
)
DISTRIBUTE ON (contact_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_contact_status
(
	contact_status_cd    VARCHAR(3) NOT NULL ,
	contact_status_desc  VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (Contact Status Code)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_content_detail
(
	content_version_id   VARCHAR(40) NOT NULL ,
	content_id           VARCHAR(40)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	contact_content_nm   VARCHAR(256)  ,
	contact_content_desc VARCHAR(1500)  ,
	contact_content_type_nm VARCHAR(50)  ,
	contact_content_status_cd VARCHAR(60)  ,
	contact_content_category_nm VARCHAR(256)  ,
	contact_content_class_nm VARCHAR(100)  ,
	contact_content_cd   VARCHAR(60)  ,
	active_flg           CHAR(1)  ,
	owner_nm             VARCHAR(256)  ,
	created_user_nm      VARCHAR(256)  ,
	created_dt           TIMESTAMP  ,
	external_reference_txt VARCHAR(1024)  ,
	external_reference_url_txt VARCHAR(1024)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (content_version_id)
) 
BY NETEZZA;

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
	content_id           VARCHAR(40)  
)
DISTRIBUTE ON (content_version_id)
) 
BY NETEZZA;

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
	content_id           VARCHAR(40)  
)
DISTRIBUTE ON (content_version_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_identifier_type
(
	identifier_type_id   VARCHAR(36) NOT NULL ,
	identifier_type_desc VARCHAR(100)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (ID Type Code)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_identity_type
(
	identity_type_cd     VARCHAR(40) NOT NULL ,
	identity_type_desc   VARCHAR(100)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (Identity Type Code)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_occurrence_detail
(
	occurrence_id        VARCHAR(36) NOT NULL ,
	start_dttm           TIMESTAMP  ,
	end_dttm             TIMESTAMP  ,
	occurrence_no        INTEGER  ,
	occurrence_type_cd   VARCHAR(30)  ,
	occurrence_object_id VARCHAR(36)  ,
	occurrence_object_type_cd VARCHAR(60)  ,
	source_system_cd     VARCHAR(10)  ,
	execution_status_cd  VARCHAR(30)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (occurrence_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_response_channel
(
	response_channel_cd  VARCHAR(40) NOT NULL ,
	response_channel_nm  VARCHAR(60)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (response_channel_nm)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_response_history
(
	response_id          VARCHAR(36) NOT NULL ,
	response_cd          VARCHAR(256)  ,
	response_dt          TIMESTAMP  ,
	response_dttm        TIMESTAMP  ,
	response_dttm_tz     TIMESTAMP  ,
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
	updated_dttm         TIMESTAMP  ,
	properties_map_doc   VARCHAR(4000)  ,
	audience_id          VARCHAR(36)  ,
	audience_occur_id    VARCHAR(36)  ,
	context_type_nm      VARCHAR(256)  ,
	context_val          VARCHAR(256)  
)
DISTRIBUTE ON (response_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_response_extended_attr
(
	response_id          VARCHAR(36) NOT NULL ,
	response_attribute_type_cd VARCHAR(10) NOT NULL ,
	attribute_nm         VARCHAR(256) NOT NULL ,
	attribute_data_type_cd VARCHAR(30)  ,
	attribute_val        VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (response_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_response_lookup
(
	response_cd          VARCHAR(256) NOT NULL ,
	response_nm          VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (response_cd)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_response_type
(
	response_type_cd     VARCHAR(60) NOT NULL ,
	response_type_desc   VARCHAR(256)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (response_type_cd)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_segment_test
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	test_nm              VARCHAR(65)  ,
	test_type_nm         VARCHAR(10)  ,
	test_enabled_flg     CHAR(1)  ,
	test_sizing_type_nm  VARCHAR(65)  ,
	test_cnt             INTEGER  ,
	test_pct             NUMERIC(5,2)  ,
	stratified_sampling_flg CHAR(1)  ,
	stratified_samp_criteria_txt VARCHAR(1024)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (test_cd)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_segment_test_x_segment
(
	test_cd              VARCHAR(60) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (test_cd)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_task_detail
(
	task_version_id      VARCHAR(36) NOT NULL ,
	task_id              VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	task_nm              VARCHAR(256)  ,
	task_desc            VARCHAR(1500)  ,
	task_type_nm         VARCHAR(40)  ,
	task_status_cd       VARCHAR(20)  ,
	task_subtype_nm      VARCHAR(100)  ,
	task_cd              VARCHAR(60)  ,
	task_delivery_type_nm VARCHAR(60)  ,
	active_flg           CHAR(1)  ,
	saved_flg            CHAR(1)  ,
	published_flg        CHAR(1)  ,
	owner_nm             VARCHAR(256)  ,
	modified_status_cd   VARCHAR(20)  ,
	created_user_nm      VARCHAR(256)  ,
	created_dt           TIMESTAMP  ,
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
	recurring_schedule_flg CHAR(1)  ,
	segment_tests_flg    CHAR(1)  ,
	control_group_action_nm VARCHAR(65)  ,
	stratified_sampling_action_nm VARCHAR(65)  
)
DISTRIBUTE ON (task_version_id)
) 
BY NETEZZA;

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
	task_id              VARCHAR(36)  
)
DISTRIBUTE ON (task_version_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_activity_x_task
(
	activity_version_id  VARCHAR(36) NOT NULL ,
	task_version_id      VARCHAR(36) NOT NULL ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
	activity_id          VARCHAR(36)  ,
	task_id              VARCHAR(36)  
)
DISTRIBUTE ON (activity_version_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_rtc_detail
(
	rtc_id               VARCHAR(36) NOT NULL ,
	task_occurrence_no   INTEGER  ,
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
	segment_id           VARCHAR(36)  ,
	task_id              VARCHAR(36)  
)
DISTRIBUTE ON (rtc_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_rtc_x_content
(
	rtc_x_content_sk     VARCHAR(36) NOT NULL ,
	rtc_id               VARCHAR(36) NOT NULL ,
	content_version_id   VARCHAR(40) NOT NULL ,
	content_hash_val     VARCHAR(32)  ,
	sequence_no          INTEGER  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
	content_id           VARCHAR(40)  
)
DISTRIBUTE ON (rtc_x_content_sk)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_segment_detail
(
	segment_version_id   VARCHAR(36) NOT NULL ,
	segment_id           VARCHAR(36)  ,
	segment_map_version_id VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	segment_nm           VARCHAR(256)  ,
	segment_desc         VARCHAR(1500)  ,
	segment_category_nm  VARCHAR(100)  ,
	segment_cd           VARCHAR(60)  ,
	segment_src_nm       VARCHAR(40)  ,
	segment_status_cd    VARCHAR(20)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  ,
	segment_map_id       VARCHAR(36)  
)
DISTRIBUTE ON (segment_version_id)
) 
BY NETEZZA;

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
	segment_id           VARCHAR(36)  
)
DISTRIBUTE ON (segment_version_id)
) 
BY NETEZZA;

EXECUTE (CREATE TABLE cdm_segment_map
(
	segment_map_version_id VARCHAR(36) NOT NULL ,
	segment_map_id       VARCHAR(36)  ,
	valid_from_dttm      TIMESTAMP NOT NULL ,
	valid_to_dttm        TIMESTAMP  ,
	segment_map_nm       VARCHAR(256)  ,
	segment_map_desc     VARCHAR(1500)  ,
	segment_map_category_nm VARCHAR(100)  ,
	segment_map_cd       VARCHAR(60)  ,
	segment_map_src_nm   VARCHAR(40)  ,
	segment_map_status_cd VARCHAR(20)  ,
	source_system_cd     VARCHAR(10)  ,
	updated_by_nm        VARCHAR(60)  ,
	updated_dttm         TIMESTAMP  
)
DISTRIBUTE ON (segment_map_version_id)
) 
BY NETEZZA;

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
	segment_map_id       VARCHAR(36)  
)
DISTRIBUTE ON (segment_map_version_id)
) 
BY NETEZZA;

DISCONNECT FROM NETEZZA;
QUIT;

