/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_get_history.sas
 *  Purpose:    Retrieve history information on the last time the CDM load Utility ran
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module retrieves information from the CDM history fle to determine the last
 *  time this process ran and the date ranges used in that run.
 *---------------------------------------------------------------------------------------*/

 %macro cdm_get_history;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Retreive CDM Load History information;
    %let rc = 0;

    filename histfile "&CDMHome.&Slash.config&Slash.&CDMHistoryFile..sas7bdat";

/*
 *  First check to see if the history file exists.  If so read it and set some necessary macro values.
 *  If it doesn't exist create it with some starting default values.
 */

    %if %sysfunc(fexist(histfile)) %then %do;
        data _null_;
            set loadcfg.&CDMHistoryFile end=done;

            if done then do;
                call symputx("CDM_DDL_PrevSchemaVer", cdm_schema_version, 'G');
                call symputx("CDM_LastRun", put(last_run, e8601dz24.3), 'G');
                call symputx("CDM_LastStatus", last_status,'G');
            end;
        run;

        %if &sysnobs eq 0 %then %do;
            %let rc = 1;
            %let CDM_ErrMsg = Unable to access CDM History file;
            %goto ERREXIT;
        %end;

    %end;
    %else %do;
        data loadcfg.&CDMHistoryFile;
            format last_run e8601dz24.3;
            length last_status $128;

            cdm_schema_version = &CDM_DDL_SchemaVer;
            cdm_code_version = &CDM_CodeVersion;
            last_run = 0;
            last_status = "No Previous Executions";

            call symputx("CDM_DDL_PrevSchemaVer", cdm_schema_version, 'G');
            call symputx("CDM_LastRun", "", 'G');
            call symputx("CDM_LastStatus", last_status,'G');
        run;

        %if &sysnobs eq 0 %then %do;
            %let rc = 1;
            %let CDM_ErrMsg = Unable to create CDM History file;

            %goto ERREXIT;
        %end;
    %end;

    %put %sysfunc(datetime(),E8601DT25.) --- From the CDM Load History file:;
    %put %sysfunc(datetime(),E8601DT25.) ---     Current CDM Schema Version:          &CDM_DDL_SchemaVer;
    %put %sysfunc(datetime(),E8601DT25.) ---     Previous CDM Schema Version:         &CDM_DDL_PrevSchemaVer;
    %put %sysfunc(datetime(),E8601DT25.) ---     Timestamp of last CDM Load Process:  &CDM_LastRun;
    %put %sysfunc(datetime(),E8601DT25.) ---     Status of last CDM Load Process:     &CDM_LastStatus;

    %if "&CDM_LastRun" = "" %then %do;
        data _null_;
            call symputx("CDM_LastRun", "1960-01-01T00:00:00.000Z", 'G');
        run;
    %end;

    %ERREXIT:

 %mend cdm_get_history;
