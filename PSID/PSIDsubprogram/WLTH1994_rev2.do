
#delimit ;

**************************************************************************
   Label           : 1994 Family Wealth Data
   Rows            : 8623
   Columns         : 34
   ASCII File Date : March 10, 2011
*************************************************************************;


infix 
      S300            1 - 1         S301            2 - 6         S302            7 - 7    
      S302A           8 - 8         S303            9 - 17        S303A          18 - 18   
      S304           19 - 19        S304A          20 - 20        S305           21 - 29   
      S305A          30 - 30        S306           31 - 31        S306A          32 - 32   
      S307           33 - 41        S307A          42 - 42        S308           43 - 43   
      S308A          44 - 44        S309           45 - 53        S309A          54 - 54   
      S310           55 - 55        S310A          56 - 56        S311           57 - 65   
      S311A          66 - 66        S313           67 - 75        S313A          76 - 76   
      S314           77 - 77        S314A          78 - 78        S315           79 - 87   
      S315A          88 - 88        S320           89 - 97        S320A          98 - 98   
      S316           99 - 107       S316A         108 - 108       S317          109 - 117  
      S317A         118 - 118  


using $datadir/WLTH1994.txt, clear ;


label variable  S300       "1994 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S301       "1994 FAMILY ID" ;                                  
label variable  S302       "IMP WTR FARM/BUS (G124) 94" ;                      
label variable  S302A      "ACC WTR FARM/BUS (G124) 94" ;                      
label variable  S303       "IMP VALUE FARM/BUS (G125) 94" ;                    
label variable  S303A      "ACC VALUE FARM/BUS (G125) 94" ;                    
label variable  S304       "IMP WTR CHECKING/SAVING (G135) 94" ;               
label variable  S304A      "ACC WTR CHECKING/SAVING (G135) 94" ;               
label variable  S305       "IMP VAL CHECKING/SAVING (G136) 94" ;               
label variable  S305A      "ACC VAL CHECKING/SAVING (G136) 94" ;               
label variable  S306       "IMP WTR OTH DEBT (G146) 94" ;                      
label variable  S306A      "ACC WTR OTH DEBT (G146) 94" ;                      
label variable  S307       "IMP VALUE OTH DEBT (G147) 94" ;                    
label variable  S307A      "ACC VALUE OTH DEBT (G147) 94" ;                    
label variable  S308       "IMP WTR OTH REAL ESTATE (G115) 94" ;               
label variable  S308A      "ACC WTR OTH REAL ESTATE (G115) 94" ;               
label variable  S309       "IMP VAL OTH REAL ESTATE (G116) 94" ;               
label variable  S309A      "ACC VAL OTH REAL ESTATE (G116) 94" ;               
label variable  S310       "IMP WTR STOCKS (G129) 94" ;                        
label variable  S310A      "ACC WTR STOCKS (G129) 94" ;                        
label variable  S311       "IMP VALUE STOCKS (G130) 94" ;                      
label variable  S311A      "ACC VALUE STOCKS (G130) 94" ;                      
label variable  S313       "IMP VALUE VEHICLES (G120) 94" ;                    
label variable  S313A      "ACC VALUE VEHICLES (G120) 94" ;                    
label variable  S314       "IMP WTR OTH ASSETS (G141) 94" ;                    
label variable  S314A      "ACC WTR OTH ASSETS (G141) 94" ;                    
label variable  S315       "IMP VALUE OTH ASSETS (G142) 94" ;                  
label variable  S315A      "ACC VALUE OTH ASSETS (G142) 94" ;                  
label variable  S320       "IMP VALUE HOME EQUITY 94" ;                        
label variable  S320A      "ACC VALUE HOME EQUITY 94" ;                        
label variable  S316       "IMP WEALTH W/O EQUITY (WEALTH1) 94" ;              
label variable  S316A      "ACC WEALTH W/O EQUITY (WEALTH1) 94" ;              
label variable  S317       "IMP WEALTH W/ EQUITY (WEALTH2) 94" ;               
label variable  S317A      "ACC WEALTH W/ EQUITY (WEALTH2) 94" ;               



#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi94   = 148.2


rename S301  famID
rename S303  assetFam_FarmBus 
rename S305  assetFam_saving
rename S307  debtFam
rename S309  assetFam_realestate
rename S311  assetFam_stock
rename S313  assetFam_vehicle
rename S315  assetFam_other
rename S320  assetFam_homeequity
rename S316  wealthFam1
rename S317  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi94'*`cpi`refyy''  
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 1994
sort famID  
duplicates list famID

save $curdir/wealthFamily1994, replace 


