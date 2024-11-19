*** This file prepares data from RAND HRS to estimates statistics ***
* updated, Novermber 15, 2024
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
	
	keep hhidpn hacohort h*atotb h*hhres h*child h*cpl r*agey_e r*mstath r*iwstat r*shlt rabyear raeduc ragender raracem
	
	*********** CPI_U ****************
	local cpi1    = 140.3      /* 1992 */
	local cpi2    = 148.2      /* 1994 */
	local cpi3    = 156.9      /* 1996 */
	local cpi4    = 163.0      /* 1998 */
	local cpi5    = 172.2      /* 2000 */
	local cpi6    = 179.9      /* 2002 */
	local cpi7    = 188.9      /* 2004 */
	local cpi8    = 201.6      /* 2006 */
	local cpi9    = 215.30     /* 2008 */  
	local cpi10   = 218.06     /* 2010 */
	local cpi11   = 229.59     /* 2012 */
	local cpi12   = 236.73     /* 2014 */
	local cpi13   = 240.00     /* 2016 */
	
	foreach mm in "2" "3" "4" "5" "6"  "7"  "8"  "9"  "10"  "11" "12" "13" {
		
		
		gen age`mm' = r`mm'agey_e
		
		gen iwstat`mm' = r`mm'iwstat
		
		gen noofresident`mm' = h`mm'hhres
		replace noofresident`mm' = 9 if noofresident`mm' > 9
		
		gen couple`mm' = . 
		replace couple`mm'  = 1 if h`mm'cpl == 1   /* 1=couple, 0=single */
		replace couple`mm'  = 0 if h`mm'cpl == 0
		* Generate variable for married
		gen marry`mm' = .
		replace marry`mm'   = 1 if r`mm'mstath == 1 | r`mm'mstath == 2 | r`mm'mstath == 3   /* 1=married/partner, 0=non-married */
		replace marry`mm'   = 0 if r`mm'mstath == 4 | r`mm'mstath == 5 | r`mm'mstath == 6 | r`mm'mstath == 7 | r`mm'mstath == 8
		* Generate number of kids
		gen noofkid`mm' = h`mm'child
		
		gen famsize`mm' = 1 + couple`mm' + noofkid`mm'
		replace famsize`mm' = 6  if famsize`mm' > 6
		
		gen netwealthA`mm' = .
		replace netwealthA`mm' = h`mm'atotb/`cpi`mm''*`cpi`refyear'' 
		
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
	
	keep hhidpn hacohort noofresident* famsize* marry* age* netwealthA* iwstat* health* health2* birth_year* educ* sex* race*
	
	reshape long age noofresident famsize marry netwealthA iwstat health health2 birth_year educ sex race, i(hhidpn) j(year)
	
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
	
	* Generate binned ages every 5 years - used for wealth generation
	* Used for regressing to obtain wealth estimates
	gen ageint5 = .
	replace ageint5 = 0 if age<50
	replace ageint5 = 1 if age>=50 & age<=54
	replace ageint5 = 2 if age>=55 & age<=59
	replace ageint5 = 3 if age>=60 & age<=64
	replace ageint5 = 4 if age>=65 & age<=69
	replace ageint5 = 5 if age>=70 & age<=74
	* Include all observations >= 75
	replace ageint5 = 6 if age>=75 & age<=79
	replace ageint5 = 7 if age>=80 & age<=85
	replace ageint5 = 8 if age>=85
	
	* Generate binned ages by five years for showing wealth results
	gen ageint5_1 = .
	replace ageint5_1 = 0 if age<50
	replace ageint5_1 = 1 if age>=50 & age<=54
	replace ageint5_1 = 2 if age>=55 & age<=59
	replace ageint5_1 = 3 if age>=60 & age<=64
	replace ageint5_1 = 4 if age>=65 & age<=69
	replace ageint5_1 = 5 if age>=70 & age<=74
	replace ageint5_1 = 6 if age>=75
	
	gen agebin1 = .
	replace agebin1 = 1 if age>=55 & age <= 69
	replace agebin1 = 2 if age>=70 & age<=89
	
	* Generate a college variable (1 if college, 0 without)
	gen college = .
	replace college = 1 if educ==5
	replace college = 0 if educ==2 | educ==3 | educ==4
	
	
	fvset base  1998 year       /* year (1998) */
	fvset base  3    famsize    /* family size(3) */ 
	fvset base  1    health     /* health(1) */
	fvset base  0    marry      /* marry(0) */
	
	xtset hhidpn year
	sort  hhidpn year
	
	save $datadir/HRS_main.dta, replace
}

****************************
***** SAMPLE SELECTION *****
****************************

use $datadir/HRS_main.dta, clear

* Keep observations for males and females
keep if sex==0 //| sex==0

* Keep observations for college and non-college
keep if college==1 //| college==1

* Keep individuals in the age range or who died in survey year
keep if (age>=51 & age<=99) | alive == 0

* Drop ahead group for first three waves (survey conducted on off-year)
drop if (hacohort==0 | hacohort==1) & (year==1992 | year==1994 | year==1996)

* Drop first year (health score imputed when missing)
drop if year==1992

* Drop if alive is null and health is null 
drop if health==. & alive==.


****************************************
***** Health Percentage Generation *****
****************************************
// preserve 
//
// * Drop individuals with no health observation
// drop if health==. & alive==1
//
// save $datadir/HRS_healthshares_input.dta, replace
//
// do $curdir/HRS_healthshare_calc.do 
//
// restore
*********************************************
***** Estimate fixed labor productivity *****
*********************************************








******************************************
***** Health Transition Calculations *****
******************************************
// xtset hhidpn year
// sort  hhidpn year
//
// save $datadir/HRS_healthmovement_input.dta, replace
//
// do $curdir/HRS_healthmovement_calc.do


*****************************
***** Estimating Wealth *****
*****************************

*** Construct wealth variables after controlling for family size and base year ***
gen noofresidbyage = .
forvalue aa = 1/8 {
   quietly: summarize noofresident if ageint5  ==`aa', detail
   replace noofresidbyage = r(mean) if ageint5 ==`aa'
}

* Identify the bottom 0.5% and top 0.5% (not used in estimation)
_pctile netwealthA if year>=1994 & age<=99,  p(0.5 99.5) 
gen netwealthA_extreme = cond( (netwealthA < r(r1) | netwealthA >r(r2) & netwealthA !=.) & year>=1994 & age<=99, 1, 0)   
quietly {                                                                                                               
	* Generate temp variables that will not be altered when we change them
	gen noofresid_temp = noofresident
	gen year_temp      = year 
	* Ensure base year is set to 1998
	fvset base  1998 year_temp
   
	* Regress using formula from paper
	reg netwealthA  ((( i.age c.noofresid_temp c.noofresid_temp#c.noofresid_temp)##i.health)##i.college)##i.sex   i.year_temp   if year>=1994 & age<=99 & netwealthA_extreme==0
	predict yhat  if netwealthA!=., xb

	* Replace by the mean number of residents
	replace noofresid_temp = noofresidbyage
	replace year_temp = 1998
	predict yhat1 if e(sample), xb
	
	* Create wealth variable
	gen wealth_fam3 = netwealthA - yhat + yhat1
	
	* Drop temporary variables
	drop noofresid_temp year_temp yhat yhat1
}

egen pctile25 = pctile(wealth_fam3), p(25) by(ageint5_1 health sex college)
egen pctile50 = pctile(wealth_fam3), p(50) by(ageint5_1 health sex college)
egen pctile75 = pctile(wealth_fam3), p(75) by(ageint5_1 health sex college)

collapse (mean) pctile25 (mean) pctile50 (mean) pctile75, by (ageint5_1 health sex college)

drop if health == .
gen original = 0

* Generate the scatter plot with number of observations for college and gender 
// twoway (scatter obs_count Age if college == 0 & sex==1, mcolor(stblue) msymbol(circle)) ///
//        (scatter obs_count Age if college == 1 & sex==1, mcolor(stred) msymbol(triangle)) ///
//        (scatter obs_count Age if college == 0 & sex==0, mcolor(styellow) msymbol(circle)) ///
// 	   (scatter obs_count Age if college == 1 & sex==0, mcolor(stgreen) msymbol(triangle)), ///
//        legend(order(1 "p(25)" 2 "p(50)" 3 "p(75)")) ///
//        ytitle("# of observations") xtitle("Age")

// save $datadir/HRS_wealth_impute_original.dta, replace

// append using $datadir/HRS_wealth_impute_original.dta

	
		
// twoway (scatter pctile25 ageint5_1 if health == 0 & college == 0 & sex==1 & original==1, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 0 & college == 0 & sex==1 & original==1, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
// 		(scatter pctile75 ageint5_1 if health == 0 & college == 0 & sex==1 & original==1, mcolor(green) msymbol(O) msize(vlarge)), ///
// 		ylabel(0(100000)800000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Unhealthy" 2 "p(50): Unhealthy" 3 "p(75): Unhealthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among unhealthy (poor+fair) people (no college, men)")

		
// twoway (scatter pctile25 ageint5_1 if health == 1 & college == 0 & sex==1 & original==1, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 1 & college == 0 & sex==1 & original==1, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
// 		(scatter pctile75 ageint5_1 if health == 1 & college == 0 & sex==1 & original==1, mcolor(green) msymbol(O) msize(vlarge)), ///
// 		ylabel(0(100000)800000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Healthy" 2 "p(50): Healthy" 3 "p(75): Healthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among healthy people (no college, men)")

// twoway (scatter pctile25 ageint5_1 if health == 0 & college == 1 & sex==1 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 0 & college == 1 & sex==1 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
// 		(scatter pctile75 ageint5_1 if health == 0 & college == 1 & sex==1 & original==0, mcolor(green) msymbol(O) msize(vlarge)), ///
// 		ylabel(0(100000)1500000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Unhealthy" 2 "p(50): Unhealthy" 3 "p(75): Unhealthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among unhealthy (poor+fair) people (college, men)")
//		
// twoway (scatter pctile25 ageint5_1 if health == 1 & college == 1 & sex==1 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 1 & college == 1 & sex==1 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
// 		(scatter pctile75 ageint5_1 if health == 1 & college == 1 & sex==1 & original==0, mcolor(green) msymbol(O) msize(vlarge)), ///
// 		ylabel(0(100000)1500000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Healthy" 2 "p(50): Healthy" 3 "p(75): Healthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among healthy people (college, men)")	


// twoway (scatter pctile25 ageint5_1 if health == 0 & college == 0 & sex==0 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 0 & college == 0 & sex==0 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
// 		(scatter pctile75 ageint5_1 if health == 0 & college == 0 & sex==0 & original==0, mcolor(green) msymbol(O) msize(vlarge)), ///
// 		ylabel(0(100000)700000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Unhealthy" 2 "p(50): Unhealthy" 3 "p(75): Unhealthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among unhealthy (poor+fair) people (no college, women)")
//		
// twoway (scatter pctile25 ageint5_1 if health == 1 & college == 0 & sex==0 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 1 & college == 0 & sex==0 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
// 		(scatter pctile75 ageint5_1 if health == 1 & college == 0 & sex==0 & original==0, mcolor(green) msymbol(O) msize(vlarge)), ///
// 		ylabel(0(100000)700000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Healthy" 2 "p(50): Healthy" 3 "p(75): Healthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among healthy people (no college, women)")
//
// twoway (scatter pctile25 ageint5_1 if health == 1 & college == 0 & sex==0 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
// 		(scatter pctile50 ageint5_1 if health == 0 & college == 0 & sex==0 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)), ///
// 		ylabel(0(100000)700000, format(%10.0fc)) ///
// 		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
//        legend(order(1 "p(25): Healthy" 2 "p(50): Unealthy") position(11) ring(0)) ///
//         ytitle("Wealth") xtitle("Age") ///
// 		title("Wealth profile among healthy people (no college, women)")

twoway (scatter pctile25 ageint5_1 if health == 0 & college == 1 & sex==0 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
		(scatter pctile50 ageint5_1 if health == 0 & college == 1 & sex==0 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
		(scatter pctile75 ageint5_1 if health == 0 & college == 1 & sex==0 & original==0, mcolor(green) msymbol(O) msize(vlarge)), ///
		ylabel(0(100000)1400000, format(%10.0fc)) ///
		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
       legend(order(1 "p(25): Unhealthy" 2 "p(50): Unhealthy" 3 "p(75): Unhealthy") position(11) ring(0)) ///
        ytitle("Wealth") xtitle("Age") ///
		title("Wealth profile among unhealthy (poor+fair) people (college, women)")

twoway (scatter pctile25 ageint5_1 if health == 1 & college == 1 & sex==0 & original==0, mcolor(red) msymbol(X) msize(vlarge)) ///
		(scatter pctile50 ageint5_1 if health == 1 & college == 1 & sex==0 & original==0, mcolor(blue) msymbol(Oh) msize(vlarge)) ///
		(scatter pctile75 ageint5_1 if health == 1 & college == 1 & sex==0 & original==0, mcolor(green) msymbol(O) msize(vlarge)), ///
		ylabel(0(100000)1400000, format(%10.0fc)) ///
		xlabel(1 "50-54" 2 "55-59" 3 "60-64" 4 "65-69" 5 "70-74" 6 "75+") ///
       legend(order(1 "p(25): Unhealthy" 2 "p(50): Unhealthy" 3 "p(75): Unhealthy") position(11) ring(0)) ///
        ytitle("Wealth") xtitle("Age") ///
		title("Wealth profile among healthy people (college, women)")























	





