/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Name:         cdm_load.sas
 *  Description:  Load data from CDM data sets into 3rd party database
 *  Version:      2.0
 *  History:
 *---------------------------------------------------------------------------------------*/

%macro ErrorCheck(tablename);
    %if &syserr. > 4 %then %do;
        %let rc = 1;
        %let CDM_ErrMsg = Unable to load CDM table &tablename;
        %put %sysfunc(datetime(),E8601DT25.) --- ERROR:  &syserrortext;
    %end;
%mend;

%macro cdm_load;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Beginning process of loading CDM data into database;

    %let rc = 0;

    %if %sysfunc(exist(cdmmart.cdm_activity_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table activity_detail_tmp
                  ( activity_version_id  VARCHAR2(36) NOT NULL ,
                    activity_id          VARCHAR2(36) NULL ,
                    valid_from_dttm      TIMESTAMP NOT NULL ,
                    valid_to_dttm        TIMESTAMP NULL ,
                    status_cd            VARCHAR2(20) NULL ,
                    activity_nm          VARCHAR2(256) NULL ,
                    activity_desc        CLOB NULL ,
                    activity_cd          VARCHAR2(60) NULL ,
                    activity_category_nm VARCHAR2(100) NULL ,
                    last_published_dttm  TIMESTAMP NULL ,
                    source_system_cd     VARCHAR2(10) NULL ,
                    updated_by_nm        VARCHAR2(60) NULL ,
                    updated_dttm         TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table activity_detail_tmp
                    add constraint activity_detail_tmp_pk primary key (activity_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.activity_detail_tmp
                select *
                from cdmmart.cdm_activity_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_activity_detail using activity_detail_tmp
                        on (cdm_activity_detail.activity_version_id = activity_detail_tmp.activity_version_id)

                    when matched then update
                    set cdm_activity_detail.activity_id = activity_detail_tmp.activity_id,
                        cdm_activity_detail.valid_from_dttm = activity_detail_tmp.valid_from_dttm,
                        cdm_activity_detail.valid_to_dttm = activity_detail_tmp.valid_to_dttm,
                        cdm_activity_detail.status_cd = activity_detail_tmp.status_cd,
                        cdm_activity_detail.activity_nm = activity_detail_tmp.activity_nm,
                        cdm_activity_detail.activity_desc = activity_detail_tmp.activity_desc,
                        cdm_activity_detail.activity_cd = activity_detail_tmp.activity_cd,
                        cdm_activity_detail.activity_category_nm = activity_detail_tmp.activity_category_nm,
                        cdm_activity_detail.last_published_dttm = activity_detail_tmp.last_published_dttm,
                        cdm_activity_detail.source_system_cd = activity_detail_tmp.source_system_cd,
                        cdm_activity_detail.updated_by_nm = activity_detail_tmp.updated_by_nm,
                        cdm_activity_detail.updated_dttm = activity_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_activity_detail.activity_version_id,
                        cdm_activity_detail.activity_id,
                        cdm_activity_detail.valid_from_dttm,
                        cdm_activity_detail.valid_to_dttm,
                        cdm_activity_detail.status_cd,
                        cdm_activity_detail.activity_nm,
                        cdm_activity_detail.activity_desc,
                        cdm_activity_detail.activity_cd,
                        cdm_activity_detail.activity_category_nm,
                        cdm_activity_detail.last_published_dttm,
                        cdm_activity_detail.source_system_cd,
                        cdm_activity_detail.updated_by_nm,
                        cdm_activity_detail.updated_dttm
                      )
                    values
                      ( activity_detail_tmp.activity_version_id,
                        activity_detail_tmp.activity_id,
                        activity_detail_tmp.valid_from_dttm,
                        activity_detail_tmp.valid_to_dttm,
                        activity_detail_tmp.status_cd,
                        activity_detail_tmp.activity_nm,
                        activity_detail_tmp.activity_desc,
                        activity_detail_tmp.activity_cd,
                        activity_detail_tmp.activity_category_nm,
                        activity_detail_tmp.last_published_dttm,
                        activity_detail_tmp.source_system_cd,
                        activity_detail_tmp.updated_by_nm,
                        activity_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_ACTIVITY_DETAIL;

                execute (drop table activity_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_ACTIVITY_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_activity_detail as u
                    set activity_id =
                            (select activity_id from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        valid_from_dttm =
                            (select valid_from_dttm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        status_cd =
                            (select status_cd from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        activity_nm =
                            (select activity_nm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        activity_desc =
                            (select activity_desc from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        activity_cd =
                            (select activity_cd from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        activity_category_nm =
                            (select activity_category_nm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        last_published_dttm =
                            (select last_published_dttm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_activity_detail as a
                             where u.activity_version_id = a.activity_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_ACTIVITY_DETAIL;

                insert into dblib.cdm_activity_detail
                select *
                from cdmmart.cdm_activity_detail as a
                where a.activity_version_id not in (select activity_version_id from dblib.cdm_activity_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_ACTIVITY_DETAIL;
            quit;

            %ErrorCheck(CDM_ACTIVITY_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_activity_detail;
                retain uobs oobs;
                set cdmmart.cdm_activity_detail
                    (rename=(activity_id=activity_id_tmp valid_from_dttm=valid_from_dttm_tmp
                             valid_to_dttm=valid_to_dttm_tmp status_cd=status_cd_tmp activity_nm=activity_nm_tmp
                             activity_desc=activity_desc_tmp activity_category_nm=activity_category_nm_tmp
                             last_published_dttm=last_published_dttm_tmp source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp updated_dttm=updated_dttm_tmp));

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
                    activity_category_nm=activity_category_nm_tmp;
                    last_published_dttm=last_published_dttm_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_activity_custom_attr)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table activity_custom_attr_tmp
                  ( activity_version_id  VARCHAR2(36) NOT NULL ,
                    attribute_nm         VARCHAR2(256) NOT NULL ,
                    attribute_data_type_cd VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val NUMBER(17,2) NULL ,
                    attribute_dttm_val   TIMESTAMP NULL ,
                    updated_by_nm        VARCHAR2(60) NULL ,
                    updated_dttm         TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table activity_custom_attr_tmp
                    add constraint activity_custom_attr_tmp_pk primary key (activity_version_id,attribute_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.activity_custom_attr_tmp
                select *
                from cdmmart.cdm_activity_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_activity_custom_attr using activity_custom_attr_tmp
                        on (cdm_activity_custom_attr.activity_version_id = activity_custom_attr_tmp.activity_version_id and
                            cdm_activity_custom_attr.attribute_nm = activity_custom_attr_tmp.attribute_nm)

                    when matched then update
                    set cdm_activity_custom_attr.attribute_data_type_cd = activity_custom_attr_tmp.attribute_data_type_cd,
                        cdm_activity_custom_attr.attribute_character_val = activity_custom_attr_tmp.attribute_character_val,
                        cdm_activity_custom_attr.attribute_numeric_val = activity_custom_attr_tmp.attribute_numeric_val,
                        cdm_activity_custom_attr.attribute_dttm_val = activity_custom_attr_tmp.attribute_dttm_val,
                        cdm_activity_custom_attr.updated_by_nm = activity_custom_attr_tmp.updated_by_nm,
                        cdm_activity_custom_attr.updated_dttm = activity_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_activity_custom_attr.activity_version_id,
                        cdm_activity_custom_attr.attribute_nm,
                        cdm_activity_custom_attr.attribute_data_type_cd,
                        cdm_activity_custom_attr.attribute_character_val,
                        cdm_activity_custom_attr.attribute_numeric_val,
                        cdm_activity_custom_attr.attribute_dttm_val,
                        cdm_activity_custom_attr.updated_by_nm,
                        cdm_activity_custom_attr.updated_dttm
                      )
                    values
                      ( activity_custom_attr_tmp.activity_version_id,
                        activity_custom_attr_tmp.attribute_nm,
                        activity_custom_attr_tmp.attribute_data_type_cd,
                        activity_custom_attr_tmp.attribute_character_val,
                        activity_custom_attr_tmp.attribute_numeric_val,
                        activity_custom_attr_tmp.attribute_dttm_val,
                        activity_custom_attr_tmp.updated_by_nm,
                        activity_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table activity_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_ACTIVITY_CUSTOM_ATTR;

            %ErrorCheck(CDM_ACTIVITY_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_activity_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_activity_custom_attr as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_activity_custom_attr as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_activity_custom_attr as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_activity_custom_attr as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_activity_custom_attr as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_activity_custom_attr as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.attribute_nm = a.attribute_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_ACTIVITY_CUSTOM_ATTR;

                insert into dblib.cdm_activity_custom_attr
                select *
                from cdmmart.cdm_activity_custom_attr as a
                where a.activity_version_id not in (select activity_version_id from dblib.cdm_activity_custom_attr)
                and a.attribute_nm not in (select attribute_nm from dblib.cdm_activity_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_ACTIVITY_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_ACTIVITY_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_activity_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_activity_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
                             attribute_numeric_val=attribute_numeric_val_tmp
                             attribute_dttm_val=attribute_dttm_val_tmp
                             updated_by_nm=updated_by_nm_tmp updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_activity_custom_attr
                    (cntllev=rec dbkey=(activity_version_id attribute_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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
    %end;

/*
 *  This table is not available yet.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_business_context)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table business_context_tmp
                  ( business_context_id  VARCHAR2(36) NOT NULL ,
                    business_context_nm  VARCHAR2(256) NULL ,
                    business_context_type_cd VARCHAR2(40) NULL ,
                    source_system_cd     VARCHAR2(10) NULL ,
                    updated_by_nm        VARCHAR2(60) NULL ,
                    updated_dttm         TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table business_context_tmp
                    add constraint business_context_tmp_pk primary key (business_context_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.business_context_tmp
                select *
                from cdmmart.cdm_business_context;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_business_context using business_context_tmp
                        on (cdm_business_context.business_context_id = business_context_tmp.business_context_id)

                    when matched then update
                    set cdm_business_context.business_context_nm = business_context_tmp.business_context_nm,
                        cdm_business_context.business_context_type_cd = business_context_tmp.business_context_type_cd,
                        cdm_business_context.source_system_cd = business_context_tmp.source_system_cd,
                        cdm_business_context.updated_by_nm = business_context_tmp.updated_by_nm,
                        cdm_business_context.updated_dttm = business_context_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_business_context.business_context_id,
                        cdm_business_context.business_context_nm,
                        cdm_business_context.business_context_type_cd,
                        cdm_business_context.source_system_cd,
                        cdm_business_context.updated_by_nm,
                        cdm_business_context.updated_dttm
                      )
                    values
                      ( business_context_tmp.business_context_id,
                        business_context_tmp.business_context_nm,
                        business_context_tmp.business_context_type_cd,
                        business_context_tmp.source_system_cd,
                        business_context_tmp.updated_by_nm,
                        business_context_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table business_context_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_BUSINESS_CONTEXT;

            %ErrorCheck(CDM_BUSINESS_CONTEXT);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_business_context as u
                    set business_context_nm =
                            (select business_context_nm from cdmmart.cdm_business_context as a
                             where u.business_context_id = a.business_context_id),
                        business_context_type_cd =
                            (select business_context_type_cd from cdmmart.cdm_business_context as a
                             where u.business_context_id = a.business_context_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_business_context as a
                             where u.business_context_id = a.business_context_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_business_context as a
                             where u.business_context_id = a.business_context_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_business_context as a
                             where u.business_context_id = a.business_context_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_BUSINESS_CONTEXT;

                insert into dblib.cdm_business_context
                select *
                from cdmmart.cdm_business_context as a
                where a.business_context_id not in (select business_context_id from dblib.cdm_business_context);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_BUSINESS_CONTEXT;
            quit;

            %ErrorCheck(CDM_BUSINESS_CONTEXT);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_business_context;
                retain uobs oobs;
                set cdmmart.cdm_business_context
                    (rename=(business_context_nm=business_context_nm_tmp
                             business_context_type_cd=business_context_type_cd_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp updated_dttm=updated_dttm_tmp));

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
                    updated_dttm = updated_dttm_tmp;

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

        %ErrorCheck(CDM_BUSINESS_CONTEXT);
        %if &rc %then %goto ERREXIT;
    %end;
*/


/*
 *  This table is populated by MA and doesn't need to be loaded by this process.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_campaign_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table campaign_detail_tmp
                  ( campaign_id          VARCHAR2(36) NOT NULL ,
                    campaign_version_no  NUMBER(6) NULL ,
                    valid_from_dttm      TIMESTAMP NOT NULL ,
                    valid_to_dttm        TIMESTAMP NULL ,
                    campaign_nm          VARCHAR2(60) NULL ,
                    campaign_desc        CLOB NULL ,
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
                    campaign_group_sk    NUMBER(15) NOT NULL ,
                    deployment_version_no NUMBER(6) NULL ,
                    source_system_cd     VARCHAR2(10) NULL ,
                    updated_by_nm        VARCHAR2(60) NULL ,
                    updated_dttm         TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table campaign_detail_tmp
                    add constraint campaign_detail_tmp_pk primary key (campaign_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.campaign_detail_tmp
                select *
                from cdmmart.cdm_campaign_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_campaign_detail using campaign_detail_tmp
                        on (cdm_campaign_detail.campaign_id = campaign_detail_tmp.campaign_id)

                    when matched then update
                    set cdm_campaign_detail.campaign_version_no = campaign_detail_tmp.campaign_version_no,
                        cdm_campaign_detail.valid_from_dttm = campaign_detail_tmp.valid_from_dttm,
                        cdm_campaign_detail.valid_to_dttm = campaign_detail_tmp.valid_to_dttm,
                        cdm_campaign_detail.campaign_nm = campaign_detail_tmp.campaign_nm,
                        cdm_campaign_detail.campaign_desc = campaign_detail_tmp.campaign_desc,
                        cdm_campaign_detail.campaign_cd = campaign_detail_tmp.campaign_cd,
                        cdm_campaign_detail.campaign_owner_nm = campaign_detail_tmp.campaign_owner_nm,
                        cdm_campaign_detail.min_budget_offer_amt = campaign_detail_tmp.min_budget_offer_amt,
                        cdm_campaign_detail.max_budget_offer_amt = campaign_detail_tmp.max_budget_offer_amt,
                        cdm_campaign_detail.min_budget_amt = campaign_detail_tmp.min_budget_amt,
                        cdm_campaign_detail.max_budget_amt = campaign_detail_tmp.max_budget_amt,
                        cdm_campaign_detail.start_dttm = campaign_detail_tmp.start_dttm,
                        cdm_campaign_detail.end_dttm = campaign_detail_tmp.end_dttm,
                        cdm_campaign_detail.run_dttm = campaign_detail_tmp.run_dttm,
                        cdm_campaign_detail.last_modified_dttm = campaign_detail_tmp.last_modified_dttm,
                        cdm_campaign_detail.approval_dttm = campaign_detail_tmp.approval_dttm,
                        cdm_campaign_detail.approval_given_by_nm = campaign_detail_tmp.approval_given_by_nm,
                        cdm_campaign_detail.last_modified_by_user_nm = campaign_detail_tmp.last_modified_by_user_nm,
                        cdm_campaign_detail.current_version_flg = campaign_detail_tmp.current_version_flg,
                        cdm_campaign_detail.deleted_flg = campaign_detail_tmp.deleted_flg,
                        cdm_campaign_detail.campaign_status_cd = campaign_detail_tmp.campaign_status_cd,
                        cdm_campaign_detail.campaign_type_cd = campaign_detail_tmp.campaign_type_cd,
                        cdm_campaign_detail.campaign_folder_txt = campaign_detail_tmp.campaign_folder_txt,
                        cdm_campaign_detail.campaign_group_sk = campaign_detail_tmp.campaign_group_sk,
                        cdm_campaign_detail.deployment_version_no = campaign_detail_tmp.deployment_version_no,
                        cdm_campaign_detail.source_system_cd = campaign_detail_tmp.source_system_cd,
                        cdm_campaign_detail.updated_by_nm = campaign_detail_tmp.updated_by_nm,
                        cdm_campaign_detail.updated_dttm = campaign_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_campaign_detail.campaign_id,
                        cdm_campaign_detail.campaign_version_no,
                        cdm_campaign_detail.valid_from_dttm,
                        cdm_campaign_detail.valid_to_dttm,
                        cdm_campaign_detail.campaign_nm,
                        cdm_campaign_detail.campaign_desc,
                        cdm_campaign_detail.campaign_cd,
                        cdm_campaign_detail.campaign_owner_nm,
                        cdm_campaign_detail.min_budget_offer_amt,
                        cdm_campaign_detail.max_budget_offer_amt,
                        cdm_campaign_detail.min_budget_amt,
                        cdm_campaign_detail.max_budget_amt,
                        cdm_campaign_detail.start_dttm,
                        cdm_campaign_detail.end_dttm,
                        cdm_campaign_detail.run_dttm,
                        cdm_campaign_detail.last_modified_dttm,
                        cdm_campaign_detail.approval_dttm,
                        cdm_campaign_detail.approval_given_by_nm,
                        cdm_campaign_detail.last_modified_by_user_nm,
                        cdm_campaign_detail.current_version_flg,
                        cdm_campaign_detail.deleted_flg,
                        cdm_campaign_detail.campaign_status_cd,
                        cdm_campaign_detail.campaign_type_cd,
                        cdm_campaign_detail.campaign_folder_txt,
                        cdm_campaign_detail.campaign_group_sk,
                        cdm_campaign_detail.deployment_version_no,
                        cdm_campaign_detail.source_system_cd,
                        cdm_campaign_detail.updated_by_nm,
                        cdm_campaign_detail.updated_dttm
                      )
                    values
                      ( campaign_detail_tmp.campaign_id,
                        campaign_detail_tmp.campaign_version_no,
                        campaign_detail_tmp.valid_from_dttm,
                        campaign_detail_tmp.valid_to_dttm,
                        campaign_detail_tmp.campaign_nm,
                        campaign_detail_tmp.campaign_desc,
                        campaign_detail_tmp.campaign_cd,
                        campaign_detail_tmp.campaign_owner_nm,
                        campaign_detail_tmp.min_budget_offer_amt,
                        campaign_detail_tmp.max_budget_offer_amt,
                        campaign_detail_tmp.min_budget_amt,
                        campaign_detail_tmp.max_budget_amt,
                        campaign_detail_tmp.start_dttm,
                        campaign_detail_tmp.end_dttm,
                        campaign_detail_tmp.run_dttm,
                        campaign_detail_tmp.last_modified_dttm,
                        campaign_detail_tmp.approval_dttm,
                        campaign_detail_tmp.approval_given_by_nm,
                        campaign_detail_tmp.last_modified_by_user_nm,
                        campaign_detail_tmp.current_version_flg,
                        campaign_detail_tmp.deleted_flg,
                        campaign_detail_tmp.campaign_status_cd,
                        campaign_detail_tmp.campaign_type_cd,
                        campaign_detail_tmp.campaign_folder_txt,
                        campaign_detail_tmp.campaign_group_sk,
                        campaign_detail_tmp.deployment_version_no,
                        campaign_detail_tmp.source_system_cd,
                        campaign_detail_tmp.updated_by_nm,
                        campaign_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table campaign_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CAMPAIGN_DETAIL;

            %ErrorCheck(CDM_CAMPAIGN_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_campaign_detail as u
                    set campaign_version_no =
                            (select campaign_version_no from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        valid_from_dttm =
                            (select valid_from_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_nm =
                            (select campaign_nm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_desc =
                            (select campaign_desc from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_cd =
                            (select campaign_cd from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_owner_nm =
                            (select campaign_owner_nm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        min_budget_offer_amt =
                            (select min_budget_offer_amt from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        max_budget_offer_amt =
                            (select max_budget_offer_amt from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        min_budget_amt =
                            (select min_budget_amt from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        start_dttm =
                            (select start_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        end_dttm =
                            (select end_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        run_dttm =
                            (select run_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        last_modified_dttm =
                            (select last_modified_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        current_version_flg =
                            (select current_version_flg from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        deleted_flg =
                            (select deleted_flg from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_status_cd =
                            (select campaign_status_cd from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_type_cd =
                            (select campaign_type_cd from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_folder_txt =
                            (select campaign_folder_txt from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        campaign_group_sk =
                            (select campaign_group_sk from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        deployment_version_no =
                            (select deployment_version_no from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_campaign_detail as a
                             where u.campaign_id = a.campaign_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CAMPAIGN_DETAIL;

                insert into dblib.cdm_campaign_detail
                select *
                from cdmmart.cdm_campaign_detail as a
                where a.campaign_id not in (select campaign_id from dblib.cdm_campaign_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CAMPAIGN_DETAIL;
            quit;

            %ErrorCheck(CDM_CAMPAIGN_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_campaign_detail;
                retain uobs oobs;
                set cdmmart.cdm_campaign_detail
                    (rename=(campaign_version_no=campaign_version_no_tmp
                             valid_from_dttm=valid_from_dttm_tmp
                             valid_to_dttm=valid_to_dttm_tmp
                             campaign_nm=campaign_nm_tmp
                             campaign_desc=campaign_desc_tmp
                             campaign_cd=campaign_cd_tmp
                             campaign_owner_nm=campaign_owner_nm_tmp
                             min_budget_offer_amt=min_budget_offer_amt_tmp
                             max_budget_offer_amt=max_budget_offer_amt_tmp
                             min_budget_amt=min_budget_amt_tmp
                             max_budget_amt=max_budget_amt_tmp
                             start_dttm=start_dttm_tmp
                             end_dttm=end_dttm_tmp
                             run_dttm=run_dttm_tmp
                             last_modified_dttm=last_modified_dttm_tmp
                             approval_dttm=approval_dttm_tmp
                             approval_given_by_nm=approval_given_by_nm_tmp
                             last_modified_by_user_nm=last_modified_by_user_nm_tmp
                             current_version_flg=current_version_flg_tmp
                             deleted_flg=deleted_flg_tmp
                             campaign_status_cd=campaign_status_cd_tmp
                             campaign_type_cd=campaign_type_cd_tmp
                             campaign_folder_txt=campaign_folder_txt_tmp
                             campaign_group_sk=campaign_group_sk_tmp
                             deployment_version_no=deployment_version_no_tmp
                             source_system_cd=source_system_cd_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_dttmp
                  ));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_campaign_detail
                    (cntllev=rec dbkey=campaign_id) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    campaign_version_no=campaign_version_no_tmp;
                    valid_from_dttm=valid_from_dttm_tmp;
                    valid_to_dttm=valid_to_dttm_tmp;
                    campaign_nm=campaign_nm_tmp;
                    campaign_desc=campaign_desc_tmp;
                    campaign_cd=campaign_cd_tmp;
                    campaign_owner_nm=campaign_owner_nm_tmp;
                    min_budget_offer_amt=min_budget_offer_amt_tmp;
                    max_budget_offer_amt=max_budget_offer_amt_tmp;
                    min_budget_amt=min_budget_amt_tmp;
                    max_budget_amt=max_budget_amt_tmp;
                    start_dttm=start_dttm_tmp;
                    end_dttm=end_dttm_tmp;
                    run_dttm=run_dttm_tmp;
                    last_modified_dttm=last_modified_dttm_tmp;
                    approval_dttm=approval_dttm_tmp;
                    approval_given_by_nm=approval_given_by_nm_tmp;
                    last_modified_by_user_nm=last_modified_by_user_nm_tmp;
                    current_version_flg=current_version_flg_tmp;
                    deleted_flg=deleted_flg_tmp;
                    campaign_status_cd=campaign_status_cd_tmp;
                    campaign_type_cd=campaign_type_cd_tmp;
                    campaign_folder_txt=campaign_folder_txt_tmp;
                    campaign_group_sk=campaign_group_sk_tmp;
                    deployment_version_no=deployment_version_no_tmp;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=updated_dttm_dttmp;

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

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CAMPAIGN_DETAIL;

            %ErrorCheck(CDM_CAMPAIGN_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
    %end;
*/


/*
 *  This table is populated by MA and doesn't need to be loaded by this process.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_campaign_custom_attr)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table campaign_custom_attr_tmp
                  ( campaign_id             VARCHAR2(36) NOT NULL ,
                    attribute_nm            VARCHAR2(256) NOT NULL ,
                    page_nm                 VARCHAR2(60) NOT NULL,
                    attribute_data_type_cd  VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val   NUMBER(17,2) NULL ,
                    attribute_dttm_val      TIMESTAMP NULL ,
                    extension_attribute_nm  VARCHAR2(2256) NULL ,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table campaign_custom_attr_tmp
                    add constraint campaign_custom_attr_tmp_pk primary key (campaign_id,attribute_nm,page_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.campaign_custom_attr_tmp
                select *
                from cdmmart.cdm_campaign_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_campaign_custom_attr using campaign_custom_attr_tmp
                        on (cdm_campaign_custom_attr.campaign_id = campaign_custom_attr_tmp.campaign_id and
                            cdm_campaign_custom_attr.attribute_nm = campaign_custom_attr_tmp.attribute_nm and
                            cdm_campaign_custom_attr.page_nm = campaign_custom_attr_tmp.page_nm)

                    when matched then update
                    set cdm_campaign_custom_attr.attribute_data_type_cd = campaign_custom_attr_tmp.attribute_data_type_cd,
                        cdm_campaign_custom_attr.attribute_character_val = campaign_custom_attr_tmp.attribute_character_val,
                        cdm_campaign_custom_attr.attribute_numeric_val = campaign_custom_attr_tmp.attribute_numeric_val,
                        cdm_campaign_custom_attr.attribute_dttm_val = campaign_custom_attr_tmp.attribute_dttm_val,
                        cdm_campaign_custom_attr.extension_attribute_nm = campaign_custom_attr_tmp.extension_attribute_nm,
                        cdm_campaign_custom_attr.updated_by_nm = campaign_custom_attr_tmp.updated_by_nm,
                        cdm_campaign_custom_attr.updated_dttm = campaign_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_campaign_custom_attr.campaign_id,
                        cdm_campaign_custom_attr.attribute_nm,
                        cdm_campaign_custom_attr.page_nm,
                        cdm_campaign_custom_attr.attribute_data_type_cd,
                        cdm_campaign_custom_attr.attribute_character_val,
                        cdm_campaign_custom_attr.attribute_numeric_val,
                        cdm_campaign_custom_attr.attribute_dttm_val,
                        cdm_campaign_custom_attr.extension_attribute_nm,
                        cdm_campaign_custom_attr.updated_by_nm,
                        cdm_campaign_custom_attr.updated_dttm
                      )
                    values
                      ( campaign_custom_attr_tmp.campaign_id,
                        campaign_custom_attr_tmp.attribute_nm,
                        campaign_custom_attr_tmp.page_nm,
                        campaign_custom_attr_tmp.attribute_data_type_cd,
                        campaign_custom_attr_tmp.attribute_character_val,
                        campaign_custom_attr_tmp.attribute_numeric_val,
                        campaign_custom_attr_tmp.attribute_dttm_val,
                        campaign_custom_attr_tmp.extension_attribute_nm,
                        campaign_custom_attr_tmp.updated_by_nm,
                        campaign_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table campaign_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CAMPAIGN_CUSTOM_ATTR;

            %ErrorCheck(CDM_CAMPAIGN_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_campaign_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm),
                        extension_attribute_nm =
                            (select extension_attribute_nm from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_campaign_custom_attr as a
                             where u.campaign_id = a.campaign_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.page_nm = a.page_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CAMPAIGN_CUSTOM_ATTR;

                insert into dblib.cdm_campaign_custom_attr
                select *
                from cdmmart.cdm_campaign_custom_attr as a
                where a.campaign_id not in (select campaign_id from dblib.cdm_campaign_custom_attr)
                and a.attribute_nm not in (select attribute_nm from dblib.cdm_campaign_custom_attr)
                and a.page_nm not in (select page_nm from dblib.cdm_campaign_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CAMPAIGN_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_CAMPAIGN_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_campaign_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_campaign_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
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

                modify dblib.cdm_campaign_custom_attr
                    (cntllev=rec dbkey=(campaign_id attribute_nm page_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    extension_attribute_nm = extension_attribute_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CAMPAIGN_CUSTOM_ATTR;

            %ErrorCheck(CDM_CAMPAIGN_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
    %end;
*/


    %if %sysfunc(exist(cdmmart.cdm_contact_channel)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table contact_channel_tmp
                  ( contact_channel_cd   VARCHAR2(60) NOT NULL ,
                    contact_channel_nm   VARCHAR2(40) NOT NULL ,
                    updated_by_nm        VARCHAR2(60) NULL ,
                    updated_dttm         TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table contact_channel_tmp
                    add constraint contact_channel_tmp_pk primary key (contact_channel_cd)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.contact_channel_tmp
                select *
                from cdmmart.cdm_contact_channel;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_contact_channel using contact_channel_tmp
                        on (cdm_contact_channel.contact_channel_cd = contact_channel_tmp.contact_channel_cd)

                    when matched then update
                    set cdm_contact_channel.contact_channel_nm = contact_channel_tmp.contact_channel_nm,
                        cdm_contact_channel.updated_by_nm = contact_channel_tmp.updated_by_nm,
                        cdm_contact_channel.updated_dttm = contact_channel_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_contact_channel.contact_channel_cd,
                        cdm_contact_channel.contact_channel_nm,
                        cdm_contact_channel.updated_by_nm,
                        cdm_contact_channel.updated_dttm
                      )
                    values
                      ( contact_channel_tmp.contact_channel_cd,
                        contact_channel_tmp.contact_channel_nm,
                        contact_channel_tmp.updated_by_nm,
                        contact_channel_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table contact_channel_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CONTACT_CHANNEL;

            %ErrorCheck(CDM_CONTACT_CHANNEL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_contact_channel as u
                    set contact_channel_nm =
                            (select contact_channel_nm from cdmmart.cdm_contact_channel as a
                             where u.contact_channel_cd = a.contact_channel_cd),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_contact_channel as a
                             where u.contact_channel_cd = a.contact_channel_cd),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_contact_channel as a
                             where u.contact_channel_cd = a.contact_channel_cd)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CONTACT_CHANNEL;

                insert into dblib.cdm_contact_channel
                select *
                from cdmmart.cdm_contact_channel as a
                where a.contact_channel_cd not in (select contact_channel_cd from dblib.cdm_contact_channel);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CONTACT_CHANNEL;
            quit;

            %ErrorCheck(CDM_CONTACT_CHANNEL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm = updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_map)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table segment_map_tmp
                  ( segment_map_version_id  VARCHAR2(36) NOT NULL ,
                    segment_map_id          VARCHAR2(36) NULL ,
                    valid_from_dttm         TIMESTAMP NOT NULL ,
                    valid_to_dttm           TIMESTAMP NULL ,
                    segment_map_nm          VARCHAR2(256) NULL ,
                    segment_map_desc        CLOB NULL ,
                    segment_map_category_nm VARCHAR2(100) NULL ,
                    segment_map_cd          VARCHAR2(60) NULL,
                    segment_map_src_nm      VARCHAR2(40) NULL ,
                    segment_map_status_cd   VARCHAR2(20) NULL ,
                    source_system_cd        VARCHAR2(10) NULL ,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table segment_map_tmp
                    add constraint segment_map_tmp_pk primary key (segment_map_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.segment_map_tmp
                select *
                from cdmmart.cdm_segment_map;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_segment_map using segment_map_tmp
                        on (cdm_segment_map.segment_map_version_id = segment_map_tmp.segment_map_version_id)

                    when matched then update
                    set cdm_segment_map.segment_map_id = segment_map_tmp.segment_map_id,
                        cdm_segment_map.valid_from_dttm = segment_map_tmp.valid_from_dttm,
                        cdm_segment_map.valid_to_dttm = segment_map_tmp.valid_to_dttm,
                        cdm_segment_map.segment_map_nm = segment_map_tmp.segment_map_nm,
                        cdm_segment_map.segment_map_desc = segment_map_tmp.segment_map_desc,
                        cdm_segment_map.segment_map_category_nm = segment_map_tmp.segment_map_category_nm,
                        cdm_segment_map.segment_map_cd = segment_map_tmp.segment_map_cd,
                        cdm_segment_map.segment_map_src_nm = segment_map_tmp.segment_map_src_nm,
                        cdm_segment_map.segment_map_status_cd = segment_map_tmp.segment_map_status_cd,
                        cdm_segment_map.source_system_cd = segment_map_tmp.source_system_cd,
                        cdm_segment_map.updated_by_nm = segment_map_tmp.updated_by_nm,
                        cdm_segment_map.updated_dttm = segment_map_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_segment_map.segment_map_version_id,
                        cdm_segment_map.segment_map_id,
                        cdm_segment_map.valid_from_dttm,
                        cdm_segment_map.valid_to_dttm,
                        cdm_segment_map.segment_map_nm,
                        cdm_segment_map.segment_map_desc,
                        cdm_segment_map.segment_map_category_nm,
                        cdm_segment_map.segment_map_cd,
                        cdm_segment_map.segment_map_src_nm,
                        cdm_segment_map.segment_map_status_cd,
                        cdm_segment_map.source_system_cd,
                        cdm_segment_map.updated_by_nm,
                        cdm_segment_map.updated_dttm
                      )
                    values
                      ( segment_map_tmp.segment_map_version_id,
                        segment_map_tmp.segment_map_id,
                        segment_map_tmp.valid_from_dttm,
                        segment_map_tmp.valid_to_dttm,
                        segment_map_tmp.segment_map_nm,
                        segment_map_tmp.segment_map_desc,
                        segment_map_tmp.segment_map_category_nm,
                        segment_map_tmp.segment_map_cd,
                        segment_map_tmp.segment_map_src_nm,
                        segment_map_tmp.segment_map_status_cd,
                        segment_map_tmp.source_system_cd,
                        segment_map_tmp.updated_by_nm,
                        segment_map_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_SEGMENT_MAP;

                execute (drop table segment_map_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_SEGMENT_MAP);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_segment_map as u
                    set segment_map_id =
                            (select segment_map_id from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        valid_from_dttm =
                            (select valid_from_dttm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        segment_map_nm =
                            (select segment_map_nm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        segment_map_desc =
                            (select segment_map_desc from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        segment_map_category_nm =
                            (select segment_map_category_nm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        segment_map_cd =
                            (select segment_map_cd from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        segment_map_src_nm =
                            (select segment_map_src_nm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        segment_map_status_cd =
                            (select segment_map_status_cd from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_segment_map as a
                             where u.segment_map_version_id = a.segment_map_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_SEGMENT_MAP;

                insert into dblib.cdm_segment_map
                select *
                from cdmmart.cdm_segment_map as a
                where a.segment_map_version_id not in (select segment_map_version_id from dblib.cdm_segment_map);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_SEGMENT_MAP;
            quit;

            %ErrorCheck(CDM_SEGMENT_MAP);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm = updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_map_custom_attr)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table segment_map_custom_attr_tmp
                  ( segment_map_version_id  VARCHAR2(36) NOT NULL ,
                    attribute_nm            VARCHAR2(256) NOT NULL ,
                    attribute_data_type_cd  VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val   NUMBER(17,2) NULL ,
                    attribute_dttm_val      TIMESTAMP NULL ,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table segment_map_custom_attr_tmp
                    add constraint segment_map_custom_attr_tmp_pk primary key (segment_map_version_id, attribute_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.segment_map_custom_attr_tmp
                select *
                from cdmmart.cdm_segment_map_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_segment_map_custom_attr using segment_map_custom_attr_tmp
                        on (cdm_segment_map_custom_attr.segment_map_version_id = segment_map_custom_attr_tmp.segment_map_version_id and
                            cdm_segment_map_custom_attr.attribute_nm = segment_map_custom_attr_tmp.attribute_nm)

                    when matched then update
                    set cdm_segment_map_custom_attr.attribute_data_type_cd = segment_map_custom_attr_tmp.attribute_data_type_cd,
                        cdm_segment_map_custom_attr.attribute_character_val = segment_map_custom_attr_tmp.attribute_character_val,
                        cdm_segment_map_custom_attr.attribute_numeric_val = segment_map_custom_attr_tmp.attribute_numeric_val,
                        cdm_segment_map_custom_attr.attribute_dttm_val = segment_map_custom_attr_tmp.attribute_dttm_val,
                        cdm_segment_map_custom_attr.updated_by_nm = segment_map_custom_attr_tmp.updated_by_nm,
                        cdm_segment_map_custom_attr.updated_dttm = segment_map_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_segment_map_custom_attr.segment_map_version_id,
                        cdm_segment_map_custom_attr.attribute_nm,
                        cdm_segment_map_custom_attr.attribute_data_type_cd,
                        cdm_segment_map_custom_attr.attribute_character_val,
                        cdm_segment_map_custom_attr.attribute_numeric_val,
                        cdm_segment_map_custom_attr.attribute_dttm_val,
                        cdm_segment_map_custom_attr.updated_by_nm,
                        cdm_segment_map_custom_attr.updated_dttm
                      )
                    values
                      ( segment_map_custom_attr_tmp.segment_map_version_id,
                        segment_map_custom_attr_tmp.attribute_nm,
                        segment_map_custom_attr_tmp.attribute_data_type_cd,
                        segment_map_custom_attr_tmp.attribute_character_val,
                        segment_map_custom_attr_tmp.attribute_numeric_val,
                        segment_map_custom_attr_tmp.attribute_dttm_val,
                        segment_map_custom_attr_tmp.updated_by_nm,
                        segment_map_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table segment_map_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_SEGMENT_MAP_CUSTOM_ATTR;

            %ErrorCheck(CDM_SEGMENT_MAP_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_segment_map_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_segment_map_custom_attr as a
                             where u.segment_map_version_id = a.segment_map_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_segment_map_custom_attr as a
                             where u.segment_map_version_id = a.segment_map_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_segment_map_custom_attr as a
                             where u.segment_map_version_id = a.segment_map_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_segment_map_custom_attr as a
                             where u.segment_map_version_id = a.segment_map_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_segment_map_custom_attr as a
                             where u.segment_map_version_id = a.segment_map_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_segment_map_custom_attr as a
                             where u.segment_map_version_id = a.segment_map_version_id and
                                   u.attribute_nm = a.attribute_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_SEGMENT_MAP_CUSTOM_ATTR;

                insert into dblib.cdm_segment_map_custom_attr
                select *
                from cdmmart.cdm_segment_map_custom_attr as a
                where a.segment_map_version_id not in (select segment_map_version_id from dblib.cdm_segment_map_custom_attr) and
                      a.attribute_nm not in (select attribute_nm from dblib.cdm_segment_map_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_SEGMENT_MAP_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_SEGMENT_MAP_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_segment_map_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_segment_map_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
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
                    (cntllev=rec dbkey=(segment_map_version_id attribute_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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
    %end;

/*
 *  This table is populated by MA and doesn't need to be loaded by this process.
 */
/*
    %if %sysfunc(exist(cdmmart.cdm_contact_status)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table contact_status_tmp
                  ( contact_status_cd     VARCHAR2(3) NOT NULL ,
                    contact_status_desc   VARCHAR2(256) NOT NULL ,
                    updated_by_nm         VARCHAR2(60) NULL ,
                    updated_dttm          TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table contact_status_tmp
                    add constraint contact_status_tmp_pk primary key (contact_status_cd)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.contact_status_tmp
                select *
                from cdmmart.cdm_contact_status;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_contact_status using contact_status_tmp
                        on (cdm_contact_status.contact_status_cd = contact_status_tmp.contact_status_cd)

                    when matched then update
                    set cdm_contact_status.contact_status_desc = contact_status_tmp.contact_status_desc,
                        cdm_contact_status.updated_by_nm = contact_status_tmp.updated_by_nm,
                        cdm_contact_status.updated_dttm = contact_status_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_contact_status.contact_status_cd,
                        cdm_contact_status.contact_status_desc,
                        cdm_contact_status.updated_by_nm,
                        cdm_contact_status.updated_dttm
                      )
                    values
                      ( contact_status_tmp.contact_status_cd,
                        contact_status_tmp.contact_status_desc,
                        contact_status_tmp.updated_by_nm,
                        contact_status_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table contact_status_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CONTACT_STATUS;

            %ErrorCheck(CDM_CONTACT_STATUS);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_contact_status as u
                    set contact_status_desc =
                            (select contact_status_desc from cdmmart.cdm_contact_status as a
                             where u.contact_status_cd = a.contact_status_cd),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_contact_status as a
                             where u.contact_status_cd = a.contact_status_cd),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_contact_status as a
                             where u.contact_status_cd = a.contact_status_cd)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CONTACT_STATUS;

                insert into dblib.cdm_contact_status
                select *
                from cdmmart.cdm_contact_status as a
                where a.contact_status_cd not in (select contact_status_cd from dblib.cdm_contact_status);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CONTACT_STATUS;
            quit;

            %ErrorCheck(CDM_CONTACT_STATUS);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_contact_status;
                retain uobs oobs;
                set cdmmart.cdm_contact_status
                    (rename=(contact_status_desc=contact_status_desc_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_contact_status
                    (cntllev=rec dbkey=(contact_status_cd)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    contact_status_desc = contact_status_desc_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_CONTACT_STATUS;

            %ErrorCheck(CDM_CONTACT_STATUS);
            %if &rc %then %goto ERREXIT;

        %end;
    %end;
*/

    %if %sysfunc(exist(cdmmart.cdm_occurrence_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table occurrence_detail_tmp
                  ( occurrence_id              VARCHAR2(36) NOT NULL ,
                    start_dttm                 TIMESTAMP NULL ,
                    end_dttm                   TIMESTAMP NULL ,
                    occurrence_no              INTEGER NULL ,
                    occurrence_type_cd         VARCHAR2(30) NULL ,
                    occurrence_object_id       VARCHAR2(36) NULL ,
                    occurrence_object_type_cd  VARCHAR2(60) NULL ,
                    source_system_cd           VARCHAR2(10) NULL ,
                    execution_status_cd        VARCHAR2(30) NULL ,
                    updated_by_nm              VARCHAR2(60) NULL ,
                    updated_dttm               TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table occurrence_detail_tmp
                    add constraint occurrence_detail_tmp_pk primary key (occurrence_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.occurrence_detail_tmp
                select *
                from cdmmart.cdm_occurrence_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_occurrence_detail using occurrence_detail_tmp
                        on (cdm_occurrence_detail.occurrence_id = occurrence_detail_tmp.occurrence_id)

                    when matched then update
                    set cdm_occurrence_detail.start_dttm = occurrence_detail_tmp.start_dttm,
                        cdm_occurrence_detail.end_dttm = occurrence_detail_tmp.end_dttm,
                        cdm_occurrence_detail.occurrence_no = occurrence_detail_tmp.occurrence_no,
                        cdm_occurrence_detail.occurrence_type_cd = occurrence_detail_tmp.occurrence_type_cd,
                        cdm_occurrence_detail.occurrence_object_id = occurrence_detail_tmp.occurrence_object_id,
                        cdm_occurrence_detail.occurrence_object_type_cd = occurrence_detail_tmp.occurrence_object_type_cd,
                        cdm_occurrence_detail.source_system_cd = occurrence_detail_tmp.source_system_cd,
                        cdm_occurrence_detail.execution_status_cd = occurrence_detail_tmp.execution_status_cd,
                        cdm_occurrence_detail.updated_by_nm = occurrence_detail_tmp.updated_by_nm,
                        cdm_occurrence_detail.updated_dttm = occurrence_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_occurrence_detail.occurrence_id,
                        cdm_occurrence_detail.start_dttm,
                        cdm_occurrence_detail.end_dttm,
                        cdm_occurrence_detail.occurrence_no,
                        cdm_occurrence_detail.occurrence_type_cd,
                        cdm_occurrence_detail.occurrence_object_id,
                        cdm_occurrence_detail.occurrence_object_type_cd,
                        cdm_occurrence_detail.source_system_cd,
                        cdm_occurrence_detail.execution_status_cd,
                        cdm_occurrence_detail.updated_by_nm,
                        cdm_occurrence_detail.updated_dttm
                      )
                    values
                      ( occurrence_detail_tmp.occurrence_id,
                        occurrence_detail_tmp.start_dttm,
                        occurrence_detail_tmp.end_dttm,
                        occurrence_detail_tmp.occurrence_no,
                        occurrence_detail_tmp.occurrence_type_cd,
                        occurrence_detail_tmp.occurrence_object_id,
                        occurrence_detail_tmp.occurrence_object_type_cd,
                        occurrence_detail_tmp.source_system_cd,
                        occurrence_detail_tmp.execution_status_cd,
                        occurrence_detail_tmp.updated_by_nm,
                        occurrence_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_OCCURRENCE_DETAIL;

                execute (drop table occurrence_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_OCCURRENCE_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_occurrence_detail as u
                    set start_dttm =
                            (select start_dttm from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        end_dttm =
                            (select end_dttm from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        occurrence_no =
                            (select occurrence_no from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        occurrence_type_cd =
                            (select occurrence_type_cd from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        occurrence_object_id =
                            (select occurrence_object_id from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        occurrence_object_type_cd =
                            (select occurrence_object_type_cd from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        execution_status_cd =
                            (select execution_status_cd from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_occurrence_detail as a
                             where u.occurrence_id = a.occurrence_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_OCCURRENCE_DETAIL;

                insert into dblib.cdm_occurrence_detail
                select *
                from cdmmart.cdm_occurrence_detail as a
                where a.occurrence_id not in (select occurrence_id from dblib.cdm_occurrence_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_OCCURRENCE_DETAIL;
            quit;

            %ErrorCheck(CDM_OCCURRENCE_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    occurrence_object_id=occurrence_object_id;
                    occurrence_object_type_cd=occurrence_object_type_cd_tmp;
                    source_system_cd=source_system_cd_tmp;
                    execution_status_cd=execution_status_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table segment_detail_tmp
                  ( segment_version_id     VARCHAR2(36) NOT NULL ,
                    segment_id             VARCHAR2(36) NULL ,
                    segment_map_version_id VARCHAR2(36) NULL ,
                    valid_from_dttm        TIMESTAMP NOT NULL ,
                    valid_to_dttm          TIMESTAMP NULL ,
                    segment_nm             VARCHAR2(256) NULL ,
                    segment_desc           CLOB NULL ,
                    segment_category_nm    VARCHAR2(100) NULL ,
                    segment_cd             VARCHAR2(60) NULL ,
                    segment_src_nm         VARCHAR2(40) NULL ,
                    segment_status_cd      VARCHAR2(20) NULL ,
                    source_system_cd       VARCHAR2(10) NULL ,
                    updated_by_nm          VARCHAR2(60) NULL ,
                    updated_dttm           TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table segment_detail_tmp
                    add constraint segment_detail_tmp_pk primary key (segment_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.segment_detail_tmp
                select *
                from cdmmart.cdm_segment_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_segment_detail using segment_detail_tmp
                        on (cdm_segment_detail.segment_version_id = segment_detail_tmp.segment_version_id)

                    when matched then update
                    set cdm_segment_detail.segment_id = segment_detail_tmp.segment_id,
                        cdm_segment_detail.segment_map_version_id = segment_detail_tmp.segment_map_version_id,
                        cdm_segment_detail.valid_from_dttm = segment_detail_tmp.valid_from_dttm,
                        cdm_segment_detail.valid_to_dttm = segment_detail_tmp.valid_to_dttm,
                        cdm_segment_detail.segment_nm = segment_detail_tmp.segment_nm,
                        cdm_segment_detail.segment_desc = segment_detail_tmp.segment_desc,
                        cdm_segment_detail.segment_category_nm = segment_detail_tmp.segment_category_nm,
                        cdm_segment_detail.segment_cd = segment_detail_tmp.segment_cd,
                        cdm_segment_detail.segment_src_nm = segment_detail_tmp.segment_src_nm,
                        cdm_segment_detail.segment_status_cd = segment_detail_tmp.segment_status_cd,
                        cdm_segment_detail.source_system_cd = segment_detail_tmp.source_system_cd,
                        cdm_segment_detail.updated_by_nm = segment_detail_tmp.updated_by_nm,
                        cdm_segment_detail.updated_dttm = segment_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_segment_detail.segment_version_id,
                        cdm_segment_detail.segment_id,
                        cdm_segment_detail.segment_map_version_id,
                        cdm_segment_detail.valid_from_dttm,
                        cdm_segment_detail.valid_to_dttm,
                        cdm_segment_detail.segment_nm,
                        cdm_segment_detail.segment_desc,
                        cdm_segment_detail.segment_category_nm,
                        cdm_segment_detail.segment_cd,
                        cdm_segment_detail.segment_src_nm,
                        cdm_segment_detail.segment_status_cd,
                        cdm_segment_detail.source_system_cd,
                        cdm_segment_detail.updated_by_nm,
                        cdm_segment_detail.updated_dttm
                      )
                    values
                      ( segment_detail_tmp.segment_version_id,
                        segment_detail_tmp.segment_id,
                        segment_detail_tmp.segment_map_version_id,
                        segment_detail_tmp.valid_from_dttm,
                        segment_detail_tmp.valid_to_dttm,
                        segment_detail_tmp.segment_nm,
                        segment_detail_tmp.segment_desc,
                        segment_detail_tmp.segment_category_nm,
                        segment_detail_tmp.segment_cd,
                        segment_detail_tmp.segment_src_nm,
                        segment_detail_tmp.segment_status_cd,
                        segment_detail_tmp.source_system_cd,
                        segment_detail_tmp.updated_by_nm,
                        segment_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_SEGMENT_DETAIL;

                execute (drop table segment_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_SEGMENT_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_segment_detail as u
                    set segment_id =
                            (select segment_id from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_map_version_id =
                            (select segment_map_version_id from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        valid_from_dttm =
                            (select valid_from_dttm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_nm =
                            (select segment_nm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_desc =
                            (select segment_desc from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_category_nm =
                            (select segment_category_nm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_cd =
                            (select segment_cd from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_src_nm =
                            (select segment_src_nm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        segment_status_cd =
                            (select segment_status_cd from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_segment_detail as a
                             where u.segment_version_id = a.segment_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_SEGMENT_DETAIL;

                insert into dblib.cdm_segment_detail
                select *
                from cdmmart.cdm_segment_detail as a
                where a.segment_version_id not in (select segment_version_id from dblib.cdm_segment_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_SEGMENT_DETAIL;
            quit;

            %ErrorCheck(CDM_SEGMENT_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_task_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table task_detail_tmp
                  ( task_version_id               VARCHAR2(36) NOT NULL ,
                    task_id                       VARCHAR2(36) NULL ,
                    valid_from_dttm               TIMESTAMP NOT NULL ,
                    valid_to_dttm                 TIMESTAMP NULL ,
                    task_nm                       VARCHAR2(256) NULL ,
                    task_desc                     CLOB NULL ,
                    task_type_nm                  VARCHAR2(40) NULL ,
                    task_status_cd                VARCHAR2(20) NULL ,
                    task_subtype_nm               VARCHAR2(100) NULL ,
                    task_cd                       VARCHAR2(60) NULL ,
                    task_delivery_type_nm         VARCHAR2(60) NULL ,
                    active_flg                    CHAR(1) NULL ,
                    saved_flg                     CHAR(1) NULL ,
                    published_flg                 CHAR(1) NULL ,
                    owner_nm                      VARCHAR2(40) NULL ,
                    modified_status_cd            VARCHAR2(20) NULL ,
                    created_user_nm               VARCHAR2(40) NULL ,
                    created_dt                    DATE NULL ,
                    scheduled_start_dttm          TIMESTAMP NULL ,
                    scheduled_end_dttm            TIMESTAMP NULL ,
                    scheduled_flg                 CHAR(1) NULL ,
                    maximum_period_expression_cnt INTEGER NULL ,
                    limit_period_unit_cnt         INTEGER NULL ,
                    limit_by_total_impression_flg CHAR(1) NULL ,
                    export_dttm                   TIMESTAMP NULL ,
                    update_contact_history_flg    CHAR(1) NULL ,
                    subject_type_nm               VARCHAR2(60) NULL ,
                    min_budget_offer_amt          NUMBER(14,2) NULL ,
                    max_budget_offer_amt          NUMBER(14,2) NULL ,
                    min_budget_amt                NUMBER(14,2) NULL ,
                    max_budget_amt                NUMBER(14,2) NULL ,
                    budget_unit_cost_amt          NUMBER(14,2) NULL ,
                    recurr_type_cd                VARCHAR2(3) NULL ,
                    budget_unit_usage_amt         NUMBER(14,2) NULL ,
                    standard_reply_flg            CHAR(1) NULL ,
                    staged_flg                    CHAR(1) NULL ,
                    contact_channel_cd            VARCHAR2(60) NULL ,
                    campaign_id                   VARCHAR2(36) NULL ,
                    business_context_id           VARCHAR2(36) NULL ,
                    source_system_cd              VARCHAR2(10) NULL ,
                    updated_by_nm                 VARCHAR2(60) NULL ,
                    updated_dttm                  TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table task_detail_tmp
                    add constraint task_detail_tmp_pk primary key (task_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.task_detail_tmp
                select *
                from cdmmart.cdm_task_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_task_detail using task_detail_tmp
                        on (cdm_task_detail.task_version_id = task_detail_tmp.task_version_id)

                    when matched then update
                    set cdm_task_detail.task_id = task_detail_tmp.task_id,
                        cdm_task_detail.valid_from_dttm = task_detail_tmp.valid_from_dttm,
                        cdm_task_detail.valid_to_dttm = task_detail_tmp.valid_to_dttm,
                        cdm_task_detail.task_nm = task_detail_tmp.task_nm,
                        cdm_task_detail.task_desc = task_detail_tmp.task_desc,
                        cdm_task_detail.task_type_nm = task_detail_tmp.task_type_nm,
                        cdm_task_detail.task_status_cd = task_detail_tmp.task_status_cd,
                        cdm_task_detail.task_subtype_nm = task_detail_tmp.task_subtype_nm,
                        cdm_task_detail.task_cd = task_detail_tmp.task_cd,
                        cdm_task_detail.task_delivery_type_nm = task_detail_tmp.task_delivery_type_nm,
                        cdm_task_detail.active_flg = task_detail_tmp.active_flg,
                        cdm_task_detail.saved_flg = task_detail_tmp.saved_flg,
                        cdm_task_detail.published_flg = task_detail_tmp.published_flg,
                        cdm_task_detail.owner_nm = task_detail_tmp.owner_nm,
                        cdm_task_detail.modified_status_cd = task_detail_tmp.modified_status_cd,
                        cdm_task_detail.created_user_nm = task_detail_tmp.created_user_nm,
                        cdm_task_detail.created_dt = task_detail_tmp.created_dt,
                        cdm_task_detail.scheduled_start_dttm = task_detail_tmp.scheduled_start_dttm,
                        cdm_task_detail.scheduled_end_dttm = task_detail_tmp.scheduled_end_dttm,
                        cdm_task_detail.scheduled_flg = task_detail_tmp.scheduled_flg,
                        cdm_task_detail.maximum_period_expression_cnt = task_detail_tmp.maximum_period_expression_cnt,
                        cdm_task_detail.limit_period_unit_cnt = task_detail_tmp.limit_period_unit_cnt,
                        cdm_task_detail.limit_by_total_impression_flg = task_detail_tmp.limit_by_total_impression_flg,
                        cdm_task_detail.export_dttm = task_detail_tmp.export_dttm,
                        cdm_task_detail.update_contact_history_flg = task_detail_tmp.update_contact_history_flg,
                        cdm_task_detail.subject_type_nm = task_detail_tmp.subject_type_nm,
                        cdm_task_detail.min_budget_offer_amt = task_detail_tmp.min_budget_offer_amt,
                        cdm_task_detail.max_budget_offer_amt = task_detail_tmp.max_budget_offer_amt,
                        cdm_task_detail.min_budget_amt = task_detail_tmp.min_budget_amt,
                        cdm_task_detail.max_budget_amt = task_detail_tmp.max_budget_amt,
                        cdm_task_detail.budget_unit_cost_amt = task_detail_tmp.budget_unit_cost_amt,
                        cdm_task_detail.recurr_type_cd = task_detail_tmp.recurr_type_cd,
                        cdm_task_detail.budget_unit_usage_amt = task_detail_tmp.budget_unit_usage_amt,
                        cdm_task_detail.standard_reply_flg = task_detail_tmp.standard_reply_flg,
                        cdm_task_detail.staged_flg = task_detail_tmp.staged_flg,
                        cdm_task_detail.contact_channel_cd = task_detail_tmp.contact_channel_cd,
                        cdm_task_detail.campaign_id = task_detail_tmp.campaign_id,
                        cdm_task_detail.business_context_id = task_detail_tmp.business_context_id,
                        cdm_task_detail.source_system_cd = task_detail_tmp.source_system_cd,
                        cdm_task_detail.updated_by_nm = task_detail_tmp.updated_by_nm,
                        cdm_task_detail.updated_dttm = task_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_task_detail.task_version_id,
                        cdm_task_detail.task_id,
                        cdm_task_detail.valid_from_dttm,
                        cdm_task_detail.valid_to_dttm,
                        cdm_task_detail.task_nm,
                        cdm_task_detail.task_desc,
                        cdm_task_detail.task_type_nm,
                        cdm_task_detail.task_status_cd,
                        cdm_task_detail.task_subtype_nm,
                        cdm_task_detail.task_cd,
                        cdm_task_detail.task_delivery_type_nm,
                        cdm_task_detail.active_flg,
                        cdm_task_detail.saved_flg,
                        cdm_task_detail.published_flg,
                        cdm_task_detail.owner_nm,
                        cdm_task_detail.modified_status_cd,
                        cdm_task_detail.created_user_nm,
                        cdm_task_detail.created_dt,
                        cdm_task_detail.scheduled_start_dttm,
                        cdm_task_detail.scheduled_end_dttm,
                        cdm_task_detail.scheduled_flg,
                        cdm_task_detail.maximum_period_expression_cnt,
                        cdm_task_detail.limit_period_unit_cnt,
                        cdm_task_detail.limit_by_total_impression_flg,
                        cdm_task_detail.export_dttm,
                        cdm_task_detail.update_contact_history_flg,
                        cdm_task_detail.subject_type_nm,
                        cdm_task_detail.min_budget_offer_amt,
                        cdm_task_detail.max_budget_offer_amt,
                        cdm_task_detail.min_budget_amt,
                        cdm_task_detail.max_budget_amt,
                        cdm_task_detail.budget_unit_cost_amt,
                        cdm_task_detail.recurr_type_cd,
                        cdm_task_detail.budget_unit_usage_amt,
                        cdm_task_detail.standard_reply_flg,
                        cdm_task_detail.staged_flg,
                        cdm_task_detail.contact_channel_cd,
                        cdm_task_detail.campaign_id,
                        cdm_task_detail.business_context_id,
                        cdm_task_detail.source_system_cd,
                        cdm_task_detail.updated_by_nm,
                        cdm_task_detail.updated_dttm
                      )
                    values
                      ( task_detail_tmp.task_version_id,
                        task_detail_tmp.task_id,
                        task_detail_tmp.valid_from_dttm,
                        task_detail_tmp.valid_to_dttm,
                        task_detail_tmp.task_nm,
                        task_detail_tmp.task_desc,
                        task_detail_tmp.task_type_nm,
                        task_detail_tmp.task_status_cd,
                        task_detail_tmp.task_subtype_nm,
                        task_detail_tmp.task_cd,
                        task_detail_tmp.task_delivery_type_nm,
                        task_detail_tmp.active_flg,
                        task_detail_tmp.saved_flg,
                        task_detail_tmp.published_flg,
                        task_detail_tmp.owner_nm,
                        task_detail_tmp.modified_status_cd,
                        task_detail_tmp.created_user_nm,
                        task_detail_tmp.created_dt,
                        task_detail_tmp.scheduled_start_dttm,
                        task_detail_tmp.scheduled_end_dttm,
                        task_detail_tmp.scheduled_flg,
                        task_detail_tmp.maximum_period_expression_cnt,
                        task_detail_tmp.limit_period_unit_cnt,
                        task_detail_tmp.limit_by_total_impression_flg,
                        task_detail_tmp.export_dttm,
                        task_detail_tmp.update_contact_history_flg,
                        task_detail_tmp.subject_type_nm,
                        task_detail_tmp.min_budget_offer_amt,
                        task_detail_tmp.max_budget_offer_amt,
                        task_detail_tmp.min_budget_amt,
                        task_detail_tmp.max_budget_amt,
                        task_detail_tmp.budget_unit_cost_amt,
                        task_detail_tmp.recurr_type_cd,
                        task_detail_tmp.budget_unit_usage_amt,
                        task_detail_tmp.standard_reply_flg,
                        task_detail_tmp.staged_flg,
                        task_detail_tmp.contact_channel_cd,
                        task_detail_tmp.campaign_id,
                        task_detail_tmp.business_context_id,
                        task_detail_tmp.source_system_cd,
                        task_detail_tmp.updated_by_nm,
                        task_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_TASK_DETAIL;

                execute (drop table task_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_TASK_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_task_detail as u
                    set task_id =
                            (select task_id from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        valid_from_dttm =
                            (select valid_from_dttm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_nm =
                            (select task_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_desc =
                            (select task_desc from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_type_nm =
                            (select task_type_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_status_cd =
                            (select task_status_cd from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_subtype_nm =
                            (select task_subtype_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_cd =
                            (select task_cd from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        task_delivery_type_nm =
                            (select task_delivery_type_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        active_flg =
                            (select active_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        saved_flg =
                            (select saved_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        published_flg =
                            (select published_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        owner_nm =
                            (select owner_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        modified_status_cd =
                            (select modified_status_cd from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        created_user_nm =
                            (select created_user_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        created_dt =
                            (select created_dt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        scheduled_start_dttm =
                            (select scheduled_start_dttm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        scheduled_end_dttm =
                            (select scheduled_end_dttm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        scheduled_flg =
                            (select scheduled_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        maximum_period_expression_cnt =
                            (select maximum_period_expression_cnt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        limit_period_unit_cnt =
                            (select limit_period_unit_cnt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        limit_by_total_impression_flg =
                            (select limit_by_total_impression_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        export_dttm =
                            (select export_dttm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        update_contact_history_flg =
                            (select update_contact_history_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        subject_type_nm =
                            (select subject_type_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        min_budget_offer_amt =
                            (select min_budget_offer_amt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        max_budget_offer_amt =
                            (select max_budget_offer_amt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        min_budget_amt =
                            (select min_budget_amt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        max_budget_amt =
                            (select max_budget_amt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        budget_unit_cost_amt =
                            (select budget_unit_cost_amt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        recurr_type_cd =
                            (select recurr_type_cd from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        budget_unit_usage_amt =
                            (select budget_unit_usage_amt from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        standard_reply_flg =
                            (select standard_reply_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        staged_flg =
                            (select staged_flg from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        contact_channel_cd =
                            (select contact_channel_cd from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        campaign_id =
                            (select campaign_id from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        business_context_id =
                            (select business_context_id from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_task_detail as a
                             where u.task_version_id = a.task_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_TASK_DETAIL;

                insert into dblib.cdm_task_detail
                select *
                from cdmmart.cdm_task_detail as a
                where a.task_version_id not in (select task_version_id from dblib.cdm_task_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_TASK_DETAIL;
            quit;

            %ErrorCheck(CDM_TASK_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                             limit_by_total_impression_flg = limit_by_to_impression_flg_tmp
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
                    updated_dttm = updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_rtc_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table rtc_detail_tmp
                  ( rtc_id                 VARCHAR2(36) NOT NULL ,
                    task_occurrence_no     INTEGER NULL ,
                    processed_dttm         TIMESTAMP NOT NULL ,
                    response_tracking_flg  CHAR(1) NULL ,
                    segment_version_id     VARCHAR2(36) NULL ,
                    task_version_id        VARCHAR(36) NOT NULL ,
                    execution_status_cd    VARCHAR2(30) NULL ,
                    deleted_flg            CHAR(1) NULL ,
                    occurrence_id          VARCHAR2(36) NULL ,
                    source_system_cd       VARCHAR2(10) NULL ,
                    updated_by_nm          VARCHAR2(60) NULL ,
                    updated_dttm           TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table rtc_detail_tmp
                    add constraint rtc_detail_tmp_pk primary key (rtc_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.rtc_detail_tmp
                select *
                from cdmmart.cdm_rtc_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_rtc_detail using rtc_detail_tmp
                        on (cdm_rtc_detail.rtc_id = rtc_detail_tmp.rtc_id)

                    when matched then update
                    set cdm_rtc_detail.task_occurrence_no = rtc_detail_tmp.task_occurrence_no,
                        cdm_rtc_detail.processed_dttm = rtc_detail_tmp.processed_dttm,
                        cdm_rtc_detail.response_tracking_flg = rtc_detail_tmp.response_tracking_flg,
                        cdm_rtc_detail.segment_version_id = rtc_detail_tmp.segment_version_id,
                        cdm_rtc_detail.task_version_id = rtc_detail_tmp.task_version_id,
                        cdm_rtc_detail.execution_status_cd = rtc_detail_tmp.execution_status_cd,
                        cdm_rtc_detail.deleted_flg = rtc_detail_tmp.deleted_flg,
                        cdm_rtc_detail.occurrence_id = rtc_detail_tmp.occurrence_id,
                        cdm_rtc_detail.source_system_cd = rtc_detail_tmp.source_system_cd,
                        cdm_rtc_detail.updated_by_nm = rtc_detail_tmp.updated_by_nm,
                        cdm_rtc_detail.updated_dttm = rtc_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_rtc_detail.rtc_id,
                        cdm_rtc_detail.task_occurrence_no,
                        cdm_rtc_detail.processed_dttm,
                        cdm_rtc_detail.response_tracking_flg,
                        cdm_rtc_detail.segment_version_id,
                        cdm_rtc_detail.task_version_id,
                        cdm_rtc_detail.execution_status_cd,
                        cdm_rtc_detail.deleted_flg,
                        cdm_rtc_detail.occurrence_id,
                        cdm_rtc_detail.source_system_cd,
                        cdm_rtc_detail.updated_by_nm,
                        cdm_rtc_detail.updated_dttm
                      )
                    values
                      ( rtc_detail_tmp.rtc_id,
                        rtc_detail_tmp.task_occurrence_no,
                        rtc_detail_tmp.processed_dttm,
                        rtc_detail_tmp.response_tracking_flg,
                        rtc_detail_tmp.segment_version_id,
                        rtc_detail_tmp.task_version_id,
                        rtc_detail_tmp.execution_status_cd,
                        rtc_detail_tmp.deleted_flg,
                        rtc_detail_tmp.occurrence_id,
                        rtc_detail_tmp.source_system_cd,
                        rtc_detail_tmp.updated_by_nm,
                        rtc_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_RTC_DETAIL;

                execute (drop table rtc_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_RTC_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_rtc_detail as u
                    set task_occurrence_no =
                            (select task_occurrence_no from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        processed_dttm =
                            (select processed_dttm from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        response_tracking_flg =
                            (select response_tracking_flg from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        segment_version_id =
                            (select segment_version_id from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        task_version_id =
                            (select task_version_id from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        execution_status_cd =
                            (select execution_status_cd from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        deleted_flg =
                            (select deleted_flg from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        occurrence_id =
                            (select occurrence_id from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_rtc_detail as a
                             where u.rtc_id = a.rtc_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RTC_DETAIL;

                insert into dblib.cdm_rtc_detail
                select *
                from cdmmart.cdm_rtc_detail as a
                where a.rtc_id not in (select rtc_id from dblib.cdm_rtc_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RTC_DETAIL;
            quit;

            %ErrorCheck(CDM_RTC_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                             updated_dttm=updated_dttm_tmp));

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;

/*
 *  This table is not available yet.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_identity_type)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table identity_type_tmp
                  ( identity_type_cd       VARCHAR2(40) NOT NULL ,
                    identity_type_desc     VARCHAR2(100) NULL ,
                    updated_by_nm          VARCHAR2(60) NULL ,
                    updated_dttm           TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table identity_type_tmp
                    add constraint identity_type_tmp_pk primary key (identity_type_cd)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.identity_type_tmp
                select *
                from cdmmart.cdm_identity_type;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_identity_type using identity_type_tmp
                        on (cdm_identity_type.identity_type_cd = identity_type_tmp.identity_type_cd)

                    when matched then update
                    set cdm_identity_type.identity_type_desc = identity_type_tmp.identity_type_desc,
                        cdm_identity_type.updated_by_nm = identity_type_tmp.updated_by_nm,
                        cdm_identity_type.updated_dttm = identity_type_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_identity_type.identity_type_cd,
                        cdm_identity_type.identity_type_desc,
                        cdm_identity_type.updated_by_nm,
                        cdm_identity_type.updated_dttm
                      )
                    values
                      ( identity_type_tmp.identity_type_cd,
                        identity_type_tmp.identity_type_desc,
                        identity_type_tmp.updated_by_nm,
                        identity_type_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_IDENTITY_TYPE;

                execute (drop table identity_type_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_IDENTITY_TYPE);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_identity_type as u
                    set identity_type_desc =
                            (select identity_type_cd from cdmmart.cdm_identity_type as a
                             where u.identity_type_cd = a.identity_type_cd),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_identity_type as a
                             where u.identity_type_cd = a.identity_type_cd),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_identity_type as a
                             where u.identity_type_cd = a.identity_type_cd)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_IDENTITY_TYPE;

                insert into dblib.cdm_identity_type
                select *
                from cdmmart.cdm_identity_type as a
                where a.identity_type_cd not in (select identity_type_cd from dblib.cdm_identity_type);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_IDENTITY_TYPE;
            quit;

            %ErrorCheck(CDM_identity_type);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;
*/

    %if %sysfunc(exist(cdmmart.cdm_identity_map)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table identity_map_tmp
                  ( identity_id        VARCHAR2(36) NOT NULL ,
                    identity_type_cd   VARCHAR2(40) NULL ,
                    updated_by_nm      VARCHAR2(60) NULL ,
                    updated_dttm       TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table identity_map_tmp
                    add constraint identity_map_tmp_pk primary key (identity_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.identity_map_tmp
                select *
                from cdmmart.cdm_identity_map;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_identity_map using identity_map_tmp
                        on (cdm_identity_map.identity_id = identity_map_tmp.identity_id)

                    when matched then update
                    set cdm_identity_map.identity_type_cd = identity_map_tmp.identity_type_cd,
                        cdm_identity_map.updated_by_nm = identity_map_tmp.updated_by_nm,
                        cdm_identity_map.updated_dttm = identity_map_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_identity_map.identity_id,
                        cdm_identity_map.identity_type_cd,
                        cdm_identity_map.updated_by_nm,
                        cdm_identity_map.updated_dttm
                      )
                    values
                      ( identity_map_tmp.identity_id,
                        identity_map_tmp.identity_type_cd,
                        identity_map_tmp.updated_by_nm,
                        identity_map_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_IDENTITY_MAP;

                execute (drop table identity_map_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_IDENTITY_MAP);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_identity_map as u
                    set identity_type_cd =
                            (select identity_type_cd from cdmmart.cdm_identity_map as a
                             where u.identity_id = a.identity_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_identity_map as a
                             where u.identity_id = a.identity_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_identity_map as a
                             where u.identity_id = a.identity_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_IDENTITY_MAP;

                insert into dblib.cdm_identity_map
                select *
                from cdmmart.cdm_identity_map as a
                where a.identity_id not in (select identity_id from dblib.cdm_identity_map);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_IDENTITY_MAP;
            quit;

            %ErrorCheck(CDM_IDENTITY_MAP);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_contact_history)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table contact_history_tmp
                  ( contact_id                 VARCHAR2(36) NOT NULL ,
                    identity_id                VARCHAR2(36) NOT NULL ,
                    contact_nm                 VARCHAR2(256) NULL ,
                    contact_dt                 DATE NULL ,
                    contact_dttm               TIMESTAMP NULL ,
                    contact_status_cd          VARCHAR2(3) NULL ,
                    optimization_backfill_flg  CHAR(1) NULL ,
                    external_contact_info_1_id VARCHAR2(32) NULL ,
                    external_contact_info_2_id VARCHAR2(32) NULL ,
                    rtc_id                     VARCHAR2(36) NULL ,
                    source_system_cd           VARCHAR2(10) NULL ,
                    updated_by_nm              VARCHAR2(60) NULL ,
                    updated_dttm               TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table contact_history_tmp
                    add constraint contact_history_tmp_pk primary key (contact_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.contact_history_tmp
                select *
                from cdmmart.cdm_contact_history;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_contact_history using contact_history_tmp
                        on (cdm_contact_history.contact_id = contact_history_tmp.contact_id)

                    when matched then update
                    set cdm_contact_history.identity_id = contact_history_tmp.identity_id,
                        cdm_contact_history.contact_nm = contact_history_tmp.contact_nm,
                        cdm_contact_history.contact_dt = contact_history_tmp.contact_dt,
                        cdm_contact_history.contact_dttm = contact_history_tmp.contact_dttm,
                        cdm_contact_history.contact_status_cd = contact_history_tmp.contact_status_cd,
                        cdm_contact_history.optimization_backfill_flg = contact_history_tmp.optimization_backfill_flg,
                        cdm_contact_history.external_contact_info_1_id = contact_history_tmp.external_contact_info_1_id,
                        cdm_contact_history.external_contact_info_2_id = contact_history_tmp.external_contact_info_2_id,
                        cdm_contact_history.rtc_id = contact_history_tmp.rtc_id,
                        cdm_contact_history.source_system_cd = contact_history_tmp.source_system_cd,
                        cdm_contact_history.updated_by_nm = contact_history_tmp.updated_by_nm,
                        cdm_contact_history.updated_dttm = contact_history_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_contact_history.contact_id,
                        cdm_contact_history.identity_id,
                        cdm_contact_history.contact_nm,
                        cdm_contact_history.contact_dt,
                        cdm_contact_history.contact_dttm,
                        cdm_contact_history.contact_status_cd,
                        cdm_contact_history.optimization_backfill_flg,
                        cdm_contact_history.external_contact_info_1_id,
                        cdm_contact_history.external_contact_info_2_id,
                        cdm_contact_history.rtc_id,
                        cdm_contact_history.source_system_cd,
                        cdm_contact_history.updated_by_nm,
                        cdm_contact_history.updated_dttm
                      )
                    values
                      ( contact_history_tmp.contact_id,
                        contact_history_tmp.identity_id,
                        contact_history_tmp.contact_nm,
                        contact_history_tmp.contact_dt,
                        contact_history_tmp.contact_dttm,
                        contact_history_tmp.contact_status_cd,
                        contact_history_tmp.optimization_backfill_flg,
                        contact_history_tmp.external_contact_info_1_id,
                        contact_history_tmp.external_contact_info_2_id,
                        contact_history_tmp.rtc_id,
                        contact_history_tmp.source_system_cd,
                        contact_history_tmp.updated_by_nm,
                        contact_history_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CONTACT_HISTORY;

                execute (drop table contact_history_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_CONTACT_HISTORY);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_contact_history as u
                    set identity_id =
                            (select identity_id from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        contact_nm =
                            (select contact_nm from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        contact_dt =
                            (select contact_dt from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        contact_dttm =
                            (select contact_dttm from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        contact_status_cd =
                            (select contact_status_cd from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        optimization_backfill_flg =
                            (select optimization_backfill_flg from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        external_contact_info_1_id =
                            (select external_contact_info_1_id from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        external_contact_info_2_id =
                            (select external_contact_info_2_id from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        rtc_id =
                            (select rtc_id from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_contact_history as a
                             where u.contact_id = a.contact_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CONTACT_HISTORY;

                insert into dblib.cdm_contact_history
                select *
                from cdmmart.cdm_contact_history as a
                where a.contact_id not in (select contact_id from dblib.cdm_contact_history);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CONTACT_HISTORY;
            quit;

            %ErrorCheck(CDM_CONTACT_HISTORY);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                             updated_dttm=updated_dttm_tmp));

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
                    rtc_id=rtc_id_tmp ;
                    source_system_cd=source_system_cd_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_content_detail)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table content_detail_tmp
                  ( content_version_id          VARCHAR2(40) NOT NULL ,
                    content_id                  VARCHAR2(40) NULL ,
                    valid_from_dttm             TIMESTAMP NOT NULL ,
                    valid_to_dttm               TIMESTAMP NULL ,
                    contact_content_nm          VARCHAR2(256) NULL ,
                    contact_content_desc        CLOB NULL ,
                    contact_content_type_nm     VARCHAR2(50) NULL ,
                    contact_content_status_cd   VARCHAR2(60) NULL ,
                    contact_content_category_nm VARCHAR2(256) NULL ,
                    contact_content_class_nm    VARCHAR2(100) NULL ,
                    contact_content_cd          VARCHAR2(60) NULL ,
                    active_flg                  CHAR(1) NULL ,
                    owner_nm                    VARCHAR2(100) NULL ,
                    created_user_nm             VARCHAR2(100) NULL ,
                    created_dt                  DATE NULL ,
                    external_reference_txt      VARCHAR2(1024) NULL ,
                    external_reference_url_txt  VARCHAR2(1024) NULL ,
                    source_system_cd            VARCHAR2(10) NULL ,
                    updated_by_nm               VARCHAR2(60) NULL ,
                    updated_dttm                TIMESTAMP NULL

                  )) by oracle;

                execute
                  ( alter table content_detail_tmp
                    add constraint content_detail_tmp_pk primary key (content_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.content_detail_tmp
                select *
                from cdmmart.cdm_content_detail;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_content_detail using content_detail_tmp
                        on (cdm_content_detail.content_version_id = content_detail_tmp.content_version_id)

                    when matched then update
                    set cdm_content_detail.content_id = content_detail_tmp.content_id,
                        cdm_content_detail.valid_from_dttm = content_detail_tmp.valid_from_dttm,
                        cdm_content_detail.valid_to_dttm = content_detail_tmp.valid_to_dttm,
                        cdm_content_detail.contact_content_nm = content_detail_tmp.contact_content_nm,
                        cdm_content_detail.contact_content_desc = content_detail_tmp.contact_content_desc,
                        cdm_content_detail.contact_content_type_nm = content_detail_tmp.contact_content_type_nm,
                        cdm_content_detail.contact_content_status_cd = content_detail_tmp.contact_content_status_cd,
                        cdm_content_detail.contact_content_category_nm = content_detail_tmp.contact_content_category_nm,
                        cdm_content_detail.contact_content_class_nm = content_detail_tmp.contact_content_class_nm,
                        cdm_content_detail.contact_content_cd = content_detail_tmp.contact_content_cd,
                        cdm_content_detail.active_flg = content_detail_tmp.active_flg,
                        cdm_content_detail.owner_nm = content_detail_tmp.owner_nm,
                        cdm_content_detail.created_user_nm = content_detail_tmp.created_user_nm,
                        cdm_content_detail.created_dt = content_detail_tmp.created_dt,
                        cdm_content_detail.external_reference_txt = content_detail_tmp.external_reference_txt,
                        cdm_content_detail.external_reference_url_txt = content_detail_tmp.external_reference_url_txt,
                        cdm_content_detail.source_system_cd = content_detail_tmp.source_system_cd,
                        cdm_content_detail.updated_by_nm = content_detail_tmp.updated_by_nm,
                        cdm_content_detail.updated_dttm = content_detail_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_content_detail.content_version_id,
                        cdm_content_detail.content_id,
                        cdm_content_detail.valid_from_dttm,
                        cdm_content_detail.valid_to_dttm,
                        cdm_content_detail.contact_content_nm,
                        cdm_content_detail.contact_content_desc,
                        cdm_content_detail.contact_content_type_nm,
                        cdm_content_detail.contact_content_status_cd,
                        cdm_content_detail.contact_content_category_nm,
                        cdm_content_detail.contact_content_class_nm,
                        cdm_content_detail.contact_content_cd,
                        cdm_content_detail.active_flg,
                        cdm_content_detail.owner_nm,
                        cdm_content_detail.created_user_nm,
                        cdm_content_detail.created_dt,
                        cdm_content_detail.external_reference_txt,
                        cdm_content_detail.external_reference_url_txt,
                        cdm_content_detail.source_system_cd,
                        cdm_content_detail.updated_by_nm,
                        cdm_content_detail.updated_dttm
                      )
                    values
                      ( content_detail_tmp.content_version_id,
                        content_detail_tmp.content_id,
                        content_detail_tmp.valid_from_dttm,
                        content_detail_tmp.valid_to_dttm,
                        content_detail_tmp.contact_content_nm,
                        content_detail_tmp.contact_content_desc,
                        content_detail_tmp.contact_content_type_nm,
                        content_detail_tmp.contact_content_status_cd,
                        content_detail_tmp.contact_content_category_nm,
                        content_detail_tmp.contact_content_class_nm,
                        content_detail_tmp.contact_content_cd,
                        content_detail_tmp.active_flg,
                        content_detail_tmp.owner_nm,
                        content_detail_tmp.created_user_nm,
                        content_detail_tmp.created_dt,
                        content_detail_tmp.external_reference_txt,
                        content_detail_tmp.external_reference_url_txt,
                        content_detail_tmp.source_system_cd,
                        content_detail_tmp.updated_by_nm,
                        content_detail_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CONTENT_DETAIL;

                execute (drop table content_detail_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_CONTENT_DETAIL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_content_detail as u
                    set content_id =
                            (select content_id from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        valid_from_dttm =
                            (select valid_from_dttm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_nm =
                            (select contact_content_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_desc =
                            (select contact_content_desc from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_type_nm =
                            (select contact_content_type_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_status_cd =
                            (select contact_content_status_cd from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_category_nm =
                            (select contact_content_category_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_class_nm =
                            (select contact_content_class_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        contact_content_cd =
                            (select contact_content_cd from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        active_flg =
                            (select active_flg from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        owner_nm =
                            (select owner_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        created_user_nm =
                            (select created_user_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        created_dt =
                            (select created_dt from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        external_reference_txt =
                            (select external_reference_txt from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        external_reference_url_txt =
                            (select external_reference_url_txt from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_content_detail as a
                             where u.content_version_id = a.content_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CONTENT_DETAIL;

                insert into dblib.cdm_content_detail
                select *
                from cdmmart.cdm_content_detail as a
                where a.content_version_id not in (select content_version_id from dblib.cdm_content_detail);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CONTENT_DETAIL;
            quit;

            %ErrorCheck(CDM_CONTENT_DETAIL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_content_custom_attr)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table content_custom_attr_tmp
                  ( content_version_id      VARCHAR2(40) NOT NULL ,
                    attribute_nm            VARCHAR2(256) NOT NULL ,
                    attribute_data_type_cd  VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val   NUMBER(17,2) NULL ,
                    attribute_dttm_val      TIMESTAMP NULL ,
                    extension_attribute_nm  VARCHAR2(256) NULL,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table content_custom_attr_tmp
                    add constraint content_custom_attr_tmp_pk primary key (content_version_id,attribute_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.content_custom_attr_tmp
                select *
                from cdmmart.cdm_content_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_content_custom_attr using content_custom_attr_tmp
                        on (cdm_content_custom_attr.content_version_id = content_custom_attr_tmp.content_version_id and
                            cdm_content_custom_attr.attribute_nm = content_custom_attr_tmp.attribute_nm)

                    when matched then update
                    set cdm_content_custom_attr.attribute_data_type_cd = content_custom_attr_tmp.attribute_data_type_cd,
                        cdm_content_custom_attr.attribute_character_val = content_custom_attr_tmp.attribute_character_val,
                        cdm_content_custom_attr.attribute_numeric_val = content_custom_attr_tmp.attribute_numeric_val,
                        cdm_content_custom_attr.attribute_dttm_val = content_custom_attr_tmp.attribute_dttm_val,
                        cdm_content_custom_attr.extension_attribute_nm = content_custom_attr_tmp.extension_attribute_nm,
                        cdm_content_custom_attr.updated_by_nm = content_custom_attr_tmp.updated_by_nm,
                        cdm_content_custom_attr.updated_dttm = content_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_content_custom_attr.content_version_id,
                        cdm_content_custom_attr.attribute_nm,
                        cdm_content_custom_attr.attribute_data_type_cd,
                        cdm_content_custom_attr.attribute_character_val,
                        cdm_content_custom_attr.attribute_numeric_val,
                        cdm_content_custom_attr.attribute_dttm_val,
                        cdm_content_custom_attr.extension_attribute_nm,
                        cdm_content_custom_attr.updated_by_nm,
                        cdm_content_custom_attr.updated_dttm
                      )
                    values
                      ( content_custom_attr_tmp.content_version_id,
                        content_custom_attr_tmp.attribute_nm,
                        content_custom_attr_tmp.attribute_data_type_cd,
                        content_custom_attr_tmp.attribute_character_val,
                        content_custom_attr_tmp.attribute_numeric_val,
                        content_custom_attr_tmp.attribute_dttm_val,
                        content_custom_attr_tmp.extension_attribute_nm,
                        content_custom_attr_tmp.updated_by_nm,
                        content_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table content_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_CONTENT_CUSTOM_ATTR;

            %ErrorCheck(CDM_CONTENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_content_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        extension_attribute_nm =
                            (select extension_attribute_nm from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_content_custom_attr as a
                             where u.content_version_id = a.content_version_id and
                                   u.attribute_nm = a.attribute_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_CONTENT_CUSTOM_ATTR;

                insert into dblib.cdm_content_custom_attr
                select *
                from cdmmart.cdm_content_custom_attr as a
                where a.content_version_id not in (select content_version_id from dblib.cdm_content_custom_attr)
                and a.attribute_nm not in (select attribute_nm from dblib.cdm_content_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_CONTENT_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_CONTENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_content_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_content_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
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
                    (cntllev=rec dbkey=(content_version_id attribute_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    extension_attribute_nm = extension_attribute_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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
    %end;

/*
 *  This table is populated by MA and doesn't need to be loaded by this process.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_dyn_content_custom_attr)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table dyn_content_custom_attr_tmp
                  ( contact_id              VARCHAR2(36) NOT NULL ,
                    attribute_nm            VARCHAR2(256) NOT NULL ,
                    content_version_id     VARCHAR2(40) NOT NULL,
                    attribute_data_type_cd  VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val   NUMBER(17,2) NULL ,
                    attribute_dttm_val      TIMESTAMP NULL ,
                    extension_attribute_nm  VARCHAR2(256) NULL,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table dyn_content_custom_attr_tmp
                    add constraint dyn_content_custom_attr_tmp_pk primary key (contact_id,attribute_nm,content_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.dyn_content_custom_attr_tmp
                select *
                from cdmmart.cdm_dyn_content_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_dyn_content_custom_attr using dyn_content_custom_attr_tmp
                        on (cdm_dyn_content_custom_attr.contact_id = dyn_content_custom_attr_tmp.contact_id and
                            cdm_dyn_content_custom_attr.attribute_nm = dyn_content_custom_attr_tmp.attribute_nm and
                            cdm_dyn_content_custom_attr.content_version_id = dyn_content_custom_attr_tmp.content_version_id)

                    when matched then update
                    set cdm_dyn_content_custom_attr.attribute_data_type_cd = dyn_content_custom_attr_tmp.attribute_data_type_cd,
                        cdm_dyn_content_custom_attr.attribute_character_val = dyn_content_custom_attr_tmp.attribute_character_val,
                        cdm_dyn_content_custom_attr.attribute_numeric_val = dyn_content_custom_attr_tmp.attribute_numeric_val,
                        cdm_dyn_content_custom_attr.attribute_dttm_val = dyn_content_custom_attr_tmp.attribute_dttm_val,
                        cdm_dyn_content_custom_attr.extension_attribute_nm = dyn_content_custom_attr_tmp.extension_attribute_nm,
                        cdm_dyn_content_custom_attr.updated_by_nm = dyn_content_custom_attr_tmp.updated_by_nm,
                        cdm_dyn_content_custom_attr.updated_dttm = dyn_content_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_dyn_content_custom_attr.contact_id,
                        cdm_dyn_content_custom_attr.attribute_nm,
                        cdm_dyn_content_custom_attr.content_version_id,
                        cdm_dyn_content_custom_attr.attribute_data_type_cd,
                        cdm_dyn_content_custom_attr.attribute_character_val,
                        cdm_dyn_content_custom_attr.attribute_numeric_val,
                        cdm_dyn_content_custom_attr.attribute_dttm_val,
                        cdm_dyn_content_custom_attr.extension_attribute_nm,
                        cdm_dyn_content_custom_attr.updated_by_nm,
                        cdm_dyn_content_custom_attr.updated_dttm
                      )
                    values
                      ( dyn_content_custom_attr_tmp.contact_id,
                        dyn_content_custom_attr_tmp.attribute_nm,
                        dyn_content_custom_attr_tmp.content_version_id,
                        dyn_content_custom_attr_tmp.attribute_data_type_cd,
                        dyn_content_custom_attr_tmp.attribute_character_val,
                        dyn_content_custom_attr_tmp.attribute_numeric_val,
                        dyn_content_custom_attr_tmp.attribute_dttm_val,
                        dyn_content_custom_attr_tmp.extension_attribute_nm,
                        dyn_content_custom_attr_tmp.updated_by_nm,
                        dyn_content_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table dyn_content_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_DYN_CONTENT_CUSTOM_ATTR;

            %ErrorCheck(CDM_DYN_CONTENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_dyn_content_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id),
                        extension_attribute_nm =
                            (select extension_attribute_nm from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_dyn_content_custom_attr as a
                             where u.contact_id = a.contact_id and
                                   u.attribute_nm = a.attribute_nm and
                                   u.content_version_id = a.content_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_DYN_CONTENT_CUSTOM_ATTR;

                insert into dblib.cdm_dyn_content_custom_attr
                select *
                from cdmmart.cdm_dyn_content_custom_attr as a
                where a.contact_id not in (select contact_id from dblib.cdm_dyn_content_custom_attr)
                and a.attribute_nm not in (select attribute_nm from dblib.cdm_dyn_content_custom_attr)
                and a.content_version_id not in (select content_version_id from dblib.cdm_dyn_content_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_DYN_CONTENT_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_DYN_CONTENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_dyn_content_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_dyn_content_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
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

                modify dblib.cdm_dyn_content_custom_attr
                    (cntllev=rec dbkey=(contact_id attribute_nm content_version_id)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    extension_attribute_nm = extension_attribute_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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

            %put %sysfunc(datetime(),E8601DT25.) ---     &uobs rows updated, &oobs added to table CDM_DYN_CONTENT_CUSTOM_ATTR;

            %ErrorCheck(CDM_DYN_CONTENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
    %end;
*/

    %if %sysfunc(exist(cdmmart.cdm_identifier_type)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table identifier_type_tmp
                  ( identifier_type_id       VARCHAR2(36) NOT NULL ,
                    identifier_type_desc     VARCHAR2(100) NULL ,
                    updated_by_nm          VARCHAR2(60) NULL ,
                    updated_dttm           TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table identifier_type_tmp
                    add constraint identifier_type_tmp_pk primary key (identifier_type_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.identifier_type_tmp
                select *
                from cdmmart.cdm_identifier_type;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_identifier_type using identifier_type_tmp
                        on (cdm_identifier_type.identifier_type_id = identifier_type_tmp.identifier_type_id)

                    when matched then update
                    set cdm_identifier_type.identifier_type_desc = identifier_type_tmp.identifier_type_desc,
                        cdm_identifier_type.updated_by_nm = identifier_type_tmp.updated_by_nm,
                        cdm_identifier_type.updated_dttm = identifier_type_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_identifier_type.identifier_type_id,
                        cdm_identifier_type.identifier_type_desc,
                        cdm_identifier_type.updated_by_nm,
                        cdm_identifier_type.updated_dttm
                      )
                    values
                      ( identifier_type_tmp.identifier_type_id,
                        identifier_type_tmp.identifier_type_desc,
                        identifier_type_tmp.updated_by_nm,
                        identifier_type_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_IDENTIFIER_TYPE;

                execute (drop table identifier_type_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_IDENTIFIER_TYPE);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_identifier_type as u
                    set identifier_type_desc =
                            (select identifier_type_desc from cdmmart.cdm_identifier_type as a
                             where u.identifier_type_id = a.identifier_type_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_identifier_type as a
                             where u.identifier_type_id = a.identifier_type_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_identifier_type as a
                             where u.identifier_type_id = a.identifier_type_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_IDENTIFIER_TYPE;

                insert into dblib.cdm_identifier_type
                select *
                from cdmmart.cdm_identifier_type as a
                where a.identifier_type_id not in (select identifier_type_id from dblib.cdm_identifier_type);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_IDENTIFIER_TYPE;
            quit;

            %ErrorCheck(CDM_IDENTIFIER_TYPE);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_identity_attr)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table identity_attr_tmp
                  ( identity_id          VARCHAR2(36) NOT NULL ,
                    identifier_type_id   VARCHAR2(36) NOT NULL ,
                    valid_from_dttm      TIMESTAMP NOT NULL ,
                    valid_to_dttm        TIMESTAMP NULL ,
                    user_identifier_val  LONG VARCHAR NULL ,
/*                    user_identifier_val  VARCHAR2(5000) NULL , */
                    entry_dttm           TIMESTAMP NULL ,
                    source_system_cd     VARCHAR2(10) NULL ,
                    updated_by_nm        VARCHAR2(60) NULL ,
                    updated_dttm         TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table identity_attr_tmp
                    add constraint identity_attr_tmp_pk primary key (identity_id, identifier_type_id, valid_from_dttm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.identity_attr_tmp
                select *
                from cdmmart.cdm_identity_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_identity_attr using identity_attr_tmp
                        on (cdm_identity_attr.identity_id = identity_attr_tmp.identity_id and
                            cdm_identity_attr.identifier_type_id = identity_attr_tmp.identifier_type_id and
                            cdm_identity_attr.valid_from_dttm = identity_attr_tmp.valid_from_dttm)

                    when matched then update
                    set cdm_identity_attr.valid_to_dttm = identity_attr_tmp.valid_to_dttm,
                        cdm_identity_attr.user_identifier_val = identity_attr_tmp.user_identifier_val,
                        cdm_identity_attr.entry_dttm = identity_attr_tmp.entry_dttm,
                        cdm_identity_attr.source_system_cd = identity_attr_tmp.source_system_cd,
                        cdm_identity_attr.updated_by_nm = identity_attr_tmp.updated_by_nm,
                        cdm_identity_attr.updated_dttm = identity_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_identity_attr.identity_id,
                        cdm_identity_attr.identifier_type_id,
                        cdm_identity_attr.valid_from_dttm,
                        cdm_identity_attr.valid_to_dttm,
                        cdm_identity_attr.user_identifier_val,
                        cdm_identity_attr.entry_dttm,
                        cdm_identity_attr.source_system_cd,
                        cdm_identity_attr.updated_by_nm,
                        cdm_identity_attr.updated_dttm
                      )
                    values
                      ( identity_attr_tmp.identity_id,
                        identity_attr_tmp.identifier_type_id,
                        identity_attr_tmp.valid_from_dttm,
                        identity_attr_tmp.valid_to_dttm,
                        identity_attr_tmp.user_identifier_val,
                        identity_attr_tmp.entry_dttm,
                        identity_attr_tmp.source_system_cd,
                        identity_attr_tmp.updated_by_nm,
                        identity_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_IDENTITY_ATTR;

                execute (drop table identity_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_IDENTITY_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_identity_attr as u
                    set valid_to_dttm =
                            (select valid_to_dttm from cdmmart.cdm_identity_attr as a
                             where u.identity_id = a.identity_id and
                                   u.identifier_type_id = a.identifier_type_id and
                                   u.valid_from_dttm = a.valid_from_dttm),
                        user_identifier_val =
                            (select user_identifier_val from cdmmart.cdm_identity_attr as a
                             where u.identity_id = a.identity_id and
                                   u.identifier_type_id = a.identifier_type_id and
                                   u.valid_from_dttm = a.valid_from_dttm),
                        entry_dttm =
                            (select entry_dttm from cdmmart.cdm_identity_attr as a
                             where u.identity_id = a.identity_id and
                                   u.identifier_type_id = a.identifier_type_id and
                                   u.valid_from_dttm = a.valid_from_dttm),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_identity_attr as a
                             where u.identity_id = a.identity_id and
                                   u.identifier_type_id = a.identifier_type_id and
                                   u.valid_from_dttm = a.valid_from_dttm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_identity_attr as a
                             where u.identity_id = a.identity_id and
                                   u.identifier_type_id = a.identifier_type_id and
                                   u.valid_from_dttm = a.valid_from_dttm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_identity_attr as a
                             where u.identity_id = a.identity_id and
                                   u.identifier_type_id = a.identifier_type_id and
                                   u.valid_from_dttm = a.valid_from_dttm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_IDENTITY_ATTR;

                insert into dblib.cdm_identity_attr
                select *
                from cdmmart.cdm_identity_attr as a
                where a.identity_id not in (select identity_id from dblib.cdm_identity_attr) and
                      a.identifier_type_id not in (select identifier_type_id from dblib.cdm_identity_attr) and
                      a.valid_from_dttm not in (select valid_from_dttm from dblib.cdm_identity_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_IDENTITY_ATTR;
            quit;

            %ErrorCheck(CDM_IDENTITY_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;

    %if %sysfunc(exist(cdmmart.cdm_response_channel)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table response_channel_tmp
                  ( response_channel_cd   VARCHAR2(20) NOT NULL ,
                    response_channel_nm   VARCHAR2(60) NULL ,
                    updated_by_nm         VARCHAR2(60) NULL ,
                    updated_dttm          TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table response_channel_tmp
                    add constraint response_channel_tmp_pk primary key (response_channel_cd)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.response_channel_tmp
                select *
                from cdmmart.cdm_response_channel;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_response_channel using response_channel_tmp
                        on (cdm_response_channel.response_channel_cd = response_channel_tmp.response_channel_cd)

                    when matched then update
                    set cdm_response_channel.response_channel_nm = response_channel_tmp.response_channel_nm,
                        cdm_response_channel.updated_by_nm = response_channel_tmp.updated_by_nm,
                        cdm_response_channel.updated_dttm = response_channel_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_response_channel.response_channel_cd,
                        cdm_response_channel.response_channel_nm,
                        cdm_response_channel.updated_by_nm,
                        cdm_response_channel.updated_dttm
                      )
                    values
                      ( response_channel_tmp.response_channel_cd,
                        response_channel_tmp.response_channel_nm,
                        response_channel_tmp.updated_by_nm,
                        response_channel_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_RESPONSE_CHANNEL;

                execute (drop table response_channel_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_RESPONSE_CHANNEL);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_response_channel as u
                    set response_channel_nm =
                            (select response_channel_nm from cdmmart.cdm_response_channel as a
                             where u.response_channel_cd = a.response_channel_cd),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_response_channel as a
                             where u.response_channel_cd = a.response_channel_cd),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_response_channel as a
                             where u.response_channel_cd = a.response_channel_cd)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RESPONSE_CHANNEL;

                insert into dblib.cdm_response_channel
                select *
                from cdmmart.cdm_response_channel as a
                where a.response_channel_cd not in (select response_channel_cd from dblib.cdm_response_channel);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RESPONSE_CHANNEL;
            quit;

            %ErrorCheck(CDM_RESPONSE_CHANNEL);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_response_lookup)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table response_lookup_tmp
                  ( response_cd     VARCHAR2(20) NOT NULL ,
                    response_nm     VARCHAR2(256) NULL ,
                    updated_by_nm   VARCHAR2(60) NULL ,
                    updated_dttm    TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table response_lookup_tmp
                    add constraint response_lookup_tmp_pk primary key (response_cd)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.response_lookup_tmp
                select *
                from cdmmart.cdm_response_lookup;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_response_lookup using response_lookup_tmp
                        on (cdm_response_lookup.response_cd = response_lookup_tmp.response_cd)

                    when matched then update
                    set cdm_response_lookup.response_nm = response_lookup_tmp.response_nm,
                        cdm_response_lookup.updated_by_nm = response_lookup_tmp.updated_by_nm,
                        cdm_response_lookup.updated_dttm = response_lookup_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_response_lookup.response_cd,
                        cdm_response_lookup.response_nm,
                        cdm_response_lookup.updated_by_nm,
                        cdm_response_lookup.updated_dttm
                      )
                    values
                      ( response_lookup_tmp.response_cd,
                        response_lookup_tmp.response_nm,
                        response_lookup_tmp.updated_by_nm,
                        response_lookup_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_RESPONSE_LOOKUP;

                execute (drop table response_lookup_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_RESPONSE_LOOKUP);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_response_lookup as u
                    set response_nm =
                            (select response_nm from cdmmart.cdm_response_lookup as a
                             where u.response_cd = a.response_cd),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_response_lookup as a
                             where u.response_cd = a.response_cd),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_response_lookup as a
                             where u.response_cd = a.response_cd)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RESPONSE_LOOKUP;

                insert into dblib.cdm_response_lookup
                select *
                from cdmmart.cdm_response_lookup as a
                where a.response_cd not in (select response_cd from dblib.cdm_response_lookup);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RESPONSE_LOOKUP;
            quit;

            %ErrorCheck(CDM_RESPONSE_LOOKUP);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;


/*
 *  This table is populated by MA and doesn't need to be loaded by this process.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_response_type)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table response_type_tmp
                  ( response_type_cd       VARCHAR2(60) NOT NULL ,
                    response_type_desc     VARCHAR2(256) NULL ,
                    updated_by_nm          VARCHAR2(60) NULL ,
                    updated_dttm           TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table response_type_tmp
                    add constraint response_type_tmp_pk primary key (response_type_cd)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.response_type_tmp
                select *
                from cdmmart.cdm_response_type;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_response_type using response_type_tmp
                        on (cdm_response_type.response_type_cd = response_type_tmp.response_type_cd)

                    when matched then update
                    set cdm_response_type.response_type_desc = response_type_tmp.response_type_desc,
                        cdm_response_type.updated_by_nm = response_type_tmp.updated_by_nm,
                        cdm_response_type.updated_dttm = response_type_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_response_type.response_type_cd,
                        cdm_response_type.response_type_desc,
                        cdm_response_type.updated_by_nm,
                        cdm_response_type.updated_dttm
                      )
                    values
                      ( response_type_tmp.response_type_cd,
                        response_type_tmp.response_type_desc,
                        response_type_tmp.updated_by_nm,
                        response_type_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_RESPONSE_TYPE;

                execute (drop table response_type_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_RESPONSE_TYPE);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_response_type as u
                    set response_type_desc =
                            (select response_type_desc from cdmmart.cdm_response_type as a
                             where u.response_type_cd = a.response_type_cd),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_response_type as a
                             where u.response_type_cd = a.response_type_cd),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_response_type as a
                             where u.response_type_cd = a.response_type_cd)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RESPONSE_TYPE;

                insert into dblib.cdm_response_type
                select *
                from cdmmart.cdm_response_type as a
                where a.response_type_cd not in (select response_type_cd from dblib.cdm_response_type);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RESPONSE_TYPE;
            quit;

            %ErrorCheck(CDM_RESPONSE_TYPE);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_response_type;
                set cdmmart.cdm_response_type
                    (rename=(response_type_desc=response_type_desc_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_response_type
                    (cntllev=rec dbkey=response_type_cd) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    response_type_desc=response_type_desc_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=updated_dttm_tmp;

                    if _iorc_ eq %sysrc(_SOK) then
                        replace;
                    else
                        output;
                end;

                _iorc_ = 0;
                _error_ = 0;
            run;

            %put %sysfunc(datetime(),E8601DT25.) ---     &nobs rows updated or added to table CDM_RESPONSE_TYPE;

            %ErrorCheck(CDM_RESPONSE_TYPE);
            %if &rc %then %goto ERREXIT;

        %end;
    %end;
*/

    %if %sysfunc(exist(cdmmart.cdm_task_custom_attr)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table task_custom_attr_tmp
                  ( task_version_id              VARCHAR2(36) NOT NULL ,
                    attribute_nm            VARCHAR2(256) NOT NULL ,
                    attribute_data_type_cd  VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val   NUMBER(17,2) NULL ,
                    attribute_dttm_val      TIMESTAMP NULL ,
                    extension_attribute_nm  VARCHAR2(256) NULL,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table task_custom_attr_tmp
                    add constraint task_custom_attr_tmp_pk primary key (task_version_id,attribute_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.task_custom_attr_tmp
                select *
                from cdmmart.cdm_task_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_task_custom_attr using task_custom_attr_tmp
                        on (cdm_task_custom_attr.task_version_id = task_custom_attr_tmp.task_version_id and
                            cdm_task_custom_attr.attribute_nm = task_custom_attr_tmp.attribute_nm)

                    when matched then update
                    set cdm_task_custom_attr.attribute_data_type_cd = task_custom_attr_tmp.attribute_data_type_cd,
                        cdm_task_custom_attr.attribute_character_val = task_custom_attr_tmp.attribute_character_val,
                        cdm_task_custom_attr.attribute_numeric_val = task_custom_attr_tmp.attribute_numeric_val,
                        cdm_task_custom_attr.attribute_dttm_val = task_custom_attr_tmp.attribute_dttm_val,
                        cdm_task_custom_attr.extension_attribute_nm = task_custom_attr_tmp.extension_attribute_nm,
                        cdm_task_custom_attr.updated_by_nm = task_custom_attr_tmp.updated_by_nm,
                        cdm_task_custom_attr.updated_dttm = task_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_task_custom_attr.task_version_id,
                        cdm_task_custom_attr.attribute_nm,
                        cdm_task_custom_attr.attribute_data_type_cd,
                        cdm_task_custom_attr.attribute_character_val,
                        cdm_task_custom_attr.attribute_numeric_val,
                        cdm_task_custom_attr.attribute_dttm_val,
                        cdm_task_custom_attr.extension_attribute_nm,
                        cdm_task_custom_attr.updated_by_nm,
                        cdm_task_custom_attr.updated_dttm
                      )
                    values
                      ( task_custom_attr_tmp.task_version_id,
                        task_custom_attr_tmp.attribute_nm,
                        task_custom_attr_tmp.attribute_data_type_cd,
                        task_custom_attr_tmp.attribute_character_val,
                        task_custom_attr_tmp.attribute_numeric_val,
                        task_custom_attr_tmp.attribute_dttm_val,
                        task_custom_attr_tmp.extension_attribute_nm,
                        task_custom_attr_tmp.updated_by_nm,
                        task_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table task_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_TASK_CUSTOM_ATTR;

            %ErrorCheck(CDM_TASK_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_task_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        extension_attribute_nm =
                            (select extension_attribute_nm from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_task_custom_attr as a
                             where u.task_version_id = a.task_version_id and
                                   u.attribute_nm = a.attribute_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_TASK_CUSTOM_ATTR;

                insert into dblib.cdm_task_custom_attr
                select *
                from cdmmart.cdm_task_custom_attr as a
                where a.task_version_id not in (select task_version_id from dblib.cdm_task_custom_attr)
                and a.attribute_nm not in (select attribute_nm from dblib.cdm_task_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_TASK_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_TASK_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_task_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_task_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
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
                    (cntllev=rec dbkey=(task_version_id attribute_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    extension_attribute_nm = extension_attribute_nm_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_activity_x_task)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table activity_x_task_tmp
                  ( activity_version_id     VARCHAR2(36) NOT NULL ,
                    task_version_id         VARCHAR2(36) NOT NULL ,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table activity_x_task_tmp
                    add constraint activity_x_task_tmp_pk primary key (activity_version_id, task_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.activity_x_task_tmp
                select *
                from cdmmart.cdm_activity_x_task;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_activity_x_task using activity_x_task_tmp
                        on (cdm_activity_x_task.activity_version_id = activity_x_task_tmp.activity_version_id and
                            cdm_activity_x_task.task_version_id = activity_x_task_tmp.task_version_id)

                    when matched then update
                    set cdm_activity_x_task.updated_by_nm = activity_x_task_tmp.updated_by_nm,
                        cdm_activity_x_task.updated_dttm = activity_x_task_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_activity_x_task.activity_version_id,
                        cdm_activity_x_task.task_version_id,
                        cdm_activity_x_task.updated_by_nm,
                        cdm_activity_x_task.updated_dttm
                      )
                    values
                      ( activity_x_task_tmp.activity_version_id,
                        activity_x_task_tmp.task_version_id,
                        activity_x_task_tmp.updated_by_nm,
                        activity_x_task_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_ACTIVITY_X_TASK;

                execute (drop table activity_x_task_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_ACTIVITY_X_TASK);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_activity_x_task as u
                    set updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_activity_x_task as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.task_version_id = a.task_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_activity_x_task as a
                             where u.activity_version_id = a.activity_version_id and
                                   u.task_version_id = a.task_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_ACTIVITY_X_TASK;

                insert into dblib.cdm_activity_x_task
                select *
                from cdmmart.cdm_activity_x_task as a
                where a.activity_version_id not in (select activity_version_id from dblib.cdm_activity_x_task) and
                      a.task_version_id not in (select task_version_id from dblib.cdm_activity_x_task);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_ACTIVITY_X_TASK;
            quit;

            %ErrorCheck(CDM_ACTIVITY_X_TASK);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                    updated_dttm=updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_rtc_x_content)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table rtc_x_content_tmp
                  ( rtc_id                  VARCHAR2(36) NOT NULL ,
                    content_version_id      VARCHAR2(36) NOT NULL ,
                    sequence_no             INTEGER NULL ,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table rtc_x_content_tmp
                    add constraint rtc_x_content_tmp_pk primary key (rtc_id, content_version_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.rtc_x_content_tmp
                select *
                from cdmmart.cdm_rtc_x_content;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_rtc_x_content using rtc_x_content_tmp
                        on (cdm_rtc_x_content.rtc_id = rtc_x_content_tmp.rtc_id and
                            cdm_rtc_x_content.content_version_id = rtc_x_content_tmp.content_version_id)

                    when matched then update
                    set cdm_rtc_x_content.sequence_no = rtc_x_content_tmp.sequence_no,
                        cdm_rtc_x_content.updated_by_nm = rtc_x_content_tmp.updated_by_nm,
                        cdm_rtc_x_content.updated_dttm = rtc_x_content_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_rtc_x_content.rtc_id,
                        cdm_rtc_x_content.content_version_id,
                        cdm_rtc_x_content.sequence_no,
                        cdm_rtc_x_content.updated_by_nm,
                        cdm_rtc_x_content.updated_dttm
                      )
                    values
                      ( rtc_x_content_tmp.rtc_id,
                        rtc_x_content_tmp.content_version_id,
                        rtc_x_content_tmp.sequence_no,
                        rtc_x_content_tmp.updated_by_nm,
                        rtc_x_content_tmp.updated_dttm
                      )
                  ) by oracle;

                %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_RTC_X_CONTENT;

                execute (drop table rtc_x_content_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %ErrorCheck(CDM_RTC_X_CONTENT);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_rtc_x_content as u
                    set sequence_no =
                            (select sequence_no from cdmmart.cdm_rtc_x_content as a
                             where u.rtc_id = a.rtc_id and
                                   u.content_version_id = a.content_version_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_rtc_x_content as a
                             where u.rtc_id = a.rtc_id and
                                   u.content_version_id = a.content_version_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_rtc_x_content as a
                             where u.rtc_id = a.rtc_id and
                                   u.content_version_id = a.content_version_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RTC_X_CONTENT;

                insert into dblib.cdm_rtc_x_content
                select *
                from cdmmart.cdm_rtc_x_content as a
                where a.rtc_id not in (select rtc_id from dblib.cdm_rtc_x_content) and
                      a.content_version_id not in (select content_version_id from dblib.cdm_rtc_x_content);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RTC_X_CONTENT;
            quit;

            %ErrorCheck(CDM_RTC_X_CONTENT);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_rtc_x_content;
                retain uobs oobs;
                set cdmmart.cdm_rtc_x_content
                    (rename=(sequence_no=sequence_no_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

                if _n_ = 1 then do;
                    uobs=0;
                    oobs=0;
                    call symput('uobs',strip(uobs));
                    call symput('oobs',strip(oobs));
                end;

                modify dblib.cdm_rtc_x_content
                    (cntllev=rec dbkey=(rtc_id content_version_id)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;
                    sequence_no=sequence_no_tmp;
                    updated_by_nm=updated_by_nm_tmp;
                    updated_dttm=updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_segment_custom_attr)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table segment_custom_attr_tmp
                  ( segment_version_id      VARCHAR2(36) NOT NULL ,
                    attribute_nm            VARCHAR2(256) NOT NULL ,
                    attribute_data_type_cd  VARCHAR2(30) NULL ,
                    attribute_character_val VARCHAR2(500) NULL ,
                    attribute_numeric_val   NUMBER(17,2) NULL ,
                    attribute_dttm_val      TIMESTAMP NULL ,
                    updated_by_nm           VARCHAR2(60) NULL ,
                    updated_dttm            TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table segment_custom_attr_tmp
                    add constraint segment_custom_attr_tmp_pk primary key (segment_version_id,attribute_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.segment_custom_attr_tmp
                select *
                from cdmmart.cdm_segment_custom_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_segment_custom_attr using segment_custom_attr_tmp
                        on (cdm_segment_custom_attr.segment_version_id = segment_custom_attr_tmp.segment_version_id and
                            cdm_segment_custom_attr.attribute_nm = segment_custom_attr_tmp.attribute_nm)

                    when matched then update
                    set cdm_segment_custom_attr.attribute_data_type_cd = segment_custom_attr_tmp.attribute_data_type_cd,
                        cdm_segment_custom_attr.attribute_character_val = segment_custom_attr_tmp.attribute_character_val,
                        cdm_segment_custom_attr.attribute_numeric_val = segment_custom_attr_tmp.attribute_numeric_val,
                        cdm_segment_custom_attr.attribute_dttm_val = segment_custom_attr_tmp.attribute_dttm_val,
                        cdm_segment_custom_attr.updated_by_nm = segment_custom_attr_tmp.updated_by_nm,
                        cdm_segment_custom_attr.updated_dttm = segment_custom_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_segment_custom_attr.segment_version_id,
                        cdm_segment_custom_attr.attribute_nm,
                        cdm_segment_custom_attr.attribute_data_type_cd,
                        cdm_segment_custom_attr.attribute_character_val,
                        cdm_segment_custom_attr.attribute_numeric_val,
                        cdm_segment_custom_attr.attribute_dttm_val,
                        cdm_segment_custom_attr.updated_by_nm,
                        cdm_segment_custom_attr.updated_dttm
                      )
                    values
                      ( segment_custom_attr_tmp.segment_version_id,
                        segment_custom_attr_tmp.attribute_nm,
                        segment_custom_attr_tmp.attribute_data_type_cd,
                        segment_custom_attr_tmp.attribute_character_val,
                        segment_custom_attr_tmp.attribute_numeric_val,
                        segment_custom_attr_tmp.attribute_dttm_val,
                        segment_custom_attr_tmp.updated_by_nm,
                        segment_custom_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table segment_custom_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_SEGMENT_CUSTOM_ATTR;

            %ErrorCheck(CDM_SEGMENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_segment_custom_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_segment_custom_attr as a
                             where u.segment_version_id = a.segment_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_character_val =
                            (select attribute_character_val from cdmmart.cdm_segment_custom_attr as a
                             where u.segment_version_id = a.segment_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_numeric_val =
                            (select attribute_numeric_val from cdmmart.cdm_segment_custom_attr as a
                             where u.segment_version_id = a.segment_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_dttm_val =
                            (select attribute_dttm_val from cdmmart.cdm_segment_custom_attr as a
                             where u.segment_version_id = a.segment_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_segment_custom_attr as a
                             where u.segment_version_id = a.segment_version_id and
                                   u.attribute_nm = a.attribute_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_segment_custom_attr as a
                             where u.segment_version_id = a.segment_version_id and
                                   u.attribute_nm = a.attribute_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_SEGMENT_CUSTOM_ATTR;

                insert into dblib.cdm_segment_custom_attr
                select *
                from cdmmart.cdm_segment_custom_attr as a
                where a.segment_version_id not in (select segment_version_id from dblib.cdm_segment_custom_attr)
                and a.attribute_nm not in (select attribute_nm from dblib.cdm_segment_custom_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_SEGMENT_CUSTOM_ATTR;
            quit;

            %ErrorCheck(CDM_SEGMENT_CUSTOM_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_segment_custom_attr;
                retain uobs oobs;
                set cdmmart.cdm_segment_custom_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_character_val=attribute_character_val_tmp
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
                    (cntllev=rec dbkey=(segment_version_id attribute_nm)) key=dbkey;

                if _iorc_ in(%sysrc(_DSENMR), %sysrc(_DSENOM), %sysrc(_DSEMTR)) or _iorc_ eq %sysrc(_SOK) then do;

                    attribute_data_type_cd = attribute_data_type_cd_tmp;
                    attribute_character_val = attribute_character_val_tmp;
                    attribute_numeric_val = attribute_numeric_val_tmp;
                    attribute_dttm_val = attribute_dttm_val_tmp;
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_response_history)) %then %do;
        %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table response_history_tmp
                  ( response_id                VARCHAR2(36) NOT NULL ,
                    response_cd                VARCHAR2(20) NULL ,
                    response_dt                DATE NULL ,
                    response_dttm              TIMESTAMP NULL ,
                    external_contact_info_1_id VARCHAR2(32) NULL ,
                    external_contact_info_2_id VARCHAR2(32) NULL ,
                    response_type_cd           VARCHAR2(60) NULL ,
                    response_channel_cd        VARCHAR2(20) NULL ,
                    conversion_flg             CHAR(1) NULL ,
                    inferred_response_flg      CHAR(1) NULL ,
                    content_id                 VARCHAR2(40) NULL ,
                    identity_id                VARCHAR2(36) NULL ,
                    rtc_id                     VARCHAR2(36) NOT NULL ,
                    content_version_id         VARCHAR2(40) NULL ,
                    response_val_amt           NUMERIC(12,2) NULL ,
                    source_system_cd           VARCHAR2(10) NULL ,
                    updated_by_nm              VARCHAR2(60) NULL ,
                    updated_dttm               TIMESTAMP NULL ,
                    contact_id                 VARCHAR2(36) NULL
                  )) by oracle;

                execute
                  ( alter table response_history_tmp
                    add constraint response_history_tmp_pk primary key (response_id)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.response_history_tmp
                select *
                from cdmmart.cdm_response_history;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_response_history using response_history_tmp
                        on (cdm_response_history.response_id = response_history_tmp.response_id)

                    when matched then update
                    set cdm_response_history.response_cd = response_history_tmp.response_cd,
                        cdm_response_history.response_dt = response_history_tmp.response_dt,
                        cdm_response_history.response_dttm = response_history_tmp.response_dttm,
                        cdm_response_history.external_contact_info_1_id = response_history_tmp.external_contact_info_1_id,
                        cdm_response_history.external_contact_info_2_id = response_history_tmp.external_contact_info_2_id,
                        cdm_response_history.response_type_cd = response_history_tmp.response_type_cd,
                        cdm_response_history.response_channel_cd = response_history_tmp.response_channel_cd,
                        cdm_response_history.conversion_flg = response_history_tmp.conversion_flg,
                        cdm_response_history.inferred_response_flg = response_history_tmp.inferred_response_flg,
                        cdm_response_history.content_id = response_history_tmp.content_id,
                        cdm_response_history.identity_id = response_history_tmp.identity_id,
                        cdm_response_history.rtc_id = response_history_tmp.rtc_id,
                        cdm_response_history.content_version_id = response_history_tmp.content_version_id,
                        cdm_response_history.response_val_amt = response_history_tmp.response_val_amt,
                        cdm_response_history.source_system_cd = response_history_tmp.source_system_cd,
                        cdm_response_history.updated_by_nm = response_history_tmp.updated_by_nm,
                        cdm_response_history.updated_dttm = response_history_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_response_history.response_id,
                        cdm_response_history.response_cd,
                        cdm_response_history.response_dt,
                        cdm_response_history.response_dttm,
                        cdm_response_history.external_contact_info_1_id,
                        cdm_response_history.external_contact_info_2_id,
                        cdm_response_history.response_type_cd,
                        cdm_response_history.response_channel_cd,
                        cdm_response_history.conversion_flg,
                        cdm_response_history.inferred_response_flg,
                        cdm_response_history.content_id,
                        cdm_response_history.identity_id,
                        cdm_response_history.rtc_id,
                        cdm_response_history.content_version_id,
                        cdm_response_history.response_val_amt,
                        cdm_response_history.source_system_cd,
                        cdm_response_history.updated_by_nm,
                        cdm_response_history.updated_dttm
                      )
                    values
                      ( response_history_tmp.response_id,
                        response_history_tmp.response_cd,
                        response_history_tmp.response_dt,
                        response_history_tmp.response_dttm,
                        response_history_tmp.external_contact_info_1_id,
                        response_history_tmp.external_contact_info_2_id,
                        response_history_tmp.response_type_cd,
                        response_history_tmp.response_channel_cd,
                        response_history_tmp.conversion_flg,
                        response_history_tmp.inferred_response_flg,
                        response_history_tmp.content_id,
                        response_history_tmp.identity_id,
                        response_history_tmp.rtc_id,
                        response_history_tmp.content_version_id,
                        response_history_tmp.response_val_amt,
                        response_history_tmp.source_system_cd,
                        response_history_tmp.updated_by_nm,
                        response_history_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table response_history_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_response_history;

            %ErrorCheck(CDM_response_history);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_response_history as u
                    set response_cd =
                            (select response_cd from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        response_dt =
                            (select response_dt from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        response_dttm =
                            (select response_dttm from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        external_contact_info_1_id =
                            (select external_contact_info_1_id from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        external_contact_info_2_id =
                            (select external_contact_info_2_id from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        response_type_cd =
                            (select response_type_cd from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        response_channel_cd =
                            (select response_channel_cd from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        conversion_flg =
                            (select conversion_flg from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        inferred_response_flg =
                            (select inferred_response_flg from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        content_id =
                            (select content_id from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        identity_id =
                            (select identity_id from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        rtc_id =
                            (select rtc_id from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        content_version_id =
                            (select content_version_id from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        response_val_amt =
                            (select response_val_amt from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        source_system_cd =
                            (select source_system_cd from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_response_history as a
                             where u.response_id = a.response_id)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RESPONSE_HISTORY;

                insert into dblib.cdm_response_history
                select *
                from cdmmart.cdm_response_history as a
                where a.response_id not in (select response_id from dblib.cdm_response_history);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RESPONSE_HISTORY;
            quit;

            %ErrorCheck(CDM_RESPONSE_HISTORY);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

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
                             updated_by_nm = updated_by_nm_tmp
                             updated_dttm = updated_dttm_tmp));

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
                    updated_by_nm = updated_by_nm_tmp;
                    updated_dttm = updated_dttm_tmp;

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
    %end;


    %if %sysfunc(exist(cdmmart.cdm_response_extended_attr)) %then %do;
       %if &DBAgnostic = 0 %then %do;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                 execute (create table response_extended_attr_tmp
                  ( response_id                 VARCHAR2(36) NOT NULL ,
                    response_attribute_type_cd  VARCHAR2(10) NOT NULL ,
                    attribute_nm                VARCHAR2(256) NOT NULL ,
                    attribute_data_type_cd      VARCHAR2(30) NULL ,
                    attribute_val               VARCHAR2(256) NULL ,
                    updated_by_nm               VARCHAR2(60) NULL ,
                    updated_dttm                TIMESTAMP NULL
                  )) by oracle;

                execute
                  ( alter table response_extended_attr_tmp
                    add constraint response_extended_attr_tmp_pk primary key (response_id, response_attribute_type_cd,attribute_nm)) by oracle;

                disconnect from oracle;
            quit;

            proc sql noprint;
                insert into dblib.response_extended_attr_tmp
                select *
                from cdmmart.cdm_response_extended_attr;
            quit;

            proc sql noerrorstop;
                connect to oracle (user=&dbuser pass=&dbpass path=&dbpath);

                execute
                  ( merge into cdm_response_extended_attr using response_extended_attr_tmp
                        on (cdm_response_extended_attr.response_id = response_extended_attr_tmp.response_id and
                            cdm_response_extended_attr.response_attribute_type_cd = response_extended_attr_tmp.response_attribute_type_cd and
                            cdm_response_extended_attr.attribute_nm = response_extended_attr_tmp.attribute_nm)

                    when matched then update
                    set cdm_response_extended_attr.attribute_data_type_cd = response_extended_attr_tmp.attribute_data_type_cd,
                        cdm_response_extended_attr.attribute_val = response_extended_attr_tmp.attribute_val,
                        cdm_response_extended_attr.updated_by_nm = response_extended_attr_tmp.updated_by_nm,
                        cdm_response_extended_attr.updated_dttm = response_extended_attr_tmp.updated_dttm
                    when not matched then insert
                      ( cdm_response_extended_attr.response_id,
                        cdm_response_extended_attr.response_attribute_type_cd,
                        cdm_response_extended_attr.attribute_nm,
                        cdm_response_extended_attr.attribute_data_type_cd,
                        cdm_response_extended_attr.attribute_val,
                        cdm_response_extended_attr.updated_by_nm,
                        cdm_response_extended_attr.updated_dttm
                      )
                    values
                      ( response_extended_attr_tmp.response_id,
                        response_extended_attr_tmp.response_attribute_type_cd,
                        response_extended_attr_tmp.attribute_nm,
                        response_extended_attr_tmp.attribute_data_type_cd,
                        response_extended_attr_tmp.attribute_val,
                        response_extended_attr_tmp.updated_by_nm,
                        response_extended_attr_tmp.updated_dttm
                      )
                  ) by oracle;

                execute (drop table response_extended_attr_tmp cascade constraints purge) by oracle;
                disconnect from oracle;
            quit;

            %put %sysfunc(datetime(),E8601DT25.) ---     Processing table CDM_RESPONSE_EXTENDED_ATTR;

            %ErrorCheck(CDM_RESPONSE_EXTENDED_ATTR);
            %if &rc %then %goto ERREXIT;
        %end;
        %else %if &DBAgnostic = 1 %then %do;

            proc sql noprint;
                update dblib.cdm_response_extended_attr as u
                    set attribute_data_type_cd =
                            (select attribute_data_type_cd from cdmmart.cdm_response_extended_attr as a
                             where u.response_id = a.response_id and
                                   u.response_attribute_type_cd = a.response_attribute_type_cd and
                                   u.attribute_nm = a.attribute_nm),
                        attribute_val =
                            (select attribute_val from cdmmart.cdm_response_extended_attr as a
                             where u.response_id = a.response_id and
                                   u.response_attribute_type_cd = a.response_attribute_type_cd and
                                   u.attribute_nm = a.attribute_nm),
                        updated_by_nm =
                            (select updated_by_nm from cdmmart.cdm_response_extended_attr as a
                             where u.response_id = a.response_id and
                                   u.response_attribute_type_cd = a.response_attribute_type_cd and
                                   u.attribute_nm = a.attribute_nm),
                        updated_dttm =
                            (select updated_dttm from cdmmart.cdm_response_extended_attr as a
                             where u.response_id = a.response_id and
                                   u.response_attribute_type_cd = a.response_attribute_type_cd and
                                   u.attribute_nm = a.attribute_nm)
                    ;

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows updated in table CDM_RESPONSE_EXTENDED_ATTR;

                insert into dblib.cdm_response_extended_attr
                select *
                from cdmmart.cdm_response_extended_attr as a
                where a.response_id not in (select response_id from dblib.cdm_response_extended_attr) and
                      a.response_attribute_type_cd not in (select response_attribute_type_cd from dblib.cdm_response_extended_attr) and
                      a.attribute_nm not in (select attribute_nm from dblib.cdm_response_extended_attr);

                %put %sysfunc(datetime(),E8601DT25.) ---     &sqlobs rows added to table CDM_RESPONSE_EXTENDED_ATTR;
            quit;

            %ErrorCheck(CDM_RESPONSE_EXTENDED_ATTR);
            %if &rc %then %goto ERREXIT;

        %end;
        %else %if &DBAgnostic = 2 %then %do;

            data dblib.cdm_response_extended_attr;
                retain uobs oobs;
                set cdmmart.cdm_response_extended_attr
                    (rename=(attribute_data_type_cd=attribute_data_type_cd_tmp
                             attribute_val=attribute_val_tmp
                             updated_by_nm=updated_by_nm_tmp
                             updated_dttm=updated_dttm_tmp));

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
                    updated_dttm = updated_dttm_tmp;

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
    %end;

    %ERREXIT:

    %if &rc %then %do;
        %put %sysfunc(datetime(),E8601DT25.) --- &CDM_ErrMsg;
        %put %sysfunc(datetime(),E8601DT25.) --- Set of CDM data sets may be incomplete;
    %end;
    %else %do;
        %put %sysfunc(datetime(),E8601DT25.) --- Completed building CDM data sets;
     %end;

%mend;
