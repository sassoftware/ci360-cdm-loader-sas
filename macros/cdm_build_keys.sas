/*---------------------------------------------------------------------------------------
 *  Copyright (c) 2005-2020, SAS Institute Inc., Cary, NC, USA, All Rights Reserved
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_build_keys.sas
 *  Purpose:    Build necessary database keys not build in the cloud
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module builds several primary keys that were not build when tables were create in the cloud
 *---------------------------------------------------------------------------------------*/

%macro ErrorCheck(tablename);
    %if &syserr. > 4 %then %do;
        %let rc = 1;
        %let CDM_ErrMsg = Unable to build database keys for table &tablename;
        %put %sysfunc(datetime(),E8601DT25.) --- ERROR:  &syserrortext;
    %end;
%mend;

%macro cdm_build_keys;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Begin building additional database keys;
    %let rc = 0;

/*
 *  Several tables have fields that are used as primary keys that weren't built by the CDM
 *  process in the cloud.  Now that we're loading tables into a database we need to make sure
 *  those fields have values.
 */

    %if %sysfunc(exist(cdmmart.cdm_activity_custom_attr)) %then %do;
        data cdmmart.cdm_activity_custom_attr;
            set cdmmart.cdm_activity_custom_attr;

            if attribute_val = "" then do;
                if attribute_numeric_val = . then anv = "";
                attribute_val = coalescec( attribute_character_val, anv, put(attribute_dttm_val, e8601dz24.3));
            end;
        run;

        %ErrorCheck(CDM_ACTIVITY_CUSTOM_ATTR);
        %if &rc %then %goto ERREXIT;
    %end;

   %if %sysfunc(exist(cdmmart.cdm_content_custom_attr)) %then %do;
        data cdmmart.cdm_content_custom_attr;
            set cdmmart.cdm_content_custom_attr;

            if attribute_val = "" then do;
                if attribute_numeric_val = . then anv = "";
                attribute_val = coalescec( attribute_character_val, anv, put(attribute_dttm_val, e8601dz24.3));
            end;
        run;

        %ErrorCheck(CDM_CONTENT_CUSTOM_ATTR);
        %if &rc %then %goto ERREXIT;
   %end;

    %if %sysfunc(exist(cdmmart.cdm_task_custom_attr)) %then %do;
        data cdmmart.cdm_task_custom_attr;
            set cdmmart.cdm_task_custom_attr;

            if attribute_val = "" then do;
                if attribute_numeric_val = . then anv = "";
                attribute_val = coalescec( attribute_character_val, anv, put(attribute_dttm_val, e8601dz24.3));
            end;
        run;

        %ErrorCheck(CDM_TASK_CUSTOM_ATTR);
        %if &rc %then %goto ERREXIT;
    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_custom_attr)) %then %do;
        data cdmmart.cdm_segment_custom_attr;
            set cdmmart.cdm_segment_custom_attr;

            if attribute_val = "" then do;
                if attribute_numeric_val = . then anv = "";
                attribute_val = coalescec( attribute_character_val, anv, put(attribute_dttm_val, e8601dz24.3));
            end;
        run;

        %ErrorCheck(CDM_SEGMENT_CUSTOM_ATTR);
        %if &rc %then %goto ERREXIT;
    %end;

    %if %sysfunc(exist(cdmmart.cdm_segment_map_custom_attr)) %then %do;
        data cdmmart.cdm_segment_map_custom_attr;
            set cdmmart.cdm_segment_map_custom_attr;

            if attribute_val = "" then do;
                if attribute_numeric_val = . then anv = "";
                attribute_val = coalescec( attribute_character_val, anv, put(attribute_dttm_val, e8601dz24.3));
            end;
        run;

        %ErrorCheck(CDM_SEGMENT_MAP_CUSTOM_ATTR);
        %if &rc %then %goto ERREXIT;
    %end;

    %if %sysfunc(exist(cdmmart.cdm_rtc_x_content)) %then %do;
        data cdmmart.cdm_rtc_x_content;
            set cdmmart.cdm_rtc_x_content;

            if rtc_x_content_sk = "" then do;
                rtc_x_content_sk = uuidgen();
            end;
        run;

        %ErrorCheck(CDM_RTC_X_CONTENT);
        %if &rc %then %goto ERREXIT;
    %end;

/*
 *  Most of these checks were put into place because of foreign key constraints between multiple tables.  Based on timing
 *  and the availability of data on any instance of a download some of those constraints could not always be satisfied and
 *  were causing issues, thus the checks here to make sure appropriate id's were found in linked tables.  For the moment
 *  those foreign key constraints have been disabled in the DDL's for the appropriate databases.
 *
 *  We are going to remove these checks for connections between various id's in several tables.  If foreign key constraints
 *  are enabled for a particular table these checks may need to be added back in.
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_rtc_detail)) and %sysfunc(exist(cdmmart.cdm_task_detail)) %then %do;
        proc sql noprint;
            create table cdmmart.cdm_rtc_detail as
                select * from cdmmart.cdm_rtc_detail as r
                where r.task_version_id ne "" and r.task_version_id in (select t.task_version_id from cdmmart.cdm_task_detail as t)
                ;
        quit;

        %ErrorCheck(CDM_RTC_DETAIL);
        %if &rc %then %goto ERREXIT;
    %end;
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_activity_x_task)) and %sysfunc(exist(cdmmart.cdm_task_detail)) %then %do;
        proc sql noprint;
            create table cdmmart.cdm_activity_x_task as
                select * from cdmmart.cdm_activity_x_task as a
                where a.task_version_id in (select t.task_version_id from cdmmart.cdm_task_detail as t)
                ;
        quit;

        %ErrorCheck(CDM_ACTIVITY_X_TASK);
        %if &rc %then %goto ERREXIT;
    %end;
 */

/*
    %if %sysfunc(exist(cdmmart.cdm_rtc_x_content)) and %sysfunc(exist(cdmmart.cdm_content_detail)) and
        %sysfunc(exist(cdmmart.cdm_rtc_detail)) %then %do;
        proc sql noprint;
            create table cdmmart.cdm_rtc_x_content as
                select * from cdmmart.cdm_rtc_x_content as r
                where r.content_version_id in (select c.content_version_id from cdmmart.cdm_content_detail as c) and
                      r.rtc_id in (select rd.rtc_id from cdmmart.cdm_rtc_detail as rd)
                ;
        quit;

        %ErrorCheck(CDM_RTC_X_CONTENT);
        %if &rc %then %goto ERREXIT;
    %end;
 */

    %ERREXIT:

    %if &rc %then %do;
        %put %sysfunc(datetime(),E8601DT25.) --- &CDM_ErrMsg;
        %put %sysfunc(datetime(),E8601DT25.) --- Unable to build all the necessary database keys;
    %end;
    %else %do;
        %put %sysfunc(datetime(),E8601DT25.) --- Completed building additional database keys;
     %end;

%mend cdm_build_keys;
