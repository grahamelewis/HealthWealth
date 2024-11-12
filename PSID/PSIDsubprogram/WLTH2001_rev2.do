
#delimit ;

**************************************************************************
   Label           : 2001 Family Wealth Data
   Rows            : 7406
   Columns         : 38
   ASCII File Date : March 2, 2011
*************************************************************************;


infix 
      S500            1 - 1         S501            2 - 6         S502            7 - 7    
      S502A           8 - 8         S503            9 - 17        S503A          18 - 18   
      S504           19 - 19        S504A          20 - 20        S505           21 - 29   
      S505A          30 - 30        S506           31 - 31        S506A          32 - 32   
      S507           33 - 41        S507A          42 - 42        S508           43 - 43   
      S508A          44 - 44        S509           45 - 53        S509A          54 - 54   
      S510           55 - 55        S510A          56 - 56        S511           57 - 65   
      S511A          66 - 66        S513           67 - 75        S513A          76 - 76   
      S514           77 - 77        S514A          78 - 78        S515           79 - 87   
      S515A          88 - 88        S518           89 - 89        S518A          90 - 90   
      S519           91 - 99        S519A         100 - 100       S520          101 - 109  
      S520A         110 - 110       S516          111 - 119       S516A         120 - 120  
      S517          121 - 129       S517A         130 - 130  

using $datadir/WLTH2001.txt, clear ;

label variable  S500       "2001 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S501       "2001 FAMILY ID" ;                                  
label variable  S502       "IMP WTR FARM/BUS (W10) 01" ;                       
label variable  S502A      "ACC WTR FARM/BUS (W10) 01" ;                       
label variable  S503       "IMP VALUE FARM/BUS (W11) 01" ;                     
label variable  S503A      "ACC VALUE FARM/BUS (W11) 01" ;                     
label variable  S504       "IMP WTR CHECKING/SAVING (W27) 01" ;                
label variable  S504A      "ACC WTR CHECKING/SAVING (W27) 01" ;                
label variable  S505       "IMP VAL CHECKING/SAVING (W28) 01" ;                
label variable  S505A      "ACC VAL CHECKING/SAVING (W28) 01" ;                
label variable  S506       "IMP WTR OTH DEBT (W38) 01" ;                       
label variable  S506A      "ACC WTR OTH DEBT (W38) 01" ;                       
label variable  S507       "IMP VALUE OTH DEBT (W39) 01" ;                     
label variable  S507A      "ACC VALUE OTH DEBT (W39) 01" ;                     
label variable  S508       "IMP WTR OTH REAL ESTATE (W1) 01" ;                 
label variable  S508A      "ACC WTR OTH REAL ESTATE (W1) 01" ;                 
label variable  S509       "IMP VAL OTH REAL ESTATE (W2) 01" ;                 
label variable  S509A      "ACC VAL OTH REAL ESTATE (W2) 01" ;                 
label variable  S510       "IMP WTR STOCKS (W15) 01" ;                         
label variable  S510A      "ACC WTR STOCKS (W15) 01" ;                         
label variable  S511       "IMP VALUE STOCKS (W16) 01" ;                       
label variable  S511A      "ACC VALUE STOCKS (W16) 01" ;                       
label variable  S513       "IMP VALUE VEHICLES (W6) 01" ;                      
label variable  S513A      "ACC VALUE VEHICLES (W6) 01" ;                      
label variable  S514       "IMP WTR OTH ASSETS (W33) 01" ;                     
label variable  S514A      "ACC WTR OTH ASSETS (W33) 01" ;                     
label variable  S515       "IMP VALUE OTH ASSETS (W34) 01" ;                   
label variable  S515A      "ACC VALUE OTH ASSETS (W34) 01" ;                   
label variable  S518       "IMP WTR ANNUITY/IRA (W21) 01" ;                    
label variable  S518A      "ACC WTR ANNUITY/IRA (W21) 01" ;                    
label variable  S519       "IMP VALUE ANNUITY/IRA (W22) 01" ;                  
label variable  S519A      "ACC VALUE ANNUITY/IRA (W22) 01" ;                  
label variable  S520       "IMP VALUE HOME EQUITY 01" ;                        
label variable  S520A      "ACC VALUE HOME EQUITY 01" ;                        
label variable  S516       "IMP WEALTH W/O EQUITY (WEALTH1) 01" ;              
label variable  S516A      "ACC WEALTH W/O EQUITY (WEALTH1) 01" ;              
label variable  S517       "IMP WEALTH W/ EQUITY (WEALTH2) 01" ;               
label variable  S517A      "ACC WEALTH W/ EQUITY (WEALTH2) 01" ;               



#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi01   = 177.1


rename S501  famID
rename S503  assetFam_FarmBus 
rename S505  assetFam_saving
rename S507  debtFam
rename S509  assetFam_realestate
rename S511  assetFam_stock
rename S513  assetFam_vehicle
rename S515  assetFam_other
rename S519  assetFam_annuityIRA
rename S520  assetFam_homeequity
rename S516  wealthFam1
rename S517  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi01'*`cpi`refyy''  
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 2001
sort famID  
duplicates list famID

save $curdir/wealthFamily2001, replace 


