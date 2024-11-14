*** This file prepares data from RAND HRS to estimates statistics ***
* updated, Novermber 9, 2024
*
* input file:
* data file: curdir/HRSdata/datadir/randhrs1992_2020v2.dta

clear all
cls

* Need at least Stata SE
set   maxvar 20000 

* Set curdir to be location of this file, datadir to be curdir/HRSdata,
* outdir to be curdir/HRSout

do set_curdir.do

global latest_survey = 13 /* Set to be latest survey in HRS (15 at time of writing) */

cd $curdir

timer clear 1

timer on 1

local createdata  = 0

if (`createdata'==1) {
	
	local refyear  = 11                         /* use price in 2012  */ 
	local minage   = 51							/*Min age in dataset */
	local maxage   = 99
	
	* Change into datadirectory, open and read file then return
	cd $datadir
	unzipfile randhrs1992_2020v2_STATA.zip, replace   /* unzip file */
	cd $curdir
	
	use $datadir/randhrs1992_2020v2.dta, clear   /* RAND HRS data */
	
	
	* Keep wanted columns
	
	keep hhidpn hacohort r*agey_e r*iwstat r*shlt rabyear raeduc ragender raracem
	
	foreach mm in "2" "3" "4" "5" "6"  "7"  "8"  "9"  "10"  "11" "12" "13"{
		
		
		gen age`mm' = r`mm'agey_e
		
		gen iwstat`mm' = r`mm'iwstat
		
		* Generate health: 1 if poor, 0 if good
		gen health`mm' = .
		replace health`mm' = 1 if r`mm'shlt==1  | r`mm'shlt==2 | r`mm'shlt==3 
		replace health`mm' = 0 if r`mm'shlt==4  | r`mm'shlt==5
		
		gen health2`mm' = r`mm'shlt
		
		
		gen birth_year`mm' = rabyear
		
		gen educ`mm' = raeduc

		gen sex`mm' = ragender
		recode sex`mm' (1=1) (2=0)	/* 1=male, 0=female */
		
		gen race`mm' = raracem
		recode race`mm'  (1=1)  (2/3=0)
	
	}
	
	keep hhidpn hacohort age* iwstat* health* health2* birth_year* educ* sex* race*
	
	reshape long age iwstat health health2 birth_year educ sex race, i(hhidpn) j(year)
	
	gen wave = year
	recode year (1=1992) (2=1994) (3=1996) (4=1998) (5=2000) (6=2002) (7=2004) (8=2006) (9=2008) (10=2010) (11=2012)  (12=2014)  (13=2016)
	
	replace age = year-birth_year if birth_year!=.
	
	xtset hhidpn year
	sort  hhidpn year
	
	gen unhealthy = 1 if health == 0
	replace unhealthy = 0 if health==1
	
	sort  hhidpn year
	gen alive =.
	replace alive =  1 if iwstat==1 | iwstat ==4    // alive this year 
	by hhidpn: replace alive = 0 if iwstat==5 & L2.alive==1   // died this year
	
	* Generate binned ages every two years
	gen ageint2 = .
	replace ageint2 = 51  if age>=51 & age<=52
	replace ageint2 = 53  if age>=53 & age<=54
	replace ageint2 = 55  if age>=55 & age<=56
	replace ageint2 = 57  if age>=57 & age<=58
	replace ageint2 = 59  if age>=59 & age<=60
	replace ageint2 = 61  if age>=61 & age<=62
	replace ageint2 = 63  if age>=63 & age<=64
	replace ageint2 = 65  if age>=65 & age<=66
	replace ageint2 = 67  if age>=67 & age<=68
	replace ageint2 = 69  if age>=69 & age<=70
	replace ageint2 = 71  if age>=71 & age<=72
	replace ageint2 = 73  if age>=73 & age<=74
	replace ageint2 = 75  if age>=75 & age<=76
	replace ageint2 = 77  if age>=77 & age<=78
	replace ageint2 = 79  if age>=79 & age<=80
	replace ageint2 = 81  if age>=81 & age<=82
	replace ageint2 = 83  if age>=83 & age<=84
	replace ageint2 = 85  if age>=85 & age<=86
	replace ageint2 = 87  if age>=87 & age<=88
	replace ageint2 = 89  if age>=89 & age<=90
	replace ageint2 = 91  if age>=91 & age<=92
	replace ageint2 = 93  if age>=93 & age<=94
	replace ageint2 = 95  if age>=95 & age<=96
	replace ageint2 = 97  if age>=97 & age<=98
	
	* Generate a college variable (1 if college, 0 without)
	gen college = .
	replace college = 1 if educ==5
	replace college = 0 if educ==2 | educ==3 | educ==4
	
	save $datadir/HRS_main.dta, replace
}

****************************
***** SAMPLE SELECTION *****
****************************

use $datadir/HRS_main.dta, clear

* Keep only males
keep if sex==1

* Keep if college is 0 or 1
keep if college==0 | college==1 

* Keep individuals in the age range or who died in survey year
keep if (age>=51 & age<=99) | alive == 0

* Drop ahead group for first three waves (survey conducted on off-year)
drop if (hacohort==0 | hacohort==1) & (year==1992 | year==1994 | year==1996)

* Drop first year (health score imputed when missing)
drop if year==1992

* Drop if alive is null and health is null 
drop if health==. & alive==.


*************** Generate Health Percentages ***********
preserve 

* Drop individuals with no health observation
drop if health==. & alive==1

save $datadir/HRS_healthshares_input.dta, replace

do $curdir/HRS_healthshare_calc.do 

restore




















