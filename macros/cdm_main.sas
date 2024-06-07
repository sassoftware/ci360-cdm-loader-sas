/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
*---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_main.sas
 *  Purpose:    Main program for the CDM Load Utility
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module is the main program for the CDM Load Utility and invokes other SAS macros
 *  for specific tasks.
 *---------------------------------------------------------------------------------------*/


 %macro cdm_main;

/*
 *  The current datetime value is used to set the 'updated_dttm' value for most CDM tables.
 *  The timestamp literal for Oracle requires a specific format so we save 2 versions of the
 *  timestamp formatted appropriately.
 */

    data _null_;
        call symputx("CurrentDateTime", put(datetime(),e8601dz24.3), 'G');
        call symputx("OracleUpdateTime", "'" !! put(datetime(),dateampm22.2) !! "'", 'G');
    run;

    %put %sysfunc(datetime(),E8601DT25.) --- Beginning Common Data Model update process;

    %CHECK_VERBOSE;

/*
 *  Define additional global macro variables we'll use throughout the process.
 */

    %global CDM_ErrMsg
            CurrentDateTime oracleUpdateTime
            CDM_PrevSchemaVersion CDM_CDMSchemaVersion CDM_UDMSchemaVersion CDM_CodeVersion
            CDM_LastRun CDM_LastStatus CDM_LastDataEndTime
            CDM_UDM_LastRun CDM_UDM_FirstEventDate
            CDM_UDM_LastRun_fmt CDM_UDM_FirstEventDate_fmt
            CDMHistoryFile
            CDM_UpdateName CDM_SourceSystem
            CDM_Download_SchemaVer CDM_DDL_SchemaVer CDM_DDL_PrevSchemaVer
            CDM_TableList
        ;

/*
 *  Some macro variables we'll use throughout the process.
 *
 *  CDM_ErrMsg - an error message that we'll display at the end, may be updated during processing
 */

    %let CDM_ErrMsg = Successful Completion;

/*
 *  We set the schema and code versions which are stored in the history file.  These are only
 *  used the first time the process is run.
 */

    %let CDM_DDL_SchemaVer = 16;
    %let CDM_CodeVersion = 5.0;
    %let CDMHistoryFile = cdm_history;

/*
 *  Data in the Common Data Model may be populated from a variety of sources.  Data loaded by
 *  this process is indicated by an update name of 'CDM2.0' and the source system is '360'.
 *
    %let CDM_UpdateName = CDM2.0;
    %let CDM_SourceSystem = 360;

/*
 *  Perform some preprocessing checks and setup.
 */

    %cdm_preprocessing;
    %if &rc ne 0 %then %goto ERREXIT;

/*
 *  We need to build the database keys for several tables that didn't have those
 *  key fields populated when the tables were built in the cloud.
 */

    %cdm_build_keys;
    %if &rc ne 0 %then %goto ERREXIT;

/*
 *  Load the CDM data sets from the on-prem CDM data library into the database.
 *  Based on the DBAgnostic flag we either use standard SAS data steps to load the data
 *  or database specific code.  At this point no database specific code is provided, the
 *  use of the 'cdm_load_oracle' macro is shown only as an example of how it may be supported
 *  in a future release.
 */

    %if &DBAgnostic = 0 %then
        %cdm_load_oracle;
    %else %if &DBAgnostic = 1 %then
        %cdm_load_datastep;

    %if &rc ne 0 %then %goto ERREXIT;

    %cdm_postprocessing;

    %ERREXIT:

    %put %sysfunc(datetime(),E8601DT25.) --- &CDM_ErrMsg;

 %mend cdm_main;
