*** This file prepares data from RAND HRS to estimates statistics ***
* updated, Novermber 14, 2024

* input file: HRSdata/HRS_healthshares_input

use   $datadir/HRS_healthshares_input, replace
xtset hhidpn year
sort  hhidpn year

collapse (mean) mean_unhealthy=unhealthy (count) obs_count=unhealthy, by(ageint2 college)

save $datadir/HRS_healthshares.dta, replace

* Rename variables for clarity in the plot
rename ageint2 Age
rename mean_unhealthy PercentUnhealthy

* Generate the scatter plot with separate markers for college groups
twoway (scatter PercentUnhealthy Age if college == 0, mcolor(blue) msymbol(circle)) ///
       (scatter PercentUnhealthy Age if college == 1, mcolor(red) msymbol(triangle)), ///
       legend(order(1 "No College" 2 "College")) ///
       ytitle("% Unhealthy") xtitle("Age")
	   
graph export `outputdir'/scatter_plot.png, as(png) replace


