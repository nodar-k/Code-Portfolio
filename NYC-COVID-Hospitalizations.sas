****************************************************************************************;
**	P8483: Spring 2021														     	  **;
**	Midterm Exam 1																	  **;
**  Name:   Nodar Kipshidze                                                           **;
**  UNI:	nk2988															       	  **;
****************************************************************************************;

****************************************************************************************;
**********************************| Question 2 |****************************************;
****************************************************************************************;

/*
Question 2A. Create a new SAS data file in the WORK library called “_5boros” by converting the 
referenced file above to a SAS data file and keeping only the variables in the table below. 
Restrict the date range for your new dataset to include only observations between March 1, 2020 
and January 31, 2022 (inclusive).

Variables to keep:
Date_of_interest
Case_count
Probable_case_count
Hospitalized_count
Death_count
Probable_death_count
BX_Case_count
BX_Probable_case_count
BX_Hospitalized_count
BX_Death_count
BX_Probable_death_count
BK_Case_count
BK_Probable_case_count
BK_Hospitalized_count
BK_Death_count
BK_Probable_death_count
QN_Case_count
QN_Probable_case_count
QN_Hospitalized_count
QN_Death_count
QN_Probable_death_count
MN_Case_count
MN_Probable_case_count
SI_Case_count
SI_Probable_case_count
SI_Hospitalized_count
SI_Death_count
SI_Probable_death_count

*/;


*Set up a temporary holding place;
filename download "/home/u60694781/sasuser.v94/Midterm/question2.csv";

*Telling SAS to find this CSV file and create a copy in my folder;
proc http url="https://github.com/nychealth/coronavirus-data/raw/f5e49358a6cf3cb2fb980f39ff3fd0b47989e2ba/trends/data-by-day.csv" 
		out=download;
run;

PROC IMPORT DATAFILE="/home/u60694781/sasuser.v94/Midterm/question2.csv" 
	OUT=WORK._5boros(keep=
	Date_of_interest
	Case_count
	Probable_case_count
	Hospitalized_count
	Death_count
	Probable_death_count
	BX_Case_count
	BX_Probable_case_count
	BX_Hospitalized_count
	BX_Death_count
	BX_Probable_death_count
	BK_Case_count
	BK_Probable_case_count
	BK_Hospitalized_count
	BK_Death_count
	BK_Probable_death_count
	QN_Case_count
	QN_Probable_case_count
	QN_Hospitalized_count
	QN_Death_count
	QN_Probable_death_count
	MN_Case_count
	MN_Probable_case_count 
	MN_Hospitalized_count
	MN_Death_count
	MN_Probable_death_count
	SI_Case_count
	SI_Probable_case_count
	SI_Hospitalized_count
	SI_Death_count
	SI_Probable_death_count
	WHERE=("01Mar2020"d <= Date_of_interest <= "31Jan2022"d)) DBMS=CSV REPLACE;
	GETNAMES=YES;
run;

*Check the contents of our improted datafile with above restrictions;
PROC CONTENTS Data=work._5boros;

*Check if we selected the right date range;
PROC TABULATE Data=work._5boros;
	var Date_of_interest;
	tables Date_of_interest,
		(min max)*f=date9.;
	Title 'Checking minimum and maximum date of restricted dataset';
run;

****************************************************************************************;

/*
Question 2B. 
Create a new variable (call it “calculated_hosp_count”) that for each day, is equal to 
the sum of the borough-specific hospitalization counts (BX_Hospitalized_count, 
BK_Hospitalized_count, QN_Hospitalized_count, MN_Hospitalized_count, and SI_Hospitalized_count). 
Write a code that creates a variable whose value is equal to 1 if calculated_hosp_count 
is equal to hospitalized_count, and zero if they are unequal. Write a code and provide the 
frequency of this variable. How many days is calculated_hosp_count = hospitalized_count? 
How many days is it unequal?
*/;

PROC FORMAT;
	value hospCheckf 0 = "Hosp counts NOT equal"
				1 = "Hosp counts equal";
run;

DATA _5boros; set _5boros;
	calculated_hosp_count=sum(of BX_Hospitalized_count
				BK_Hospitalized_count
				QN_Hospitalized_count
				MN_Hospitalized_count
				SI_Hospitalized_count);
	if calculated_hosp_count = hospitalized_count then hospCheck=1;
	else if calculated_hosp_count NOT= hospitalized_count then hospCheck=0;
	format hospCheck hospCheckf.;
	label hospCheck="Checking hospital count against calculated hospital count";
run;

*Checking to see my new variable was calcualted correctly; 
PROC FREQ data=_5boros;
	table hospCheck;
	Title 'Frequency of equal and unequal hospitalization counts';
PROC PRINT data=_5boros;
	where hospCheck=1;
	var calculated_hosp_count hospitalized_count;
	Title 'Harmonized hospitalization counts';
PROC PRINT data=_5boros;
	where hospCheck=0;
	var calculated_hosp_count hospitalized_count;
	Title 'Discordant hospitalization counts';
run;

/*
Answer to Question 2B:

For my newly coded variable "hospCheck", there are 697 (99.29%) observations where the hospitalization counts
are not equal between hospitalized_count and calculated_hosp_count. In comparsion, there are 5 (0.71%) observations
where where the hospitalization counts are equal between hospitalized_count and calculated_hosp_count.
*/;

****************************************************************************************;

/*
Question 2C. Create a new variable “max_hosp_count” that takes the larger of the two values 
(calculated_hosp_count and hospitalized_count) for each day. Confirm this works.
*/;

DATA _5boros; set _5boros;
	max_hosp_count=max(hospitalized_count, calculated_hosp_count);
run;

PROC PRINT data=_5boros;
	var calculated_hosp_count hospitalized_count max_hosp_count;
	Title 'Checking to see our new variable is correctly coded';
run;

* Going through the readout, it seems the variable is calcualted correctly;

****************************************************************************************;

/*
Question 2D. Create 5 new variables (one for each Borough) that adds that borough’s confirmed and 
probable death counts on a given day. For each borough please provide the date which had 
the highest death count and the value of this death count.
*/;

DATA _5boros; set _5boros;
	BK_TOTAL_DEATH_COUNT = BK_DEATH_COUNT+BK_PROBABLE_DEATH_COUNT; 
	label BK_TOTAL_DEATH_COUNT="Total confirmed & probable COVID-19 deaths in Brooklyn";
	BX_TOTAL_DEATH_COUNT = BX_DEATH_COUNT+BX_PROBABLE_DEATH_COUNT;
	label BX_TOTAL_DEATH_COUNT="Total confirmed & probable COVID-19 deaths in Bronx";
	MN_TOTAL_DEATH_COUNT = MN_DEATH_COUNT+MN_PROBABLE_DEATH_COUNT;
	label MN_TOTAL_DEATH_COUNT="Total confirmed & probable COVID-19 deaths in Manhattan";
	QN_TOTAL_DEATH_COUNT = QN_DEATH_COUNT+QN_PROBABLE_DEATH_COUNT;
	label QN_TOTAL_DEATH_COUNT="Total confirmed & probable COVID-19 deaths in Queens";
	SI_TOTAL_DEATH_COUNT = SI_DEATH_COUNT+SI_PROBABLE_DEATH_COUNT;
	label SI_TOTAL_DEATH_COUNT="Total confirmed & probable COVID-19 deaths in Staten Island";
run;

PROC MEANS data=_5boros NOPRINT;
	var BK_TOTAL_DEATH_COUNT MN_TOTAL_DEATH_COUNT BX_TOTAL_DEATH_COUNT;
	output out=summary (drop= _TYPE_ _FREQ_)
		maxid(BK_TOTAL_DEATH_COUNT(DATE_OF_INTEREST))=_Date_BK
		maxid(MN_TOTAL_DEATH_COUNT(DATE_OF_INTEREST))=_Date_MN
		maxid(BX_TOTAL_DEATH_COUNT(DATE_OF_INTEREST))=_Date_BX
		maxid(QN_TOTAL_DEATH_COUNT(DATE_OF_INTEREST))=_Date_QN
		maxid(SI_TOTAL_DEATH_COUNT(DATE_OF_INTEREST))=_Date_SI
		max(BK_TOTAL_DEATH_COUNT MN_TOTAL_DEATH_COUNT 
		BX_TOTAL_DEATH_COUNT 
		QN_TOTAL_DEATH_COUNT SI_TOTAL_DEATH_COUNT)=
		BK_Peak MN_Peak BX_Peak QN_Peak SI_Peak ;
PROC PRINT data=summary;
Title 'Peaks in Confirmed and Probable COVID-19 Deaths by Borough and Date';
run;

/*
Answer to Question 2D:
The tallest peak for confirmed and probable COVID-19 deaths
between March 1, 2020 and January 31, 2022 for all boroughs 
was in the first two weeks of April 2020. 

The peak death count in Brooklyn was 265 deaths of April 12, 2020. 
The peak death count in Manhattan was 121 deaths in April 7, 2020.
The peak death count in the Bronx was 168 deaths in April 11, 2020.
The peak death count in Queens was 259 deaths in April 6, 2020.
The peak death count in Staten Island was 43 deaths in APril 8, 2020.
*/;

****************************************************************************************;

/*
Question 2E. 
Which borough had the most confirmed cases cumulatively? 
Which borough had the most cumulative hospitalizations? 
Which borough had the most confirmed deaths?
*/;

PROC MEANS SUM data=_5boros;
	var BK_CASE_COUNT BX_CASE_COUNT MN_CASE_COUNT QN_CASE_COUNT SI_CASE_COUNT
		BK_HOSPITALIZED_COUNT BX_HOSPITALIZED_COUNT MN_HOSPITALIZED_COUNT 
		QN_HOSPITALIZED_COUNT SI_HOSPITALIZED_COUNT
		BK_DEATH_COUNT MN_DEATH_COUNT BX_DEATH_COUNT 
		QN_DEATH_COUNT SI_DEATH_COUNT;
run;

/*
Answer to Question 2E:
Between March 1, 2020 and January 31, 2022, among all five boroughs,
Brooklyn had the most cumulative cases at 579,096 cases. Similarly,
Brooklyn had the most cumulative hospitalizations at 44,222 hospitalizations. Finally,
Brooklyn had the most confirmed deaths at 10,420 confirmed deaths. This could be because 
Brooklyn has the largest population among all five boroughs, therefore, a per capita statistic 
may be more appropriate here.
*/;

****************************************************************************************;

/*
Question 2F.

SAS data file “midterm_2f” in the RAW data file contains only three variables: date_of_interest, 
Borough, and Hospitalizations. Below please find the 2020 US Census estimates for population by 
borough (thanks, Wikipedia!). Using these two pieces of information (this will involve creating 
a new SAS data file in the SAS editor and merging this with the midterm_2f data file by borough), 
create a variable “hosp_per_100k” that is equal to the number of hospitalizations divided by that 
Borough’s population, times 100,000. Then write a code and answers to the following questions in comments:

	•Which borough had the largest single-day hospitalization rate per 100,000 population? What was this rate?
	•Which borough had the largest mean hospitalization rate per 100,000 population? What was this rate?
	•Restricted to dates in 2022, which borough had the LOWEST mean hospitalization rate? What was this rate?

*/;


*Reference library of raw data;
libname bHosp "/home/u60694781/my_shared_file_links/mrl2013/RAW DATA/";
run;

*1. Create a copy in our work library;
*2. Set up logic statements that calculate Borough-specific hosp. rates;
*3. Label our new variable;
DATA _b_Hosp; set bHosp.midterm_2f;
	if Borough = "BX" then hosp_per_100k=(Hospitalizations/1472654)*100000;
	else if Borough = "BK" then hosp_per_100k=(Hospitalizations/2736074)*100000;
	else if Borough = "MN" then hosp_per_100k=(Hospitalizations/1694251)*100000;
	else if Borough = "QN" then hosp_per_100k=(Hospitalizations/2405464)*100000;
	else if Borough = "SI" then hosp_per_100k=(Hospitalizations/495747)*100000;
	label Hospitalizations= "Hospitalizations per 100,000";
run;

*Max and mean hosp overall, by borough;
PROC MEANS max mean data=_b_Hosp;
	class Borough;
	var hosp_per_100k;
	Title "Mean and highest hospitalizations per 100,000 from January 1, 2022 to end of period. Standardized to population. Stratified by borough.";
run;

*Mean hosp rate for 2022, by borough;
PROC MEANS mean data=_b_Hosp;
	class Borough;
	var hosp_per_100k;
	WHERE Date_of_interest >= "01JAN2022"d;
	Title "Lowest hospitalizations per 100,000 from January 1, 2022 to end of period. Standardized to population. Stratified by borough.";
run;

/*
Answer to Question 2F:

When standardized for population, the Bronx had the largest single-day hospitalization rate at 26.55 per 100,000. 
When standardized for population, the Bronx had the largest mean hospitalization rate for the entire observation period with
a mean 3.077 per 100,000 hospitalizations. Finally, Queens has had the lowest mean hospitalization rate in 2022, 
with a mean hospitalization rate of 5.51 per 100,000.

*/;