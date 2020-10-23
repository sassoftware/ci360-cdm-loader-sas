/*---------------------------------------------------------------------------------------
 *  Copyright (c) 2005-2020, SAS Institute Inc., Cary, NC, USA, All Rights Reserved
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_load_datastep.sas
 *  Purpose:    Load records from the CDM data sets into the on-prem database
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module loads data from the CDM SAS data sets into the database using a SAS data step
 *---------------------------------------------------------------------------------------*/

%macro ErrorCheck(tablename);
    %if &syserr. > 4 %then %do;
        %let rc = 1;
        %let CDM_ErrMsg = Unable to load CDM table &tablename;
        %put %sysfunc(datetime(),E8601DT25.) --- ERROR:  &syserrortext;
    %end;
%mend;

%macro cdm_load_datastep;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Beginning process of loading CDM data into database;
    %put %sysfunc(datetime(),E8601DT25.) --- Updated time for these transactions is &CurrentDateTime;

    %let rc = 0;

/*
 *  For each SAS data set in the CDM make sure it exists in the CDM Mart.  If present, use a SAS data step
 *  to modify the existing database, either updating or adding observations based on the primary key.
 */

    %if %sysfunc(exist(cdmmart.cdm_activity_detail)) and %index(&CDM_TableList,CDM_ACTIVITY_DETAIL) %then %do;

            data dblib.cdm_activity_detail;
                retain uobs oobs;
                set cdmmart.cdm_activity_detail
                    (rename=(activity_id=activity_id_tmp
                             valid_from_dttm=valid_from_dttm_tmp
                             valid_to_dttm=valid_to_dttm_tmp
                             status_cd=status_cd_tmp
                             activity_nm=activity_nm_tmp
                             activity_desc=activity_desc_tmp
                             activity_cd=activity_cd_tmp
                             activity_category_nm=activity_category_nm_tmp
                             last_published_dttm=last_published_dttm_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_activity_detail
                    (cntllev=rec dbkey=activity_version_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    activity_id=activity_id_tmp;
                    valid_from_dttm=valid_from_dttm_tmp;
                    valid_to_dttm=valid_to_dttm_tmp;
                    status_cd=status_cd_tmp;
                    activity_nm=activity_nm_tmp;
                    activity_desc=activity_desc_tmp;
                    activity_cd=activity_cd_tmp;
                    activity_category_nm=activity_category_nm_tmp;
                    last_published_dttm=last_published_dttm_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_ACTIVITY_DETAIL;

            %ErrorCheck(CDM_ACTIVITY_DETAIL);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_activity_custom_attr)) and %index(&CDM_TableList,CDM_ACTIVITY_CUSTOM_ATTR) %then %do;

            data dblib.cdm_activity_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_activity_custom_attr
                    (rename=(attribute_character_val=attribute_character_val_tmp
                             attribute_numeric_val=attribute_numeric_val_tmp
                             attribute_dttm_val=attribute_dttm_val_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_activity_custom_attr
                    (cntllev=rec dbkey=(activity_version_id attribute_nm attribute_data_type_cd attribute_val)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_ACTIVITY_CUSTOM_ATTR;

            %ErrorCheck(CDM_ACTIVITY_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_business_context)) and %index(&CDM_TableList,CDM_BUSINESS_CONTEXT) %then %do;

            data dblib.cdm_business_context;
                retain uobs oobs;
                set cdmmart.cdm_business_context
                    (rename=(business_context_nm=business_context_nm_tmp
                             business_context_type_cd=business_context_type_cd_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_business_context
                    (cntllev=rec dbkey=(business_context_id)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    business_context_nm = business_context_nm_tmp;
                    business_context_type_cd = business_context_type_cd_tmp;
                    source_system_cd = source_system_cd_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

                %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_BUSINESS_CONTEXT;

            %ErrorCheck(CDM_BUSINESS_CONTEXT);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_contact_channel)) and %index(&CDM_TableList,CDM_CONTACT_CHANNEL) %then %do;

            data dblib.cdm_contact_channel;
                retain uobs oobs;
                set cdmmart.cdm_contact_channel
                    (rename=(contact_channel_nm=contact_channel_nm_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_contact_channel
                    (cntllev=rec dbkey=(contact_channel_cd)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    contact_channel_nm = contact_channel_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CONTACT_CHANNEL;

            %ErrorCheck(CDM_CONTACT_CHANNEL);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_map)) and %index(&CDM_TableList,CDM_SEGMENT_MAP) %then %do;

            data dblib.cdm_segment_map;
                retain uobs oobs;
                set cdmmart.cdm_segment_map
                    (rename=(segment_map_id=segment_map_id_tmp
                             valid_from_dttm=valid_from_dttm_tmp
                             valid_to_dttm=valid_to_dttm_tmp
                             segment_map_nm=segment_map_nm_tmp
                             segment_map_desc=segment_map_desc_tmp
                             segment_map_category_nm=segment_map_category_nm_tmp
                             segment_map_cd=segment_map_cd_tmp
                             segment_map_src_nm=segment_map_src_nm_tmp
                             segment_map_status_cd=segment_map_status_cd_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_segment_map
                    (cntllev=rec dbkey=(segment_map_version_id)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    segment_map_id=segment_map_id_tmp;
                    valid_from_dttm=valid_from_dttm_tmp;
                    valid_to_dttm=valid_to_dttm_tmp;
                    segment_map_nm=segment_map_nm_tmp;
                    segment_map_desc=segment_map_desc_tmp;
                    segment_map_category_nm=segment_map_category_nm_tmp;
                    segment_map_cd=segment_map_cd_tmp;
                    segment_map_src_nm=segment_map_src_nm_tmp;
                    segment_map_status_cd=segment_map_status_cd_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_SEGMENT_MAP;

            %ErrorCheck(CDM_SEGMENT_MAP);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_map_custom_attr)) and %index(&CDM_TableList,CDM_SEGMENT_MAP_CUSTOM_ATTR) %then %do;

            data dblib.cdm_segment_map_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_segment_map_custom_attr
                    (rename=(attribute_character_val=attribute_character_val_tmp
                             attribute_numeric_val=attribute_numeric_val_tmp
                             attribute_dttm_val=attribute_dttm_val_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_segment_map_custom_attr
                    (cntllev=rec dbkey=(segment_map_version_id attribute_nm attribute_data_type_cd attribute_val)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_SEGMENT_MAP_CUSTOM_ATTR;

            %ErrorCheck(CDM_SEGMENT_MAP_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_occurrence_detail)) and %index(&CDM_TableList,CDM_OCCURRENCE_DETAIL) %then %do;

            data dblib.cdm_occurrence_detail;
                retain uobs oobs;
                set cdmmart.cdm_occurrence_detail
                    (rename=(start_dttm=start_dttm_tmp
                             end_dttm=end_dttm_tmp
                             occurrence_no=occurrence_no_tmp
                             occurrence_type_cd=occurrence_type_cd_tmp
                             occurrence_object_id=occurrence_object_id_tmp
                             occurrence_object_type_cd=occurrence_object_type_cd_tmp
                             source_system_cd=source_system_cd_tmp
                             execution_status_cd=execution_status_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_occurrence_detail
                    (cntllev=rec dbkey=occurrence_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    start_dttm=start_dttm_tmp;
                    end_dttm=end_dttm_tmp;
                    occurrence_no=occurrence_no_tmp;
                    occurrence_type_cd=occurrence_type_cd_tmp;
                    occurrence_object_id=occurrence_object_id_tmp;
                    occurrence_object_type_cd=occurrence_object_type_cd_tmp;
                    source_system_cd=source_system_cd_tmp;
                    execution_status_cd=execution_status_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_OCCURRENCE_DETAIL;

            %ErrorCheck(CDM_OCCURRENCE_DETAIL);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_detail)) and %index(&CDM_TableList,CDM_SEGMENT_DETAIL) %then %do;

            data dblib.cdm_segment_detail;
                retain uobs oobs;
                set cdmmart.cdm_segment_detail
                    (rename=(segment_id=segment_id_tmp
                             segment_map_version_id=segment_map_version_id_tmp
                             valid_from_dttm=valid_from_dttm_tmp
                             valid_to_dttm=valid_to_dttm_tmp
                             segment_nm=segment_nm_tmp
                             segment_desc=segment_desc_tmp
                             segment_category_nm=segment_category_nm_tmp
                             segment_cd=segment_cd_tmp
                             segment_src_nm=segment_src_nm_tmp
                             segment_status_cd=segment_status_cd_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_segment_detail
                    (cntllev=rec dbkey=segment_version_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    segment_id=segment_id_tmp;
                    segment_map_version_id=segment_map_version_id_tmp;
                    valid_from_dttm=valid_from_dttm_tmp;
                    valid_to_dttm=valid_to_dttm_tmp;
                    segment_nm=segment_nm_tmp;
                    segment_desc=segment_desc_tmp;
                    segment_category_nm=segment_category_nm_tmp;
                    segment_cd=segment_cd_tmp;
                    segment_src_nm=segment_src_nm_tmp;
                    segment_status_cd=segment_status_cd_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_SEGMENT_DETAIL;

            %ErrorCheck(CDM_SEGMENT_DETAIL);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_task_detail)) and %index(&CDM_TableList,CDM_TASK_DETAIL)%then %do;

            data dblib.cdm_task_detail;
                retain uobs oobs;
                set cdmmart.cdm_task_detail
                    (rename=(task_id = task_id_tmp
                             valid_from_dttm = valid_from_dttm_tmp
                             valid_to_dttm = valid_to_dttm_tmp
                             task_nm = task_nm_tmp
                             task_desc = task_desc_tmp
                             task_type_nm = task_type_nm_tmp
                             task_status_cd = task_status_cd_tmp
                             task_subtype_nm = task_subtype_nm_tmp
                             task_cd = task_cd_tmp
                             task_delivery_type_nm = task_delivery_type_nm_tmp
                             active_flg = active_flg_tmp
                             saved_flg = saved_flg_tmp
                             published_flg = published_flg_tmp
                             owner_nm = owner_nm_tmp
                             modified_status_cd = modified_status_cd_tmp
                             created_user_nm = created_user_nm_tmp
                             created_dt = created_dt_tmp
                             scheduled_start_dttm = scheduled_start_dttm_tmp
                             scheduled_end_dttm = scheduled_end_dttm_tmp
                             scheduled_flg = scheduled_flg_tmp
                             maximum_period_expression_cnt = max_period_expression_cnt_tmp
                             limit_period_unit_cnt = limit_period_unit_cnt_tmp
                             limit_by_total_impression_flg = limit_by_tot_impression_flg_tmp
                             export_dttm = export_dttm_tmp
                             update_contact_history_flg = update_contact_history_flg_tmp
                             subject_type_nm = subject_type_nm_tmp
                             min_budget_offer_amt = min_budget_offer_amt_tmp
                             max_budget_offer_amt = max_budget_offer_amt_tmp
                             min_budget_amt = min_budget_amt_tmp
                             max_budget_amt = max_budget_amt_tmp
                             budget_unit_cost_amt = budget_unit_cost_amt_tmp
                             recurr_type_cd = recurr_type_cd_tmp
                             budget_unit_usage_amt = budget_unit_usage_amt_tmp
                             standard_reply_flg = standard_reply_flg_tmp
                             staged_flg = staged_flg_tmp
                             contact_channel_cd = contact_channel_cd_tmp
                             campaign_id = campaign_id_tmp
                             business_context_id = business_context_id_tmp
                             source_system_cd = source_system_cd_tmp
                             updated_by_nm = updated_by_nm_tmp
                             updated_dttm = updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_task_detail
                    (cntllev=rec dbkey=task_version_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    task_id = task_id_tmp;
                    valid_from_dttm = valid_from_dttm_tmp;
                    valid_to_dttm = valid_to_dttm_tmp;
                    task_nm = task_nm_tmp;
                    task_desc = task_desc_tmp;
                    task_type_nm = task_type_nm_tmp;
                    task_status_cd = task_status_cd_tmp;
                    task_subtype_nm = task_subtype_nm_tmp;
                    task_cd = task_cd_tmp;
                    task_delivery_type_nm = task_delivery_type_nm_tmp;
                    active_flg = active_flg_tmp;
                    saved_flg = saved_flg_tmp;
                    published_flg = published_flg_tmp;
                    owner_nm = owner_nm_tmp;
                    modified_status_cd = modified_status_cd_tmp;
                    created_user_nm = created_user_nm_tmp;
                    created_dt = created_dt_tmp;
                    scheduled_start_dttm = scheduled_start_dttm_tmp;
                    scheduled_end_dttm = scheduled_end_dttm_tmp;
                    scheduled_flg = scheduled_flg_tmp;
                    maximum_period_expression_cnt = max_period_expression_cnt_tmp;
                    limit_period_unit_cnt = limit_period_unit_cnt_tmp;
                    limit_by_total_impression_flg = limit_by_tot_impression_flg_tmp;
                    export_dttm = export_dttm_tmp;
                    update_contact_history_flg = update_contact_history_flg_tmp;
                    subject_type_nm = subject_type_nm_tmp;
                    min_budget_offer_amt = min_budget_offer_amt_tmp;
                    max_budget_offer_amt = max_budget_offer_amt_tmp;
                    min_budget_amt = min_budget_amt_tmp;
                    max_budget_amt = max_budget_amt_tmp;
                    budget_unit_cost_amt = budget_unit_cost_amt_tmp;
                    recurr_type_cd = recurr_type_cd_tmp;
                    budget_unit_usage_amt = budget_unit_usage_amt_tmp;
                    standard_reply_flg = standard_reply_flg_tmp;
                    staged_flg = staged_flg_tmp;
                    contact_channel_cd = contact_channel_cd_tmp;
                    campaign_id = campaign_id_tmp;
                    business_context_id = business_context_id_tmp;
                    source_system_cd = source_system_cd_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_TASK_DETAIL;

            %ErrorCheck(CDM_TASK_DETAIL);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_rtc_detail)) and %index(&CDM_TableList,CDM_RTC_DETAIL) %then %do;

            data dblib.cdm_rtc_detail;
                retain uobs oobs;
                set cdmmart.cdm_rtc_detail
                    (rename=(task_occurrence_no=task_occurrence_no_tmp
                             processed_dttm=processed_dttm_tmp
                             response_tracking_flg=response_tracking_flg_tmp
                             segment_version_id=segment_version_id_tmp
                             task_version_id=task_version_id_tmp
                             execution_status_cd=sexecution_status_cd_tmp
                             deleted_flg=deleted_flg_tmp
                             occurrence_id=occurrence_id_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp)
                             where=(segment_version_id_tmp ne "" and task_version_id_tmp ne ""));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_rtc_detail
                    (cntllev=rec dbkey=rtc_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    task_occurrence_no=task_occurrence_no_tmp;
                    processed_dttm=processed_dttm_tmp;
                    response_tracking_flg=response_tracking_flg_tmp;
                    segment_version_id=segment_version_id_tmp;
                    task_version_id=task_version_id_tmp;
                    execution_status_cd=sexecution_status_cd_tmp;
                    deleted_flg=deleted_flg_tmp;
                    occurrence_id=occurrence_id_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_RTC_DETAIL;

            %ErrorCheck(CDM_RTC_DETAIL);
            %if &rc %then %goto ERREXIT;

    %end;


/*
 *  This table is not available yet.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_identity_type)) and %index(&CDM_TableList,CDM_IDENTITY_TYPE) %then %do;

            data dblib.cdm_identity_type;
                retain uobs oobs;
                set cdmmart.cdm_identity_type
                    (rename=(identity_type_desc=identity_type_desc_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_identity_type
                    (cntllev=rec dbkey=identity_type_cd) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    identity_type_desc=identity_type_desc_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_IDENTITY_TYPE;

            %ErrorCheck(CDM_IDENTITY_TYPE);
            %if &rc %then %goto ERREXIT;

    %end;
*/


    %if %sysfunc(exist(cdmmart.cdm_identity_map)) and %index(&CDM_TableList,CDM_IDENTITY_MAP) %then %do;

            data dblib.cdm_identity_map;
                retain uobs oobs;
                set cdmmart.cdm_identity_map
                    (rename=(identity_type_cd=identity_type_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_identity_map
                    (cntllev=rec dbkey=identity_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    identity_type_cd=identity_type_cd;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_IDENTITY_MAP;

            %ErrorCheck(CDM_IDENTITY_MAP);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_contact_history)) %then %do;

            data dblib.cdm_contact_history;
                retain uobs oobs;
                set cdmmart.cdm_contact_history
                    (rename=(identity_id=identity_id_tmp
                             contact_nm=contact_nm_tmp
                             contact_dt=contact_dt_tmp
                             contact_dttm=contact_dttm_tmp
                             contact_status_cd=contact_status_cd_tmp
                             optimization_backfill_flg=optimization_backfill_flg_tmp
                             external_contact_info_1_id=external_contact_info_1_id_tmp
                             external_contact_info_2_id=external_contact_info_2_id_tmp
                             rtc_id=rtc_id_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp)
                     where=(updated_dttm_tmp ge &CDM_UDMFirstEventDate));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_contact_history
                    (cntllev=rec dbkey=contact_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    identity_id=identity_id_tmp;
                    contact_nm=contact_nm_tmp;
                    contact_dt=contact_dt_tmp;
                    contact_dttm=contact_dttm_tmp;
                    contact_status_cd=contact_status_cd_tmp;
                    optimization_backfill_flg=optimization_backfill_flg_tmp;
                    external_contact_info_1_id=external_contact_info_1_id_tmp;
                    external_contact_info_2_id=external_contact_info_2_id_tmp;
                    rtc_id=rtc_id_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CONTACT_HISTORY;

            %ErrorCheck(CDM_CONTACT_HISTORY);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_content_detail)) and %index(&CDM_TableList,CDM_CONTENT_DETAIL) %then %do;

            data dblib.cdm_content_detail;
                retain uobs oobs;
                set cdmmart.cdm_content_detail
                    (rename=(content_id=content_id_tmp
                             valid_from_dttm=valid_from_dttm_tmp
                             valid_to_dttm=valid_to_dttm_tmp
                             contact_content_nm=contact_content_nm_tmp
                             contact_content_desc=contact_content_desc_tmp
                             contact_content_type_nm=contact_content_type_nm_tmp
                             contact_content_status_cd=contact_content_status_cd_tmp
                             contact_content_category_nm=contact_content_category_nm_tmp
                             contact_content_class_nm=contact_content_class_nm_tmp
                             contact_content_cd=contact_content_cd_tmp
                             active_flg=active_flg_tmp
                             owner_nm=owner_nm_tmp
                             created_user_nm=created_user_nm_tmp
                             created_dt=created_dt_tmp
                             external_reference_txt=external_reference_txt_tmp
                             external_reference_url_txt=external_reference_url_txt_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_content_detail
                    (cntllev=rec dbkey=content_version_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    content_id=content_id_tmp;
                    valid_from_dttm=valid_from_dttm_tmp;
                    valid_to_dttm=valid_to_dttm_tmp;
                    contact_content_nm=contact_content_nm_tmp;
                    contact_content_desc=contact_content_desc_tmp;
                    contact_content_type_nm=contact_content_type_nm_tmp;
                    contact_content_status_cd=contact_content_status_cd_tmp;
                    contact_content_category_nm=contact_content_category_nm_tmp;
                    contact_content_class_nm=contact_content_class_nm_tmp;
                    contact_content_cd=contact_content_cd_tmp;
                    active_flg=active_flg_tmp;
                    owner_nm=owner_nm_tmp;
                    created_user_nm=created_user_nm_tmp;
                    created_dt=created_dt_tmp;
                    external_reference_txt=external_reference_txt_tmp;
                    external_reference_url_txt=external_reference_url_txt_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CONTENT_DETAIL;

            %ErrorCheck(CDM_CONTENT_DETAIL);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_content_custom_attr)) and %index(&CDM_TableList,CDM_CONTENT_CUSTOM_ATTR) %then %do;

            data dblib.cdm_content_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_content_custom_attr
                    (rename=(attribute_character_val=attribute_character_val_tmp
                             attribute_numeric_val=attribute_numeric_val_tmp
                             attribute_dttm_val=attribute_dttm_val_tmp
                             extension_attribute_nm=extension_attribute_nm_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_content_custom_attr
                    (cntllev=rec dbkey=(content_version_id attribute_nm attribute_data_type_cd attribute_val)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    extension_attribute_nm = extension_attribute_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CONTENT_CUSTOM_ATTR;

            %ErrorCheck(CDM_CONTENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_identifier_type)) and %index(&CDM_TableList,CDM_IDENTIFIER_TYPE) %then %do;

            data dblib.cdm_identifier_type;
                retain uobs oobs;
                set cdmmart.cdm_identifier_type
                    (rename=(identifier_type_desc=identifier_type_desc_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_identifier_type
                    (cntllev=rec dbkey=identifier_type_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    identifier_type_desc=identifier_type_desc_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_IDENTIFIER_TYPE;

            %ErrorCheck(CDM_IDENTIFIER_TYPE);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_identity_attr)) and %index(&CDM_TableList,CDM_IDENTITY_ATTR) %then %do;

            data dblib.cdm_identity_attr;
                retain uobs oobs;
                set cdmmart.cdm_identity_attr
                    (rename=(valid_to_dttm=valid_to_dttm_tmp
                             user_identifier_val=user_identifier_val_tmp
                             entry_dttm=entry_dttm_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_identity_attr
                    (cntllev=rec dbkey=(identity_id identifier_type_id valid_from_dttm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    valid_to_dttm=valid_to_dttm_tmp;
                    user_identifier_val=user_identifier_val_tmp;
                    entry_dttm=entry_dttm_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_IDENTITY_ATTR;

            %ErrorCheck(CDM_IDENTITY_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;

    %if %sysfunc(exist(cdmmart.cdm_response_channel)) and %index(&CDM_TableList,CDM_RESPONSE_CHANNEL) %then %do;

            data dblib.cdm_response_channel;
                retain uobs oobs;
                set cdmmart.cdm_response_channel
                    (rename=(response_channel_nm=response_channel_nm_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_response_channel
                    (cntllev=rec dbkey=response_channel_cd) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    response_channel_nm=response_channel_nm_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_RESPONSE_CHANNEL;

            %ErrorCheck(CDM_RESPONSE_CHANNEL);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_task_custom_attr))  and %index(&CDM_TableList,CDM_TASK_CUSTOM_ATTR)%then %do;

            data dblib.cdm_task_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_task_custom_attr
                    (rename=(attribute_character_val=attribute_character_val_tmp
                             attribute_numeric_val=attribute_numeric_val_tmp
                             attribute_dttm_val=attribute_dttm_val_tmp
                             extension_attribute_nm=extension_attribute_nm_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_task_custom_attr
                    (cntllev=rec dbkey=(task_version_id attribute_nm attribute_data_type_cd attribute_val)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    extension_attribute_nm = extension_attribute_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_TASK_CUSTOM_ATTR;

            %ErrorCheck(CDM_TASK_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_activity_x_task))  and %index(&CDM_TableList,CDM_ACTIVITY_X_TASK)%then %do;

            data dblib.cdm_activity_x_task;
                retain uobs oobs;
                set cdmmart.cdm_activity_x_task
                    (rename=(updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_activity_x_task
                    (cntllev=rec dbkey=(activity_version_id task_version_id)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_ACTIVITY_X_TASK;

            %ErrorCheck(CDM_ACTIVITY_X_TASK);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_rtc_x_content)) and %index(&CDM_TableList,CDM_RTC_X_CONTENT) %then %do;

            data dblib.cdm_rtc_x_content;
                retain uobs oobs;
                set cdmmart.cdm_rtc_x_content
                    (rename=(rtc_id=rtc_id_tmp
                             content_version_id=content_version_id_tmp
                             content_hash_val=content_hash_val_tmp
                             sequence_no=sequence_no_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp)
                             where=(content_version_id_tmp ne "" ));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_rtc_x_content
                    (cntllev=rec dbkey=(rtc_x_content_sk)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    rtc_id=rtc_id_tmp;
                    content_version_id=content_version_id_tmp;
                    content_hash_val=content_hash_val_tmp;
                    sequence_no=sequence_no_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_RTC_X_CONTENT;

            %ErrorCheck(CDM_RTC_X_CONTENT);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_segment_custom_attr)) and %index(&CDM_TableList,CDM_SEGMENT_CUSTOM_ATTR) %then %do;

            data dblib.cdm_segment_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_segment_custom_attr
                    (rename=(attribute_character_val=attribute_character_val_tmp
                             attribute_numeric_val=attribute_numeric_val_tmp
                             attribute_dttm_val=attribute_dttm_val_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_segment_custom_attr
                    (cntllev=rec dbkey=(segment_version_id attribute_nm attribute_data_type_cd attribute_val)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_SEGMENT_CUSTOM_ATTR;

            %ErrorCheck(CDM_SEGMENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_response_lookup))  and %index(&CDM_TableList,CDM_RESPONSE_LOOKUP) %then %do;

            data dblib.cdm_response_lookup;
                retain uobs oobs;
                set cdmmart.cdm_response_lookup
                    (rename=(response_nm=response_nm_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_response_lookup
                    (cntllev=rec dbkey=response_cd) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    response_nm=response_nm_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_RESPONSE_LOOKUP;

            %ErrorCheck(CDM_RESPONSE_LOOKUP);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_response_history)) %then %do;

            data dblib.cdm_response_history;
                retain uobs oobs;
                set cdmmart.cdm_response_history
                    (rename=(response_cd = response_cd_tmp
                             response_dt = response_dt_tmp
                             response_dttm = response_dttm_tmp
                             external_contact_info_1_id = external_contact_info_1_id_tmp
                             external_contact_info_2_id = external_contact_info_2_id_tmp
                             response_type_cd = response_type_cd_tmp
                             response_channel_cd = response_channel_cd_tmp
                             conversion_flg = conversion_flg_tmp
                             inferred_response_flg = inferred_response_flg_tmp
                             content_id = content_id_tmp
                             identity_id = identity_id_tmp
                             rtc_id = rtc_id_tmp
                             content_version_id = content_version_id_tmp
                             response_val_amt = response_val_amt_tmp
                             source_system_cd = source_system_cd_tmp
                             contact_id = contact_id_tmp
                             content_hash_val = content_hash_val_tmp
                             updated_by_nm = updated_by_nm_tmp
                             updated_dttm = updated_dttm_tmp)
                     where=(updated_dttm_tmp ge &CDM_UDMFirstEventDate));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_response_history
                    (cntllev=rec dbkey=(response_id)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    response_cd = response_cd_tmp;
                    response_dt = response_dt_tmp;
                    response_dttm = response_dttm_tmp;
                    external_contact_info_1_id = external_contact_info_1_id_tmp;
                    external_contact_info_2_id = external_contact_info_2_id_tmp;
                    response_type_cd = response_type_cd_tmp;
                    response_channel_cd = response_channel_cd_tmp;
                    conversion_flg = conversion_flg_tmp;
                    inferred_response_flg = inferred_response_flg_tmp;
                    content_id = content_id_tmp;
                    identity_id = identity_id_tmp;
                    rtc_id = rtc_id_tmp;
                    content_version_id = content_version_id_tmp;
                    response_val_amt = response_val_amt_tmp;
                    source_system_cd = source_system_cd_tmp;
                    contact_id = contact_id_tmp;
                    content_hash_val = content_hash_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to tablee CDM_RESPONSE_HISTORY;

            %ErrorCheck(CDM_RESPONSE_HISTORY);
            %if &rc %then %goto ERREXIT;

    %end;


    %if %sysfunc(exist(cdmmart.cdm_response_extended_attr)) %then %do;

            data dblib.cdm_response_extended_attr;
                retain uobs oobs;
                set cdmmart.cdm_response_extended_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_val=attribute_val_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp)
                     where=(updated_dttm_tmp ge &CDM_UDMFirstEventDate));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_response_extended_attr
                    (cntllev=rec dbkey=(response_id response_attribute_type_cd attribute_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_val = attribute_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = input("&CurrentDateTime", e8601dz24.3);

                    if _iorc_ eq %sysrc(_SOK) then do;
                        replace;
                        uobs = uobs + 1;
                        call symput('uobs',strip(uobs));
                    end;
                    else do;
                        output;
                        oobs = oobs + 1;
                        call symput('oobs',strip(oobs));
                    end;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_RESPONSE_EXTENDED_ATTR;

            %ErrorCheck(CDM_RESPONSE_EXTENDED_ATTR);
            %if &rc %then %goto ERREXIT;

    %end;

    %ERREXIT:

    %if &rc %then %do;
        %put %sysfunc(datetime(),E8601DT25.) --- &CDM_ErrMsg;
        %put %sysfunc(datetime(),E8601DT25.) --- Loading of CDM tables may be incomplete;
    %end;
    %else %do;
        %put %sysfunc(datetime(),E8601DT25.) --- Completed loading of CDM tables;
     %end;

%mend cdm_load_datastep;
