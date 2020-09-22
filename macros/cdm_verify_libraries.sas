/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_verify_libraries.sas
 *  Purpose:    Ensure the required directories exist
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module verifies the required CDM directories exist or can be created
 *---------------------------------------------------------------------------------------*/


 %macro cdm_verify_libraries;

    %CHECK_VERBOSE;

    %let rc = 0;

    %put %sysfunc(datetime(),E8601DT25.) --- Verify that the required libraries and directories exist;

/*
 *  Verify the existence of the CDM home, configuration and warehouse directories.  If they don't exist
 *  we can't proceed.
 */

    %put %sysfunc(datetime(),E8601DT25.) ---     CDM DataMart is &CDMMart;

    %if %sysfunc(fileexist(&CDMMart)) eq 1 %then %do;
        %if %sysfunc(fileexist(&CDMMart.&Slash.data&Slash.dsccnfg)) eq 0 %then %do;
            %put %sysfunc(datetime(),E8601DT25.) ---         CDM configuration directory does not exist, unable to continue;
            %let CDM_ErrMsg = Unsuccessful completion;
            %let rc = 1;
            %goto ERREXIT;
        %end;

        %if %sysfunc(fileexist(&CDMMart.&Slash.data&Slash.dscwh)) eq 0 %then %do;
            %put %sysfunc(datetime(),E8601DT25.) ---         CDM data warehouse directory does not exist, unable to continue;
            %let CDM_ErrMsg = Unsuccessful completion;
            %let rc = 1;
            %goto ERREXIT;
        %end;
    %end;
    %else %do;
        %put %sysfunc(datetime(),E8601DT25.) ---         CDM DataMart path does not exist, unable to continue;
        %let CDM_ErrMsg = Unsuccessful completion;
        %let rc = 1;
        %goto ERREXIT;
    %end;

/*
 *  Verify the existence of the CDM library and directories.  If the data or config directories don't exist
 *  we will create them.  If there are errors creating them or if the CDMHome directory doesn't
 *  exist we will exit.
 */

    %put %sysfunc(datetime(),E8601DT25.) ---     CDM OnPrem home is &CDMHome;

    %if %sysfunc(fileexist(&CDMHome)) eq 1 %then %do;
        %if %sysfunc(fileexist(&CDMHome.&SLASH.ddl)) eq 0 %then %do;
            %put %sysfunc(datetime(),E8601DT25.) ---         CDM OnPrem DDL library does not exist, unable to continue;
            %let CDM_ErrMsg = Unsuccessful completion;
            %let rc = 1;
            %goto ERREXIT;

        %end;

        %if %sysfunc(fileexist(&CDMHome.&SLASH.config)) eq 0 %then %do;
            %put %sysfunc(datetime(),E8601DT25.) ---         CDM OnPrem configuration directory does not exist, it will be created;

            data _null_;
                cdmconfig = dcreate("config", "&CDMHome");
                if strip(cdmconfig) = "" then do;
                    call symputx('rc', '1', 'g');
                end;
            run;

            %if &rc ne 0 %then %do;
                %put %sysfunc(datetime(),E8601DT25.) ---         Unable to create the CDM configuration directory &CDMHome.&Slash./config, exiting;
                %let CDM_ErrMsg = Unsuccessful completion;
                %goto ERREXIT;
            %end;
        %end;

    %end;
    %else %do;
        %put %sysfunc(datetime(),E8601DT25.) ---         CDM OnPrem Home does not exist, unable to continue;
        %let rc = 1;
        %let CDM_ErrMsg = Unsuccessful completion;
        %goto ERREXIT;
    %end;

    %put %sysfunc(datetime(),E8601DT25.) --- Library and directory validation complete;

    %ERREXIT:

 %mend cdm_verify_libraries;
