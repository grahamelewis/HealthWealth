
#delimit ;

**************************************************************************
   Label           : 2003 Family Wealth Data
   Rows            : 7822
   Columns         : 38
   ASCII File Date : March 2, 2011
*************************************************************************;


infix 
      S600            1 - 1         S601            2 - 6         S602            7 - 7    
      S602A           8 - 8         S603            9 - 17        S603A          18 - 18   
      S604           19 - 19        S604A          20 - 20        S605           21 - 29   
      S605A          30 - 30        S606           31 - 31        S606A          32 - 32   
      S607           33 - 41        S607A          42 - 42        S608           43 - 43   
      S608A          44 - 44        S609           45 - 53        S609A          54 - 54   
      S610           55 - 55        S610A          56 - 56        S611           57 - 65   
      S611A          66 - 66        S613           67 - 75        S613A          76 - 76   
      S614           77 - 77        S614A          78 - 78        S615           79 - 87   
      S615A          88 - 88        S618           89 - 89        S618A          90 - 90   
      S619           91 - 99        S619A         100 - 100       S620          101 - 109  
      S620A         110 - 110       S616          111 - 119       S616A         120 - 120  
      S617          121 - 129       S617A         130 - 130  

using $datadir/WLTH2003.txt, clear;

label variable  S600       "2003 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S601       "2003 FAMILY ID" ;                                  
label variable  S602       "IMP WTR FARM/BUS (W10) 03" ;                       
label variable  S602A      "ACC WTR FARM/BUS (W10) 03" ;                       
label variable  S603       "IMP VALUE FARM/BUS (W11) 03" ;                     
label variable  S603A      "ACC VALUE FARM/BUS (W11) 03" ;                     
label variable  S604       "IMP WTR CHECKING/SAVING (W27) 03" ;                
label variable  S604A      "ACC WTR CHECKING/SAVING (W27) 03" ;                
label variable  S605       "IMP VAL CHECKING/SAVING (W28) 03" ;                
label variable  S605A      "ACC VAL CHECKING/SAVING (W28) 03" ;                
label variable  S606       "IMP WTR OTH DEBT (W38) 03" ;                       
label variable  S606A      "ACC WTR OTH DEBT (W38) 03" ;                       
label variable  S607       "IMP VALUE OTH DEBT (W39) 03" ;                     
label variable  S607A      "ACC VALUE OTH DEBT (W39) 03" ;                     
label variable  S608       "IMP WTR OTH REAL ESTATE (W1) 03" ;                 
label variable  S608A      "ACC WTR OTH REAL ESTATE (W1) 03" ;                 
label variable  S609       "IMP VAL OTH REAL ESTATE (W2) 03" ;                 
label variable  S609A      "ACC VAL OTH REAL ESTATE (W2) 03" ;                 
label variable  S610       "IMP WTR STOCKS (W15) 03" ;                         
label variable  S610A      "ACC WTR STOCKS (W15) 03" ;                         
label variable  S611       "IMP VALUE STOCKS (W16) 03" ;                       
label variable  S611A      "ACC VALUE STOCKS (W16) 03" ;                       
label variable  S613       "IMP VALUE VEHICLES (W6) 03" ;                      
label variable  S613A      "ACC VALUE VEHICLES (W6) 03" ;                      
label variable  S614       "IMP WTR OTH ASSETS (W33) 03" ;                     
label variable  S614A      "ACC WTR OTH ASSETS (W33) 03" ;                     
label variable  S615       "IMP VALUE OTH ASSETS (W34) 03" ;                   
label variable  S615A      "ACC VALUE OTH ASSETS (W34) 03" ;                   
label variable  S618       "IMP WTR ANNUITY/IRA (W21) 03" ;                    
label variable  S618A      "ACC WTR ANNUITY/IRA (W21) 03" ;                    
label variable  S619       "IMP VALUE ANNUITY/IRA (W22) 03" ;                  
label variable  S619A      "ACC VALUE ANNUITY/IRA (W22) 03" ;                  
label variable  S620       "IMP VALUE HOME EQUITY 03" ;                        
label variable  S620A      "ACC VALUE HOME EQUITY 03" ;                        
label variable  S616       "IMP WEALTH W/O EQUITY (WEALTH1) 03" ;              
label variable  S616A      "ACC WEALTH W/O EQUITY (WEALTH1) 03" ;              
label variable  S617       "IMP WEALTH W/ EQUITY (WEALTH2) 03" ;               
label variable  S617A      "ACC WEALTH W/ EQUITY (WEALTH2) 03" ;               




#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi03   = 184.0


rename S601  famID
rename S603  assetFam_FarmBus 
rename S605  assetFam_saving
rename S607  debtFam
rename S609  assetFam_realestate
rename S611  assetFam_stock
rename S613  assetFam_vehicle
rename S615  assetFam_other
rename S619  assetFam_annuityIRA
rename S620  assetFam_homeequity
rename S616  wealthFam1
rename S617  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi03'*`cpi`refyy''  
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 2003
sort famID  
duplicates list famID

save $curdir/wealthFamily2003, replace 


