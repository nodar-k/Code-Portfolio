*Import data file;


PROC IMPORT FILE="/home/u60694781/sasuser.v94/cases_WHO_extract.csv"
        out=CASESVAX2
        dbms=csv
        replace;
        getnames=yes;
RUN;

*Telling SAS to find this CSV file and create a copy in my folder;
filename download "/home/u60694781/sasuser.v94/owid_covid_raw.xlsx";

proc http url="https://covid.ourworldindata.org/data/owid-covid-data.xlsx" 
		out=download;
run;

PROC IMPORT FILE=download
        out=OWID_FULL_DATASET dbms=xlsx replace;
        getnames=yes;
RUN;

filename download_2 "/home/u60694781/sasuser.v94/classifications.xlsx";

proc http url="http://databank.worldbank.org/data/download/site-content/CLASS.xlsx" 
		out=download_2;
run;

PROC IMPORT FILE=download_2
        out=INCOME_CLASS dbms=xlsx replace;
        getnames=yes;
RUN;


DATA OWID_FULL_DATASET; SET OWID_FULL_DATASET;
        date_format = INPUT(date, YYMMDD10.);
        format date_format YYMMDD10.;
        rename location = country;
RUN;

*Create means;
PROC MEANS mean data=OWID_FULL_DATASET;
	VAR new_tests_per_thousand;
	BY country;
	WHERE "31Dec2019"d <= date_format <= "31May2021"d;
	output out=class_means mean= sum= /autoname;
RUN;

PROC SORT DATA=class_means; BY Country;
PROC SORT DATA=CASESVAX2; BY Country;
RUN;

DATA COMBO;
	MERGE class_means(in=a) CASESVAX2(in=b); 
	BY Country;
	if a=b;
RUN;

DATA RESTRICTED_SET; SET OWID_FULL_DATASET;
	KEEP country date_format excess_mortality_cumulative;
	WHERE date_format = "31May2021"d;
RUN;

DATA COMBO2;
	MERGE RESTRICTED_SET(in=a) CASESVAX2(in=b); 
	BY Country;
	if a=b;
RUN;

*ADJUSTED MODEL;
PROC GLM data=COMBO2;
	title "Example of linear regression";
	CLASS income_group(ref="High income");
	model excess_mortality_cumulative = MONTHS_TO_VAX income_group log_pop /solution clparm;
RUN;

PROC GLM data=COMBO;
	CLASS income_group(ref="High income");
	model cum_deaths_prop_log = MONTHS_TO_VAX|income_group new_tests_per_thousand_mean log_pop/solution clparm;
RUN;

*ADJUSTED MODEL;
PROC GLM data=COMBO;
	title "Example of linear regression";
	CLASS income_group(ref="High income");
	model cum_deaths_prop_log = MONTHS_TO_VAX income_group log_pop new_tests_per_thousand_mean /solution clparm;
RUN;

DATA INCOME_CATS; SET CASESVAX2;
	KEEP Country income_group;
RUN;

*Create some new variables;
DATA CASESVAX2; SET CASESVAX2;
	if income_group = 'NA' then income_group=.;			*In R, empty values = NA, we need to correct this in SAS;
	if DAYS_TO_FIRST_AUTH = 'NA' then DAYS_TO_FIRST_AUTH=.;
	if DAYS_TO_FIRST_VAX = 'NA' then DAYS_TO_FIRST_VAX=.;

	*Transform some of the variables;
	cum_deaths_prop_log = log(cum_deaths_prop);
	cum_deaths_prop_sqr = sqrt(cum_deaths_prop);
	log_pop = log(population);
	
	*Create variables that convert from days to months;
	MONTHS_TO_VAX = DAYS_TO_FIRST_VAX/30;
	MONTHS_TO_AUTH = DAYS_TO_FIRST_AUTH/30;
RUN;

*Produce some stats on some of our variables to better understand how things are spread;
proc univariate data=CASESVAX2;
   var cum_cases_prop cum_deaths_prop months_to_vax months_to_auth;
   histogram;
run;

*Create a new binary varibale; 
DATA CASESVAX2; SET CASESVAX2;
	if cum_cases_prop >= 0.015593 then CUM_CASES_PROP_BIN = 1;
	else if cum_cases_prop < 0.015593 & cum_cases_prop >0 then CUM_CASES_PROP_BIN = 0;
	else CUM_CASES_PROP_BIN=.;
RUN;

*Produce frequency plot on cum cases by income group;
PROC FREQ data=CASESVAX2;
	TABLE CUM_CASES_PROP_BIN*INCOME_GROUP;
RUN;

*Comparing months to vaccination by income category;
PROC GLM data=CASESVAX2;
	title "Comparing months to first vaccination by income category";
	CLASS income_group(ref="High income");
	model MONTHS_TO_VAX = income_group/solution clparm;
	LSMEANS income_group/ADJUST=BON CL;
RUN;

*Comparing months to authorization by income category;
PROC GLM data=CASESVAX2;
	title "Comparing months to first authorization by income category";
	CLASS income_group(ref="High income");
	model MONTHS_TO_AUTH = income_group/solution clparm;
	LSMEANS income_group/ADJUST=BON CL;
RUN;

*CRUDE MODELS;
PROC GLM data=casesVax;
	model cum_deaths_prop_log = MONTHS_TO_VAX/solution clparm;
RUN;

PROC GLM data=casesVax;
	model cum_deaths_prop_log = log_pop/solution clparm;
RUN;

PROC GLM data=casesVax;
	CLASS income_group(ref="High income");
	model cum_deaths_prop_log = income_group/solution clparm;
RUN;

*ADJUSTED MODEL;
PROC GLM data=casesVax2;
	title "Example of linear regression";
	CLASS income_group(ref="High income");
	model cum_deaths_prop_log = MONTHS_TO_VAX|income_group log_pop /solution clparm;
RUN;

PROC LOGISTIC data=combo;
	CLASS CUM_CASES_PROP_BIN(ref='0') INCOME_GROUP(ref="Low income");
	model CUM_CASES_PROP_BIN = MONTHS_TO_VAX income_group log_pop new_tests_per_thousand_mean /firth;
RUN;
