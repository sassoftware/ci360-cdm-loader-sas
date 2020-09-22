/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Name:           cdm_postprocessing.sas
 *  Description:    postprocessing for the CDM ETL Utility
 *  Version:        2.0
 *  History:
 *---------------------------------------------------------------------------------------*/
 
 %macro cdm_postprocessing;
 
    %CHECK_VERBOSE;

    %put %sysfunc(datetime(),E8601DT25.) --- Beginning CDM postprocessing;
    %let rc = 0;
    
    %cdm_update_history;

    
    %ERREXIT:     
 
 %mend;
 
