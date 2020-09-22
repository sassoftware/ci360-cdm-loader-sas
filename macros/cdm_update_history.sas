/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Name:           cdm_update_history.sas
 *  Description:    Update history information for this run of the CDM ETL Utility ran
 *  Version:        2.0
 *  History:
 *---------------------------------------------------------------------------------------*/

 %macro cdm_update_history;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Updating CDM History information;
    %let rc = 0;

    data work.&CDMHistoryFile;
        format last_run e8601dz24.3;
        length last_status $128;

        cdm_schema_version = &CDM_DDL_SchemaVer;
        last_run = input("&CurrentDateTime", e8601dz24.3);
        cdm_code_version = &CDM_CodeVersion;
        last_status = "&CDM_ErrMsg";
    run;

    proc append base=loadcfg.&CDMHistoryFile data=work.&CDMHistoryFile; run;


    %ERREXIT:

 %mend;
