/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_get_data_range.sas
 *  Purpose:    Determine the date range for pulling new events from the CDM
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module checks the dates of the most recent data in the downloaded CDM
 *  data warehouse and determines what range we need to load into the CDM database.
 *---------------------------------------------------------------------------------------*/

%macro cdm_get_data_range;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Retrieve CDM download history information;
    %let rc = 0;

/*
 *  CDM_Download_SchemaVer is the CDM schema version from the downloaded CDM tables based on the
 *  cdm_version_hist data set.
 */

       data _null_;
            set cdmcfg.cdm_version_hist end=done;
            if done then do;
                call symputx("CDM_Download_SchemaVer", ver_num, 'G');
            end;
        run;

/*
 *  CDM_Last_Run is the last time the CDM ETL process ran based on the CDM History file.
 *  Using that date, pull from the UDM history file the first UDM download that ran after that
 *  time that had data available as well as the start time for events in that download.
 *  That will mark the beginning of new events in the UDM that we need to pull for this update to the CDM.
 */

    proc sql noprint;
        select min(download_dttm) format=13., dataRangeStartTimeStamp format=13.
            into :lastdownload, :starteventtimestamp
        from cdmcfg.cdm_download_history
        where download_dttm ge input("&CDM_LastRun", e8601dz24.3) and
              dataRangeProcessingStatus eq 'DATA_AVAILABLE';
    run;

    %if &sqlobs eq 0 %then %do;
        %let rc = 1;
        %let CDM_ErrMsg = Unable to determine last CDM download from the history file;
        %goto ERREXIT;
    %end;
    %else %do;
        data _null_;
            call symputx( "CDM_UDMLastRun", &lastdownload, 'G');
            call symputx( "CDM_UDMFirstEventDate", &starteventtimestamp, 'G');
            call symputx( "CDM_UDMLastRun_fmt", put(&lastdownload, e8601dz24.3), 'G');
            call symputx( "CDM_UDMFirstEventDate_fmt", put(&starteventtimestamp, e8601dz24.3), 'G');
        run;

        %put %sysfunc(datetime(),E8601DT25.) --- From the CDM Downlod History file:;
        %put %sysfunc(datetime(),E8601DT25.) ---     CDM Schema Version from most recent download:                     &CDM_Download_SchemaVer;
        %put %sysfunc(datetime(),E8601DT25.) ---     Timestamp of last successful CDM Download Process:  &CDM_UDMLastRun_fmt;
        %put %sysfunc(datetime(),E8601DT25.) ---     Starting event timestamp of the last CDM run:   &CDM_UDMFirstEventDate_fmt;

    %end;

    proc sql noprint;
        select distinct(entityName) into :CDM_TableList separated by '~'
        from cdmcfg.cdm_nonpar_download_hist
        where download_dttm gt input("&CDM_LastRun", e8601dz24.3)
    ;

    %ERREXIT:

%mend cdm_get_data_range;
