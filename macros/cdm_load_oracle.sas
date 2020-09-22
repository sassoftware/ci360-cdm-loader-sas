/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_load_oracle.sas
 *  Purpose:    Load records from the CDM data sets into Oracle
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module loads data from the CDM SAS data sets into Oracle
 *---------------------------------------------------------------------------------------*/

%macro ErrorCheck(tablename);
    %if &syserr. > 4 %then %do;
        %let rc = 1;
        %let CDM_ErrMsg = Unable to load CDM table &tablename;
        %put %sysfunc(datetime(),E8601DT25.) --- ERROR:  &syserrortext;
    %end;
%mend;

%macro cdm_load_oracle;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Database specific code for the loading of data is not supported at this time.;

    %let rc = 1;

    %ERREXIT:

%mend cdm_load_oracle;
