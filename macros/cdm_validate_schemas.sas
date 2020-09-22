/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_validate_schemas.sas
 *  Purpose:    Verify that the downloaded CDM tables are compatible with our schema
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module performs some validation steps for the CDM Load Utility.
 *---------------------------------------------------------------------------------------*/

 %macro cdm_validate_schemas;

    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Validating UDM and CDM schemas;
    %let rc = 0;

    %if &CDM_Download_SchemaVer ne &CDM_DDL_SchemaVer %then %do;
        %put %sysfunc(datetime(),E8601DT25.) --- Downloaded CDM Schema version &CDM_Download_SchemaVer is incompatible with current CDM DDL Schema Version &CDM_DDL_SchemaVer;
        %let rc = 1;
        %let CDM_ErrMsg = Incompatible Downloaded and DDL Schema Versions;
        %goto ERREXIT;
    %end;


    %ERREXIT:

%mend cdm_validate_schemas;
