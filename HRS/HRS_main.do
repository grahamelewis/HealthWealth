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
	
	keep hhidpn hacohort r*agey_e r*shlt rabyear raeduc ragender raracem
	
	foreach mm in "2" "3" "4" "5" "6"  "7"  "8"  "9"  "10"  "11" "12" "13"{
		
		
		gen age`mm' = r`mm'agey_e
		
		gen health_status`mm' = r`mm'shlt
		
		gen birth_year`mm' = rabyear
		
		gen educ`mm' = raeduc

		gen sex`mm' = ragender
		recode sex`mm' (1=1) (2=0)	/* 1=male, 0=female */
		
		gen race`mm' = raracem
	
	}
	
	keep hhidpn hacohort age* health_status* birth_year* educ* sex* race*
	
	reshape long age health_status birth_year educ sex race, i(hhidpn) j(year)
	
	gen wave = year
	recode year (1=1992) (2=1994) (3=1996) (4=1998) (5=2000) (6=2002) (7=2004) (8=2006) (9=2008) (10=2010) (11=2012)  (12=2014)  (13=2016)
	
	replace age   = year-birth_year if birth_year!=.
	
	save $datadir/HRS_main.dta, replace
	
}

****************************
***** SAMPLE SELECTION *****
****************************

use $datadir/HRS_main.dta, replace


* Drop ahead group for first three waves (survey conducted on off-year)
drop if (hacohort==0 | hacohort==1) & (year==1992 | year==1994 | year==1996)
* Drop first year (health score imputed when missing)
drop if year==1992

* Keep only those without a college education 
keep if educ==2 | educ==3 | educ==4
* Keep only males
keep if sex==1

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

drop if health_status == .

gen badhealth = .
replace badhealth = 1 if health_status>=3
replace badhealth = 0 if health_status<=2

table (ageint2) (badhealth), statistic(mean badhealth)











