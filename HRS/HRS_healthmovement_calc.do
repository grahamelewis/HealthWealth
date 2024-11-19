*** This file estimates the probability switching health states conditional on previous states of health ***
* updated, Novermber 14, 2024

* input file: HRSdata/HRS_healthmovement_input

use $datadir/HRS_healthmovement_input.dta, replace


************ Transition from Bad => Good | Bad 


* Gen variable for bad health hazard rate cals
gen bad_start = 1 if health==0 & F2.health!=. & hhidpn==F2.hhidpn

* Gen variable noting if transitoned from bad to good, 1st obs after
gen hazrB2 = 0 if bad_start==1 & F2.health==0 & hhidpn==F2.hhidpn
replace hazrB2 = 1 if bad_start==1 & F2.health==1 & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 2nd obs after
gen hazrB4 = 0 if L2.health==0 & health==0 & F2.health==0 & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrB4 = 1 if L2.health==0 & health==0 & F2.health==1 & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 3rd obs after
gen hazrB6 = 0 if L4.health==0 & L2.health==0 & health==0 & F2.health==0 & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrB6 = 1 if L4.health==0 & L2.health==0 & health==0 & F2.health==1 & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 4th obs after
gen hazrB8 = 0 if L6.health==0 & L4.health==0 & L2.health==0 & health==0 & F2.health==0 & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrB8 = 1 if L6.health==0 & L4.health==0 & L2.health==0 & health==0 & F2.health==1 & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 5th obs after
gen hazrB10 = 0 if L8.health==0 & L6.health==0 & L4.health==0 & L2.health==0 & health==0 & F2.health==0 & hhidpn==L8.hhidpn & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrB10 = 1 if L8.health==0 & L6.health==0 & L4.health==0 & L2.health==0 & health==0 & F2.health==1 & hhidpn==L8.hhidpn & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn



************ Transition from Good => Bad | Good 

* Gen variable for good health hazard rate cals
gen good_start = 1 if health==1 & F2.health!=. & hhidpn==F2.hhidpn

* Gen variable noting if transitoned from bad to good, 1st obs after
gen hazrG2 = 0 if good_start==1 & F2.health==1 & hhidpn==F2.hhidpn
replace hazrG2 = 1 if good_start==1 & F2.health==0 & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 2nd obs after
gen hazrG4 = 0 if L2.health==1 & health==1 & F2.health==1 & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrG4 = 1 if L2.health==1 & health==1 & F2.health==0 & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 3rd obs after
gen hazrG6 = 0 if L4.health==1 & L2.health==1 & health==1 & F2.health==1 & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrG6 = 1 if L4.health==1 & L2.health==1 & health==1 & F2.health==0 & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 4th obs after
gen hazrG8 = 0 if L6.health==1 & L4.health==1 & L2.health==1 & health==1 & F2.health==1 & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrG8 = 1 if L6.health==1 & L4.health==1 & L2.health==1 & health==1 & F2.health==0 & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn

* Gen variable noting if transitioned from bad to good, 5th obs after
gen hazrG10 = 0 if L8.health==1 & L6.health==1 & L4.health==1 & L2.health==1 & health==1 & F2.health==0 & hhidpn==L8.hhidpn & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn
replace hazrG10 = 1 if L8.health==1 & L6.health==1 & L4.health==1 & L2.health==1 & health==1 & F2.health==0 & hhidpn==L8.hhidpn & hhidpn==L6.hhidpn & hhidpn==L4.hhidpn & hhidpn==L2.hhidpn & hhidpn==F2.hhidpn


collapse (mean) hazrB2 hazrB4 hazrB6 hazrB8 hazrB10 hazrG2 hazrG4 hazrG6 hazrG8 hazrG10, by(agebin1 college)

save $datadir/HRS_healthmovement.dta, replace

graph bar hazrB2 hazrB4 hazrB6 hazrB8 hazrB10 if agebin1 == 1, over(college) ///
    bargap(5) ///
    bar(1, fcolor(maroon)) ///
    title("Bad=>Good 55-69") ///
    ylabel(, angle(0)) ///
    legend(label(1 "No degree") label(2 "College")) ///
	blabel(bar, position(inside) format(%9.1f) color(white))

graph export $outputdir/hazrB_first_agebin.png, replace

graph bar hazrB2 hazrB4 hazrB6 hazrB8 hazrB10 if agebin1 == 2, over(college) ///
    title("Bad=>Good 70-89") ylabel(, nogrid)
	
graph export $outputdir/hazrB_second_agebin.png, replace



graph bar hazrG2 hazrG4 hazrG6 hazrG8 hazrG10 if agebin1 == 1, over(college) ///
    title("Good=>Bad 55-69") ylabel(, nogrid)
	
graph export $outputdir/hazrG_first_agebin.png, replace

graph bar hazrG2 hazrG4 hazrG6 hazrG8 hazrG10 if agebin1 == 2, over(college) ///
    title("Good=>Bad 70-89") ylabel(, nogrid)
	
graph export $outputdir/hazrG_second_agebin.png, replace
	




