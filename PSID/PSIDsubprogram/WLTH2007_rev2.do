
#delimit ;

**************************************************************************
   Label           : 2007 Family Wealth Data
   Rows            : 8289
   Columns         : 38
   ASCII File Date : March 2, 2011
*************************************************************************;


infix 
      S800            1 - 1         S801            2 - 6         S802            7 - 7    
      S802A           8 - 8         S803            9 - 17        S803A          18 - 18   
      S804           19 - 19        S804A          20 - 20        S805           21 - 29   
      S805A          30 - 30        S806           31 - 31        S806A          32 - 32   
      S807           33 - 41        S807A          42 - 42        S808           43 - 43   
      S808A          44 - 44        S809           45 - 53        S809A          54 - 54   
      S810           55 - 55        S810A          56 - 56        S811           57 - 65   
      S811A          66 - 66        S813           67 - 75        S813A          76 - 76   
      S814           77 - 77        S814A          78 - 78        S815           79 - 87   
      S815A          88 - 88        S818           89 - 89        S818A          90 - 90   
      S819           91 - 99        S819A         100 - 100       S820          101 - 109  
      S820A         110 - 110       S816          111 - 119       S816A         120 - 120  
      S817          121 - 129       S817A         130 - 130  

using $datadir/WLTH2007.txt, clear ;


label variable  S800       "2007 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S801       "2007 FAMILY ID" ;                                  
label variable  S802       "IMP WTR FARM/BUS (W10) 07" ;                       
label variable  S802A      "ACC WTR FARM/BUS (W10) 07" ;                       
label variable  S803       "IMP VALUE FARM/BUS (W11) 07" ;                     
label variable  S803A      "ACC VALUE FARM/BUS (W11) 07" ;                     
label variable  S804       "IMP WTR CHECKING/SAVING (W27) 07" ;                
label variable  S804A      "ACC WTR CHECKING/SAVING (W27) 07" ;                
label variable  S805       "IMP VAL CHECKING/SAVING (W28) 07" ;                
label variable  S805A      "ACC VAL CHECKING/SAVING (W28) 07" ;                
label variable  S806       "IMP WTR OTH DEBT (W38) 07" ;                       
label variable  S806A      "ACC WTR OTH DEBT (W38) 07" ;                       
label variable  S807       "IMP VALUE OTH DEBT (W39) 07" ;                     
label variable  S807A      "ACC VALUE OTH DEBT (W39) 07" ;                     
label variable  S808       "IMP WTR OTH REAL ESTATE (W1) 07" ;                 
label variable  S808A      "ACC WTR OTH REAL ESTATE (W1) 07" ;                 
label variable  S809       "IMP VAL OTH REAL ESTATE (W2) 07" ;                 
label variable  S809A      "ACC VAL OTH REAL ESTATE (W2) 07" ;                 
label variable  S810       "IMP WTR STOCKS (W15) 07" ;                         
label variable  S810A      "ACC WTR STOCKS (W15) 07" ;                         
label variable  S811       "IMP VALUE STOCKS (W16) 07" ;                       
label variable  S811A      "ACC VALUE STOCKS (W16) 07" ;                       
label variable  S813       "IMP VALUE VEHICLES (W6) 07" ;                      
label variable  S813A      "ACC VALUE VEHICLES (W6) 07" ;                      
label variable  S814       "IMP WTR OTH ASSETS (W33) 07" ;                     
label variable  S814A      "ACC WTR OTH ASSETS (W33) 07" ;                     
label variable  S815       "IMP VALUE OTH ASSETS (W34) 07" ;                   
label variable  S815A      "ACC VALUE OTH ASSETS (W34) 07" ;                   
label variable  S818       "IMP WTR ANNUITY/IRA (W21) 07" ;                    
label variable  S818A      "ACC WTR ANNUITY/IRA (W21) 07" ;                    
label variable  S819       "IMP VALUE ANNUITY/IRA (W22) 07" ;                  
label variable  S819A      "ACC VALUE ANNUITY/IRA (W22) 07" ;                  
label variable  S820       "IMP VALUE HOME EQUITY 07" ;                        
label variable  S820A      "ACC VALUE HOME EQUITY 07" ;                        
label variable  S816       "IMP WEALTH W/O EQUITY (WEALTH1) 07" ;              
label variable  S816A      "ACC WEALTH W/O EQUITY (WEALTH1) 07" ;              
label variable  S817       "IMP WEALTH W/ EQUITY (WEALTH2) 07" ;               
label variable  S817A      "ACC WEALTH W/ EQUITY (WEALTH2) 07" ;               


#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi07   = 207.342


rename S801  famID
rename S803  assetFam_FarmBus 
rename S805  assetFam_saving
rename S807  debtFam
rename S809  assetFam_realestate
rename S811  assetFam_stock
rename S813  assetFam_vehicle
rename S815  assetFam_other
rename S819  assetFam_annuityIRA
rename S820  assetFam_homeequity
rename S816  wealthFam1
rename S817  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi07'*`cpi`refyy''
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 2007
sort famID  
duplicates list famID

save $curdir/wealthFamily2007, replace 

