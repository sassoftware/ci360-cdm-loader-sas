/*---------------------------------------------------------------------------------------
 * Copyright © 2020, SAS Institute Inc., Cary, NC, USA.  All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 *---------------------------------------------------------------------------------------
 *
 *  Module:     cdm_launch.sas
 *  Purpose:    Controls the running of the Common Data Model Loader
 *  Version:    2.0
 *  History:
 *---------------------------------------------------------------------------------------
 *  This module controls the running of the CDM loader utility and should be updated to
 *  reflect directory locations specific to your environment. It will use history information
 *  maintained by both this utility and the CDM download process to determine the latest data
 *  to load into the database.
 *
 *  Setup:  The Common Data Model (CDM) ETL utility requires the following directory
 *    structure to be created under the "home" directory for the utility.
 *
 *      config    - will contain configuration and temporary files
 *      ddl       - sample definitions for loading the CDM into 3rd party databases
 *      logs      - where the log files from executing the CDM utility will be written
 *      macros    - where the SAS macros comprising the CDM utility will be stored
 *
 *  A SAS macro variable is defined below referencing the top level of this directory
 *  structure.
 *
 *  This utility takes the downloaded CDM SAS data sets and loads them into an on-prem
 *  3rd party database.  This utility does not download the data sets, it requires a
 *  separate process which is provided as a Knowledge Share Application (KSA) and is also
 *  available through GitHub to do the download and creation of the CDM data sets.
 *  A SAS macro variable is defined referencing the location of those previously downloaded
 *  SAS data sets.
 *
 *  DDL files defining the tables and their contents are provided for many databases in
 *  the 'ddl' directory.  This utility has been tested with Oracle and can be used as a
 *  template for loading into other databases with minimal modifications.
 *---------------------------------------------------------------------------------------*/


/*  Define global macro variables.  */

    %global Verbose DBAgnostic rc CDMHome CDMMart Slash
            dbname dbpath dbschema dbuser dbpass
            ;

/*
 *  The VERBOSE flag determines whether to print all SAS notes and messages to the log
 *  or only specific messages that indicate the progress of the execution.  Set VERBOSE=1 for
 *  debugging purposes, set VERBOSE=0 for normal operation; VERBOSE=0 is the default.
 *
 *  The DBAgnostic flag controls whether to use database agnostic syntax which should be
 *  applicable to most data bases and is the default.  At this point only database agnostic
 *  support is provided.  At a future date code may be provided for specific databases.
 */

    %let Verbose=0;
    %let DBAgnostic=1;
    %let rc = 0;

%macro CHECK_VERBOSE;
    %if "&Verbose" eq "1" %then
        options source2 source compress=yes symbolgen mlogic mprint mrecall notes serror noquotelenmax;
    %else
        options source2 source compress=yes nofmterr novnferr nobyerr nodsnferr nosymbolgen nomlogic nomprint
                nomrecall nonotes noserror noquotelenmax;
%mend;

    %CHECK_VERBOSE;

/*
 *  Set the value of the following CDM macro variables.
 *
 *  CDMHOME indicates the directory location where this CDM utility has been installed.
 *  CDMMart indicates the top directory location where the CDM SAS data sets have been downloaded.
 *  Slash   indicates the type of slash character that is used in file system paths, based on whether
 *          you are running on Windows '\' or Linux '/'.
 */

    %let CDMHome=/dev/sassoftware/ci360-cdm-loader-sas;
    %let CDMMart=/dev/sassoftware/ci360-download-client-sas;
    %let Slash = /;

/*
 *  Define the schema and credentials required to access the on-prem database.
 */

    %let dbname=oracle;
    %let dbpath=orapath
    %let dbschema=myschema;
    %let dbuser=myuser;
    %let dbpass="mypass";

/*
 *  The printto procedure will direct log output to a file.  The step below directs the log to the "logs"
 *  directory of the CDMHome location, including the current date time in the log file name.
 */

    proc printto log="&CDMHome&Slash.logs&Slash.CDMLoad_%left(%sysfunc(datetime(),B8601DT15.)).log"; run;


/*
 *  Define the location where the SAS macros that comprise this utility can be found.
 */

    filename cdmautos "&CDMHome.&Slash.macros";
    options mautosource sasautos=(cdmautos,SASAUTOS);

/*
 *  Define the SAS libref for database access
 */

    libname dblib &dbname path=&dbpath schema=&dbschema user=&dbuser pw=&dbpass
            dbmax_text=5000
            bl_default_dir='/tmp'
            reread_exposure=yes
            update_lock_type=row
            ;


/*
 *  Launch the CDM ETL Utility
 */

    %cdm_main;

/*
 *  Stop printing output to the log
 */

    proc printto; run;

