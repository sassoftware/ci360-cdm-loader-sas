#  SAS Customer Intelligence 360 CDM Loader - SAS

## Overview
This is a sample client that loads data sets from the Common Data Model (CDM) for SAS Customer Intelligence 360 
into a third-party database.

<!--- ## What's New -->

## Prerequisites
Before you can run the program, complete these steps:
1. Install Base SAS. The version depends on the database that you are loading data into:
      * For the Snowflake database, install Base SAS 9.4M7 (with Unicode Support).
      * For all other databases, install Base SAS 9.4M4 (with Unicode Support).
2. Enable SAS to use the XCMD System Option. For more information, see the 
  [Help Center for SAS 9.4](https://go.documentation.sas.com/?cdcId=pgmsascdc&cdcVersion=9.4_3.4) and search for the 
  XCMD option.

## Installation
Download the CDM loader program from this repository and save it to the machine where it will run (your local machine, 
for example).

## Getting Started
Before you set up the CDM loader to run, familiarize with the database setup and some best practices.

### Setting up the On-Premises Database Tables
Before you can load CDM data into the third-party database, the tables must be created in the database using
an appropriate DDL file.e.g for Oracle database use ./ddl/ci_cdm3_ddl_oracle.sas

The /ddl folder contains DDL macros to create the tables in many third-party databases. If a DDL macro  
does not exist for a specific database, use an existing DDL as a template to start from.

The /ddl folder also contains corresponding macros to delete (DROP) the tables from a database. These 
macros can be used to remove the existing tables if necessary.

You only need to run the DDL macros once to create the tables in your database. However, if you delete the tables you will need 
to run the DDL macros again.

**Note:** Your database credentials are needed to create or delete the tables. These credentials are defined in the 
/macros/cdm_launch.sas file. For information on how to set your credentials, see [Examples](#examples).

This program (the CDM loader) does not download the CDM data sets. This program uses data sets that
were already downloaded through the download API (or with the 
[ci360-download-client-sas program](https://github.com/sassoftware/ci360-download-client-sas) on GitHub).

### Best Practice for Loading Data Sets
When you download data sets that are used with the CDM loader, you should delete previously downloaded 
data sets before you download new data with the ci360-download-client-sas program. Data is appended to some data sets, 
so the size of those sets continues to grow.

By deleting previously downloaded data before a new download attempt, you can improve performance by ensuring that 
only new or updated data is loaded into the database.

However, if you are using other utilities to process the downloaded data, you should evaluate whether you need to delete 
the existing data sets between downloads.

## Running the CDM Loader

1. Open BASE SAS 9.4M4 (with Unicode Support).
2. Open the cdm_launch.sas macro from the /macros folder
3. Set the required variables in the cdm_launch.sas macro.


## Examples

These examples show how to set the variables in cdm_launch.sas.

1. Define variables for file locations and the file system:
   * the location where the CDM loader is installed
   * the location where the download client is installed
   * the "Slash" character, which is the directory separator for your file system. Set this appropriately for either
     a Microsoft Windows or Unix platform.
     
   ```
   %let CDMHome=/dev/sassoftware/ci360-cdm-loader-sas;
   %let CDMMart=/dev/sassoftware/ci360-download-client-sas;
   %let Slash = /;
   ```

2. Define the third-party database name and the credentials to access the database:
   ```
   %let dbname=oracle;
   %let dbpath=orapath
   %let dbschema=myschema;
   %let dbuser=myuser;
   %let dbpass="mypass";
   ```

### Migrating to Schema 16
If you are using CDM loader with schema 10. please update your database  to schema 16 using alter ddl file  ./ddl/ci_cdm3_alter_ddl_<dbname>.sas .
e.g. if you are using oracle as databasee alter file is ci_cdm3_alter_ddl_oracle.sas .
Please run the alter ddls and then run the cdm loader program.
Use updated SAS download client for schema16.


### Troubleshooting
The Postgres DDL, including Aurora Postgres, need to be run as a superuser to avoid permission error while executing disable trigger code:

## Contributing

We welcome your contributions! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on how to submit contributions to this project.

## License

This project is licensed under the [Apache 2.0 License](LICENSE).

## Additional Resources
For more information, see the [Learn Page](https://support.sas.com/en/software/customer-intelligence-360-support.html) for SAS Customer Intelligence 360.
