
#delimit ;

**************************************************************************
   Label           : 2005 Family Wealth Data
   Rows            : 8002
   Columns         : 38
   ASCII File Date : March 2, 2011
*************************************************************************;


infix 
      S700            1 - 1         S701            2 - 6         S702            7 - 7    
      S702A           8 - 8         S703            9 - 17        S703A          18 - 18   
      S704           19 - 19        S704A          20 - 20        S705           21 - 29   
      S705A          30 - 30        S706           31 - 31        S706A          32 - 32   
      S707           33 - 41        S707A          42 - 42        S708           43 - 43   
      S708A          44 - 44        S709           45 - 53        S709A          54 - 54   
      S710           55 - 55        S710A          56 - 56        S711           57 - 65   
      S711A          66 - 66        S713           67 - 75        S713A          76 - 76   
      S714           77 - 77        S714A          78 - 78        S715           79 - 87   
      S715A          88 - 88        S718           89 - 89        S718A          90 - 90   
      S719           91 - 99        S719A         100 - 100       S720          101 - 109  
      S720A         110 - 110       S716          111 - 119       S716A         120 - 120  
      S717          121 - 129       S717A         130 - 130  

using $datadir/WLTH2005.txt, clear ;


label variable  S700       "2005 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S701       "2005 FAMILY ID" ;                                  
label variable  S702       "IMP WTR FARM/BUS (W10) 05" ;                       
label variable  S702A      "ACC WTR FARM/BUS (W10) 05" ;                       
label variable  S703       "IMP VALUE FARM/BUS (W11) 05" ;                     
label variable  S703A      "ACC VALUE FARM/BUS (W11) 05" ;                     
label variable  S704       "IMP WTR CHECKING/SAVING (W27) 05" ;                
label variable  S704A      "ACC WTR CHECKING/SAVING (W27) 05" ;                
label variable  S705       "IMP VAL CHECKING/SAVING (W28) 05" ;                
label variable  S705A      "ACC VAL CHECKING/SAVING (W28) 05" ;                
label variable  S706       "IMP WTR OTH DEBT (W38) 05" ;                       
label variable  S706A      "ACC WTR OTH DEBT (W38) 05" ;                       
label variable  S707       "IMP VALUE OTH DEBT (W39) 05" ;                     
label variable  S707A      "ACC VALUE OTH DEBT (W39) 05" ;                     
label variable  S708       "IMP WTR OTH REAL ESTATE (W1) 05" ;                 
label variable  S708A      "ACC WTR OTH REAL ESTATE (W1) 05" ;                 
label variable  S709       "IMP VAL OTH REAL ESTATE (W2) 05" ;                 
label variable  S709A      "ACC VAL OTH REAL ESTATE (W2) 05" ;                 
label variable  S710       "IMP WTR STOCKS (W15) 05" ;                         
label variable  S710A      "ACC WTR STOCKS (W15) 05" ;                         
label variable  S711       "IMP VALUE STOCKS (W16) 05" ;                       
label variable  S711A      "ACC VALUE STOCKS (W16) 05" ;                       
label variable  S713       "IMP VALUE VEHICLES (W6) 05" ;                      
label variable  S713A      "ACC VALUE VEHICLES (W6) 05" ;                      
label variable  S714       "IMP WTR OTH ASSETS (W33) 05" ;                     
label variable  S714A      "ACC WTR OTH ASSETS (W33) 05" ;                     
label variable  S715       "IMP VALUE OTH ASSETS (W34) 05" ;                   
label variable  S715A      "ACC VALUE OTH ASSETS (W34) 05" ;                   
label variable  S718       "IMP WTR ANNUITY/IRA (W21) 05" ;                    
label variable  S718A      "ACC WTR ANNUITY/IRA (W21) 05" ;                    
label variable  S719       "IMP VALUE ANNUITY/IRA (W22) 05" ;                  
label variable  S719A      "ACC VALUE ANNUITY/IRA (W22) 05" ;                  
label variable  S720       "IMP VALUE HOME EQUITY 05" ;                        
label variable  S720A      "ACC VALUE HOME EQUITY 05" ;                        
label variable  S716       "IMP WEALTH W/O EQUITY (WEALTH1) 05" ;              
label variable  S716A      "ACC WEALTH W/O EQUITY (WEALTH1) 05" ;              
label variable  S717       "IMP WEALTH W/ EQUITY (WEALTH2) 05" ;               
label variable  S717A      "ACC WEALTH W/ EQUITY (WEALTH2) 05" ;               


#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi05   = 195.3


rename S701  famID
rename S703  assetFam_FarmBus 
rename S705  assetFam_saving
rename S707  debtFam
rename S709  assetFam_realestate
rename S711  assetFam_stock
rename S713  assetFam_vehicle
rename S715  assetFam_other
rename S719  assetFam_annuityIRA
rename S720  assetFam_homeequity
rename S716  wealthFam1
rename S717  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi05'*`cpi`refyy'' 
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 2005
sort famID  
duplicates list famID

save $curdir/wealthFamily2005, replace 

