
#delimit ;

**************************************************************************
   Label           : 1989 Family Wealth Data
   Rows            : 7114
   Columns         : 34
   ASCII File Date : March 2, 2011
*************************************************************************;


infix 
      S200            1 - 1         S201            2 - 5         S202            6 - 6    
      S202A           7 - 7         S203            8 - 16        S203A          17 - 17   
      S204           18 - 18        S204A          19 - 19        S205           20 - 28   
      S205A          29 - 29        S206           30 - 30        S206A          31 - 31   
      S207           32 - 40        S207A          41 - 41        S208           42 - 42   
      S208A          43 - 43        S209           44 - 52        S209A          53 - 53   
      S210           54 - 54        S210A          55 - 55        S211           56 - 64   
      S211A          65 - 65        S213           66 - 74        S213A          75 - 75   
      S214           76 - 76        S214A          77 - 77        S215           78 - 86   
      S215A          87 - 87        S220           88 - 96        S220A          97 - 97   
      S216           98 - 106       S216A         107 - 107       S217          108 - 116  
      S217A         117 - 117  
using $datadir/WLTH1989.txt, clear ;
;
label variable  S200       "1989 WEALTH FILE RELEASE NUMBER" ;                 
label variable  S201       "1989 FAMILY ID" ;                                  
label variable  S202       "IMP WTR FARM/BUS (G124) 89" ;                      
label variable  S202A      "ACC WTR FARM/BUS (G124) 89" ;                      
label variable  S203       "IMP VALUE FARM/BUS (G125) 89" ;                    
label variable  S203A      "ACC VALUE FARM/BUS (G125) 89" ;                    
label variable  S204       "IMP WTR CHECKING/SAVING (G135) 89" ;               
label variable  S204A      "ACC WTR CHECKING/SAVING (G135) 89" ;               
label variable  S205       "IMP VAL CHECKING/SAVING (G136) 89" ;               
label variable  S205A      "ACC VAL CHECKING/SAVING (G136) 89" ;               
label variable  S206       "IMP WTR OTH DEBT (G146) 89" ;                      
label variable  S206A      "ACC WTR OTH DEBT (G146) 89" ;                      
label variable  S207       "IMP VALUE OTH DEBT (G147) 89" ;                    
label variable  S207A      "ACC VALUE OTH DEBT (G147) 89" ;                    
label variable  S208       "IMP WTR OTH REAL ESTATE (G115) 89" ;               
label variable  S208A      "ACC WTR OTH REAL ESTATE (G115) 89" ;               
label variable  S209       "IMP VAL OTH REAL ESTATE (G116) 89" ;               
label variable  S209A      "ACC VAL OTH REAL ESTATE (G116) 89" ;               
label variable  S210       "IMP WTR STOCKS (G129) 89" ;                        
label variable  S210A      "ACC WTR STOCKS (G129) 89" ;                        
label variable  S211       "IMP VALUE STOCKS (G130) 89" ;                      
label variable  S211A      "ACC VALUE STOCKS (G130) 89" ;                      
label variable  S213       "IMP VALUE VEHICLES (G120) 89" ;                    
label variable  S213A      "ACC VALUE VEHICLES (G120) 89" ;                    
label variable  S214       "IMP WTR OTH ASSETS (G141) 89" ;                    
label variable  S214A      "ACC WTR OTH ASSETS (G141) 89" ;                    
label variable  S215       "IMP VALUE OTH ASSETS (G142) 89" ;                  
label variable  S215A      "ACC VALUE OTH ASSETS (G142) 89" ;                  
label variable  S220       "IMP VALUE HOME EQUITY 89" ;                        
label variable  S220A      "ACC VALUE HOME EQUITY 89" ;                        
label variable  S216       "IMP WEALTH W/O EQUITY (WEALTH1) 89" ;              
label variable  S216A      "ACC WEALTH W/O EQUITY (WEALTH1) 89" ;              
label variable  S217       "IMP WEALTH W/ EQUITY (WEALTH2) 89" ;               
label variable  S217A      "ACC WEALTH W/ EQUITY (WEALTH2) 89" ;               


#delimit cr ;

local refyy   = 96
local cpi96   = 156.40
local cpi84   = 103.90
local cpi89   = 124.00


rename S201  famID
rename S203  assetFam_FarmBus 
rename S205  assetFam_saving
rename S207  debtFam
rename S209  assetFam_realestate
rename S211  assetFam_stock
rename S213  assetFam_vehicle
rename S215  assetFam_other
rename S220  assetFam_homeequity
rename S216  wealthFam1
rename S217  wealthFam2


foreach var of varlist assetFam* debtFam* wealthFam* {
   replace `var'=`var'/`cpi89'*`cpi`refyy'' 
}

keep famID assetFam* debtFam* wealthFam*

gen wave = 1989
sort famID  
duplicates list famID

save $curdir/wealthFamily1989, replace 
