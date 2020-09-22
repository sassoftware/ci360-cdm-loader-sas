/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_preprocessing.sas
 *  Purpose:    Setup and validation for the CDM Load Utility
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module performs some validation steps for the CDM Load Utility.
 *---------------------------------------------------------------------------------------*/

 %macro cdm_preprocessing;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Beginning preprocessing steps;
    %let rc = 0;

/*
 *  Make sure the required directories exist, or if necessary are able to be created.
 */

    %cdm_verify_libraries;
    %if &rc ne 0 %then %goto ERREXIT;

/*
 *  Define the necessary SAS libraries.
 *  CDMMART - the directory location where the downloaded CDM SAS data sets will be found
 *  CDMCFG  - the directory location where the configuration file from the CDM download process is stored
 *  LOADCFG - the directory location where the configuration file from the CDM load process will be stored
*/

    %put %sysfunc(datetime(),E8601DT25.) --- Define CDM libraries;

    libname cdmmart "&CDMMart.&Slash.data&Slash.dscwh";
    libname cdmcfg  "&CDMMart.&Slash.data&Slash.dsccnfg";
    libname loadcfg "&CDMHome.&Slash.config";

/*
 *  Look at our CDM history file to determine the last time we ran, or create the history file
 *  if this is our first time.
 */

    %cdm_get_history;
    %if &rc ne 0 %then %goto ERREXIT;

/*
 *  Use information from the CDM download history file to determine if new events have been added to the
 *  CDM tables since the last time the CDM load process was run.
 */

    %cdm_get_data_range;
    %if &rc ne 0 %then %goto ERREXIT;

/*
 *  Validate the schemas between downloaded CDM and CDM in the on-prem database.
 */

    %cdm_validate_schemas;
    %if &rc ne 0 %then %goto ERREXIT;

    %ERREXIT:

 %mend cdm_preprocessing;

