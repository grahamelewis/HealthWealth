
#delimit ;

**************************************************************************
   Label           : 1984 Family Wealth Data
   Rows            : 6918
   Columns         : 34
   ASCII File Date : March 2, 2011
*************************************************************************;


infix 
      S100            1 - 1         S101            2 - 6         S102            7 - 7    
      S102A           8 - 8         S103            9 - 17        S103A          18 - 18   
      S104           19 - 19        S104A          20 - 20        S105           21 - 29   
      S105A          30 - 30        S106           31 - 31        S106A          32 - 32   
      S107           33 - 41        S107A          42 - 42        S108           43 - 43   
      S108A          44 - 44        S109           45 - 53        S109A          54 - 54   
      S110           55 - 55        S110A          56 - 56        S111           57 - 65   
      S111A          66 - 66        S113           67 - 75        S113A          76 - 76   
      S114           77 - 77        S114A          78 - 78        S115           79 - 87   
      S115A          88 - 88        S120           89 - 97        S120A          98 - 98   
      S116           99 - 107       S116A         108 - 108       S117          109 - 117  
      S117A         118 - 118  

	  
using $datadir/WLTH1984.txt, clear ;


;
label variable  S100       "1984 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S101       "1984 FAMILY ID" ;                                  
label variable  S102       "IMP WTR FARM/BUS (K122) 84" ;                      
label variable  S102A      "ACC WTR FARM/BUS (K122) 84" ;                      
label variable  S103       "IMP VALUE FARM/BUS (K123) 84" ;                    
label variable  S103A      "ACC VALUE FARM/BUS (K123) 84" ;                    
label variable  S104       "IMP WTR CHECKING/SAVING (K132) 84" ;               
label variable  S104A      "ACC WTR CHECKING/SAVING (K132) 84" ;               
label variable  S105       "IMP VAL CHECKING/SAVING (K133) 84" ;               
label variable  S105A      "ACC VAL CHECKING/SAVING (K133) 84" ;               
label variable  S106       "IMP WTR OTH DEBT (K145) 84" ;                      
label variable  S106A      "ACC WTR OTH DEBT (K145) 84" ;                      
label variable  S107       "IMP VALUE OTH DEBT (K146) 84" ;                    
label variable  S107A      "ACC VALUE OTH DEBT (K146) 84" ;                    
label variable  S108       "IMP WTR OTH REAL ESTATE (K113) 84" ;               
label variable  S108A      "ACC WTR OTH REAL ESTATE (K113) 84" ;               
label variable  S109       "IMP VAL OTH REAL ESTATE (K114) 84" ;               
label variable  S109A      "ACC VAL OTH REAL ESTATE (K114) 84" ;               
label variable  S110       "IMP WTR STOCKS (K127) 84" ;                        
label variable  S110A      "ACC WTR STOCKS (K127) 84" ;                        
label variable  S111       "IMP VALUE STOCKS (K128) 84" ;                      
label variable  S111A      "ACC VALUE STOCKS (K128) 84" ;                      
label variable  S113       "IMP VALUE VEHICLES (K118) 84" ;                    
label variable  S113A      "ACC VALUE VEHICLES (K118) 84" ;                    
label variable  S114       "IMP WTR OTH ASSETS (K137) 84" ;                    
label variable  S114A      "ACC WTR OTH ASSETS (K137) 84" ;                    
label variable  S115       "IMP VALUE OTH ASSETS (K138) 84" ;                  
label variable  S115A      "ACC VALUE OTH ASSETS (K138) 84" ;                  
label variable  S120       "IMP VALUE HOME EQUITY 84" ;                        
label variable  S120A      "ACC VALUE HOME EQUITY 84" ;                        
label variable  S116       "IMP WEALTH W/O EQUITY (WEALTH1) 84" ;              
label variable  S116A      "ACC WEALTH W/O EQUITY (WEALTH1) 84" ;              
label variable  S117       "IMP WEALTH W/ EQUITY (WEALTH2) 84" ;               
label variable  S117A      "ACC WEALTH W/ EQUITY (WEALTH2) 84" ;               


#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi83   = 99.60


rename S101  famID
rename S103  assetFam_FarmBus 
rename S105  assetFam_saving
rename S107  debtFam
rename S109  assetFam_realestate
rename S111  assetFam_stock
rename S113  assetFam_vehicle
rename S115  assetFam_other
rename S120  assetFam_homeEquity
rename S116  wealthFam1
rename S117  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi84'*`cpi`refyy''  
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 1984
sort famID  
duplicates list famID

save $curdir/wealthFamily1984, replace 

