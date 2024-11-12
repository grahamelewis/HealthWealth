**** This program estimates runs the do files from the PSID ****
*    updated: November 6, 2024
*    input files:
*           (PSID data)
*        => Downloaded PSID data (stored in '../fam_data/')
*            - 1984-2021 family files (FAMxxx.txt, FAMxxxER.txt)
*        => Downloaded PSID data (stored in 'datadir')
*            - 1984-2021 family files (FAMxxx.txt, FAMxxxER.txt)

//Section 1: Import the data

	if "`c(username)'"== "graham" {
		global curdir "/Users/graham/OneDrive/Research/HealthWealth/data/fam_data/PSID" // set a local to move the data directory
		global datadir "/Users/graham/OneDrive/Research/HealthWealth/data/fam_data" // set a local to move the data directory
		global subdir "/Users/graham/OneDrive/Research/HealthWealth/PSID/PSIDsubprogram" // set a local to move the data directory
		global outdir "/Users/graham/OneDrive/Research/HealthWealth/data/PSIout" // set a local to move to the code directory

}

clear all

set more off

timer clear 1

timer on 1

do $subdir/IND2021ER_rev2.do // extract variables from raw PSID text files and create data (PSIDsample.dta)

timer off 1

timer list 1







