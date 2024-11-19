*** This file prepares data from RAND HRS to estimates statistics ***
* updated, Novermber 14, 2024

* input file: HRSdata/HRS_healthshares_input

use   $datadir/HRS_healthshares_input, replace
xtset hhidpn year
sort  hhidpn year

collapse (mean) mean_unhealthy=unhealthy (count) obs_count=unhealthy, by(ageint2 college sex)

save $datadir/HRS_healthshares.dta, replace

* Rename variables for clarity in the plot
rename ageint2 Age
rename mean_unhealthy PercentUnhealthy



* Generate the scatter plot with separate markers for college and gender
twoway (scatter PercentUnhealthy Age if college == 0 & sex==1, mcolor(stblue) msymbol(circle)) ///
       (scatter PercentUnhealthy Age if college == 1 & sex==1, mcolor(stred) msymbol(triangle)) ///
       (scatter PercentUnhealthy Age if college == 0 & sex==0, mcolor(styellow) msymbol(circle)) ///
	   (scatter PercentUnhealthy Age if college == 1 & sex==0, mcolor(stgreen) msymbol(triangle)), ///
       legend(order(1 "Men, No College" 2 "Men, College" 3 "Women, No College" 4 "Women, College")) ///
       ytitle("% Unhealthy") xtitle("Age")
	   

* Generate the scatter plot with number of observations for college and gender 
twoway (scatter obs_count Age if college == 0 & sex==1, mcolor(stblue) msymbol(circle)) ///
       (scatter obs_count Age if college == 1 & sex==1, mcolor(stred) msymbol(triangle)) ///
       (scatter obs_count Age if college == 0 & sex==0, mcolor(styellow) msymbol(circle)) ///
	   (scatter obs_count Age if college == 1 & sex==0, mcolor(stgreen) msymbol(triangle)), ///
       legend(order(1 "Men, No College" 2 "Men, College" 3 "Women, No College" 4 "Women, College")) ///
       ytitle("# of observations") xtitle("Age")

	   
	   
	   