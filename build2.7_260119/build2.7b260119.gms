$title  Food Supply Simulation in Japan applying the SWISSfoodSys Model

$onText
Build 2.7b Jan 19 2026
Simultaneous simulation for croping and animal production models with 16 crops, 6 processing foods,
18 feeds, 7 livestocks, 5 animal products and 2 marine products .
The objective function consists of calorie deficit and net food intake balance of 8 food groups.
The contstraints on cropping are a) arable land endowments in total acreage and each cropping month;
                                 b) expansion margin;
                                 c) fertilizer supply and usage (constanat or variable) balance by element; and
The contstraints on livestock production are total feed supply and TDN and CP balance.
The common constraints on agricultural labor supply and usage balance.
Variable cropping patterns (rice and wheat based; potato based)
Differentiate land type and region for cropping.
Baseline scenario (current food and feed import) and import decline scenarios.
Post-hoc analysiy for no-pestiside area to deduct the yield.
Ishikawa et al.(2025) Food Supply Simulation in Japan applying the SWISSfoodSys Model. 
$offText

* set build version name:
$if not setglobal build  $setglobal build 2.7b
* enable gdxxrw (0 only for developpers):
$if not setglobal gdx2xl $setglobal gdx2xl 1

* set weight for calorie deficit in objective fuction:
$if not setglobal scn_weight  $setglobal scn_weight  0
* set variable upper limit for cropping area expansion:
$if not setglobal scn_areaMax $setglobal scn_areaMax 0
* set variable cropping pattern (rice and wheat based; potato based):
$if not setglobal scn_pattern $setglobal scn_pattern 1
* set first-year cropping scenario:
$if not setglobal scn_firstYr $setglobal scn_firstYr 0
* set grain stockpile release scenario:
$if not setglobal scn_stockRe $setglobal scn_stockRe 0

* set variable import scenario (0=baseline(0%), 1=20%, 2=40%, 3=60%, 4=100%):
$if not setglobal idc     $setglobal idc    4
* set rate of no pestiside area in post-hoc analysis (any value in [0,100]):
$if not setglobal npe     $setglobal npe    0
* evaluate calorie deficit and nutrient intake by rate not by difference:
$if not setglobal rate    $setglobal rate   1
* include constraints on fertilizer element balance (do not set 1 if liebig is 1):
$if not setglobal fbal    $setglobal fbal   0
* include variable yield and fertilizer application (do not set 1 if fbal is 1):
$if not setglobal liebig  $setglobal liebig 0
* include deserted land on land balance:
$if not setglobal dsrt    $setglobal dsrt   1
* include constraints on labor balance:
$if not setglobal lbal    $setglobal lbal   1

* generate land usage report:
$if not setglobal landrep       $setglobal landrep  1
* generate fertilizer balance report:
$if not setglobal fertilizerrep $setglobal fertrep  1
* generate labor balance report:
$if not setglobal laborrep      $setglobal laborrep 1


* set name for output files
$if not setglobal name $setglobal name unknown
$ifthen %scn_weight%==1
$setglobal name weight
$elseif %scn_areaMax%==1
$setglobal name areaMax
$elseif %scn_pattern%==1
$setglobal name pattern
$elseif %scn_firstYr%==1
$setglobal name firstYr
$else 
$setglobal name stockRe
$endif
* set key for naming output files
$if not setglobal key $setglobal key %fbal%_%liebig%

* name output files
$iftheni %KEY% == 1_0
$if not setglobal gdx_results   $setglobal gdx_results   .\results\%build%_idc%idc%_%name%_fbal_results.gdx
$if not setglobal excel_results $setglobal excel_results .\results\%build%_idc%idc%_%name%_fbal_results.xlsx
$elseif %KEY% == 0_1
$if not setglobal gdx_results   $setglobal gdx_results   .\results\%build%_idc%idc%_%name%_liebig_results.gdx
$if not setglobal excel_results $setglobal excel_results .\results\%build%_idc%idc%_%name%_liebig_results.xlsx
$else
$if not setglobal gdx_results   $setglobal gdx_results   .\results\%build%_idc%idc%_%name%_results.gdx
$if not setglobal excel_results $setglobal excel_results .\results\%build%_idc%idc%_%name%_results.xlsx
$endif



$sTitle Sets
* item classification
Set
    c crops   /
    rice
    wheat
    pwheat         'cropped in paddy'
    barley
    pbarley        'cropped in paddy'
    naked
    corn           'feed use, cropped in pasture'
    sorghum        'feed use, cropped in pasture'
    mis_grains   
    sweetp
    psweetp        'cropped in paddy'
    potato
    ppotato        'cropped in paddy'
    soy
    psoy           'cropped in paddy'
    mis_beans    
    green_veges  
    mis_veges    
    mandarin     
    apple
    mis_fruits   
    scane        
    sbeat        
    rapeseed
    fish
    seaweed
    starch         'made of corn, potato, sweetp'
    sugar          'made of scane,sbeat '
    oil            'made of rapeseed'
    miso           'made of soy'
    soysource      'made of soy'
    mis_foods    /
    ap animal products /
    beef
    pork
    chicken
    egg
    milk               /
    g  item of goods   /set.c, set.ap/
    fe feeds   /
    fodder         'timothy (1st heading)'
    ricestraw      'rice'
    ricebran       'rice'
    wheatstraw     'wheat'
    wheatbran      'wheat'
    potatovines    'sweetpotato'
    soybeancake    'soy'
    rapeseedcake   'rapeseed'
    beetpulp       'sugarbeat'
    molasses       'sugarbeat'
    bagasse        'sugarcane'
    meatbonemeal   'constant'
    fishmeal       'constant'
    corn           'import only'
    sorghum        'import only'
    wheat          'no import stock only'
    barley         'no import stock only'
    rice           'no import stock only'/
    ls livestocks  /
    dairycow       '> 2 years'
    dairyox        '> 2 years'
    heifer         '1 - 2 years'
    calves         '< 12 months'
    swine
    broiler
    layinghens    /
    x item of goods /set.g, set.ls/
    
* crop classification to land type
    paddy(c)       'Paddy field'
    /rice,pwheat,pbarley,psweetp,ppotato,psoy/
    field(c)       'Upland field'
    /wheat,barley,naked,mis_grains,sweetp,potato,soy,mis_beans,green_veges,mis_veges,scane,sbeat,rapeseed/  
    orchard(c)     'Orchard'
    /mandarin,apple,mis_fruits/
    pasture(c)     'Pasture'
    /corn,sorghum/
    local(c)       'Upland field in Hokkaido and Okinawa'
    /scane,sbeat/  
   
* food groups
    staple(c)
    /rice,wheat,pwheat,sweetp,psweetp,potato,ppotato,soy,psoy/
    edible(c)
    /rice,wheat,pwheat,barley,pbarley,naked,mis_grains,sweetp,psweetp,potato,ppotato,soy,psoy,mis_beans,green_veges,mis_veges,mandarin,apple,mis_fruits/  
    marine(c)
    /fish,seaweed/
    processed(c)
    /starch,sugar,oil,miso,soysource,mis_foods/   
    import(g)
    /rice,wheat,barley,naked,mis_grains,sweetp,potato,soy,mis_beans,green_veges,mis_veges,
    apple,mis_fruits,rapeseed,starch,fish,seaweed,sugar,oil,soysource,mis_foods,
    beef,pork,chicken,egg,milk/
    cg crop groups /
    grain         'grains'
    tuber         'tuber'
    pulse         'pulse and legume'
    veget         'vegetables'
    fruit         'fruits'
    starch        'processed starch'
    sugar         'processed sugar'
    other         'other processed foods'/
    ag animal product groups /
    meat          'meats'
    egg_dairy     'egg and dairy'/
    tg total food groups /set.cg, set.ag/

* model arguments
    t cropping month   /
    jan
    feb
    mar
    apr
    may
    jun
    jul
    aug
    sep
    oct
    nov
    dec     /
    r region /
    Hokkaido      
    Tohoku_Hokuriku
    Kanto_West
    Okinawa     /
    l land type /
    paddy_wet
    paddy_dry     'double crop'
    field_rain
    field_irr     'double crop'     
    orchard
    pasture     /
    pattern Cropping pattern for FSS scenario /
    rice_wheat
    potato        /
    n nutrient values   /
    calorie       'kcal'
    protein       'grams'
    fat           'grams'
    carbonhydrate 'grams'
    pop           'population (million)'
    supplypy      'supply per year (kg)'
    supplypd      'supply per day (grams)'/
    nn  nutrition /
    calorie
    protein
    fat
    carbonhydrate /
    nf feed nutrients /
    tdn           'total digestable nutrients (MT per head)'
    cp            'crude protain              (% of tdn)'
    cp_low
    cp_mid
    cp_high       /
    e fertilizer elemtnts   /
    nitrogen     'N kg/ha'
    phosphate    'P2O5 kg/ha'
    kalium       'K2O kg/ha' /
    a age   /
    0-1
    1-2
    3-5
    6-7
    8-9
    10-11
    12-14
    15-17
    18-29
    30-49
    50-64
    65-74
    75-     /
    p production  /
    area         '1000ha'
    yield        'MT per ha (crops)'
    prod         '1000t'
    import       '1000t'
    export       '1000t'
    stock        '1000t'
    total        '1000t'
    feed         '1000t'
    seed         '1000t'
    processing   '1000t'
    passenger    '1000t'
    wear         '1000t'
    gross        '1000t'
    g2n          'percent'
    net          '1000t' /
    q feed quantity  /
    stock
    import
    presupply
    const           /
    s sex  /
    male
    female /
    v value       /
    pc           'percapita per day'
    value        'nutrients in net food 100g'/


* scenario
    u  upper limit for area expansion   /u2, u3, u4, u5, u10/
    w  weight on calorie balance        /w100, w75, w50, w25/
    z  animal production scenario       /low, mid, high, fstock/;

* i for ingredient crops in food processing 
alias (c,i);

* m for month by commencement of shock
alias (t,m);

set
   mmap(m,c)   Monthly cropping calendar mapping
   rmap(r,c)   Region to suitable crop mapping
   lmap(l,c)   Land type to suitable crop mapping
   CRL(c,r,l)  Region x land type pair for crop
   cmap(cg,c)  Crop groups to crop mapping  /
   grain.(rice,wheat,pwheat,barley,pbarley,naked,mis_grains)
   tuber.(sweetp,potato,psweetp,ppotato)
   pulse.(soy,psoy,mis_beans)
   veget.(green_veges,mis_veges)
   fruit.(mandarin,apple,mis_fruits)
   starch.(starch)
   sugar.(sugar)
   other.(oil,miso,soysource,mis_foods)      /
   amap(ag,ap)  Animap product groups to animal products mapping  /
   meat.(beef,pork,chicken)
   egg_dairy.(egg,milk)                    /
   tmap(tg,x)   Food groups to goods mapping  /
   grain.(rice,wheat,pwheat,barley,pbarley,naked,mis_grains)
   tuber.(sweetp,potato,psweetp,ppotato)
   pulse.(soy,psoy,mis_beans)
   veget.(green_veges,mis_veges)
   fruit.(mandarin,apple,mis_fruits)
   starch.(starch)
   sugar.(sugar,scane,sbeat)
   other.(oil,miso,soysource,mis_foods,rapeseed)
   meat.(beef,pork,chicken,dairyox,swine,broiler)
   egg_dairy.(egg,milk,dairycow,heifer,calves,layinghens)    /
;



$sTitle Parameters
parameter
   k(cg)      Number of crops in cg group /
   grain      4 
   tuber      2 
   pulse      2 
   veget      2 
   fruit      3 
   starch     1 
   sugar      1 
   other      3 /
   j(ag)      Number of animal products in ap group /
   meat       3
   egg_dairy  2 /
   sp(c)      Government grain stockpile (1000t) /
   rice       2500 
   wheat      900  /
   wapply(w)  Set weight for loop operation /
   w100       1
   w75        0.75
   w50        0.50
   w25        0.25 /
   uapply(u)  Set upper limit for loop operation /
   u2         2
   u3         3
   u4         4
   u5         5
   u10       10 /;;

parameter
    data(*,p)         'Production data'
    land_endw(r,l)    'Land endowment (1000ha)'
    land_dsrt(r,*)    'Deserted land (1000ha)'
    landreq_CRT(c,r,t)'Seasonal requirement by crop (0/1)'
    landreq_hok(c,t)
    landreq_oth(c,t)
    climreq(c,r)      'Climate requirement by crop (0/1)'
    typereq(c,l)      'Land type requirement by crop (0/1)'
    fdemand(ls,nf)    'Feed nutrient demand   (TDN:kilograms per head, CP:%)'
    fsupply(ls,nf,fe) 'Feed nutrient supply   (%)'
    fconst(fe,q)      'Feed constraints       (t)'
    edemand(c,e)      'Fertilizer element demand (each element: kg/ha)'
    esupply(*,e)      'Fertilizer element supply (each element: t)'
*                      *prod: chemical fertilizer domestically produced (FAOSTAT 2023)
*                      *import: chemical fertilizer imported (FAOSTAT 2023)
*                      *organic: organic fertilizer estimated (total fertilizer use - chemical fertilizers (prod + import))
    fertcoef(c,e,*)   'Fertilizer input coefficients'
*                      *slope: differential yield to fertilizer ( t/ha / kg/ha )
*                      *intercept: base yield ( t/ha )
*                      *max: upper limit of fertilizer application adjusted to data(c,"yield") ( kg/ha )
    ldemand_c(*)      'Labor dmenad (h/10a -> h/1000ha)'
    ldemand_l(*)      'Labor dmenad (h/head)'    
    intake(a,s,n)     'Required daily intake of nutrients'
    nvalue(*,v,n)     'Nutritive supply and value of foods';
    
$gdxin prod_alt.gdx
$load data
$gdxin
$gdxin land_endw.gdx
$load land_endw
$gdxin
$gdxin land_dsrt.gdx
$load land_dsrt
$gdxin
$gdxin landreq_hok.gdx
$load landreq_hok
$gdxin
$gdxin landreq_oth.gdx
$load landreq_oth
$gdxin
$gdxin climreq.gdx
$load climreq
$gdxin
$gdxin typereq.gdx
$load typereq
$gdxin
$gdxin fdemand.gdx
$load  fdemand
$gdxin
$gdxin fsupply.gdx
$load  fsupply
$gdxin
$gdxin fconst_imp.gdx
$load  fconst
$gdxin
$gdxin edemand.gdx
$load  edemand
$gdxin
$gdxin esupply.gdx
$load  esupply
$gdxin
$gdxin fertcoef.gdx
$load  fertcoef
$gdxin
$gdxin ldemand_c.gdx
$load  ldemand_c
$gdxin
$gdxin ldemand_l.gdx
$load  ldemand_l
$gdxin
$gdxin intake.gdx
$load intake
$gdxin
$gdxin nvalue.gdx
$load nvalue
$gdxin
$include data_idc_scn%idc%.gms
$include data_ydc.gms

* Set mmap from landreq
    mmap(m,c) = yes$(landreq_oth(c,m)=1);
* Set rmap from climreq
    rmap(r,c) = yes$(climreq(c,r)=1);
* Set lmap from climreq
    lmap(l,c) = yes$(typereq(c,l)=1);
* Three dimensional apping
    CRL(c,r,l) = yes$(rmap(r,c) and lmap(l,c));
* Seasonal requirement diversified by region
    landreq_CRT(c,r,t)$(not sameas(r,'Hokkaido')) = landreq_oth(c,t);
    landreq_CRT(c,"Hokkaido",t) = landreq_hok(c,t);
* Cgemical fertilizer supply may exceed total fertilizer use due to inventory stock, crops not considered, current use undersetimated, etc.
    esupply("organic",e) = max(0, sum(c, data(c,"area")*edemand(c,e))-(esupply("prod",e)+esupply("import",e)) );
* Convert 10a to 1000ha
    ldemand_c(c) = ldemand_c(c)*(10**4);
* Include deserted land to land endowment
$iftheni %dsrt%==1
    land_endw(r,"paddy_wet") = land_endw(r,"paddy_wet")+land_dsrt(r,"paddy_dsrt");
    land_endw(r,"field_rain") = land_endw(r,"field_rain")+land_dsrt(r,"field_dsrt");
$endif

Display CRL, esupply, ldemand_c, land_endw;


Scalar
    labor      'Total labor supply (bilion h)'                      /  2.96  /
    
    dummy      'Dummy value to linear term of zyield and fert'      /  1e-5  /
    rate_npe   'rate % of no pestiside area '                       /  %npe% /
    
    spent      'Rate of dairycow spent for beef production'
    culled     'Rate of layinghens culled for chicken prodution'
    lactating  'Rate of dairycow lactating for milk production'

    limit      'Upper bound for area expansion and feed production'
    weight     'Weight on calorie balance in the objective function';

parameter
    head(ls)   'Number of animals (head)'/
    dairycow     861700
    dairyox      237760
    heifer       62300
    calves       447200
    swine        8949000
    broiler      139230000
    layinghens   182661000 /
    lsu(ls)    'Livestock unit coefficient'/
    dairycow     1
    dairyox      1
    heifer       0.8
    calves       0.4
    swine        0.5
    broiler      0.007
    layinghens   0.014  /
    fdm(fe)    'Feed DM coefficient (except fodder)'/
    fodder       1
    ricestraw    0.928
    wheatstraw   0.91
    potatovines  0.289
    ricebran     0.9
    wheatbran    0.87
    soybeancake  0.88
    rapeseedcake 0.89
    beetpulp     0.243
    molasses     0.754
    bagasse      0.46 /;


Table
    pcoef(c,i)   'Output of processed food by 1 unit crop'
                   rice   potato   ppotato   soy    psoy    scane   sbeat   rapeseed
    starch                 0.20     0.20 
    sugar                                                   0.10    0.15             
    oil            0.018                    0.18    0.18                     0.37
    miso                                    5.0     5.0
    soysource                               3.3     3.3                              ;
    
Table
    acoef(ap,ls) 'Output of animal product (kg) by 1 unit livestock'
                   dairycow  dairyox  heifer  calves  swine  broiler  layinghens
    beef           220.3     340.9
    pork                                              78.0
    chicken                                                  1.85     1.73
    egg                                                               18.9
    milk           4500                                                         ;

Table
    fcoef(fe,c) 'Forage and Feed yield (MT/ha)'
                   rice   wheat   pwheat   sweetp   potato   psweetp   ppotato   soy    psoy   scane   sbeat   rapeseed  
    ricestraw      5.15
    wheatstraw            5.15    5.15
    potatovines                            26.54    26.54     26.54    26.54
    ricebran       0.38
    wheatbran             0.96    0.96
    soybeancake                                                                  1.20   1.20
    rapeseedcake                                                                                                 1.20
    beetpulp                                                                                            2.92
    molasses                                                                                            2.17
    bagasse                                                                                    16.39                    ;

    spent     = 0.5*head("calves") / head("dairycow");
    culled    = 83304000           / head("layinghens");
    lactating = 736500             / head("dairycow");  
    acoef("beef","dairycow")      = acoef("beef","dairycow")*spent;
    acoef("milk","dairycow")      = acoef("milk","dairycow")*lactating;
    acoef("chicken","layinghens") = acoef("chicken","layinghens")*culled;

Parameter
    tpop                'National population       (million)'
    pintake(a,s,nn)     'Daily intake requirement  (kcal grams/million)'
    nreq(nn)            'Daily intake requirement  (kcal grams/capita)'
    nnvalue(*,nn)       'Nutritive value of foods  (kcal grams/netfood gram)'
    nnpcvalue(*,nn)     'Nutritive value of foods  (kcal grams/capita)'   
    nnpc(*)             'Current daily intake      (grams/capita)'
    
    t2g(*)              'Total food to gross food'
    t2p(*)              'Total food to processing use'
    t2f(*)              'Total food to feed use'
    g2n(*)              'Gross food to net food '
   
    x2n(c)              'Cropping area(1000ha) to net food (grams)'
    x2nn(c,nn)          'Cropping area(1000ha) to nutritive value (kcal grams)'
    x2f(c,i)            'Cropping area(1000ha) of i to processed food (grams) of c '
    x2fn(c,i,nn)        'Cropping area(1000ha) of i to nutritive value (kcal grams) of c'
    x2a(ap,ls)          'Livestock head to net food (grams)'
    x2an(ap,ls,nn)      'Livestock head to nutritional value (kcal grams)'
    x2fe(fe,c)          'Cropping area(1000ha) to DM base feed (MT)'
    
    yieldcoef(c,l)      'Yield increase coefficient for "paddy_dry" and "field_irr"'
    npecoef(c)          'No pestiside area yield decrease coefficent'

    im(*)               'Imported food (net food)     (grams)'
    impc(*)             '              (daily intake) (grams/capita)'
    imnn(nn)            '              (nutrients)    (kcal grams/capita)';

    tpop = sum((a,s), intake(a,s,"pop"));

    pintake(a,s,"calorie")       = intake(a,s,"pop") * intake(a,s,"calorie");
    pintake(a,s,"protein")       = intake(a,s,"pop") * intake(a,s,"protein");
    pintake(a,s,"fat")           = intake(a,s,"pop") * intake(a,s,"fat");
    pintake(a,s,"carbonhydrate") = intake(a,s,"pop") * intake(a,s,"carbonhydrate");

    nreq(nn) = sum((a,s),pintake(a,s,nn))/tpop;

    nnvalue(g,"calorie")         = nvalue(g,"value","calorie")/100;
    nnvalue(g,"protein")         = nvalue(g,"value","protein")/100;
    nnvalue(g,"fat")             = nvalue(g,"value","fat")/100;
    nnvalue(g,"carbonhydrate")   = nvalue(g,"value","carbonhydrate")/100;
    nnpcvalue(g,"calorie")       = nvalue(g,"pc","calorie");
    nnpcvalue(g,"protein")       = nvalue(g,"pc","protein");
    nnpcvalue(g,"fat")           = nvalue(g,"pc","fat");
    nnpcvalue(g,"carbonhydrate") = nvalue(g,"pc","carbonhydrate");    
    nnpc(g)                      = nvalue(g,"pc","supplypd");

    t2g(g)       = data(g,"gross")/data(g,"total");
    t2p(g)       = data(g,"processing")/data(g,"total");
    t2p("soy")   = 18/data("soy","prod");
    t2p("psoy")  = 18/data("psoy","prod");
    t2f(g)       = data(g,"feed")/data(g,"total");
    g2n(g)       = data(g,"g2n")/100;
    
    x2n(c)       = data(c,"yield")*t2g(c)*g2n(c)*(10**9);
    x2nn(c,nn)   = x2n(c)*nnvalue(c,nn);
    x2f(c,i)     = data(i,"yield")*t2p(i)*pcoef(c,i)*(10**9);
    x2fn(c,i,nn) = x2f(c,i)*nnvalue(c,nn);
    x2a(ap,ls)     = acoef(ap,ls)*g2n(ap)*1000;
    x2an(ap,ls,nn) = x2a(ap,ls)*nnvalue(ap,nn)*0.8;
    x2fe(fe,c)     = fcoef(fe,c)*fdm(fe)*(10**3);
    
    yieldcoef(c,l)$lmap(l,c) = 1;
    yieldcoef("rice","paddy_dry")      = 1.02;
    yieldcoef("pwheat","paddy_dry")    = 1.07;
    yieldcoef("psweetp","paddy_dry")   = 1.15;
    yieldcoef("sweetp","field_irr")    = 1.15;
    yieldcoef("ppotato","paddy_dry")   = 1.23;
    yieldcoef("potato","field_irr")    = 1.23;
    yieldcoef("psoy","paddy_dry")      = 1.08;
    yieldcoef("soy","field_irr")       = 1.08;
    yieldcoef("mis_veges","paddy_dry") = 1.13;
    yieldcoef("mis_veges","field_irr") = 1.13;
    yieldcoef("scane","field_irr")     = 1.33;
    
    npecoef(c) = 1-rdc_rate_yld(c)*rate_npe/100;

    im(g) $import(g)   = (1-rdc_rate(g))*data(g,"import")*t2g(g)*g2n(g)*(10**9) $import(g);
    impc(g) $import(g) = im(g)/(tpop*(10**6)*365) $import(g);
    imnn(nn)           = sum(g, impc(g)*nnvalue(g,nn) $import(g));

Display tpop, pintake, nreq, nnvalue, nnpc, x2n, x2nn, x2fe, yieldcoef, im, impc, imnn;



$sTitle Variables
Variable
    xrlcrop(c,r,l)
    
    xcrop(c)      'Cropping area (1000ha)'
    xlive(ls)     'Head of animal ls'
    yfeed(ls,fe)  'Distribution of feed j to animal ls (MT)'
    zyield(*)     'Effective yield by Liebigs law (MT/ha)'
    fert(c,e)     'Fertilizer application per area (kg/ha)'
    
    eled(e)       'Fertilizer element demand (MT)'
    eles(e)       'Fertilizer element supply (MT)'
    
    labd_c        'Labor demand by crop      (bil. h)'
    labd_ls       'Labor demand by livestock (bil. h)'

    tdnd(ls)      'TDN demand by livestock (MT)'
    tdns(ls)      'TDN supply to livestock (MT)'
    cpd(ls)       'CP demand by livestock  (MT)'
    cps(ls)       'CP supply to livestock  (MT)'
    dms(fe)       'DM supply               (MT)'

    nnpotential_c(c,nn)  'Potential nutrition intake from crops (kcal or grams/capita)'
    nnpotential_f(c,nn)  'Potential nutrition intake from processed foods (kcal or grams/capita)'
    nnpotential_l(ap,nn) 'Potential nutrition intake from animal products (kcal or grams/capita)'

    cdeficit      'Calorie deficit (kcal/capita)'
    cshortrate    'Calorie shortage rate'

    dpotential_c(c)      'Potential netfood intake from crops (grams/capita)'
    dpotential_f(c)      'Potential netfood intake from processed foods (grams/capita)'
    dpotential_l(ap)     'Potential netfood intake from animal products (grams/capita)'
    
    delta(cg)     'Net food intake change (grams/capita)'
    deltasumsq    'Sum of squared net food intake change rate (crop group)'
    
    adelta(ag)    'Net food intake change (grams/capita)'
    adeltasumsq   'Sum of squared net food intake change rate (animal product group)'
    
    target        'Weighted average of calorie deficit and net food balance';

Positive Variable xrlcrop, xcrop, xlive, yfeed, zyield, fert;

*   upper limit of fertilizer application adjusted equivalent to data(c,"yield")
    fert.up(c,e) = fertcoef(c,e,"max");


$sTitle Equations
Equation
    link          'xrlcrop to xcrop link by summation'
    landbal       'Monthly land balance on each land type (1000ha)'
   
    areamax_y     'Area upper bound on paddy crops   (1000ha)'
    areamax_u     'Area upper bound on upland crops  (1000ha)'
    areamax_p     'Area upper bound on pasture crops (1000ha)'
    areamax_o     'Area upper bound on orchard       (1000ha)'
    areamax_l     'Area upper bound on local crops   (1000ha)'
   
    jan           'Cropping area balance by month    (1000ha)'
    feb
    mar
    apr
    may
    jun
    jul
    aug
    sep
    oct
    nov
    dec

    Liebig        'Effective yield by Liebigs law of minimum (MT/ha)'
    Liebigbal     'Fertilizer element balance　(MT each element)'
    eledemand     'Fertilizer element demand  (MT each element)'
    elesupply     'Fertilizer element supply  (MT each element)'
    elebal        'Fertilizer element balance (MT each element)'
    
    labdemand_c   'Total labor demand by crop      (bil. hour)'
    labdemand_l   'Total labor demand by livestock (bil. hour)' 
    labbal        'Total labor balance             (bil. hour)'

    tdndemand     'TDN demand by animal ls'
    tdnsupply     'TDN supply for animal ls by feed fe'
    tdnbal        'TDN balance'    
    cpdemand      'CP demand by animal ls'
    cpdemand_low  'CP demand by animal ls (underestimate)'
    cpdemand_high 'CP demand by animal ls (overestimate)'
    cpsupply      'CP supply for animal ls'
    cpbal         'CP balance'
    dmsupply      'Feed supply (constant + import + crop byproducts) (dry matter MT)'
    distbal       'Feed distribution balance'
    distbal_stock 'Feed distribution balance with feed grain stockpile'

    bredbal       'Livestock breeding balance'
    dairyoxrep    'Reproduction rate of dairy ox per mother dairycow'
    heiferrep     'Reproduction rate of heifer per mother dairycow'
    calfrep       'Reproduction rate of calves per mother dairycow'

    nutpet_c      'Potential nutrition supply (grams or kcal/capita)'
    nutpet_f
    nutpet_l
 
    caloriebal    'Calorie deficit (kcal/capita)'
    caloriebal_r  'Calorie shortage rate'

    dietpet_c     'Potential netfood supply (kcal/capita)'
    dietpet_f
    dietpet_l

    dietbal       'Net food balance by fgroup (grams/capita)'
    dietbal_r     'Net food shortage rate by fgroup'
    adietbal      
    adietbal_r   
    
    dif           'Objective function evaluated as difference value'
    rat           'Objective function evaluated as rate of shortage';

    link(c)..             sum((r,l)$CRL(c,r,l), xrlcrop(c,r,l)) =e= xcrop(c);
    landbal(t,r,l)..      sum(c$CRL(c,r,l), xrlcrop(c,r,l) * landreq_CRT(c,r,t)) =l= land_endw(r,l);

    areamax_y(c)..        xcrop(c) $ paddy(c)   =l= limit*data(c,"area") $ paddy(c);
    areamax_u(c)..        xcrop(c) $ field(c)   =l= limit*data(c,"area") $ field(c);
    areamax_p(c)..        xcrop(c) $ pasture(c) =l=       data(c,"area") $ pasture(c);
    areamax_o(c)..        xcrop(c) $ orchard(c) =l=       data(c,"area") $ orchard(c);
    areamax_l(c)..        xcrop(c) $ local(c)   =l=       data(c,"area") $ local(c);

    jan(c)..              xcrop(c) $ mmap("jan",c) =l= data(c,"area") $ mmap("jan",c);
    feb(c)..              xcrop(c) $ mmap("feb",c) =l= data(c,"area") $ mmap("feb",c);
    mar(c)..              xcrop(c) $ mmap("mar",c) =l= data(c,"area") $ mmap("mar",c);
    apr(c)..              xcrop(c) $ mmap("apr",c) =l= data(c,"area") $ mmap("apr",c);
    may(c)..              xcrop(c) $ mmap("may",c) =l= data(c,"area") $ mmap("may",c);
    jun(c)..              xcrop(c) $ mmap("jun",c) =l= data(c,"area") $ mmap("jun",c);
    jul(c)..              xcrop(c) $ mmap("jul",c) =l= data(c,"area") $ mmap("jul",c);
    aug(c)..              xcrop(c) $ mmap("aug",c) =l= data(c,"area") $ mmap("aug",c);
    sep(c)..              xcrop(c) $ mmap("sep",c) =l= data(c,"area") $ mmap("sep",c);
    oct(c)..              xcrop(c) $ mmap("oct",c) =l= data(c,"area") $ mmap("oct",c);
    nov(c)..              xcrop(c) $ mmap("nov",c) =l= data(c,"area") $ mmap("nov",c);
    dec(c)..              xcrop(c) $ mmap("dec",c) =l= data(c,"area") $ mmap("dec",c);

    eledemand(e)..        eled(e)  =e= sum(c, xcrop(c)*edemand(c,e));
    elesupply(e)..        eles(e)  =e= esupply("prod",e) + esupply("import",e) + esupply("organic",e);
    elebal(e)..           eled(e)  =l= eles(e);
    
    Liebig(c,e)..         zyield(c) =l= fertcoef(c,e,"intercept") + fertcoef(c,e,"slope")*fert(c,e);    
    Liebigbal(e)..        sum(c, xcrop(c)*fert(c,e)) =l= eles(e);

*   Liebig's Law of the Minimum yield(c) = min_e [ a(c,e) + b(c,e)*fert(c,e) ] is executed as 
*                               yield(c) =l= a(c,e) + b(c,e)*fert(c,e)  (∀e)
*   Maximize production in the objective function being executed also maximize yield(c) as much as possible
*   Since the above inequality must hold for all e, yield(c) corresponds to the “minimum value” of the potential yield for each element e.
    
    labdemand_c..         labd_c   =e= sum(c, xcrop(c)*ldemand_c(c)) /(10**9);
    labdemand_l..         labd_ls  =e= sum(ls,xlive(ls)*ldemand_l(ls))/(10**9);
    labbal..              labd_c + labd_ls  =l= labor;

    tdndemand(ls)..       tdnd(ls) =e= xlive(ls)*fdemand(ls,"tdn")/1000;
    tdnsupply(ls)..       tdns(ls) =e= sum(fe, yfeed(ls,fe)*fsupply(ls,"tdn",fe)/100);
    tdnbal(ls)..          tdnd(ls) =l= tdns(ls);
    
    cpdemand(ls)..        cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_mid")/100;
    cpdemand_low(ls)..    cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_low")/100;
    cpdemand_high(ls)..   cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_high")/100;
    cpsupply(ls)..        cps(ls)  =e= sum(fe, yfeed(ls,fe)*fsupply(ls,"cp",fe)/100);
    cpbal(ls)..           cpd(ls)  =l= cps(ls);
    
    dmsupply(fe)..        dms(fe)  =e= fconst(fe,"const")+(1-rdc_rate_fe(fe))*fconst(fe,"import")+sum(c, xcrop(c)*x2fe(fe,c));
    distbal(fe)..         dms(fe)  =g= sum(ls, yfeed(ls,fe));
    distbal_stock(fe)..   dms(fe)  =g= sum(ls, yfeed(ls,fe))-fconst(fe,"stock");

    bredbal(ls)..         xlive(ls) =l= limit*head(ls);    
    dairyoxrep..          head("dairyox")*xlive("dairycow") =l= xlive("dairyox")*head("dairycow");
    heiferrep..           head("heifer") *xlive("dairycow") =l= xlive("heifer") *head("dairycow");
    calfrep..             head("calves") *xlive("dairycow") =l= xlive("calves") *head("dairycow");


    nutpet_c(c,nn)..      nnpotential_c(c,nn) =e= sum((r,l)$CRL(c,r,l), xrlcrop(c,r,l)*x2nn(c,nn)*yieldcoef(c,l)
$ifi %liebig%==1                                                                      *zyield(c)/data(c,"yield")
                                                 )/(tpop*(10**6)*365);
    
    nutpet_f(c,nn)..      nnpotential_f(c,nn) =e= sum((i,r,l)$CRL(i,r,l), xrlcrop(i,r,l)*x2fn(c,i,nn)*yieldcoef(i,l)
$ifi %liebig%==1                                                                        *zyield(i)/data(i,"yield")
                                                 )/(tpop*(10**6)*365);
    
    nutpet_l(ap,nn)..     nnpotential_l(ap,nn) =e= sum(ls, xlive(ls)*x2an(ap,ls,nn))/(tpop*(10**6)*365);
                                                                           
    caloriebal..          cdeficit =e= nreq("calorie")-imnn("calorie")
                                       -sum((c,ap), nnpotential_c(c,"calorie")+nnpotential_f(c,"calorie")+nnpotential_l(ap,"calorie"))
$ifi %liebig%==1                       -sum(c, zyield(c))*dummy - sum((c,e), fert(c,e))*dummy
*   Add a “very small linear term” to the objective function to avoid the saddle point solutions (all zero).       
                          ;
                          
    caloriebal_r..        cshortrate =e= cdeficit/nreq("calorie")
$ifi %liebig%==1                         -sum(c, zyield(c))*dummy - sum((c,e), fert(c,e))*dummy
*   Add a “very small linear term” to the objective function to avoid the saddle point solutions (all zero).       
                          ;                                   


    dietpet_c(c)..        dpotential_c(c) =e= sum((r,l)$CRL(c,r,l), xrlcrop(c,r,l)*x2n(c)*yieldcoef(c,l)
$ifi %liebig%==1                                                                  *zyield(c)/data(c,"yield")
                                                  )/(tpop*(10**6)*365);
    
    dietpet_f(c)..        dpotential_f(c) =e= sum((i,r,l)$CRL(i,r,l), xrlcrop(i,r,l)*x2f(c,i)*yieldcoef(i,l)
$ifi %liebig%==1                                                                    *zyield(i)/data(i,"yield")
                                                  )/(tpop*(10**6)*365);

    dietpet_l(ap)..       dpotential_l(ap) =e= sum(ls, xlive(ls)*x2a(ap,ls))/(tpop*(10**6)*365);

    dietbal(cg)..         delta(cg) =e= sum(c $cmap(cg,c), nnpc(c)-impc(c)-dpotential_c(c)-dpotential_f(c))
$ifi %liebig%==1                       -sum(c, zyield(c))*dummy - sum((c,e), fert(c,e))*dummy
*   Add a “very small linear term” to the objective function to avoid the saddle point solutions (all zero).       
                          ;

    dietbal_r..           deltasumsq =e= sum(cg, sqr(
                                                     (delta(cg)/sum(c $cmap(cg,c), nnpc(c))) / k(cg)
                                                    )
                                            );

    adietbal(ag)..        adelta(ag) =e= sum(ap $amap(ag,ap), nnpc(ap)-impc(ap)-dpotential_l(ap)
                                            );

    adietbal_r..          adeltasumsq =e= sum(ag, sqr(
                                                     (adelta(ag)/sum(ap $amap(ag,ap), nnpc(ap))) / j(ag)
                                                     )
                                             );

    dif..                 target =e= weight*cdeficit + (1-weight)*(sum(cg,delta(cg))+sum(ag,adelta(ag)));
    rat..                 target =e= weight*cshortrate + (1-weight)*(deltasumsq +adeltasumsq);



$sTitle Model definition and solve
    Model crop_constraint   /
                              link,landbal,
                              areamax_y,areamax_u,areamax_p,areamax_o,areamax_l
$ifi %fbal%==1                eledemand,elesupply,elebal
$ifi %liebig%==1              elesupply,Liebig,Liebigbal
$ifi %lbal%==1                labdemand_c,labdemand_l,labbal
                            /;
    Model animal_constraint /
                              tdndemand,tdnsupply,tdnbal
                              cpdemand,cpsupply,cpbal
                              dmsupply,distbal
                              bredbal
                            /;
    Model balance           /
                              nutpet_c, nutpet_f, nutpet_l,
                              caloriebal,caloriebal_r
                              dietpet_c,dietpet_f,dietpet_l
                              dietbal,dietbal_r,
                              adietbal,adietbal_r
                            /;

* Standard solution
    Model sol_dif           / crop_constraint + animal_constraint + balance + dif /;
    Model sol_rat           / crop_constraint + animal_constraint + balance + rat /;

* Solution without expansion upper bound and CP balance
    Model sol_dif_unlimited / sol_dif - areamax_y - areamax_u - areamax_p - cpdemand - cpsupply - cpbal/;
    Model sol_rat_unlimited / sol_rat - areamax_y - areamax_u - areamax_p - cpdemand - cpsupply - cpbal/;

* First-year scenario
    Model sol_dif_jan       / sol_dif+jan /;
    Model sol_dif_feb       / sol_dif+feb /;
    Model sol_dif_mar       / sol_dif+mar /;
    Model sol_dif_apr       / sol_dif+apr /;
    Model sol_dif_may       / sol_dif+may /;
    Model sol_dif_jun       / sol_dif+jun /;
    Model sol_dif_jul       / sol_dif+jul /;
    Model sol_dif_aug       / sol_dif+aug /;
    Model sol_dif_sep       / sol_dif+sep /;
    Model sol_dif_oct       / sol_dif+oct /;
    Model sol_dif_nov       / sol_dif+nov /;
    Model sol_dif_dec       / sol_dif+dec /;
    
    Model sol_rat_jan       / sol_rat+jan /;
    Model sol_rat_feb       / sol_rat+feb /;
    Model sol_rat_mar       / sol_rat+mar /;
    Model sol_rat_apr       / sol_rat+apr /;
    Model sol_rat_may       / sol_rat+may /;
    Model sol_rat_jun       / sol_rat+jun /;
    Model sol_rat_jul       / sol_rat+jul /;
    Model sol_rat_aug       / sol_rat+aug /;
    Model sol_rat_sep       / sol_rat+sep /;
    Model sol_rat_oct       / sol_rat+oct /;
    Model sol_rat_nov       / sol_rat+nov /;
    Model sol_rat_dec       / sol_rat+dec /;



$sTitle Display Solutions
Set
    frep           Net food report /
    current_diet   'Current netfood intake      (grams/day-capita)'
    potential_diet 'Potential netfood intake    (grams/day-capita)'
    current_cal    'Current calorie intake      (kcal/day-capita)'
    potential_cal  'Potential calorie intake    (kcal/day-capita)'
    import         'Import                      (grams/day-capita)'
    change         'Change in diet              (grams/day-capita)'
    ros            'Self sufficiency            (%)'/
    nrep           Nutiritional report /
    required       'Required nutrients          (kcal grams/day-capita)'
    current        'Current intake              (kcal grams/day-capita)'
    potential      'Potential intake            (kcal grams/day-capita)'
    import         'Import                      (kcal grams/day-capita)'
    shortage       'Shortage                    (kcal grams/day-capita)'
    ros            'Self sufficiency            (%)'/
    erep           Feed nutrition report /
    tdp_dist       'Potential TDP distribution  (kg/year-head)'
    cp_dist        'Potential CP distribution   (kg/year-head)'/
    prep           Animal population report /
    current        'Current population          (head)'
    potential      'Potential population        (head)'
    change         'Change in population        (head)'
    roc            'Rate of change              (%)'
    carcass        'Carcass by early slaughter'/
    rep            Calorie balance on First-year scenario
    /mean,max,min/
    nonzero(ls)    non-zero constraint on zfeedrep
    /dairycow,dairyox,heifer,calves,layinghens/;

Parameter
*   Assign calculated values
    wxrlcrop(w,c,r,l)        'Cropping area by region and landtype(1000ha)'
    wxcrop(w,c)              'Cropping area (1000ha)'
    wxlive(w,ls)             'Livestock head (head)'
    wzyield(w,c)             'Effective yield by Liebigs law (MT/ha)'
    wfert(w,c,e)             'Fertilizer application per area (kg/ha)'
    wxnnpotential_c(w,c,nn)  'Potential nutrition intake from crops (kcal or grams/capita)'
    wxnnpotential_f(w,c,nn)  'Potential nutrition intake from processed foods (kcal or grams/capita)'
    wxnnpotential_l(w,ap,nn) 'Potential nutrition intake from animal products (kcal or grams/capita)'
    wxdpotential_c(w,c)      'Potential netfood intake from crops (grams/capita)'
    wxdpotential_f(w,c)      'Potential netfood intake from processed foods (grams/capita)'
    wxdpotential_l(w,ap)     'Potential netfood intake from animal products (grams/capita)'
    wcroprep                 'Crop report summary'
    wfoodrep                 'Processed food summary'
    wliverep                 'Animal product summary'
    wdietrep                 'Nutrient summary'
    wradar                   'Radar chart summary for crop group'
    waradar                  'Radar chart summary for animal product group'
    wlandrep                 'Land allocation summary (1000ha)'
    wlandrep_month  
    wlandrep_region 
    wlaborrep                'Labor allocation summary (bil. hour)'
    wfertrep                 'Fertilizer usage report summary (each element MT)'
    wyieldrep                'Effective yield by Liebigs law summary (MT/ha)'
    
    lxrlcrop(u,c,r,l)
    lxcrop(u,c)  
    lxlive(u,ls)
    lzyield(u,c)
    lfert(u,c,e) 
    lxnnpotential_c(u,c,nn)
    lxnnpotential_f(u,c,nn)
    lxnnpotential_l(u,ap,nn)
    lxdpotential_c(u,c)
    lxdpotential_f(u,c)
    lxdpotential_l(u,ap)
    lcroprep
    lfoodrep
    lliverep
    ldietrep
    lradar 
    laradar
    llandrep
    llandrep_month
    llandrep_region
    llaborrep
    lfertrep 
    lyieldrep 
    
    pxrlcrop(*,c,r,l)
    pxcrop(*,c)  
    pxlive(*,ls)
    pzyield(*,c)
    pfert(*,c,e) 
    pxnnpotential_c(*,c,nn)
    pxnnpotential_f(*,c,nn)
    pxnnpotential_l(*,ap,nn)
    pxdpotential_c(*,c)
    pxdpotential_f(*,c)
    pxdpotential_l(*,ap)
    pcroprep
    pfoodrep
    pliverep
    pdietrep
    pradar 
    paradar
    plandrep
    plandrep_month
    plandrep_region
    plaborrep
    pfertrep 
    pyieldrep 
          
    mxcrop(m,*)
    mcroprep
    mfoodrep
    mdietrep

*   Feed and livestock report
    zyfeed(z,*,*)            'Distribution of feed j to animal l'
    zfeedrep                 'Feed distribution report'
    zpoprep                  'Animal population report'
        
*   Grain stockpile release scenario
    stock                    'Grain stockpile reserved'
    xcbal                    'Calorie balance on First-year scenario  (kcal/day-capita)'
    period                   'Estimated maximum duration of stockpile release (days)';

* test run
* do not change
limit = 3;
weight = 0.75;
    solve sol_dif minimizing target using nlp ;

Display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l, 
$ifi %fbal%==1   eled.l, eles.l
$ifi %lbal%==1   labd_c.l, labd_ls.l
$ifi %liebig%==1 zyield.l, fert.l
        cdeficit.l, cshortrate.l, deltasumsq.l, adeltasumsq.l ;



$sTitle Scenario by weight (weight = 100, 75, 50, 25)
limit = 3;

if(%scn_weight%,
if(%rate%,
 loop(w,
    weight = wapply(w);
    solve sol_rat minimizing target using nlp ;
    display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l ;
    wxrlcrop(w,c,r,l) = xrlcrop.l(c,r,l);
    wxcrop(w,c) = xcrop.l(c);
    wxlive(w,ls)= xlive.l(ls);
$ifi %liebig%==1    wzyield(w,c) = zyield.l(c); wfert(w,c,e) = fert.l(c,e);
    wxnnpotential_c(w,c,nn) = nnpotential_c.l(c,nn);
    wxnnpotential_f(w,c,nn) = nnpotential_f.l(c,nn);
    wxnnpotential_l(w,ap,nn) = nnpotential_l.l(ap,nn);
    wxdpotential_c(w,c) = dpotential_c.l(c);
    wxdpotential_f(w,c) = dpotential_f.l(c);
    wxdpotential_l(w,ap) = dpotential_l.l(ap);
 );
else
 loop(w,
    weight = wapply(w);
    solve sol_dif minimizing target using nlp ;
    display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l ;
    wxrlcrop(w,c,r,l) = xrlcrop.l(c,r,l);
    wxcrop(w,c) = xcrop.l(c);
    wxlive(w,ls)= xlive.l(ls);
$ifi %liebig%==1    wzyield(w,c) = zyield.l(c);  wfert(w,c,e) = fert.l(c,e);
    wxnnpotential_c(w,c,nn) = nnpotential_c.l(c,nn);
    wxnnpotential_f(w,c,nn) = nnpotential_f.l(c,nn);
    wxnnpotential_l(w,ap,nn) = nnpotential_l.l(ap,nn);
    wxdpotential_c(w,c) = dpotential_c.l(c);
    wxdpotential_f(w,c) = dpotential_f.l(c);
    wxdpotential_l(w,ap) = dpotential_l.l(ap);
 );
);
);

    wcroprep(w,c,"current_diet")   = nnpc(c)$edible(c);
    wcroprep(w,c,"potential_diet") = wxdpotential_c(w,c)*npecoef(c) $edible(c);
    wcroprep(w,c,"current_cal")    = nnpcvalue(c,"calorie")$edible(c);
    wcroprep(w,c,"potential_cal")  = wxnnpotential_c(w,c,"calorie")*npecoef(c) $edible(c);
    wcroprep(w,c,"import")         = impc(c)$edible(c);
    wcroprep(w,c,"change")         = wcroprep(w,c,"potential_diet")+wcroprep(w,c,"import")-wcroprep(w,c,"current_diet");
    wcroprep(w,"total",frep)       = sum(c, wcroprep(w,c,frep));
                                                 
    wfoodrep(w,c,"current_diet")   = nnpc(c) $processed(c);
    wfoodrep(w,c,"potential_diet") = wxdpotential_f(w,c)*npecoef(c) $processed(c);
    wfoodrep(w,c,"current_cal")    = nnpcvalue(c,"calorie") $processed(c);
    wfoodrep(w,c,"potential_cal")  = wxnnpotential_f(w,c,"calorie")*npecoef(c) $processed(c);
    wfoodrep(w,c,"import")         = impc(c)$processed(c);
    wfoodrep(w,c,"change")         = wfoodrep(w,c,"potential_diet")+wfoodrep(w,c,"import")-wfoodrep(w,c,"current_diet");
    wfoodrep(w,"total",frep)       = sum(c, wfoodrep(w,c,frep));

    wliverep(w,ap,"current_diet")  = nnpc(ap);
    wliverep(w,ap,"current_cal")   = nnpcvalue(ap,"calorie");
    wliverep(w,ap,"potential_diet")= wxdpotential_l(w,ap);
    wliverep(w,ap,"potential_cal" )= wxnnpotential_l(w,ap,"calorie");
    wliverep(w,ap,"import")        = impc(ap);
    wliverep(w,ap,"change")        = wliverep(w,ap,"potential_diet")+wliverep(w,ap,"import")-wliverep(w,ap,"current_diet");
    wliverep(w,"total",frep)       = sum(ap, wliverep(w,ap,frep));

    wdietrep(w,nn,"required")      = nreq(nn);
    wdietrep(w,nn,"current")       = sum(g, nnpcvalue(g,nn));
    wdietrep(w,nn,"potential")     = sum(c, wxnnpotential_c(w,c,nn)+wxnnpotential_f(w,c,nn))
                                           + sum(ap, wxnnpotential_l(w,ap,nn))
                                           + sum(c,  data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))/(tpop*(10**6)*365);
    wdietrep(w,nn,"import")        = imnn(nn);                            
    wdietrep(w,nn,"shortage")      = wdietrep(w,nn,"potential")+wdietrep(w,nn,"import")-wdietrep(w,nn,"required");
    wdietrep(w,nn,"ros")           = 100*(wdietrep(w,nn,"potential")+wdietrep(w,nn,"import"))/wdietrep(w,nn,"required");

    wradar(w,cg,"current")         = sum(c $cmap(cg,c), nnpc(c));
    wradar(w,cg,"potential")       = sum(c $cmap(cg,c), wcroprep(w,c,"potential_diet")+wfoodrep(w,c,"potential_diet"));
    wradar(w,cg,"import")          = sum(c $cmap(cg,c), impc(c));
    wradar(w,cg,"change")          = wradar(w,cg,"potential") + wradar(w,cg,"import") - wradar(w,cg,"current");
    wradar(w,cg,"ros")             = 100*(wradar(w,cg,"potential")+wradar(w,cg,"import"))/wradar(w,cg,"current");
    waradar(w,ag,"current")        = sum(ap $amap(ag,ap), nnpc(ap));
    waradar(w,ag,"potential")      = sum(ap $amap(ag,ap), wliverep(w,ap,"potential_diet"));
    waradar(w,ag,"import")         = sum(ap $amap(ag,ap), impc(ap));
    waradar(w,ag,"change")         = waradar(w,ag,"potential") + waradar(w,ag,"import") - waradar(w,ag,"current");
    waradar(w,ag,"ros")            = 100*(waradar(w,ag,"potential")+waradar(w,ag,"import")) / waradar(w,ag,"current");
    
    wlandrep_region("current","total",c) = data(c,"area");
    wlandrep_region(w,r,c)         = sum(l, wxrlcrop(w,c,r,l));
    wlandrep_region(w,"total",c)   = sum(r, wlandrep_region(w,r,c));
    wlandrep_region(w,r,"total")   = sum(c, wlandrep_region(w,r,c));
    wlandrep_month(w,t,l,c)        = sum(r, wxrlcrop(w,c,r,l)*landreq_CRT(c,r,t));
    wlandrep_month(w,t,l,"total")  = sum(c, wlandrep_month(w,t,l,c));

    wlaborrep(w,c)                 = wxcrop(w,c)   *ldemand_c(c) /(10**9);
    wlaborrep("current",c)         = data(c,"area")*ldemand_c(c) /(10**9);
    wlaborrep(w,ls)                = wxlive(w,ls)  *ldemand_l(ls)/(10**9);
    wlaborrep("current",ls)        = head(ls)      *ldemand_l(ls)/(10**9);
    wlaborrep(w,"total")           = sum(c,wlaborrep(w,c)) + sum(ls,wlaborrep(w,ls));
    wlaborrep("current","total")   = sum(c,wlaborrep("current",c)) + sum(ls,wlaborrep("current",ls));

    wfertrep("current",e,c)        = data(c,"area")*edemand(c,e);
    wfertrep("current",e,"total")  = sum(c,wfertrep("current",e,c));    
    wfertrep(w,e,c)                = wxcrop(w,c)*edemand(c,e)
$ifi %liebig%==1                                *wfert(w,c,e) /edemand(c,e)              
    ;
    wfertrep(w,e,"total")          = sum(c,wfertrep(w,e,c));

$iftheni %liebig%==1
    wyieldrep(w,c,"current")       = data(c,"yield");
    wyieldrep(w,c,"potential")     = wzyield(w,c);
    wyieldrep(w,c,"change"  )      = wyieldrep(w,c,"current")-wyieldrep(w,c,"potential");
$endif

 

$sTitle Scenario by expansion margin (limit = 2, 3, 4, 5)
weight = 0.75;

if(%scn_areaMax%,
if(%rate%,
 loop(u,
    limit = uapply(u);
    solve sol_rat minimizing target using nlp ;
    display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l ;
    lxrlcrop(u,c,r,l) = xrlcrop.l(c,r,l);
    lxcrop(u,c) = xcrop.l(c);
    lxlive(u,ls)= xlive.l(ls);
$ifi %liebig%==1    lzyield(u,c) = zyield.l(c); lfert(u,c,e) = fert.l(c,e);
    lxnnpotential_c(u,c,nn) = nnpotential_c.l(c,nn);
    lxnnpotential_f(u,c,nn) = nnpotential_f.l(c,nn);
    lxnnpotential_l(u,ap,nn) = nnpotential_l.l(ap,nn);
    lxdpotential_c(u,c) = dpotential_c.l(c);
    lxdpotential_f(u,c) = dpotential_f.l(c);
    lxdpotential_l(u,ap) = dpotential_l.l(ap);
  );
else
 loop(u,
    limit = uapply(u);
    solve sol_dif minimizing target using nlp ;
    display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l ;
    lxrlcrop(u,c,r,l) = xrlcrop.l(c,r,l);
    lxcrop(u,c) = xcrop.l(c);
    lxlive(u,ls)= xlive.l(ls);
$ifi %liebig%==1    lzyield(u,c) = zyield.l(c); lfert(u,c,e) = fert.l(c,e);
    lxnnpotential_c(u,c,nn) = nnpotential_c.l(c,nn);
    lxnnpotential_f(u,c,nn) = nnpotential_f.l(c,nn);
    lxnnpotential_l(u,ap,nn) = nnpotential_l.l(ap,nn);
    lxdpotential_c(u,c) = dpotential_c.l(c);
    lxdpotential_f(u,c) = dpotential_f.l(c);
    lxdpotential_l(u,ap) = dpotential_l.l(ap);
  );
);
);

    lcroprep(u,c,"current_diet")   = nnpc(c)$edible(c);
    lcroprep(u,c,"potential_diet") = lxdpotential_c(u,c)*npecoef(c) $edible(c);
    lcroprep(u,c,"current_cal")    = nnpcvalue(c,"calorie")$edible(c);
    lcroprep(u,c,"potential_cal")  = lxnnpotential_c(u,c,"calorie")*npecoef(c) $edible(c);
    lcroprep(u,c,"import")         = impc(c)$edible(c);
    lcroprep(u,c,"change")         = lcroprep(u,c,"potential_diet")+lcroprep(u,c,"import")-lcroprep(u,c,"current_diet");
    lcroprep(u,"total",frep)       = sum(c, lcroprep(u,c,frep));
                                                 
    lfoodrep(u,c,"current_diet")   = nnpc(c) $processed(c);
    lfoodrep(u,c,"potential_diet") = lxdpotential_f(u,c)*npecoef(c) $processed(c);
    lfoodrep(u,c,"current_cal")    = nnpcvalue(c,"calorie") $processed(c);
    lfoodrep(u,c,"potential_cal")  = lxnnpotential_f(u,c,"calorie")*npecoef(c) $processed(c);
    lfoodrep(u,c,"import")         = impc(c)$processed(c);
    lfoodrep(u,c,"change")         = lfoodrep(u,c,"potential_diet")+lfoodrep(u,c,"import")-lfoodrep(u,c,"current_diet");
    lfoodrep(u,"total",frep)       = sum(c, lfoodrep(u,c,frep));

    lliverep(u,ap,"current_diet")  = nnpc(ap);
    lliverep(u,ap,"current_cal")   = nnpcvalue(ap,"calorie");
    lliverep(u,ap,"potential_diet")= lxdpotential_l(u,ap);
    lliverep(u,ap,"potential_cal" )= lxnnpotential_l(u,ap,"calorie");
    lliverep(u,ap,"import")        = impc(ap);
    lliverep(u,ap,"change")        = lliverep(u,ap,"potential_diet")+lliverep(u,ap,"import")-lliverep(u,ap,"current_diet");
    lliverep(u,"total",frep)       = sum(ap, lliverep(u,ap,frep));

    ldietrep(u,nn,"required")      = nreq(nn);
    ldietrep(u,nn,"current")       = sum(g, nnpcvalue(g,nn));
    ldietrep(u,nn,"potential")     = sum(c, lxnnpotential_c(u,c,nn)+lxnnpotential_f(u,c,nn))
                                           + sum(ap, lxnnpotential_l(u,ap,nn))
                                           + sum(c,  data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))/(tpop*(10**6)*365);
    ldietrep(u,nn,"import")        = imnn(nn);                            
    ldietrep(u,nn,"shortage")      = ldietrep(u,nn,"potential")+ldietrep(u,nn,"import")-ldietrep(u,nn,"required");
    ldietrep(u,nn,"ros")           = 100*(ldietrep(u,nn,"potential")+ldietrep(u,nn,"import"))/ldietrep(u,nn,"required");

    lradar(u,cg,"current")         = sum(c $cmap(cg,c), nnpc(c));
    lradar(u,cg,"potential")       = sum(c $cmap(cg,c), lcroprep(u,c,"potential_diet")+lfoodrep(u,c,"potential_diet"));
    lradar(u,cg,"import")          = sum(c $cmap(cg,c), impc(c));
    lradar(u,cg,"change")          = lradar(u,cg,"potential") + lradar(u,cg,"import") - lradar(u,cg,"current");
    lradar(u,cg,"ros")             = 100*(lradar(u,cg,"potential")+lradar(u,cg,"import"))/lradar(u,cg,"current");
    laradar(u,ag,"current")        = sum(ap $amap(ag,ap), nnpc(ap));
    laradar(u,ag,"potential")      = sum(ap $amap(ag,ap), lliverep(u,ap,"potential_diet"));
    laradar(u,ag,"import")         = sum(ap $amap(ag,ap), impc(ap));
    laradar(u,ag,"change")         = laradar(u,ag,"potential") + laradar(u,ag,"import") - laradar(u,ag,"current");
    laradar(u,ag,"ros")            = 100*(laradar(u,ag,"potential")+laradar(u,ag,"import")) / laradar(u,ag,"current");

    llandrep_region("current","total",c) = data(c,"area");
    llandrep_region(u,r,c)         = sum(l, lxrlcrop(u,c,r,l));
    llandrep_region(u,"total",c)   = sum(r, llandrep_region(u,r,c));
    llandrep_region(u,r,"total")   = sum(c, llandrep_region(u,r,c));
    llandrep_month(u,t,l,c)        = sum(r, lxrlcrop(u,c,r,l)*landreq_CRT(c,r,t));
    llandrep_month(u,t,l,"total")  = sum(c, llandrep_month(u,t,l,c));

    llaborrep(u,c)                 = lxcrop(u,c)   *ldemand_c(c) /(10**9);
    llaborrep("current",c)         = data(c,"area")*ldemand_c(c) /(10**9);
    llaborrep(u,ls)                = lxlive(u,ls)  *ldemand_l(ls)/(10**9);
    llaborrep("current",ls)        = head(ls)      *ldemand_l(ls)/(10**9);
    llaborrep(u,"total")           = sum(c,llaborrep(u,c)) + sum(ls,llaborrep(u,ls));
    llaborrep("current","total")   = sum(c,llaborrep("current",c)) + sum(ls,llaborrep("current",ls));
    
    lfertrep("current",e,c)        = data(c,"area")*edemand(c,e);
    lfertrep("current",e,"total")  = sum(c,lfertrep("current",e,c));    
    lfertrep(u,e,c)                = lxcrop(u,c)*edemand(c,e)
$ifi %liebig%==1                                *lfert(u,c,e) /edemand(c,e)              
    ;
    lfertrep(u,e,"total")          = sum(c,lfertrep(u,e,c));

$iftheni %liebig%==1
    lyieldrep(u,c,"current")       = data(c,"yield");
    lyieldrep(u,c,"potential")     = lzyield(u,c);
    lyieldrep(u,c,"change"  )      = lyieldrep(u,c,"current")-lyieldrep(u,c,"potential");
$endif



$sTitle First-year scenario 
limit = 3;
weight = 0.75;

if(%scn_firstYr%,
if(%rate%,
   solve sol_rat_jan minimizing target using nlp ;
   mxcrop("jan",c) = xcrop.l(c);
   solve sol_rat_feb minimizing target using nlp ;
   mxcrop("feb",c) = xcrop.l(c);
   solve sol_rat_mar minimizing target using nlp ;
   mxcrop("mar",c) = xcrop.l(c);
   solve sol_rat_apr minimizing target using nlp ;
   mxcrop("apr",c) = xcrop.l(c);
   solve sol_rat_may minimizing target using nlp ;
   mxcrop("may",c) = xcrop.l(c);
   solve sol_rat_jun minimizing target using nlp ;
   mxcrop("jun",c) = xcrop.l(c);
   solve sol_rat_jul minimizing target using nlp ;
   mxcrop("jul",c) = xcrop.l(c);
   solve sol_rat_aug minimizing target using nlp ;
   mxcrop("aug",c) = xcrop.l(c);
   solve sol_rat_sep minimizing target using nlp ;
   mxcrop("sep",c) = xcrop.l(c);
   solve sol_rat_oct minimizing target using nlp ;
   mxcrop("oct",c) = xcrop.l(c);
   solve sol_rat_nov minimizing target using nlp ;
   mxcrop("nov",c) = xcrop.l(c);
   solve sol_rat_dec minimizing target using nlp ;
   mxcrop("dec",c) = xcrop.l(c);
else
   solve sol_dif_jan minimizing target using nlp ;
   mxcrop("jan",c) = xcrop.l(c);
   solve sol_dif_feb minimizing target using nlp ;
   mxcrop("feb",c) = xcrop.l(c);
   solve sol_dif_mar minimizing target using nlp ;
   mxcrop("mar",c) = xcrop.l(c);
   solve sol_dif_apr minimizing target using nlp ;
   mxcrop("apr",c) = xcrop.l(c);
   solve sol_dif_may minimizing target using nlp ;
   mxcrop("may",c) = xcrop.l(c);
   solve sol_dif_jun minimizing target using nlp ;
   mxcrop("jun",c) = xcrop.l(c);
   solve sol_dif_jul minimizing target using nlp ;
   mxcrop("jul",c) = xcrop.l(c);
   solve sol_dif_aug minimizing target using nlp ;
   mxcrop("aug",c) = xcrop.l(c);
   solve sol_dif_sep minimizing target using nlp ;
   mxcrop("sep",c) = xcrop.l(c);
   solve sol_dif_oct minimizing target using nlp ;
   mxcrop("oct",c) = xcrop.l(c);
   solve sol_dif_nov minimizing target using nlp ;
   mxcrop("nov",c) = xcrop.l(c);
   solve sol_dif_dec minimizing target using nlp ;
   mxcrop("dec",c) = xcrop.l(c);
);
);

    mcroprep(m,c,"supply")    = mxcrop(m,c)*data(c,"yield") $edible(c);
    mcroprep(m,c,"grossfood") = mxcrop(m,c)*data(c,"yield")*t2g(c) $edible(c);
    mcroprep(m,c,"netfood")   = mxcrop(m,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
    mcroprep(m,c,"current")   = nnpc(c)$edible(c);
    mcroprep(m,c,"potential") = mcroprep(m,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    mcroprep(m,c,"change")    = mcroprep(m,c,"potential")-mcroprep(m,c,"current");
    mcroprep(m,"total",frep)  = sum(c, mcroprep(m,c,frep));

    mfoodrep(m,c,"netfood")   = sum(i, mxcrop(m,i)*data(i,"yield")*t2p(i)*pcoef(c,i) $processed(c));
    mfoodrep(m,c,"current")   = nnpc(c)$processed(c);
    mfoodrep(m,c,"potential") = mfoodrep(m,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    mfoodrep(m,c,"change")    = mfoodrep(m,c,"potential")-mfoodrep(m,c,"current");
    mfoodrep(m,"total",frep)  = sum(c, mfoodrep(m,c,frep));

    mdietrep(m,nn,"required") = nreq(nn);
    mdietrep(m,nn,"potential")= sum(c,mcroprep(m,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                              + sum(c,mfoodrep(m,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                              + sum(c,data(c,"net")*nnvalue(c,nn)*(10**9)$marine(c)) /(tpop*(10**6)*365);
    mdietrep(m,nn,"shortage") = mdietrep(m,nn,"potential") - mdietrep(m,nn,"required");
    mdietrep(m,nn,"ros")      = 100*mdietrep(m,nn,"potential") / mdietrep(m,nn,"required");



$sTitle Scenario by cropping pattern (rice_wheat, potato)
weight = 1;

$onText
Changes in parameter landreq
*Common
  1. Remove psoy from the planting schedule, only soy remains valid
  2. Remove rapeseed, barley, and naked from the planting schedule
  3. Modify the planting periods for potatoe to match sweet potatoe
*Rice and wheat-centered cropping
  4. Remove potatoes and sweet potatoes from the cropping schedule
*Potato-centered cropping
  5. Remove wheat from the cropping schedule, only pwheat remains valid
  6. Remove soy from the cropping schedule 
  7. Add potatoe and sweet potatoe to the list of crops for paddy field
*Convert pasture to farmland (treat pasture the same as upland field)
*Removed protein requirement variable (cpd(Is)) for livestock feed from the formula
*Assumed rice bran production enables rice oil production from the feed degreasing process
*Assumed fish is harvested up to the TAC limit: let data("fish","prod") = 4650 (1000MT)
*Additional
  a. Alternative x2n and x2nn with converter that include "processing" into netfood
     for "rice","wheat","pwheat","sweetp","psweetp","potato","ppotato")
  b. Post-calculation: vegetable cropping area using residual land area and residual labor
     save labor demand for vegetables by 50% 
$offText

*Convert pasture to field_rain except Hokkaido
    land_endw(r,"field_rain") $(not sameas(r,'Hokkaido')) = land_endw(r,"field_rain") + land_endw(r,"pasture");
    land_endw(r,"pasture") $(not sameas(r,'Hokkaido')) = 0;
*Convert fish production to TAC limit 4650(1000MT) to adjust net food value
    data("fish","net") = data("fish","net")*4650/data("fish","prod");
*Alternate x2n and x2nn to include "processing" into netfood for staple food group
    x2n(c) $staple(c) = data(c,"yield")*(data(c,"gross")+data(c,"processing"))/data(c,"total")*g2n(c)*(10**9);
    x2nn(c,nn) $staple(c) = x2n(c)*nnvalue(c,nn);
*Save labor demand for vegetables by 50%
    ldemand_c("mis_veges") = 0.5*ldemand_c("mis_veges");
    
parameter
    allow(pattern,c)   'Allowance of cropping in each pattern';
    allow(pattern,c) = 1;
*Common
    allow(pattern,"psoy") = 0;
    allow(pattern,"barley") = 0;
    allow(pattern,"pbarley") = 0;
    allow(pattern,"naked") = 0;
    allow(pattern,"rapeseed") = 0;
    allow(pattern,"corn") = 0;
    allow(pattern,"sorghum") = 0;
*Rice and wheat-centered cropping
    allow("rice_wheat","sweetp") = 0;
    allow("rice_wheat","potato") = 0;
    allow("rice_wheat","psweetp") = 0;
    allow("rice_wheat","ppotato") = 0;
*Potato-centered cropping
    allow("potato","wheat") = 0;
    allow("potato","soy") = 0;

display x2n, x2nn, allow;

if(%rate%,
 loop(pattern,
* Clear variables
    xrlcrop.lo(c,r,l) = 0; xrlcrop.up(c,r,l) = +inf;
* Control croppable plants
    xrlcrop.up(c,r,l)$(not allow(pattern,c)) = 0;
* Solution without expansion upper bound and CP balance
    solve sol_rat_unlimited minimizing target using nlp ;
    display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l;
    pxrlcrop(pattern,c,r,l) = xrlcrop.l(c,r,l);
    pxcrop(pattern,c) = xcrop.l(c);
    pxlive(pattern,ls)= xlive.l(ls);
$ifi %liebig%==1    pzyield(pattern,c) = zyield.l(c); pfert(pattern,c,e) = fert.l(c,e);
    pxnnpotential_c(pattern,c,nn) = nnpotential_c.l(c,nn);
    pxnnpotential_f(pattern,c,nn) = nnpotential_f.l(c,nn);
    pxnnpotential_l(pattern,ap,nn) = nnpotential_l.l(ap,nn);
    pxdpotential_c(pattern,c) = dpotential_c.l(c);
    pxdpotential_f(pattern,c) = dpotential_f.l(c);
    pxdpotential_l(pattern,ap) = dpotential_l.l(ap);
 );
else
 loop(pattern,
* Clear variables
    xrlcrop.lo(c,r,l) = 0; xrlcrop.up(c,r,l) = +inf;
* Control croppable plants
    xrlcrop.up(c,r,l)$(not allow(pattern,c)) = 0;
* Solution without expansion upper bound and CP balance 
    solve sol_dif_unlimited minimizing target using nlp ;
    display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l;
    pxrlcrop(pattern,c,r,l) = xrlcrop.l(c,r,l);
    pxcrop(pattern,c) = xcrop.l(c);
    pxlive(pattern,ls)= xlive.l(ls);
$ifi %liebig%==1    pzyield(pattern,c) = zyield.l(c); pfert(pattern,c,e) = fert.l(c,e);
    pxnnpotential_c(pattern,c,nn) = nnpotential_c.l(c,nn);
    pxnnpotential_f(pattern,c,nn) = nnpotential_f.l(c,nn);
    pxnnpotential_l(pattern,ap,nn) = nnpotential_l.l(ap,nn);
    pxdpotential_c(pattern,c) = dpotential_c.l(c);
    pxdpotential_f(pattern,c) = dpotential_f.l(c);
    pxdpotential_l(pattern,ap) = dpotential_l.l(ap);
 );
);

*Post-calculation of vegetable cropping area
parameters
    resLand(pattern,r,l,t)      'Residual land by month (1000ha)'
    resLabor(pattern)           'Residual labor (bil. hour)'
    xveg_resLand(pattern,t)     'Maximum cropping area with residual land  (1000ha)'
    xveg_resLabor(pattern)      'Maximum cropping area with residual labor (1000ha)'
    xveg(pattern,t)             'Post-calculation cropping area (1000ha)'
    totalxveg(pattern)          'Annual cropping area (1000ha)'
    dietxveg(pattern)           'Netfood supply (grams/day-capita)'
    nutxveg(pattern,nn)         'Nutrition supply (grams or kcal/day-capita)';
    
scalar
    laborVeg                    'Labor demand of vegetable per month (bil. hour /1000ha)';
    laborVeg = ldemand_c("mis_veges")/(10**9);
    
*Residual land (croppable in "paddy_dry" or "field_irr") and labor per month
    resLand(pattern,r,l,t) $(sameas(l,'paddy_dry') or sameas(l,'field_irr')) = land_endw(r,l) - sum(c, pxrlcrop(pattern,c,r,l)*landreq_CRT(c,r,t));
    resLabor(pattern)      = labor   - sum(c, pxcrop(pattern,c) * ldemand_c(c))/(10**9)
                                     - sum(ls, pxlive(pattern,ls)* ldemand_l(ls))/(10**9);

* Non-negativity check
    resLand(pattern,r,l,t) = max(0, resLand(pattern,r,l,t));
    resLabor(pattern)      = max(0, resLabor(pattern));

* Maximum cropping area with either residual input
    xveg_resLand(pattern,t) = sum((r,l),resLand(pattern,r,l,t));
    xveg_resLabor(pattern)  = resLabor(pattern)/laborVeg;

* Joint constraint on cropping area of "mis_veges"
    xveg(pattern,t)      = min( xveg_resLand(pattern,t), xveg_resLabor(pattern) );
* Assign maximum area over t
    totalxveg(pattern)   = smax(t, xveg(pattern,t));
    dietxveg(pattern)    = totalxveg(pattern)*x2n("mis_veges")    /(tpop*(10**6)*365);
    nutxveg(pattern,nn)  = totalxveg(pattern)*x2nn("mis_veges",nn)/(tpop*(10**6)*365);

display resLand, resLabor, xveg_resLand, xveg_resLabor, xveg, totalxveg;

*Assign "mis_veges" values by post-calculation
    pxcrop(pattern,"mis_veges") = totalxveg(pattern);
    pxdpotential_c(pattern,"mis_veges") = dietxveg(pattern);
    pxnnpotential_c(pattern,"mis_veges",nn) = nutxveg(pattern,nn);
                                           
    pcroprep(pattern,c,"current_diet")   = nnpc(c)$edible(c);
    pcroprep(pattern,c,"potential_diet") = pxdpotential_c(pattern,c)*npecoef(c) $edible(c);
    pcroprep(pattern,c,"current_cal")    = nnpcvalue(c,"calorie")$edible(c);
    pcroprep(pattern,c,"potential_cal")  = pxnnpotential_c(pattern,c,"calorie")*npecoef(c) $edible(c);
    pcroprep(pattern,c,"import")         = impc(c)$edible(c);
    pcroprep(pattern,c,"change")         = pcroprep(pattern,c,"potential_diet")+pcroprep(pattern,c,"import")-pcroprep(pattern,c,"current_diet");
    pcroprep(pattern,"total",frep)       = sum(c, pcroprep(pattern,c,frep));
                                                 
    pfoodrep(pattern,c,"current_diet")   = nnpc(c) $processed(c);
    pfoodrep(pattern,c,"potential_diet") = pxdpotential_f(pattern,c)*npecoef(c) $processed(c);
    pfoodrep(pattern,c,"current_cal")    = nnpcvalue(c,"calorie") $processed(c);
    pfoodrep(pattern,c,"potential_cal")  = pxnnpotential_f(pattern,c,"calorie")*npecoef(c) $processed(c);
    pfoodrep(pattern,c,"import")         = impc(c)$processed(c);
    pfoodrep(pattern,c,"change")         = pfoodrep(pattern,c,"potential_diet")+pfoodrep(pattern,c,"import")-pfoodrep(pattern,c,"current_diet");
    pfoodrep(pattern,"total",frep)       = sum(c, pfoodrep(pattern,c,frep));

    pliverep(pattern,ap,"current_diet")  = nnpc(ap);
    pliverep(pattern,ap,"current_cal")   = nnpcvalue(ap,"calorie");
    pliverep(pattern,ap,"potential_diet")= pxdpotential_l(pattern,ap);
    pliverep(pattern,ap,"potential_cal" )= pxnnpotential_l(pattern,ap,"calorie");
    pliverep(pattern,ap,"import")        = impc(ap);
    pliverep(pattern,ap,"change")        = pliverep(pattern,ap,"potential_diet")+pliverep(pattern,ap,"import")-pliverep(pattern,ap,"current_diet");
    pliverep(pattern,"total",frep)       = sum(ap, pliverep(pattern,ap,frep));

    pdietrep(pattern,nn,"required")      = nreq(nn);
    pdietrep(pattern,nn,"current")       = sum(g, nnpcvalue(g,nn));
    pdietrep(pattern,nn,"potential")     = sum(c, pxnnpotential_c(pattern,c,nn)+pxnnpotential_f(pattern,c,nn))
                                           + sum(ap, pxnnpotential_l(pattern,ap,nn))
                                           + sum(c,  data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))/(tpop*(10**6)*365);
    pdietrep(pattern,nn,"import")        = imnn(nn);                            
    pdietrep(pattern,nn,"shortage")      = pdietrep(pattern,nn,"potential")+pdietrep(pattern,nn,"import")-pdietrep(pattern,nn,"required");
    pdietrep(pattern,nn,"ros")           = 100*(pdietrep(pattern,nn,"potential")+pdietrep(pattern,nn,"import"))/pdietrep(pattern,nn,"required");

    pradar(pattern,cg,"current")         = sum(c $cmap(cg,c), nnpc(c));
    pradar(pattern,cg,"potential")       = sum(c $cmap(cg,c), pcroprep(pattern,c,"potential_diet")+pfoodrep(pattern,c,"potential_diet"));
    pradar(pattern,cg,"import")          = sum(c $cmap(cg,c), impc(c));
    pradar(pattern,cg,"change")          = pradar(pattern,cg,"potential") + pradar(pattern,cg,"import") - pradar(pattern,cg,"current");
    pradar(pattern,cg,"ros")             = 100*(pradar(pattern,cg,"potential")+pradar(pattern,cg,"import"))/pradar(pattern,cg,"current");
    paradar(pattern,ag,"current")        = sum(ap $amap(ag,ap), nnpc(ap));
    paradar(pattern,ag,"potential")      = sum(ap $amap(ag,ap), pliverep(pattern,ap,"potential_diet"));
    paradar(pattern,ag,"import")         = sum(ap $amap(ag,ap), impc(ap));
    paradar(pattern,ag,"change")         = paradar(pattern,ag,"potential") + paradar(pattern,ag,"import") - paradar(pattern,ag,"current");
    paradar(pattern,ag,"ros")            = 100*(paradar(pattern,ag,"potential")+paradar(pattern,ag,"import")) / paradar(pattern,ag,"current");
    
    plandrep_region("current","total",c) = data(c,"area");
    plandrep_region(pattern,r,c)         = sum(l, pxrlcrop(pattern,c,r,l));
    plandrep_region(pattern,"total",c)   = sum(r, plandrep_region(pattern,r,c));
    plandrep_region(pattern,r,"total")   = sum(c, plandrep_region(pattern,r,c));
    plandrep_month(pattern,t,l,c)        = sum(r, pxrlcrop(pattern,c,r,l)*landreq_CRT(c,r,t));
    plandrep_month(pattern,t,l,"total")  = sum(c, plandrep_month(pattern,t,l,c));
*Assign "mis_veges" values by post-calculation
    plandrep_region(pattern,"total","mis_veges") = totalxveg(pattern);
    plandrep_month(pattern,t,"total","mis_veges") = xveg(pattern,t);

    plaborrep(pattern,c)                 = pxcrop(pattern,c) *ldemand_c(c) /(10**9);
    plaborrep("current",c)               = data(c,"area")    *ldemand_c(c) /(10**9);
    plaborrep(pattern,ls)                = pxlive(pattern,ls)*ldemand_l(ls)/(10**9);
    plaborrep("current",ls)              = head(ls)          *ldemand_l(ls)/(10**9);
    plaborrep(pattern,"total")           = sum(c,plaborrep(pattern,c)) + sum(ls,plaborrep(pattern,ls));
    plaborrep("current","total")         = sum(c,plaborrep("current",c)) + sum(ls,plaborrep("current",ls));

    pfertrep("current",e,c)              = data(c,"area")*edemand(c,e);
    pfertrep("current",e,"total")        = sum(c,pfertrep("current",e,c));    
    pfertrep(pattern,e,c)                = pxcrop(pattern,c)*edemand(c,e)
$ifi %liebig%==1                                            *pfert(pattern,c,e) /edemand(c,e)              
    ;
    pfertrep(pattern,e,"total")          = sum(c,pfertrep(pattern,e,c));

$iftheni %liebig%==1
    pyieldrep(pattern,c,"current")       = data(c,"yield");
    pyieldrep(pattern,c,"potential")     = pzyield(pattern,c);
    pyieldrep(pattern,c,"change"  )      = pyieldrep(pattern,c,"current")-pyieldrep(pattern,c,"potential");
$endif



$sTitle Grain stockpile release scenario
    stock("grossfood",c)      = sp(c); 
    stock("netfood",c)        = sp(c)*g2n(c);
    stock("netfood","total")  = sum(c,stock("netfood",c));
    stock("netfoodpc",c)      = stock("netfood",c)*(10**9)/(tpop*(10**6)*365);
    stock("netfoodpc","total")= sum(c,stock("netfoodpc",c));
    stock("calorie",c)        = stock("netfood",c)*nnvalue(c,"calorie")*(10**9)/(tpop*(10**6)*365);
    stock("calorie","total")  = sum(c,stock("calorie",c));

    xcbal("mean")             = (-1)*sum(m,mdietrep(m,"calorie","shortage"))/12;
    xcbal("max")              = (-1)*smax(m,mdietrep(m,"calorie","shortage"));
    xcbal("min")              = (-1)*smin(m,mdietrep(m,"calorie","shortage"));

    period("100%",rep)        = 365*stock("calorie","total")/xcbal(rep);
    period("90%",rep)         = 365*stock("calorie","total")/(xcbal(rep)-2158*0.1);
    period("80%",rep)         = 365*stock("calorie","total")/(xcbal(rep)-2158*0.2);



$sTitle Feed stockpile release scenario
*TBD



$sTitle Export Results
Execute_Unload '%gdx_results%',
    wcroprep, wfoodrep, wliverep, wdietrep, wradar, waradar, wlandrep_region, wlandrep_month, wlaborrep, wfertrep,
    lcroprep, lfoodrep, lliverep, ldietrep, lradar, laradar, llandrep_region, llandrep_month, llaborrep, lfertrep,
    pcroprep, pfoodrep, pliverep, pdietrep, pradar, paradar, plandrep_region, plandrep_month, plaborrep, pfertrep,
    mcroprep, mfoodrep, mdietrep,
$ifi %liebig%==1 wyieldrep, lyieldrep, pyieldrep,
    stock, period;

if(%gdx2xl%,
$iftheni %scn_weight%==1
execute 'gdxxrw %gdx_results% o=%excel_results% par=wcroprep rng=wcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wfoodrep rng=wfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wliverep rng=wliverep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wdietrep rng=wdietrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=wradar   rng=wradar!A1   rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=waradar  rng=wradar!A35  rdim=2 cdim=1'
$iftheni %landrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=wlandrep_region rng=wlandrep!A1 rdim=2 cdim=1'
    execute 'gdxxrw %gdx_results% o=%excel_results% par=wlandrep_month  rng=wlandrep!A15 rdim=2 cdim=2'
$endif
$iftheni %laborrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=wlaborrep rng=wlaborrep!A1 rdim=1 cdim=1'
$endif
$iftheni %fertrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=wfertrep rng=wfertrep!A1 rdim=1 cdim=2'
$iftheni %liebig%==1
        execute 'gdxxrw %gdx_results% o=%excel_results% par=wyieldrep rng=wyieldrep!A1 rdim=2 cdim=1'
$endif
$endif
$endif

$iftheni %scn_areaMax%==1
execute 'gdxxrw %gdx_results% o=%excel_results% par=lcroprep rng=lcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=lfoodrep rng=lfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=lliverep rng=lliverep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=ldietrep rng=ldietrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=lradar   rng=lradar!A1   rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=laradar  rng=lradar!A45  rdim=2 cdim=1'
$iftheni %landrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=llandrep_region rng=llandrep!A1 rdim=2 cdim=1'
    execute 'gdxxrw %gdx_results% o=%excel_results% par=llandrep_month  rng=llandrep!A15 rdim=2 cdim=2'
$endif
$iftheni %laborrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=llaborrep rng=llaborrep!A1 rdim=1 cdim=1'
$endif
$iftheni %fertrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=lfertrep rng=lfertrep!A1 rdim=1 cdim=2'
$iftheni %liebig%==1
        execute 'gdxxrw %gdx_results% o=%excel_results% par=lyieldrep rng=lyieldrep!A1 rdim=2 cdim=1'
$endif
$endif
$endif

$iftheni %scn_pattern%==1
execute 'gdxxrw %gdx_results% o=%excel_results% par=pcroprep rng=pcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pfoodrep rng=pfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pliverep rng=pliverep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pdietrep rng=pdietrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=pradar   rng=pradar!A1   rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=paradar  rng=pradar!A19  rdim=2 cdim=1'
$iftheni %landrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=plandrep_region rng=plandrep!A1 rdim=2 cdim=1'
    execute 'gdxxrw %gdx_results% o=%excel_results% par=plandrep_month  rng=plandrep!A15 rdim=2 cdim=2'
$endif
$iftheni %laborrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=plaborrep rng=plaborrep!A1 rdim=1 cdim=1'
$endif
$iftheni %fertrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=pfertrep rng=pfertrep!A1 rdim=1 cdim=2'
$iftheni %liebig%==1
        execute 'gdxxrw %gdx_results% o=%excel_results% par=pyieldrep rng=pyieldrep!A1 rdim=2 cdim=1'
$endif
$endif
$endif

$iftheni %scn_firstYr%==1
execute 'gdxxrw %gdx_results% o=%excel_results% par=mcroprep rng=mcroprep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=mfoodrep rng=mfoodrep!A1 rdim=2 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=mdietrep rng=mdietrep!A1 rdim=2 cdim=1'
$endif

$iftheni %scn_stockRe%==1
execute 'gdxxrw %gdx_results% o=%excel_results% par=stock    rng=stock!A1 rdim=1 cdim=1'
execute 'gdxxrw %gdx_results% o=%excel_results% par=period   rng=period!A1 rdim=1 cdim=1'
$endif
);