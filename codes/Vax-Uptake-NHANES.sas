/*	SECTION ONE: DATA CLEANING AND COMPILATION 
	In this section, we will be capturing dataset that contains our research of interest from NHANES and create a large merged datasets with only the variables of interest.
	Also we will be creating and manipulating exposure/outcome/confounder variables from the datasets for the analysis purpose. */


/*	1A: 
	Description: Set up a temporary holding place for the 2015-2016 and 2017-2018 xpt. datafiles in the sasuser file, datafiles of interest include:
					Demo: Demographic Variables 
					Huq: Hospital Utilization and Access to Care Questionnaire
					Imq: Immunization Questionnaire
					Hiq: Health Insurance Questionnaire
					Inq: Income Questionnaire
					Ocq: Occupation Questionnaire
					Hsq: Current Health Status Questionnaire
	Reason: The downloaded xpt. datafiles will be stored in these temporary places and ready to be transposed into SAS format.*/

/*2017-2018 datasets*/
FILENAME demo_18 "/home/u60651041/sasuser.v94/demo_18.xpt";
FILENAME huq_18 "/home/u60651041/sasuser.v94/huq_18.xpt";
FILENAME imq_18 "/home/u60651041/sasuser.v94/imq_18.xpt";
FILENAME hiq_18 "/home/u60651041/sasuser.v94/hiq_18.xpt";
FILENAME inq_18 "/home/u60651041/sasuser.v94/inq_18.xpt";
FILENAME ocq_18 "/home/u60651041/sasuser.v94/ocq_18.xpt";
FILENAME hsq_18 "/home/u60651041/sasuser.v94/hsq_18.xpt";
/*2015-2016 datasets*/
FILENAME demo_16 "/home/u60651041/sasuser.v94/demo_16.xpt";
FILENAME huq_16 "/home/u60651041/sasuser.v94/huq_16.xpt";
FILENAME imq_16 "/home/u60651041/sasuser.v94/imq_16.xpt";
FILENAME hiq_16 "/home/u60651041/sasuser.v94/hiq_16.xpt";
FILENAME inq_16 "/home/u60651041/sasuser.v94/inq_16.xpt";
FILENAME ocq_16 "/home/u60651041/sasuser.v94/ocq_16.xpt";
FILENAME hsq_16 "/home/u60651041/sasuser.v94/hsq_16.xpt";
RUN;

/*	1B: 
	Description: Download SAS transport files from CDC website in xpt format and saved them to the previously created SASUSER files
	Reason: The downloaded xpt. datafiles will be stored in these temporary places and ready to be transposed into SAS format.*/	
	
/*2017-2018 datasets*/
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/DEMO_J.xpt" out=demo_18;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/HUQ_J.XPT" out=huq_18;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/IMQ_J.XPT" out=imq_18;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/HIQ_J.XPT" out=hiq_18;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/INQ_J.XPT" out=inq_18;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/OCQ_J.XPT" out=ocq_18;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2017-2018/HSQ_J.XPT" out=hsq_18;
/*2015-2016 datasets*/
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/DEMO_I.xpt" out=demo_16;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/HUQ_I.XPT" out=huq_16;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/IMQ_I.XPT" out=imq_16;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/HIQ_I.XPT" out=hiq_16;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/INQ_I.XPT" out=inq_16;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/OCQ_I.XPT" out=ocq_16;
PROC HTTP url="https://wwwn.cdc.gov/Nchs/Nhanes/2015-2016/HSQ_I.XPT" out=hsq_16;
RUN;

/*	1C: 
	Description: Create library references in the SASUSER file and transposed the xpt files into SAS format
	Reason: The xpt file will not operate in SAS, transpose into SAS is necessary for further data manipulation*/
	
/*2017-2018 datasets*/
LIBNAME xdemo18 xport "/home/u60651041/sasuser.v94/demo_18.xpt";
LIBNAME xhuq18 xport "/home/u60651041/sasuser.v94/huq_18.xpt";
LIBNAME ximq18 xport "/home/u60651041/sasuser.v94/imq_18.xpt";
LIBNAME xhiq18 xport "/home/u60651041/sasuser.v94/hiq_18.xpt";
LIBNAME xinq18 xport "/home/u60651041/sasuser.v94/inq_18.xpt";
LIBNAME xocq18 xport "/home/u60651041/sasuser.v94/ocq_18.xpt";
LIBNAME xhsq_18 xport "/home/u60651041/sasuser.v94/hsq_18.xpt";
/*2015-2016 datasets*/
LIBNAME xdemo16 xport "/home/u60651041/sasuser.v94/demo_16.xpt";
LIBNAME xhuq16 xport "/home/u60651041/sasuser.v94/huq_16.xpt";
LIBNAME ximq16 xport "/home/u60651041/sasuser.v94/imq_16.xpt";
LIBNAME xhiq16 xport "/home/u60651041/sasuser.v94/hiq_16.xpt";
LIBNAME xinq16 xport "/home/u60651041/sasuser.v94/inq_16.xpt";
LIBNAME xocq16 xport "/home/u60651041/sasuser.v94/ocq_16.xpt";
LIBNAME xhsq16 xport "/home/u60651041/sasuser.v94/hsq_16.xpt";

/*	 1D: 
  	 Description: For every datafile, Keep only the variables of interest. Variables of interest include:
	   Demo: ID, Gender, Age, Race (Hispanic/NH Asian), Educational Level (6-19/ 20+), Country of Birth
	   Huq:  ID, Routine Place to go for Healthcare, Type Place Most Often Go for Healthcare, Times Receive Healthcare Over Past Year
	   Imq:	 ID, Hepatitis A vaccine receivement, Hepatitis B vaccine 3 dose receivement, HPV Vaccine Receivement for Female, HPV Vaccine Receivement for Male, Age first dose HPV, Number of dose of HPV vaccine received 
	   Hiq:	 ID, Covered by insurance, Covered by Private Insurance/Medicare/Medi-Gap/Medicaid/CHIP/Military healthcare/State-Sponsored Heapth Plan/ Other Government health plan/ Single Servce Plan
	   inq:  ID, Monthly Family Income
	   ocq:  ID, Type of Work Done Last Week, Job/Work Situation, Main Reson Did not Work Last Week
	   hsq:  ID, General Health Condition
  	 Reason: The exposure is operationalized by Insurance Coverage, outcome is operationalized by HPVA/HPVB vaccine uptake and the confounder is operationalized by SES status (Education, Job and Income).
   		   The deletion of unwanted parts would make the analyze step easier*/

/*2017-2018 datasets*/
DATA demo18; SET xdemo18.DEMO_J; KEEP SEQN RIAGENDR RIDAGEYR RIDRETH1 RIDRETH3 DMDEDUC3 DMDEDUC2 DMDBORN4;
DATA huq18; SET xhuq18.HUQ_J; KEEP SEQN HUQ030 HUQ041 HUQ051;
DATA imq18; SET ximq18.IMQ_J; KEEP SEQN IMQ011 IMQ020 IMQ060 IMQ070 IMQ090 IMQ100;
DATA hiq18; SET xhiq18.HIQ_J; KEEP SEQN HIQ011 HIQ031A HIQ031B HIQ031C HIQ031D HIQ031E HIQ031F HIQ031H HIQ031I HIQ031J;
DATA inq18; SET xinq18.INQ_J; KEEP SEQN IND235;
DATA ocq18; SET xocq18.OCQ_J; KEEP SEQN OCD150 OCQ260 OCQ380;
DATA hsq18; SET xhsq_18.HSQ_J; KEEP SEQN HSD010;
/*2015-2016 datasets*/
DATA demo16; SET xdemo16.DEMO_I; KEEP SEQN RIAGENDR RIDAGEYR RIDRETH1 RIDRETH3 DMDEDUC3 DMDEDUC2 DMDBORN4;
DATA huq16; SET xhuq16.HUQ_I; KEEP SEQN HUQ030 HUQ041 HUQ051;
DATA imq16; SET ximq16.IMQ_I; KEEP SEQN IMQ011 IMQ020 IMQ060 IMQ070 IMQ090 IMQ100;
DATA hiq16; SET xhiq16.HIQ_I; KEEP SEQN HIQ011 HIQ031A HIQ031B HIQ031C HIQ031D HIQ031E HIQ031F HIQ031H HIQ031I HIQ031J;
DATA inq16; SET xinq16.INQ_I; KEEP SEQN IND235;
DATA ocq16; SET xocq16.OCQ_I; KEEP SEQN OCD150 OCQ260 OCQ380;
DATA hsq16; SET xhsq16.HSQ_I; KEEP SEQN HSD010;
RUN;

/*	1E:
	Description: Sort datasets by Respondent Sequence Number, create a full merged datasets pooling 2015-2016 and 2016-2017 files by matching the Respondent Sequence Number from each datafile
	Reason: The compilation of multiple datafiles will bind individuals' information altogether through matching their Respondent Sequence Number, which is necessary for analysis step*/ 

/*2017-2018 datasets*/
PROC SORT DATA=demo18; BY SEQN;
PROC SORT DATA=huq18; BY SEQN;
PROC SORT DATA=imq18; BY SEQN;
PROC SORT DATA=hiq18; BY SEQN;
PROC SORT DATA=inq18; BY SEQN;
PROC SORT DATA=ocq18; BY SEQN;
PROC SORT DATA=hsq18; BY SEQN;
/*2015-2016 datasets*/
PROC SORT DATA=demo16; BY SEQN;
PROC SORT DATA=huq16; BY SEQN;
PROC SORT DATA=imq16; BY SEQN;
PROC SORT DATA=hiq16; BY SEQN;
PROC SORT DATA=inq16; BY SEQN;
PROC SORT DATA=ocq16; BY SEQN;
PROC SORT DATA=hsq16; BY SEQN;
RUN;

/*2017-2018 datasets*/
DATA MERGE18;
MERGE demo18 huq18 imq18 hiq18 inq18 ocq18 hsq18; 
BY SEQN;
/*2015-2016 datasets*/
DATA MERGE16;
MERGE demo16 huq16 imq16 hiq16 inq16 ocq16 hsq16; 
BY SEQN;
RUN;

/* 1F: 
	Description: Create full merged dataset pooling both NHANES year 2015-2016 and 2017-2018. Restrict to age group of 9 to 59 years old .
	Reason: Pooling two years data would allow a greater sample size for analyze. Since our research of interest are people age 9-59, restricting the age group is necessary*/
	
DATA MERGEDSET;
SET MERGE18 MERGE16;
WHERE RIDAGEYR in(9:59); 
RUN;

/*Check age was correctly restricted*/
PROC MEANS MIN MAX DATA=MERGEDSET;
VAR RIDAGEYR;
RUN;

/*	1G:
	Description: Create dummy variables for the exposure incovF, a categorical variable with 3 levels indicating individual's health insurance coverage status 
				 (No health insurance/Private Health insurance/Fed/State funded Health Insurance).
				 incovF is operationalized based on Health Insurance Questionnaire (HIQ):
				 incovF=0 if individual is not covered by any healthcare insurance (Answered NO to Health Insurance Coverage HIQ011)
				 incovF=1 if individual is only covered by private healthcare insurance (Answer YES to Health Insurance Coverage HIQ011 and Covered by Single Service Plan HIQ301J) 
				 incovF=2 if individual is only covered by any state-funded or government-funded healthcare insurance 
				 (Answer YES to Health Insurance Coverage HIQ011 and either Covered by Medicare/Medi-Gap/Medicaid/SCHIP/Military HealthCare/State-spnosored/other government insurance HIQ031B/031C/031D/031E/031F/031H/031I) 
	Reason: To create the dummy variables for the exposure Health insurance Coverage and enable operationalization of the exposure of interest in the study: Healthcare utilization*/ 	 

/*Format the exposure variables*/
PROC FORMAT;
value incovF 0 = 'No health insurance'
			 1 = 'Health insurance (private)'
			 2 = 'Health insurance (fed/state funded)';

/*Create exposure variable INCOV*/ 
DATA MERGEDSET; SET MERGEDSET;
IF HIQ011=2 then INCOV=0;		
ELSE IF HIQ011=1 & HIQ301J=23 then INCOV=0; 
ELSE IF HIQ011=1 & HIQ031A=14 then INCOV=1; 
ELSE IF HIQ011=1 & (HIQ031B=15 OR HIQ031C=16 OR HIQ031D=17 OR HIQ031E=18 OR HIQ031F=19 OR HIQ031H=21 OR HI0Q31I=22) then INCOV=2;
FORMAT INCOV incovF.;
LABEL INCOV ='Health insurance coverage';
RUN;

/*Check 2015-2016, 2017-2018 and pooled dataset if exposure variable was correctly coded and labelled*/
PROC FREQ DATA=MERGE18;
TABLE HIQ011 HIQ031A HIQ031B HIQ031C HIQ031D HIQ031E HIQ031F HIQ031H HIQ031I HIQ031J;
RUN;
PROC FREQ DATA=MERGE16;
TABLE HIQ011 HIQ031A HIQ031B HIQ031C HIQ031D HIQ031E HIQ031F HIQ031H HIQ031I HIQ031J;
RUN;
PROC FREQ DATA=MERGEDSET;
TABLE INCOV;
RUN;

/*	1H:
	Description: Create dummy variables for the outcome HEP_A_VAX, HEP_B_VAX and HPV_VAX, all are binary variables indicating individual's HEPA/HEPB/HPV Vaccination History.
				 1. HEP_A_VAX is operationalized based on Immunization Questionnaire (IMQ):
				 		HEP_A_VAX=1 if individual have ever received at least one dose of Hepatitis A vaccine (Answered "Yes,at least two doses" or "Less than 2 doses" to Question Received Hepatitis A vaccine IMQ011)
				 		HEP_A_VAX=0 if individual have never received Hepatitis A vaccine (Answered "No dose" to Question Received Hepatitis A vaccine IMQ011)
				 2. HEP_B_VAX is operationalized based on Immunization Questionnaire (IMQ):
				 		HEP_B_VAX=1 if individual have ever received at least one dose of Hepatitis B vaccine (Answered "Yes,at least three doses" or "Less than 3 doses" to Question Received Hepatitis B vaccine IMQ020)
				 		HEP_A_VAX=0 if individual have never received Hepatitis B vaccine (Answered "No dose" to Question Received Hepatitis B vaccine IMQ020)
				 3. HPV_VAX is operationlized based on Immunization Questionnaire (IMQ):
				 		HPV_VAX=1 if individual have ever received HPV vaccine (Answered "Yes"to Question Received HPV vaccine IMQ060 for female IMQ070 for male)
				 		HPV_VAX=0 if individual have never received HPV vaccine (Answered "NO"to Question Received HPV vaccine IMQ060 for female IMQ070 for male)			 
	Reason: To create the dummy variables for the outcome HEPA/HEPB/HPV vaccination uptake history and enable the operationalization of the outcome of interest in the study: Vaccine Uptake*/ 	

/*Label vaccination outcome variables*/
PROC FORMAT;
value vaxF 0 = 'Never vaccinated'
			 1 = 'Ever vaccianted (at least 1 dose)';

/*Create outcome variables*/

/*1. HEP A Vaccination history*/
DATA MERGEDSET; SET MERGEDSET;
IF IMQ011 in(1,2) then HEP_A_VAX=1;		 
ELSE IF IMQ011=3 then HEP_A_VAX=0;   
ELSE HEP_A_VAX=.;

/*2. HEP B Vaccination history*/
IF IMQ020 in(1,2) then HEP_B_VAX=1;		 
ELSE IF IMQ020=3 then HEP_B_VAX=0;   
ELSE HEP_B_VAX=.;

/*3. HPV Vaccination history*/
IF IMQ060=1 OR IMQ070=1 then HPV_VAX=1;		
ELSE IF (IMQ060=2 & IMQ070^=1) OR (IMQ070=2 & IMQ060^=1)  then HPV_VAX=0;  
ELSE HPV_VAX=.;

/*Apply the labels*/
FORMAT HEP_A_VAX HEP_B_VAX HPV_VAX vaxF.;
LABEL HEP_A_VAX = "Hepatitis A Vaccine";
LABEL HEP_B_VAX = "Hepatitis B Vaccine";
LABEL HPV_VAX = "HPV Vaccine";
RUN;

/*Checking if outcome variables were correctly coded and labelled*/
PROC FREQ DATA=MERGEDSET;
TABLE IMQ011*HEP_A_VAX;
TABLE IMQ020*HEP_B_VAX;
TABLE IMQ060*HPV_VAX;
TABLE IMQ070*HPV_VAX;
Title 'Checking recoding of the outcome variables';
RUN;
PROC FREQ DATA=MERGEDSET;
TABLE HEP_A_VAX HEP_B_VAX HPV_VAX;
RUN;

/*	1I:
	Description: Create dummy variables for the potential confounders include EDU, income, birthc, WORK, HEALTH, raceEth
			   	1. EDU is a binary variable indicating individuals' Education Attainment, operationalized based on Demographic Variables & Sample Weights Questionnaire (Demo)
			   		EDU=0 if individuals highest level of degree is less than High School (Answered "Less than 9th grade"or "9-11th grade"to the question Education level DMDEDUC2)
			   		EDU=1 if individuals highest level of degree is higher than High School (Answered "High School graduate/GED"or "COllege/AA" or "College graduateor above"to the question Education level DMDEDUC2)
			   	2. income is an ordinal(4) categorical variable indicating individuals' monthly family income level, operationalized based on Income questionnaire (inq_i)
			   		income=0 if individual's monthly family income is between $0-1,249 (Answered 1 or 2 or 3 to question Monthly Family Income IND235)
			   		income=1 if individual's monthly family income is between $1,250-$2,900 (Answered 4 or 5 or 6 to question Monthly Family Income IND235)
			   		income=2 if individual's monthly family income is between $2,900-$5,399 (Answered 7 or 8 or 9 to question Monthly Family Income IND235)
			   		income=3 if individual's monthly family income is greater than $5,400 (Answered 10 or 11 or 12 to question Monthly Family Income IND235)
			   	3. Birthc is a binary variable indicating if individual is born in the United State, operationalized based on Demographic Variables & Sample Weights Questionnaire (Demo)
			   		Birthc=0 if individual is not born in the United State (Answered "Others" to question Country of birth DMDBORN4)
			   		Birthc=1 if individual is  born in the United State (Answered "Born in 50 US states or Washington,DC " to question Country of birth DMDBORN4)
			   	4. WORK is a binary variable indicating individuals type of work, operationalized based on Occupation Questionnaire (OCQ_H)
			   		WORK=0 if individual is not currently working (Answered "With a job or business but not at work," or "Looking for work" or "Not working at a job or business" to the question type of work done last week OCD150)
			   		WORK=1 if individual is currently working (Answered "Working at a job or business" to the question Type of work done last week OCD150)
			   	5.HEALTH is an ordinal(3) categorical variable indicating individuals self-reported health status
			   		Health=0 if individual reported poor health (Answered "Poor" to the question General Health Condition HSD010)
			   		Health=1 if individual reported fair health (Answered "Fair" to the question General Health Condition HSD010)
			   		Health=2 if individual reported good/excellent health (Answered "Good" or "Very Good" or "Excellent" to the question General Health Condition HSD010)
			   	6.raceEth is a nominal(5) variable indicating individual's race,operationalized based on Demographic Variables & Sample Weights Questionnaire (Demo)
			   		raceEth=0 if individuals reported Hispanic or Latino race (Answered "Mexican American" or "Other Hispanic" to the question Race/Hispanic Origin w/NH Asian RIDRETH3)
					raceEth=1 if individuals reported NH: White race (Answered "Non-Hispanic White" to the question Race/Hispanic Origin w/NH Asian RIDRETH3)
					raceEth=2 if individuals reported NH: Black race (Answered "Non-Hispanic Black" to the question Race/Hispanic Origin w/NH Asian RIDRETH3)
					raceEth=3 if individuals reported NH: Asian race (Answered "Non-Hispanic Asian" to the question Race/Hispanic Origin w/NH Asian RIDRETH3)
					raceEth=4 if individuals reported Other or multi-racialrace (Answered "Other or multi-racialrace " to the question Race/Hispanic Origin w/NH Asian RIDRETH3)
		Reason:SES status including income, education and other social factors are confounders of interests in this study. Categorical variables are reduced into fewer categories and labelled
					for the purpose of creating dummy variables and the further analyses. */
	

/*Create format for coufounders*/
PROC FORMAT;
value eduF 0 = 'Less than HS Education'
			 1 = 'HS educuation or greater';
			 
value incomeF 0 = "$0-1,249" 
				1 = "$1,250-$2,900" 
				2 = "$2,900-$5,399" 
				3  = "> $5,400";
				
value birthcF 0 = "No" 
				1 = "Yes";

value workF 0 = "Not currently working" 
				1 = "Currently working";

value HEALTHf 0 = "Poor" 
				1 = "Fair"
				2 = "Good to excellent";

value raceEthF 0 = "Hispanic or Latino" 
				1 = "NH: White"
				2 = "NH: Black"
				3 = "NH: Asian"
				4 = "Other or multi-racial";
				
/*Create format for the gender variable for the ease of data analysis*/
value genderF 1 = "Male" 
				2 = "Female";
			
/*1. Create confounder dummy variables Education Attainment and apply the label*/
DATA MERGEDSET; SET MERGEDSET;
IF DMDEDUC2 in(1:2) then EDU=0; 
	ELSE IF DMDEDUC2 in(3:5) then EDU=1; 
	ELSE EDU=.;
FORMAT EDU eduF.;
LABEL EDU = "Educational attainment (for those 20 or greater)";

/*2. Create confounder dummy variables Family Monthly income and apply the label*/
IF IND235 in(1:3) then income=0;
	ELSE IF IND235 in(4:6) then income=1;
	ELSE IF	IND235 in(7:9) then income=2;
	ELSE IF IND235 in(10:12) then income=3;
	ELSE income=.;
FORMAT income incomeF.;
LABEL INCOME = "Monthly family income (recoded from IND235)";

/*3. Create confounder dummy variables Place of Birth and apply the label*/
IF DMDBORN4 = 1 then birthc=1;
	ELSE IF DMDBORN4 = 2 then birthc=0;
	ELSE birthc=.;
FORMAT birthc birthcF.;
LABEL birthc = "Born in the U.S.?";

/*4. Create confounder dummy variables work status and apply the label*/
IF OCD150 =1 then WORK=1;
	ELSE IF OCD150 in(2:4) then WORK=0;
	ELSE WORK=.;
FORMAT WORK workF.;
LABEL WORK = "Work done last week (recoded from OCD150)";

/*5. Create confounder variable self-reported health status and apply the label*/
IF HSD010 in(1:3) then HEALTH=2;
	ELSE IF HSD010=4 then HEALTH=1;
	ELSE IF HSD010=5 then HEALTH=0;
	ELSE HEALTH=.;
FORMAT HEALTH HEALTHF.;
LABEL HEALTH = "Self-reported health condition (recoded from HSD010)";

/*6. Create confounder dummy variables race and apply the label*/
IF RIDRETH3 in(1:2) then raceEth=0;
	ELSE IF RIDRETH3=3 then raceEth=1;
	ELSE IF RIDRETH3=4 then raceEth=2;
	ELSE IF RIDRETH3=6 then raceEth=3;
	ELSE IF RIDRETH3=7 then raceEth=4;
	ELSE raceEth=.;
FORMAT raceEth raceEthF.;
LABEL raceEth = "Self-reported race and ethnicity (recoded from RIDETH3)";

/*Apply the label to the gender variable for the ease of data analysis*/
FORMAT RIAGENDR genderF.;
RUN;

/*	SECTION TWO: DATA ANALYSIS
	In the following Section, we will be using exposure, outcome and potential confounder variables created in the section one to investigate our research question:
	Is healthcare insurance utilization associated with vaccine uptake?*/
	
/*	2A:  
	Description: Check if our created exposure(Healthcare insurance status) and outcomes (HEPA/HEPB/HPV vaccination) are coded/formatted correctly
	Reason: These will be the final variables for the analysis, any abnormality will result in falseful calculation */
PROC FREQ DATA=MERGEDSET;
TABLE INCOV*HEP_A_VAX / chisq expected;
TABLE INCOV*HEP_B_VAX/ chisq expected; 
TABLE INCOV*HPV_VAX/ chisq expected;
Title 'Checking recoding of the outcome variables';
RUN;

/* 2B: 
	Description: We assessed the crude association between exposure and outcome of interest using Logistic Regression.
				 In total of 6 models are created for 3 outcomes of interested, stratified by binary age group.
	Reason: To calculated the odds ratio,a measure of association comparing exposure groups using Logistic Regression. 
			Logistic regression is the default analytic technique for regression with binary outcome, in this case have received vaccine or have not
			Due to age limitation in certain questions, the crude models are stratified by age*/

/*2B1: Crude model assessing association between different Healthcare insurance utilization and Hepatitis A vaccine uptake among those who are aged 19 and below
		For the exposure, no health insurance is set as reference group*/
/* Crude Odds ratio comparing federal and reference group: 1.595 (CI:1.210,2.103)  
   Crude Odds ratio comparing Private and reference group: 1.254 (CI:0.951,1.653) p-value=0.0007 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') / param=reference;
MODEL Hep_A_Vax = incov;
WHERE RIDAGEYR LE 19;
Title1 'Crude model for Hep A vs Insurance Coverage';
RUN;

/*2B2: Crude model testing association between different Healthcare insurance utilization and Hepatitis B vaccine uptake among those who are aged 19 and below
		For the exposure, no health insurance is set as reference group*/
/* Crude Odds ratio comparing federal and reference group: 1.451 (CI:1.061,1.985)  
   Crude Odds ratio comparing Private and reference group: 1.784 (CI:1.294,2.460) p-value=0.0015 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') / param=reference;
MODEL Hep_B_Vax = incov;
WHERE RIDAGEYR LE 19;
Title1 'Crude model for Hep B vs Insurance Coverage';
RUN;

/*2B3: Crude model testing association between different Healthcare insurance utilization and HPV vaccine uptake among those who are aged 19 and below
		For the exposure, no health insurance is set as reference group*/
/* Crude Odds ratio comparing federal and reference group: 1.335 (CI:1.021,1.747)  
   Crude Odds ratio comparing private and reference group: 1.186 (CI:0.905,1.554)  p-value=0.0642 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') / param=reference;
MODEL HPV_Vax = incov;
WHERE RIDAGEYR LE 19;
Title1 'Crude model for HPV Vax vs Insurance Coverage';
RUN;

/*2B4: Crude model testing association between different Healthcare insurance utilization and Hepatitis A vaccine uptake among those who are aged 20 and greater
		For the exposure, no health insurance is set as reference group*/
/* Crude Odds ratio comparing federal and reference group:  1.335 (95% CI: 1.134, 1.572)  
   Crude Odds ratio comparing private and reference group:  1.377 (95% CI: 1.196, 1.585)  p-value<0.0001 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') / param=reference;
MODEL Hep_A_Vax = incov;
WHERE RIDAGEYR GE 20;
Title1 'Crude model for Hep A vs Insurance Coverage';
RUN;

/*2B5: Crude model testing association between different Healthcare insurance utilization and Hepatitis B vaccine uptake among those who are aged 20 and greater
		For the exposure, no health insurance is set as reference group*/
/* Crude Odds ratio comparing federal and reference group:  1.680 (95% CI: 1.434, 1.969) 
   Crude Odds ratio comparing private and reference group:  1.914 (95% CI: 1.668, 2.196) p-value<0.0001 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') / param=reference;
MODEL Hep_B_Vax = incov;
WHERE RIDAGEYR GE 20;
Title1 'Crude model for Hep B vs Insurance Coverage';
RUN;

/*2B6: Crude model testing association between different Healthcare insurance utilization and HPV vaccine uptake among those who are aged 20 and greater
		For the exposure, no health insurance is set as reference group*/
/* Crude Odds ratio comparing federal and reference group: 1.817  (95% CI: 1.427, 2.312)   
   Crude Odds ratio comparing private and reference group: 1.273 (95% CI: 1.021, 1.587)   p-value<0.0001 see abstract result section and table two */
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') / param=reference;
MODEL HPV_Vax = incov;
WHERE RIDAGEYR GE 20;
Title1 'Crude model for HPV Vax vs Insurance Coverage';
RUN;

/* 2C: 
	Description: We assessed the adjusted association between exposure and outcome of interest adjusting for confounders using Logistic Regression.
				 In total of 6 models are created for 3 outcomes of interest, stratified by binary age group.
	Reason: To calculated the odds ratio,a measure of association comparing exposure groups adjusting for confounders using Logistic Regression. 
			Logistic regression is the default analytic technique for regression with binary outcome, in this case have received vaccine or have not
			Due to age limitation in certain questions, the crude models are stratified by age*/

/*2C1: Adjusted model assessing association between different Healthcare insurance utilization and Hepatitis A vaccine uptake among those who are aged 19 and below,
		adjusting for gender, race/eth, birth country, and family income; 
		For the exposure, no health insurance is set as reference group
		For the counfouders: not born in US, $0-1,249 income, Not currently working, poor health status are set as reference groups for each variable */
/* Adjusted Odds ratio comparing federal and reference group: 1.334	(CI:0.954, 1.865) 
   Adjusted Odds ratio comparing private and reference group: 1.147	(CI:0.807, 1.630) p-value=0.1535 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') RIAGENDR(ref='Male') raceEth(ref='NH: White') BIRTHC(ref='No') INCOME(ref='$0-1,249') / param=reference;
MODEL Hep_A_Vax = incov RIAGENDR raceEth INCOME BIRTHC RIDAGEYR;
Title1 'Adjusted model for Hep A vs Insurance Coverage for young age group';
WHERE RIDAGEYR LE 19;
RUN;

/*2C2: Adjusted model assessing association between different Healthcare insurance utilization and Hepatitis B vaccine uptake among those who are aged 19 and below,
		adjusting for gender, race/eth, birth country, and family income; 
		For the exposure, no health insurance is set as reference group
		For the counfouders: not born in US, $0-1,249 income, Not currently working, poor health status are set as reference groups for each variable */
/* Adjusted Odds ratio comparing federal and reference group: 1.129 (CI:0.767, 1.662) 
   Adjusted Odds ratio comparing private and reference group: 1.094 (CI:0.725, 1.652) p-value=0.0007 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') RIAGENDR(ref='Male') raceEth(ref='NH: White') BIRTHC(ref='No') INCOME(ref='$0-1,249') / param=reference;
MODEL Hep_B_Vax = incov RIAGENDR raceEth INCOME BIRTHC RIDAGEYR;
Title1 'Adjusted model for Hep B vs Insurance Coverage for young age group';
WHERE RIDAGEYR LE 19;
RUN;

/*2C3: Adjusted model assessing association between different Healthcare insurance utilization and HPV vaccine uptake among those who are aged 19 and below,
		adjusting for gender, race/eth, birth country, and family income; 
		For the exposure, no health insurance is set as reference group
		For the counfouders: not born in US, $0-1,249 income, Not currently working, poor health status are set as reference groups for each variable */
/* Adjusted Odds ratio comparing federal and reference group: 2.016 (CI:1.441, 2.819) 
   Adjusted Odds ratio comparing private and reference group: 1.632 (CI:1.147, 2.321) p-value=0.0001 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') RIAGENDR(ref='Male') raceEth(ref='NH: White') BIRTHC(ref='No') INCOME(ref='$0-1,249') / param=reference;
MODEL HPV_Vax = incov RIAGENDR raceEth INCOME BIRTHC RIDAGEYR;
Title1 'Adjusted model for HPV Vax vs Insurance Coverage for young age group';
WHERE RIDAGEYR LE 19;
RUN;

/*2C4: Adjusted model assessing association between different Healthcare insurance utilization and Hepatitis A vaccine uptake among those who are aged 20 and above,
		adjusting for gender, race/eth, highest educational attainment, birth country, income, work, and current health status;
		For the exposure, no health insurance is set as reference group
		For the counfouders: not born in US, $0-1,249 income, Not currently working, poor health status are set as reference groups for each variable */
/* Adjusted Odds ratio comparing federal and reference group: 1.489 (CI:1.204, 1.841) 
   Adjusted Odds ratio comparing private and reference group: 1.342 (CI:1.104, 1.633) p-value=0.0007 see abstract result and table two*/

PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') RIAGENDR(ref='Male') raceEth(ref='NH: White') EDU(ref='Less than HS Education') 
		BIRTHC(ref='No') INCOME(ref='$0-1,249') WORK (ref='Not currently working') HEALTH(ref='Poor') / param=reference;
MODEL Hep_A_Vax = incov RIAGENDR raceEth EDU INCOME BIRTHC WORK HEALTH RIDAGEYR;
Title1 'Adjusted model for Hep A vs Insurance Coverage (20 or older)';
WHERE RIDAGEYR GE 20;
RUN;

/*2C5: Adjusted model assessing association between different Healthcare insurance utilization and Hepatitis B vaccine uptake among those who are aged 20 and above,
		adjusting for gender, race/eth, highest educational attainment, birth country, income, work, and current health status;
		For the exposure, no health insurance is set as reference group
		For the counfouders: not born in US, $0-1,249 income, Not currently working, poor health status are set as reference groups for each variable */
/* Adjusted Odds ratio comparing federal and reference group: 1.836 (CI:1.483, 2.274) 
   Adjusted Odds ratio comparing federal and reference group: 1.762 (CI:1.445, 2.147) p-value<0.0001 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') RIAGENDR(ref='Male') raceEth(ref='NH: White') EDU(ref='Less than HS Education') 
		BIRTHC(ref='No') INCOME(ref='$0-1,249') WORK (ref='Not currently working') HEALTH(ref='Poor') / param=reference;
MODEL Hep_B_Vax = incov RIAGENDR raceEth EDU INCOME BIRTHC WORK HEALTH RIDAGEYR;
Title1 'Adjusted model for Hep B vs Insurance Coverage (20 or older)';
WHERE RIDAGEYR GE 20;
RUN;

/*2C6: Adjusted model assessing association between different Healthcare insurance utilization and HPV vaccine uptake among those who are aged 20 and above,
		adjusting for gender, race/eth, highest educational attainment, birth country, income, work, and current health status;
		For the exposure, no health insurance is set as reference group
		For the counfouders: not born in US, $0-1,249 income, Not currently working, poor health status are set as reference groups for each variable */
/* Adjusted Odds ratio comparing federal and reference group: 1.565 (CI:1.122,  2.182)
   Adjusted Odds ratio comparing private and reference group: 1.168 (CI:0.854, 1.596) p-value<0.0001 see abstract result and table two*/
PROC LOGISTIC DATA=MERGEDSET;
CLASS incov(ref='No health insurance') RIAGENDR(ref='Male') raceEth(ref='NH: White') EDU(ref='Less than HS Education') 
		BIRTHC(ref='No') INCOME(ref='$0-1,249') WORK (ref='Not currently working') HEALTH(ref='Poor') / param=reference;
MODEL HPV_Vax = incov RIAGENDR raceEth EDU INCOME BIRTHC WORK HEALTH RIDAGEYR;
Title1 'Adjusted model for HPV vs Insurance Coverage (20 or older)';
WHERE RIDAGEYR GE 20;
RUN;


*****************************************************************************
**		Table 1  Data												   **
*****************************************************************************;
/* The values here reflect the descriptive statistics mentioned in the Methods
section of the abstract and are reported in the Results section.
   
Comparisons are being made between the categorizations of those never vaccinated
and those vaccinated for each vaccine type; Chi-squared tests are run to determine
if there is a difference in vaccine status based on the categorization provided. 
This is then reported in Table 1 with the counts and percentages for each group 
within each varaible as well as documenting if is there a difference in vaccination 
status with a p-value (i.e. is there a difference in vaccination status by gender 
- i.e. between Male and Female respondents).
*/

/* Running Chi-Squared tests for Hepatitis A (HAV) Vaccine*/
/*Frequency and Chi-squared test p-value see table 1*/
PROC FREQ DATA=MERGEDSET;
table Hep_A_Vax*(riagendr edu income birthc health work raceEth) / chisq;
run;
/*Frequency and two-sample t test p-value see table 1*/
PROC TTEST DATA=MERGEDSET;
class Hep_A_Vax;
var ridageyr;
run; 

/* Running tests for Hepatitis B (HBV) Vaccine*/
/*Frequency and Chi-squared test p-value see table 1*/
PROC FREQ DATA=MERGEDSET;
table Hep_B_Vax*(riagendr edu income birthc health work raceEth) / chisq;
run;  
/*Frequency and two-sample t test p-value see table 1*/ 
PROC TTEST DATA=MERGEDSET;
class Hep_A_Vax;
var ridageyr;
run;  

/* Running tests for HPV Vaccine*/
/*Frequency and Chi-squared test p-value see table 1*/
PROC FREQ DATA=MERGEDSET;
table HPV_Vax*(riagendr edu income birthc health work raceEth) / chisq;
run;
/*Frequency and two-sample t test p-value see table 1*/ 
PROC TTEST DATA=MERGEDSET;
class Hep_A_Vax;
var ridageyr;
run; 
