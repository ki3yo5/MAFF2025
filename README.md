# MAFF2023-2025
## Food Supply Simulation in Japan applying the SWISSfoodSys Model

## Build 2.7 Jan 19 2026
-    2.7: Variable cropping pattern (rice and wheat based; potato based)
-    2.7a: Unified arable land across country.
-    2.7b: Differentiated land type (paddy_dry, field_irr), region (Hokkaido, Tohoku_Hokuriku, Kanto_West, Okinawa) and cropping season (Hokkaido and Others).

## scenario setting in main file
### set import scenario (0=baseline(0%), 1=20%, 2=40%, 3=60%, 4=100%): idc
### set rate of no pestiside area in post-hoc analysis (any value in [0,100]): npe
### set 1/0 to evaluate calorie deficit and nutrient intake by rate not by difference: rate (1 is recommended) 
### set 1/0 to include constraints on fertilizer element balance (do not set 1 if liebig is 1): fbal
### set 1/0 to include variable yield and fertilizer application (do not set 1 if fbal is 1): liebig
### set 1/0 to include deserted land on land balance: dsrt
### set 1/0 to include constraints on labor balance: lbal

## scenario variation in main file (multiple selection possible)
### set 1/0 to variate weight for calorie deficit in objective fuction: scn_weight
### set 1/0 to variate upper limit for cropping area expansion: scn_areaMax
### set 1/0 to variate cropping pattern: scn_pattern
### set 1/0 to variate first-year cropping scenario: scn_firstYr
### set 1/0 to activate grain stockpile release scenario: scn_stockRe

## file included
### main files (open this file to execute simulation)
   build2.Xa.gms       'Unified arable land across country'  
   build2.Xb.gms       'Differentiate land type and region for cropping'  
### branch files (set scenario parameters)
   data_idc_scn0.gms   'Import decline rate for goods and feeds'  
   data_idc_scn1.gms  
   data_idc_scn2.gms  
   data_idc_scn3.gms  
   data_idc_scn4.gms  
   data_ydc.gms        'Yield reduction rate in no pestiside use area'  
### data files
   climreq.gdx         'Climate requirement by crop (0/1)'  
   edemand.gdx         'Fertilizer element demand (each element: kg/ha)'  
   esupply.gdx         'Fertilizer element supply (each element: t)'  
   fconst_imp.gdx      'Feed constraints       (t)'  
   fdemand.gdx         'Feed nutrient demand   (TDN:kilograms per head, CP:%)'  
   fertcoef.gdx        'Fertilizer input coefficients'  
   fsupply.gdx         'Feed nutrient supply   (%)'  
   intake.gdx          'Required daily intake of nutrients'  
   land_dsrt.gdx       'Deserted land (1000ha)'  
   land_endw.gdx       'Land endowment (1000ha)'  
   landreq_alt.gdx     'Seasonal requirement by crop (0/1) alternative for build2.Xa.gms'  
   landreq_hok.gdx     'Seasonal requirement by crop (0/1) for build2.Xb.gms'  
   landreq_oth.gdx  
   ldemand_c.gdx       'Labor dmenad (h/10a -> h/1000ha)'  
   ldemand_l.gdx       'Labor dmenad (h/head)'  
   nvalue.gdx          'Nutritive supply and value of foods'  
   prod_alt.gdx        'Production data'  
   typereq.gdx         'Land type requirement by crop (0/1)'  
### output listing file (open this file to check solve status)
   build2.X.lst  
   xlsx2gdx.lst  
   
--------------------------------------------------------------------------------------

## Build 2.6 Nov 26 2025
-    Post-hoc analysis is available by entering any value as the estimated reduction area in yield due to reduced pesticide use.  

## Build 2.5 Nov 24 2025
-  The contstraints on cropping are
         a)  arable land endowments by total acreage and cropping season;
         b)  expansion margin for each crop;
         c)  total fertilizer supply and element usage (constanat or variable) balance; and
         d)  agricultural labor supply and usage balance.
-  The common constraints on all goods are total agricultural labor supply and unit labor demand.
Ishikawa et al.(2025) Food Supply Simulation in Japan applying the SWISSfoodSys Model.  

## Build 2.4 Nov 17 2025
-  The contstraints on cropping are a) arable land endowments by total acreage and month; b) expansion margin for each crop; and c) total fertilizer supply and N, P, K balance.  
-  The common constraints on all goods are total agricultural labor supply and unit labor demand.  

## Build 2.3 Feb 16 2025
-  Simultaneous simulation for croping and animal production models with 16 crops, 6 processing foods, 13 feeds, 7 livestocks, 5 animal products and 2 marine products.  
-  Besides baseline scenario (no food and feed import), optional import decline scenario is avialable.  

## Build 2.1 Nov 28 2024
-  Cropping model with 16 crops, 2 marine products, 6 processing foods.  
-  Livestock model with 13 feeds, 7 livestocks, 5 animal products.  
-  Objective function is calorie deficit and food intake balance of 8 food groups.  
-  Contstraints on cropping with arable land endowments and expansion margins for each crops.  
-  Contstraints on livestock production with feed distribution and feed TDN and CP balance.  
-  Simultaneous simulation for croping and animal production models.  
-  Optional module for import decline.  

## Build 1.5 Jan 13 2024
Cropping model with 16 crops, 2 marine products, 6 processing foods.  
Objective function is calorie deficit and nutrient intake balance by 8 food groups.  
The two components are weighted with 4 patterns of weights.  
Contstraints on land size by each type, each month and expansion margins for each crops.  
Calorie and nutrient balance is optimized for per capita per day.  

## Build 1.4 Dec 26 2023
Cropping model with 16 crops, 2 marine products, 6 processing foods.  
Objective function is calorie deficit and nutrient intake balance in difference or rate.  
Contstraints on land size by each type and 300% margin for each cropiing area.  
Cropping on pasture, orchard, local plants are exception.  
Calorie and nutrient balance is optimized for the total population per day.  

## Build 1.3 Dec 24 2023
Cropping model with 16 crops, 2 marine products, 6 processing foods.  
Objective function is calorie deficit and nutrient intake balance only.  
Contstraints on land size by each type and 300% margin for each cropiing area.  
Cropping on pasture, orchard, local plants are exception.  
Calorie and nutrient balance is optimized for the total population per day.  

## Build 1.2 Dec 23 2023
Cropping model with 16 crops but without livestock and processing foods.  
Objective function is calorie deficit and nutrient intake balance only.  
Contstraints on land size by each type and 500% margin for each cropiing area.  
Calorie and nutrient balance is optimized for the total population per day.  

## Build 1.1 Dec 12 2023
Cropping model with 16 crops but without livestock and processing foods.  
Objective function is calorie deficit and nutrient intake balance only.  
Contstraints on pooled land size and 250% margin for each cropiing area.  
Calorie and nutrient balance is optimized for the total population per day.  

## Build 1.0
Simple model with 7 crops and calorie and PCF balance only.  
Contstraints on land size (1ha) only.  
Nutrient balance per day per family (4 adults) is optimized.  

Ishikawa K., Pre-simulation for DSS-ESSA Model. The MAFF Open Lab, 2023.  
