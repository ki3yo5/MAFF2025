$title  Food Supply Simulation in Japan applying the SWISSfoodSys Model

$onText
Build 2.7b Feb 4 2026
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
$if not setglobal build  $setglobal build  2.7b
* select data year:
$if not setglobal dataYr $setglobal dataYr 2022
* enable gdxxrw (0 only for developpers):
$if not setglobal gdx2xl $setglobal gdx2xl 1

* set variable weight for calorie deficit in objective fuction:
$if not setglobal scn_weight  $setglobal scn_weight  0
* set variable upper limit for cropping area expansion:
$if not setglobal scn_areaMax $setglobal scn_areaMax 0
* set variable cropping pattern:
$if not setglobal scn_pattern $setglobal scn_pattern 1
* set variable first-year cropping scenario:
$if not setglobal scn_firstYr $setglobal scn_firstYr 0
* set grain stockpile release scenario:
$if not setglobal scn_stockRe $setglobal scn_stockRe 0

* set import decline scenario (0=baseline(0%), 1=20%, 2=40%, 3=60%, 4=100%):
$if not setglobal imscn  $setglobal imscn  4
* set default weight for calorie deficit in objective fuction (any value in [0,100]):
$if not setglobal wval   $setglobal wval   100
* set default upper limit for cropping area expansion:
$if not setglobal uval   $setglobal uval   3
* set solve statement without cropping area upper bound:
$if not setglobal unlim  $setglobal unlim  1
* include deserted land into land endowment (sey 0 if no deserted land):
$if not setglobal dsrt   $setglobal dsrt   1
* evaluate objective function by rate not by difference:
$if not setglobal rate   $setglobal rate   1
* include constraints on fertilizer element balance (do not set 1 if liebig is 1):
$if not setglobal fbal   $setglobal fbal   1
* include variable yield and fertilizer application (do not set 1 if fbal is 1):
$if not setglobal liebig $setglobal liebig 0
* set rate of chemical fertilizer import decline (any value in [0,100]):
$if not setglobal ncf    $setglobal ncf    50
* set rate of no pestiside area (any value in [0,100]):
$if not setglobal npe    $setglobal npe    0
* include young animals for reproduction:
$if not setglobal reprod $setglobal reprod 0
* include CP balance in feed nutrient:
$if not setglobal CP     $setglobal CP     0

* generate land usage report:
$if not setglobal landrep  $setglobal landrep  1
* generate fertilizer balance report:
$if not setglobal fertrep  $setglobal fertrep  1
* generate labor balance report:
$if not setglobal laborrep $setglobal laborrep 1

$setglobal SUF ""

* set suffix for file name
$batinclude appendTagVal.inc wval %wval%
$batinclude appendTag.inc unlim   %unlim%
$ifi not %unlim%==1 $batinclude appendTagVal.inc uval %uval%
$batinclude appendTag.inc fbal    %fbal%
$batinclude appendTag.inc liebig  %liebig%
$batinclude appendTagVal.inc ncf  %ncf%
$batinclude appendTagVal.inc npe  %npe%
$batinclude appendTag.inc reprod  %reprod%
$batinclude appendTag.inc CP      %CP%

* name output files
$setglobal gdx_results   .\results\%build%_data%dataYr%_import%imscn%_%SUF%_results.gdx
$setglobal excel_results .\results\%build%_data%dataYr%_import%imscn%_%SUF%_results.xlsx



$sTitle Sets
Set
* item 
    c            crops
    ap           animal products
    fe           feeds
    ls           livestocks
* food groups
    cg           crops and processed foods
    ag           animal products
* model arguments
    t            cropping month 
    r            region 
    l            land type
    p            production 
    e            fertilizer elemtnts 
    q            feed quantity 
    nf           feed nutrients 
    n            nutrient values  
    nn           nutrition 
    a            age 
    s            sex  
    v            value
    sname        scalar value name (for data import)
* scenario
    scn          import scenario
    w            weight on calorie balance
    u            upper limit for cropping area   
    z            animal production scenario
    pattern      cropping pattern
* mapping
    mmap         crops to month
    mmap_hok
    rmap         crops to regions 
    lmap         crops to land type 
    CRL          crops to region land type pair
    ;

$gdxin sets.gdx
$load c ap fe ls cg ag t r l p e q nf n nn a s v sname scn w u z pattern rmap lmap mmap mmap_hok
$gdxin

* i for ingredient for processed food 
alias (c,i);

Set
* union
    g            /set.c, set.ap/
    x            /set.g, set.ls/
* mapping to land type
    paddy(c)     /rice,pwheat,pbarley,psweetp,ppotato,psoy/
    field(c)     /wheat,barley,naked,mis_grains,sweetp,potato,soy,mis_beans,veges,scane,sbeat,rapeseed/  
    orchard(c)   /mandarin,apple,mis_fruits/
    pasture(c)   /corn,sorghum/
    local(c)     /scane,sbeat/
    winter(c)    /wheat,pwheat,barley,pbarley,naked,potato,ppotato,veges,scane,rapeseed/
* aggregator for double cropping item
    total_wheat(c)  /wheat,pwheat/
    total_barley(c) /barley,pbarley/
    total_sweetp(c) /sweetp,psweetp/
    total_potato(c) /potato,ppotato/
    total_soy(c)    /soy,psoy/
* mapping to report layer group
    staple(c)    /rice,wheat,pwheat,sweetp,psweetp,potato,ppotato,soy,psoy/
    edible(c)    /rice,wheat,pwheat,barley,pbarley,naked,mis_grains,sweetp,psweetp,potato,ppotato,soy,psoy,mis_beans,veges,mandarin,apple,mis_fruits/  
    marine(c)    /fish,seaweed/
    processed(c) /starch,sugar,oil,miso,soysource,mis_foods/   
    import(g)    /rice,wheat,barley,naked,mis_grains,sweetp,potato,soy,mis_beans,veges,apple,mis_fruits,rapeseed,fish,seaweed,starch,sugar,oil,soysource,mis_foods,beef,pork,chicken,egg,milk/
* mapping to food group
    cmap(cg,c)   Crop groups to crop mapping 
                 /grain.(rice,wheat,pwheat,barley,pbarley,naked,mis_grains)
                  tuber.(sweetp,potato,psweetp,ppotato)
                  pulse.(soy,psoy,mis_beans)
                  veget.(veges)
                  fruit.(mandarin,apple,mis_fruits)
                  starch.(starch)
                  sugar.(sugar)
                  other.(oil,miso,soysource,mis_foods) /
    amap(ag,ap)  Animap product groups to animal products mapping 
                 /meat.(beef,pork,chicken)
                  egg_dairy.(egg,milk) /
    ;

* crops to region land type pair
    CRL(c,r,l) = yes$(rmap(c,r) and lmap(c,l));

Display CRL; 



$sTitle Parameters
Scalar    
    dummy      'Dummy value to linear term of zyield and fert'       / 1e-5  /
    rate_ncf   'rate % of chemical fertilizer import decline'        / %ncf% /
    rate_npe   'rate % of no pestiside area'                         / %npe% /
    weight     'Weight on calorie balance in the objective function' / %wval% /
    limit      'Upper bound for area expansion and feed production'  / %uval% /
    ;

parameter
* data
    data(*,p)         'Production data'  
    land_endw(r,l)    'Land endowment (1000ha)'
    land_dsrt(r,*)    'Deserted land (1000ha)'  
    edemand(c,e)      'Fertilizer element demand (each element: kg/ha)'
    esupply(*,e)      'Fertilizer element supply (each element: t)'
    fertcoef(c,e,*)   'Fertilizer input coefficients'
    head(ls)          'Number of animals      (head)'    
    fdemand(ls,nf)    'Feed nutrient demand   (TDN:kilograms per head, CP:%)'
    fsupply(ls,nf,fe) 'Feed nutrient supply   (%)'
    fconst(fe,q)      'Feed constraints       (t)'
    ldemand_c(*)      'Labor dmenad (hour/10a -> hour/1000ha)'
    ldemand_l(*)      'Labor dmenad (hour/head)'   
    intake(a,s,n)     'Required daily intake of nutrients'
    nvalue(*,v,n)     'Nutritive supply and value of foods'
    sval(sname)       'Scalar values (for data import)'
* constant
    CRT(c,r,t)        'Crops to region month pair (0/1)'
    n_group(*)        'Number of item in food group'
    stockpile(c)      'Government grain stockpile (1000t) '
    wapply(w)         'Set weight for loop operation'
    uapply(u)         'Set upper limit for loop operation'
    lsu(ls)           'Livestock unit coefficient'
    dmcoef(fe)        'Feed DM coefficient'
    pcoef(c,i)        'Output of processed food by 1 unit crop'
    acoef(ap,ls)      'Output of animal product (kg) by 1 unit livestock'
    fcoef(fe,c)       'Forage and Feed yield (MT/ha)'
    ycoef(c,l)        'Yield increase coefficient for "paddy_dry" and "field_irr"'
* scenario
    ncfcoef           'Chemical fertilizer import decline coefficient'
    npecoef(c)        'No pestiside area yield decrease coefficent'
    yrrate(*)         'Yield reduction rate'
    irrate(*,*)       'Import reduation rate'
    frrate(*,*)       'Feed import reduction rate'
    im(*)             'Imported food (net food)     (grams)'
    impc(*)           '              (daily intake) (grams/capita)'
    imnn(nn)          '              (nutrients)    (kcal grams/capita)'
* converters
    tpop              'National population       (million)'
    pintake(a,s,nn)   'Daily intake requirement  (kcal grams/million)'
    nreq(nn)          'Daily intake requirement  (kcal grams/capita)'
    nnvalue(*,nn)     'Nutritive value of foods  (kcal grams/netfood gram)'
    nnpcvalue(*,nn)   'Nutritive value of foods  (kcal grams/capita)'   
    nnpc(*)           'Current daily intake      (grams/capita)'
    t2g(*)            'Total food to gross food'
    t2p(*)            'Total food to processing use'
    t2f(*)            'Total food to feed use'
    g2n(*)            'Gross food to net food '
    x2n(c)            'Cropping area(1000ha) to net food (grams)'
    x2nn(c,nn)        'Cropping area(1000ha) to nutritive value (kcal grams)'
    x2f(c,i)          'Cropping area(1000ha) of i to processed food (grams) of c '
    x2fn(c,i,nn)      'Cropping area(1000ha) of i to nutritive value (kcal grams) of c'
    x2a(ap,ls)        'Livestock head to net food (grams)'
    x2an(ap,ls,nn)    'Livestock head to nutritional value (kcal grams)'
    x2fe(fe,c)        'Cropping area(1000ha) to DM base feed (MT)'
    ;
    
$gdxin data_%dataYr%.gdx
$load data land_endw land_dsrt head fdemand fsupply fconst edemand esupply fertcoef ldemand_c ldemand_l intake nvalue sval
$gdxin

$gdxin parameters.gdx
$load n_group stockpile wapply uapply lsu dmcoef pcoef acoef fcoef ycoef yrrate irrate frrate
$gdxin

* Organic fertilizer supply as residual of chemical fertilizer supply and total demand
    esupply("organic",e) = max(0, sum(c,data(c,"area")*edemand(c,e))-esupply("prod",e)-esupply("import",e) );
* Convert hour/10a -> hour/1000ha
    ldemand_c(c) = ldemand_c(c)*(10**4);
* Include deserted land into land endowment
$iftheni %dsrt%==1
    land_endw(r,"paddy_wet")  = land_endw(r,"paddy_wet")  + land_dsrt(r,"paddy_dsrt");
    land_endw(r,"field_rain") = land_endw(r,"field_rain") + land_dsrt(r,"field_dsrt");
$endif
* dairycow half of newborn calves spent to produce beef  
    acoef("beef","dairycow")      = acoef("beef","dairycow")*(0.5*head("calves")/head("dairycow"));
* dairycow of lactating to produce milk
    acoef("milk","dairycow")      = acoef("milk","dairycow")*(sval("lactating")/head("dairycow"));
* layinghens culled to produce chicken
    acoef("chicken","layinghens") = acoef("chicken","layinghens")*(sval("culled")/head("layinghens"));
    
    CRT(c,r,t)$(not sameas(r,'Hokkaido')) = yes$mmap(c,t);
    CRT(c,"Hokkaido",t)                   = yes$mmap_hok(c,t);
    
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
* adjust processing rate (oil) of domestically produced soybeans
    t2p("soy")   = 18/data("soy","prod");
    t2p("psoy")  = 18/data("psoy","prod");
    t2f(g)       = data(g,"feed")/data(g,"total");
    g2n(g)       = data(g,"g2n")/100;
    
    x2n(c)         = data(c,"yield")*t2g(c)*g2n(c)*(10**9);
    x2nn(c,nn)     = x2n(c)*nnvalue(c,nn);
    x2f(c,i)       = data(i,"yield")*t2p(i)*pcoef(c,i)*(10**9);
    x2fn(c,i,nn)   = x2f(c,i)*nnvalue(c,nn);
    x2a(ap,ls)     = acoef(ap,ls)*g2n(ap)*1000;
    x2an(ap,ls,nn) = x2a(ap,ls)*nnvalue(ap,nn)*0.8;
    x2fe(fe,c)     = fcoef(fe,c)*dmcoef(fe)*(10**3);
    
    ncfcoef    = 1-rate_ncf/100;
    npecoef(c) = 1-yrrate(c)*rate_npe/100;

    im(g) $import(g)   = (1-irrate(g,'scn%imscn%'))*data(g,"import")*t2g(g)*g2n(g)*(10**9) $import(g);
    impc(g) $import(g) = im(g)/(tpop*(10**6)*365) $import(g);
    imnn(nn)           = sum(g, impc(g)*nnvalue(g,nn) $import(g));

Display CRT, esupply, ldemand_c, land_endw;



$sTitle Variables
Variable
    xrlcrop(c,r,l)       'Cropping area (1000ha)'
    xcrop(c)             'Cropping area (1000ha)'
    xlive(ls)            'Head of animal ls'
    yfeed(ls,fe)         'Distribution of feed j to animal ls (MT)'
    zyield(*)            'Effective yield by Liebigs law (MT/ha)'
    fert(c,e)            'Fertilizer application per area (kg/ha)'
    
    eled(e)              'Fertilizer element demand (MT)'
    eles(e)              'Fertilizer element supply (MT)'
    
    labd_c               'Labor demand by crop      (bil. h)'
    labd_ls              'Labor demand by livestock (bil. h)'

    tdnd(ls)             'TDN demand by livestock (MT)'
    tdns(ls)             'TDN supply to livestock (MT)'
    cpd(ls)              'CP demand by livestock  (MT)'
    cps(ls)              'CP supply to livestock  (MT)'
    dms(fe)              'DM supply               (MT)'

    nnpotential_c(c,nn)  'Potential nutrition intake from crops (kcal or grams/capita)'
    nnpotential_f(c,nn)  'Potential nutrition intake from processed foods (kcal or grams/capita)'
    nnpotential_l(ap,nn) 'Potential nutrition intake from animal products (kcal or grams/capita)'

    cdeficit             'Calorie deficit (kcal/capita)'
    cshortrate           'Calorie shortage rate'

    dpotential_c(c)      'Potential netfood intake from crops (grams/capita)'
    dpotential_f(c)      'Potential netfood intake from processed foods (grams/capita)'
    dpotential_l(ap)     'Potential netfood intake from animal products (grams/capita)'
    
    delta(cg)            'Net food intake change (grams/capita)'
    deltasumsq           'Sum of squared net food intake change rate (crop group)'
    
    adelta(ag)           'Net food intake change (grams/capita)'
    adeltasumsq          'Sum of squared net food intake change rate (animal product group)'
    
    target               'Weighted average of calorie deficit and net food balance';

Positive Variable xrlcrop, xcrop, xlive, yfeed, zyield, fert;

* set upper limit of fertilizer application adjusted equivalent to data(c,"yield")
    fert.up(c,e) = fertcoef(c,e,"max");



$sTitle Equations
Equation
    link                 'xrlcrop to xcrop link by summation'
    landbal              'Monthly land balance on each land type (1000ha)'
   
    areamax_y            'Area upper bound on paddy crops   (1000ha)'
    areamax_u            'Area upper bound on upland crops  (1000ha)'
    areamax_p            'Area upper bound on pasture crops (1000ha)'
    areamax_o            'Area upper bound on orchard       (1000ha)'
    areamax_l            'Area upper bound on local crops   (1000ha)'
    areamax_wheat        'Area upper bound on wheat and pwheat (1000ha)'
    areamax_barley       '                    barley and pbarley'
    areamax_sweetp       '                    sweetp and psweetp'
    areamax_potato       '                    potato and ppotato'
    areamax_soy          '                    soy and psoy'
   
    jan                  'Cropping area balance by month    (1000ha)'
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

    Liebig               'Effective yield by Liebigs law of minimum (MT/ha)'
    Liebigbal            'Fertilizer element balance　(MT each element)'
    eledemand            'Fertilizer element demand  (MT each element)'
    elesupply            'Fertilizer element supply  (MT each element)'
    elebal               'Fertilizer element balance (MT each element)'
    
    labdemand_c          'Total labor demand by crop      (bil. hour)'
    labdemand_l          'Total labor demand by livestock (bil. hour)' 
    labbal               'Total labor balance             (bil. hour)'

    tdndemand            'TDN demand by animal ls'
    tdnsupply            'TDN supply for animal ls by feed fe'
    tdnbal               'TDN balance'    
    cpdemand             'CP demand by animal ls'
    cpdemand_low         'CP demand by animal ls (underestimate)'
    cpdemand_high        'CP demand by animal ls (overestimate)'
    cpsupply             'CP supply for animal ls'
    cpbal                'CP balance'
    dmsupply             'Feed supply (constant + import + crop byproducts) (dry matter MT)'
    distbal              'Feed distribution balance'
    distbal_stock        'Feed distribution balance with feed grain stockpile'

    bredbal              'Livestock breeding balance'
    dairyoxrep           'Reproduction rate of dairy ox per mother dairycow'
    heiferrep            'Reproduction rate of heifer per mother dairycow'
    calfrep              'Reproduction rate of calves per mother dairycow'

    nutpet_c             'Potential nutrition supply (grams or kcal/capita)'
    nutpet_f
    nutpet_l
 
    caloriebal           'Calorie deficit (kcal/capita)'
    caloriebal_r         'Calorie shortage rate'

    dietpet_c            'Potential netfood supply (kcal/capita)'
    dietpet_f
    dietpet_l

    dietbal              'Net food balance by fgroup (grams/capita)'
    dietbal_r            'Net food shortage rate by fgroup'
    adietbal      
    adietbal_r   
    
    dif                  'Objective function evaluated as difference value'
    rat                  'Objective function evaluated as rate of shortage';

    link(c)..             sum((r,l)$CRL(c,r,l), xrlcrop(c,r,l)) =e= xcrop(c);
    landbal(t,r,l)..      sum(c$CRL(c,r,l), xrlcrop(c,r,l) * CRT(c,r,t)) =l= land_endw(r,l);

    areamax_y(c)..        xcrop(c) $ paddy(c)   =l= limit*data(c,"area") $ paddy(c);
    areamax_u(c)..        xcrop(c) $ field(c)   =l= limit*data(c,"area") $ field(c);
    areamax_p(c)..        xcrop(c) $ pasture(c) =l= limit*data(c,"area") $ pasture(c);
    areamax_o(c)..        xcrop(c) $ orchard(c) =l=       data(c,"area") $ orchard(c);
    areamax_l(c)..        xcrop(c) $ local(c)   =l=       data(c,"area") $ local(c);
    areamax_wheat..       sum(c $total_wheat(c), xcrop(c)) =l= limit*data("wheat","area");
    areamax_barley..      sum(c $total_barley(c),xcrop(c)) =l= limit*data("barley","area");
    areamax_sweetp..      sum(c $total_sweetp(c),xcrop(c)) =l= limit*data("sweetp","area");
    areamax_potato..      sum(c $total_potato(c),xcrop(c)) =l= limit*data("potato","area");
    areamax_soy..         sum(c $total_soy(c),   xcrop(c)) =l= limit*data("soy","area");

    jan(c)..              xcrop(c) $ mmap(c,"jan") =l= data(c,"area") $ mmap(c,"jan");
    feb(c)..              xcrop(c) $ mmap(c,"feb") =l= data(c,"area") $ mmap(c,"feb");
    mar(c)..              xcrop(c) $ mmap(c,"mar") =l= data(c,"area") $ mmap(c,"mar");
    apr(c)..              xcrop(c) $ mmap(c,"apr") =l= data(c,"area") $ mmap(c,"apr");
    may(c)..              xcrop(c) $ mmap(c,"may") =l= data(c,"area") $ mmap(c,"may");
    jun(c)..              xcrop(c) $ mmap(c,"jun") =l= data(c,"area") $ mmap(c,"jun");
    jul(c)..              xcrop(c) $ mmap(c,"jul") =l= data(c,"area") $ mmap(c,"jul");
    aug(c)..              xcrop(c) $ mmap(c,"aug") =l= data(c,"area") $ mmap(c,"aug");
    sep(c)..              xcrop(c) $ mmap(c,"sep") =l= data(c,"area") $ mmap(c,"sep");
    oct(c)..              xcrop(c) $ mmap(c,"oct") =l= data(c,"area") $ mmap(c,"oct");
    nov(c)..              xcrop(c) $ mmap(c,"nov") =l= data(c,"area") $ mmap(c,"nov");
    dec(c)..              xcrop(c) $ mmap(c,"dec") =l= data(c,"area") $ mmap(c,"dec");

    eledemand(e)..        eled(e)  =e= sum(c, xcrop(c)*edemand(c,e));
    elesupply(e)..        eles(e)  =e= ncfcoef*esupply("prod",e) + ncfcoef*esupply("import",e) + esupply("organic",e);
*   No chemical fertilizer coefficient (ncfcoef) involves import and production except nitrogen 
    elebal(e)..           eled(e)  =l= eles(e);

*   Liebig's Law of the Minimum yield(c) = min_e [ a(c,e) + b(c,e)*fert(c,e) ] is executed as 
*                               yield(c) =l= a(c,e) + b(c,e)*fert(c,e)  (∀e)
*   Maximize production in the objective function being executed also maximize yield(c) as much as possible.
*   Since the above inequality must hold for all e, yield(c) corresponds to the “minimum value” of the potential yield for the scarsiest element.    
    Liebig(c,e)..         zyield(c) =l= fertcoef(c,e,"intercept") + fertcoef(c,e,"slope")*fert(c,e);    
    Liebigbal(e)..        sum(c, xcrop(c)*fert(c,e)) =l= eles(e);
    
    labdemand_c..         labd_c   =e= sum(c, xcrop(c)*ldemand_c(c)) /(10**9);
    labdemand_l..         labd_ls  =e= sum(ls,xlive(ls)*ldemand_l(ls))/(10**9);
    labbal..              labd_c + labd_ls  =l= sval("lsupply");

    tdndemand(ls)..       tdnd(ls) =e= xlive(ls)*fdemand(ls,"tdn")/1000;
    tdnsupply(ls)..       tdns(ls) =e= sum(fe, yfeed(ls,fe)*fsupply(ls,"tdn",fe)/100);
    tdnbal(ls)..          tdnd(ls) =l= tdns(ls);
    
    cpdemand(ls)..        cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_mid")/100;
    cpdemand_low(ls)..    cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_low")/100;
    cpdemand_high(ls)..   cpd(ls)  =e= tdnd(ls)*fdemand(ls,"cp_high")/100;
    cpsupply(ls)..        cps(ls)  =e= sum(fe, yfeed(ls,fe)*fsupply(ls,"cp",fe)/100);
    cpbal(ls)..           cpd(ls)  =l= cps(ls);
    
    dmsupply(fe)..        dms(fe)  =e= fconst(fe,"const")+(1-frrate(fe,'scn%imscn%'))*fconst(fe,"import")+sum(c, xcrop(c)*x2fe(fe,c));
    distbal(fe)..         dms(fe)  =g= sum(ls, yfeed(ls,fe));
    distbal_stock(fe)..   dms(fe)  =g= sum(ls, yfeed(ls,fe))-fconst(fe,"stock");

    bredbal(ls)..         xlive(ls) =l= limit*head(ls);    
    dairyoxrep..          xlive("dairyox") =e= head("dairyox")*xlive("dairycow")/head("dairycow");
    heiferrep..           xlive("heifer")  =e= head("heifer") *xlive("dairycow")/head("dairycow");
    calfrep..             xlive("calves")  =e= head("calves") *xlive("dairycow")/head("dairycow");


    nutpet_c(c,nn)..      nnpotential_c(c,nn) =e= sum((r,l)$CRL(c,r,l), xrlcrop(c,r,l)*x2nn(c,nn)*ycoef(c,l)
$ifi %liebig%==1                                                                      *zyield(c)/data(c,"yield")
                                                 )/(tpop*(10**6)*365);
    
    nutpet_f(c,nn)..      nnpotential_f(c,nn) =e= sum((i,r,l)$CRL(i,r,l), xrlcrop(i,r,l)*x2fn(c,i,nn)*ycoef(i,l)
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


    dietpet_c(c)..        dpotential_c(c) =e= sum((r,l)$CRL(c,r,l), xrlcrop(c,r,l)*x2n(c)*ycoef(c,l)
$ifi %liebig%==1                                                                  *zyield(c)/data(c,"yield")
                                                  )/(tpop*(10**6)*365);
    
    dietpet_f(c)..        dpotential_f(c) =e= sum((i,r,l)$CRL(i,r,l), xrlcrop(i,r,l)*x2f(c,i)*ycoef(i,l)
$ifi %liebig%==1                                                                    *zyield(i)/data(i,"yield")
                                                  )/(tpop*(10**6)*365);

    dietpet_l(ap)..       dpotential_l(ap) =e= sum(ls, xlive(ls)*x2a(ap,ls))/(tpop*(10**6)*365);

    dietbal(cg)..         delta(cg) =e= sum(c $cmap(cg,c), nnpc(c)-impc(c)-dpotential_c(c)-dpotential_f(c))
$ifi %liebig%==1                       -sum(c, zyield(c))*dummy - sum((c,e), fert(c,e))*dummy
*   Add a “very small linear term” to the objective function to avoid the saddle point solutions (all zero).       
                          ;

    dietbal_r..           deltasumsq =e= sum(cg, sqr(
                                                     (delta(cg)/sum(c $cmap(cg,c), nnpc(c))) / n_group(cg)
                                                    )
                                            );

    adietbal(ag)..        adelta(ag) =e= sum(ap $amap(ag,ap), nnpc(ap)-impc(ap)-dpotential_l(ap)
                                            );

    adietbal_r..          adeltasumsq =e= sum(ag, sqr(
                                                     (adelta(ag)/sum(ap $amap(ag,ap), nnpc(ap))) / n_group(ag)
                                                     )
                                             );

    dif..                 target =e= weight*cdeficit + (1-weight)*(sum(cg,delta(cg))+sum(ag,adelta(ag)));
    rat..                 target =e= weight*cshortrate + (1-weight)*(deltasumsq +adeltasumsq);



$sTitle Model definition and solve
    Model crop_constraint   /
                              link,landbal,areamax_o,areamax_l
                              labdemand_c,labdemand_l,labbal
$ifi %fbal%==1                eledemand,elesupply,elebal
$ifi %liebig%==1              elesupply,Liebig,Liebigbal
                            /;
    Model area_max          /
                              areamax_y,areamax_u,areamax_p
                              areamax_wheat,areamax_barley,areamax_sweetp,areamax_potato,areamax_soy
                            /;
    Model animal_constraint /
                              tdndemand,tdnsupply,tdnbal
                              dmsupply,distbal
                              bredbal
$ifi %CP%==1                  cpdemand,cpsupply,cpbal
$ifi %reprod%==1              dairyoxrep,heiferrep,calfrep
                            /;
    Model balance           /
                              nutpet_c, nutpet_f, nutpet_l,
                              caloriebal,caloriebal_r
                              dietpet_c,dietpet_f,dietpet_l
                              dietbal,dietbal_r,
                              adietbal,adietbal_r
                            /;

* Standard solution
    Model sol_dif           / crop_constraint + area_max + animal_constraint + balance + dif /;
    Model sol_rat           / crop_constraint + area_max + animal_constraint + balance + rat /;

* Solution without expansion upper bound
    Model sol_dif_unlimited / sol_dif - area_max /;
    Model sol_rat_unlimited / sol_rat - area_max /;

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
    current_cal    'Current calorie intake      (kcal/day-capita)'
    potential_cal  'Potential calorie intake    (kcal/day-capita)'
    current_diet   'Current netfood intake      (grams/day-capita)'
    potential_diet 'Potential netfood intake    (grams/day-capita)'
    import_diet    'Import                      (grams/day-capita)'
    change_diet    'Change in diet              (grams/day-capita)'/
    nrep           Nutiritional report /
    required       'Required nutrients          (kcal grams/day-capita)'
    current        'Current intake              (kcal grams/day-capita)'
    potential      'Potential intake            (kcal grams/day-capita)'
    import         'Import                      (kcal grams/day-capita)'
    shortage       'Shortage                    (kcal grams/day-capita)'
    srate          'Sufficiency rate            (%)'/
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
* Assign calculated values
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
          
    mxcrop(t,*)
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
    solve sol_dif minimizing target using nlp ;

Display xrlcrop.l, xcrop.l, xlive.l, yfeed.l, dms.l
$ifi %fbal%==1   eled.l, eles.l
$ifi %liebig%==1 zyield.l, fert.l
        cdeficit.l, cshortrate.l, deltasumsq.l, adeltasumsq.l ;



$sTitle Scenario by weight (weight = 100, 75, 50, 25)
if(%scn_weight%,
if(%rate%,
 loop(w,
    weight = wapply(w);
  if(%unlim%,
    solve sol_rat_unlimited minimizing target using nlp ;
  else
    solve sol_rat minimizing target using nlp ;
  );
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
  if(%unlim%,
    solve sol_dif_unlimited minimizing target using nlp ;
  else
    solve sol_dif minimizing target using nlp ;
  );
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

    wcroprep(w,c,"current_cal")    = nnpcvalue(c,"calorie")$edible(c);
    wcroprep(w,c,"potential_cal")  = wxnnpotential_c(w,c,"calorie")*npecoef(c) $edible(c);
    wcroprep(w,c,"current_diet")   = nnpc(c)$edible(c);
    wcroprep(w,c,"potential_diet") = wxdpotential_c(w,c)*npecoef(c) $edible(c);
    wcroprep(w,c,"import_diet")    = impc(c)$edible(c);
    wcroprep(w,c,"change_diet")    = wcroprep(w,c,"potential_diet")+wcroprep(w,c,"import_diet")-wcroprep(w,c,"current_diet");
    wcroprep(w,"total",frep)       = sum(c, wcroprep(w,c,frep));

    wfoodrep(w,c,"current_cal")    = nnpcvalue(c,"calorie") $processed(c);
    wfoodrep(w,c,"potential_cal")  = wxnnpotential_f(w,c,"calorie")*npecoef(c) $processed(c);                                                 
    wfoodrep(w,c,"current_diet")   = nnpc(c) $processed(c);
    wfoodrep(w,c,"potential_diet") = wxdpotential_f(w,c)*npecoef(c) $processed(c);
    wfoodrep(w,c,"import_diet")    = impc(c)$processed(c);
    wfoodrep(w,c,"change_diet")    = wfoodrep(w,c,"potential_diet")+wfoodrep(w,c,"import_diet")-wfoodrep(w,c,"current_diet");
    wfoodrep(w,"total",frep)       = sum(c, wfoodrep(w,c,frep));

    wliverep(w,ap,"current_cal")   = nnpcvalue(ap,"calorie");
    wliverep(w,ap,"potential_cal" )= wxnnpotential_l(w,ap,"calorie");
    wliverep(w,ap,"current_diet")  = nnpc(ap);
    wliverep(w,ap,"potential_diet")= wxdpotential_l(w,ap);
    wliverep(w,ap,"import_diet")   = impc(ap);
    wliverep(w,ap,"change_diet")   = wliverep(w,ap,"potential_diet")+wliverep(w,ap,"import_diet")-wliverep(w,ap,"current_diet");
    wliverep(w,"total",frep)       = sum(ap, wliverep(w,ap,frep));

    wdietrep(w,nn,"required")      = nreq(nn);
    wdietrep(w,nn,"current")       = sum(g, nnpcvalue(g,nn));
    wdietrep(w,nn,"potential")     = sum(c, wxnnpotential_c(w,c,nn)+wxnnpotential_f(w,c,nn))
                                           + sum(ap, wxnnpotential_l(w,ap,nn))
                                           + sum(c,  data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))/(tpop*(10**6)*365)
                                           - sum(c,  wxnnpotential_c(w,c,nn)*(1-npecoef(c)) $edible(c))
                                           - sum(c,  wxnnpotential_f(w,c,nn)*(1-npecoef(c)) $processed(c));
    wdietrep(w,nn,"import")        = imnn(nn);                            
    wdietrep(w,nn,"shortage")      = wdietrep(w,nn,"potential")+wdietrep(w,nn,"import")-wdietrep(w,nn,"required");
    wdietrep(w,nn,"srate")         = 100*(wdietrep(w,nn,"potential")+wdietrep(w,nn,"import"))/wdietrep(w,nn,"required");

    wradar(w,cg,"current")         = sum(c $cmap(cg,c), nnpc(c));
    wradar(w,cg,"potential")       = sum(c $cmap(cg,c), wcroprep(w,c,"potential_diet")+wfoodrep(w,c,"potential_diet"));
    wradar(w,cg,"import")          = sum(c $cmap(cg,c), impc(c));
    wradar(w,cg,"change")          = wradar(w,cg,"potential") + wradar(w,cg,"import") - wradar(w,cg,"current");
    wradar(w,cg,"srate")           = 100*(wradar(w,cg,"potential")+wradar(w,cg,"import"))/wradar(w,cg,"current");
    waradar(w,ag,"current")        = sum(ap $amap(ag,ap), nnpc(ap));
    waradar(w,ag,"potential")      = sum(ap $amap(ag,ap), wliverep(w,ap,"potential_diet"));
    waradar(w,ag,"import")         = sum(ap $amap(ag,ap), impc(ap));
    waradar(w,ag,"change")         = waradar(w,ag,"potential") + waradar(w,ag,"import") - waradar(w,ag,"current");
    waradar(w,ag,"srate")          = 100*(waradar(w,ag,"potential")+waradar(w,ag,"import")) / waradar(w,ag,"current");
    
    wlandrep_region("current","total",c) = data(c,"area");
    wlandrep_region(w,r,c)         = sum(l, wxrlcrop(w,c,r,l));
    wlandrep_region(w,"total",c)   = sum(r, wlandrep_region(w,r,c));
    wlandrep_region(w,r,"total")   = sum(c, wlandrep_region(w,r,c));
    wlandrep_month(w,t,l,c)        = sum(r, wxrlcrop(w,c,r,l)*CRT(c,r,t));
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
    weight = %wval%/100;

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

    lcroprep(u,c,"current_cal")    = nnpcvalue(c,"calorie")$edible(c);
    lcroprep(u,c,"potential_cal")  = lxnnpotential_c(u,c,"calorie")*npecoef(c) $edible(c);
    lcroprep(u,c,"current_diet")   = nnpc(c)$edible(c);
    lcroprep(u,c,"potential_diet") = lxdpotential_c(u,c)*npecoef(c) $edible(c);
    lcroprep(u,c,"import_diet")    = impc(c)$edible(c);
    lcroprep(u,c,"change_diet")    = lcroprep(u,c,"potential_diet")+lcroprep(u,c,"import_diet")-lcroprep(u,c,"current_diet");
    lcroprep(u,"total",frep)       = sum(c, lcroprep(u,c,frep));

    lfoodrep(u,c,"current_cal")    = nnpcvalue(c,"calorie") $processed(c);
    lfoodrep(u,c,"potential_cal")  = lxnnpotential_f(u,c,"calorie")*npecoef(c) $processed(c);                                                 
    lfoodrep(u,c,"current_diet")   = nnpc(c) $processed(c);
    lfoodrep(u,c,"potential_diet") = lxdpotential_f(u,c)*npecoef(c) $processed(c);
    lfoodrep(u,c,"import_diet")    = impc(c)$processed(c);
    lfoodrep(u,c,"change_diet")    = lfoodrep(u,c,"potential_diet")+lfoodrep(u,c,"import_diet")-lfoodrep(u,c,"current_diet");
    lfoodrep(u,"total",frep)       = sum(c, lfoodrep(u,c,frep));

    lliverep(u,ap,"current_cal")   = nnpcvalue(ap,"calorie");
    lliverep(u,ap,"potential_cal") = lxnnpotential_l(u,ap,"calorie");
    lliverep(u,ap,"current_diet")  = nnpc(ap);
    lliverep(u,ap,"potential_diet")= lxdpotential_l(u,ap);
    lliverep(u,ap,"import")        = impc(ap);
    lliverep(u,ap,"change")        = lliverep(u,ap,"potential_diet")+lliverep(u,ap,"import_diet")-lliverep(u,ap,"current_diet");
    lliverep(u,"total",frep)       = sum(ap, lliverep(u,ap,frep));
    
    ldietrep(u,nn,"required")      = nreq(nn);
    ldietrep(u,nn,"current")       = sum(g, nnpcvalue(g,nn));
    ldietrep(u,nn,"potential")     = sum(c, lxnnpotential_c(u,c,nn)+lxnnpotential_f(u,c,nn))
                                           + sum(ap, lxnnpotential_l(u,ap,nn))
                                           + sum(c,  data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))/(tpop*(10**6)*365)
                                           - sum(c,  lxnnpotential_c(u,c,nn)*(1-npecoef(c)) $edible(c))
                                           - sum(c,  lxnnpotential_f(u,c,nn)*(1-npecoef(c)) $processed(c));
    ldietrep(u,nn,"import")        = imnn(nn);                            
    ldietrep(u,nn,"shortage")      = ldietrep(u,nn,"potential")+ldietrep(u,nn,"import")-ldietrep(u,nn,"required");
    ldietrep(u,nn,"srate")         = 100*(ldietrep(u,nn,"potential")+ldietrep(u,nn,"import"))/ldietrep(u,nn,"required");

    lradar(u,cg,"current")         = sum(c $cmap(cg,c), nnpc(c));
    lradar(u,cg,"potential")       = sum(c $cmap(cg,c), lcroprep(u,c,"potential_diet")+lfoodrep(u,c,"potential_diet"));
    lradar(u,cg,"import")          = sum(c $cmap(cg,c), impc(c));
    lradar(u,cg,"change")          = lradar(u,cg,"potential") + lradar(u,cg,"import") - lradar(u,cg,"current");
    lradar(u,cg,"srate")           = 100*(lradar(u,cg,"potential")+lradar(u,cg,"import"))/lradar(u,cg,"current");
    laradar(u,ag,"current")        = sum(ap $amap(ag,ap), nnpc(ap));
    laradar(u,ag,"potential")      = sum(ap $amap(ag,ap), lliverep(u,ap,"potential_diet"));
    laradar(u,ag,"import")         = sum(ap $amap(ag,ap), impc(ap));
    laradar(u,ag,"change")         = laradar(u,ag,"potential") + laradar(u,ag,"import") - laradar(u,ag,"current");
    laradar(u,ag,"srate")          = 100*(laradar(u,ag,"potential")+laradar(u,ag,"import")) / laradar(u,ag,"current");

    llandrep_region("current","total",c) = data(c,"area");
    llandrep_region(u,r,c)         = sum(l, lxrlcrop(u,c,r,l));
    llandrep_region(u,"total",c)   = sum(r, llandrep_region(u,r,c));
    llandrep_region(u,r,"total")   = sum(c, llandrep_region(u,r,c));
    llandrep_month(u,t,l,c)        = sum(r, lxrlcrop(u,c,r,l)*CRT(c,r,t));
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
    weight = %wval%;
    limit = %uval%;

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

    mcroprep(t,c,"supply")    = mxcrop(t,c)*data(c,"yield") $edible(c);
    mcroprep(t,c,"grossfood") = mxcrop(t,c)*data(c,"yield")*t2g(c) $edible(c);
    mcroprep(t,c,"netfood")   = mxcrop(t,c)*data(c,"yield")*t2g(c)*g2n(c) $edible(c);
    mcroprep(t,c,"current")   = nnpc(c)$edible(c);
    mcroprep(t,c,"potential") = mcroprep(t,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    mcroprep(t,c,"change")    = mcroprep(t,c,"potential")-mcroprep(t,c,"current");
    mcroprep(t,"total",frep)  = sum(c, mcroprep(t,c,frep));

    mfoodrep(t,c,"netfood")   = sum(i, mxcrop(t,i)*data(i,"yield")*t2p(i)*pcoef(c,i) $processed(c));
    mfoodrep(t,c,"current")   = nnpc(c)$processed(c);
    mfoodrep(t,c,"potential") = mfoodrep(t,c,"netfood")*(10**9)/(tpop*(10**6)*365);
    mfoodrep(t,c,"change")    = mfoodrep(t,c,"potential")-mfoodrep(t,c,"current");
    mfoodrep(t,"total",frep)  = sum(c, mfoodrep(t,c,frep));

    mdietrep(t,nn,"required") = nreq(nn);
    mdietrep(t,nn,"potential")= sum(c,mcroprep(t,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                              + sum(c,mfoodrep(t,c,"netfood")*nnvalue(c,nn)*(10**9)) /(tpop*(10**6)*365)
                              + sum(c,data(c,"net")*nnvalue(c,nn)*(10**9)$marine(c)) /(tpop*(10**6)*365);
    mdietrep(t,nn,"shortage") = mdietrep(t,nn,"potential") - mdietrep(t,nn,"required");
    mdietrep(t,nn,"ros")      = 100*mdietrep(t,nn,"potential") / mdietrep(t,nn,"required");



$sTitle Scenario by cropping pattern
    weight = %wval%/100;
    limit = %uval%;

$onText
Changes in parameter landreq
*Common
  1. Remove psoy from the planting schedule, only soy remains valid
  2. Remove rapeseed, barley, and naked from the planting schedule
  3. Modify the planting periods for potatoe to match sweet potatoe
  4. No cropping over Nov.-Feb. season in Tohoku_Hokuriku
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
    ldemand_c("veges") = 0.5*ldemand_c("veges");
    
parameter
    allow(pattern,c)   'Allowance of cropping in each pattern';
    allow(pattern,c) = 1;
*Banned items for all pattern
    allow(pattern,"barley") = 0;
    allow(pattern,"pbarley") = 0;
    allow(pattern,"naked") = 0;
    allow(pattern,"corn") = 0;
    allow(pattern,"sorghum") = 0;
    allow(pattern,"mis_grains") = 0;
    allow(pattern,"mis_beans") = 0;
    allow(pattern,"rapeseed") = 0;
*Rice and wheat-centered cropping
    allow("rice_wheat","sweetp") = 0;
    allow("rice_wheat","potato") = 0;
    allow("rice_wheat","psweetp") = 0;
    allow("rice_wheat","ppotato") = 0;
*Potato-centered cropping
    allow("potato","wheat") = 0;
    allow("potato","soy") = 0;
    allow("potato","psoy") = 0;
*Combination of rice_wheat and potato
    allow("combination",c) = 1;
    allow("combination","naked") = 0;
    allow("combination","corn") = 0;
    allow("combination","sorghum") = 0;
    allow("combination","mis_grains") = 0;
    allow("combination","mis_beans") = 0;
    allow("combination","rapeseed") = 0;

display CRT, land_endw, x2n, x2nn, allow;

if(%rate%,
 loop(pattern,
* Clear variables
    xrlcrop.lo(c,r,l) = 0; xrlcrop.up(c,r,l) = +inf;
* Control croppable plants
    xrlcrop.up(c,r,l)$(not allow(pattern,c)) = 0;
* No cropping over winter season in Tohoku_Hokuriku
*    xrlcrop.up(c,"Tohoku_Hokuriku",l)$winter(c) = 0;
  if(%unlim%,
    solve sol_rat_unlimited minimizing target using nlp ;
  else
    solve sol_rat minimizing target using nlp ;
  );
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
* No cropping over winter season in Tohoku_Hokuriku
*    xrlcrop.up(c,"Tohoku_Hokuriku",l)$winter(c) = 0;
  if(%unlim%,
    solve sol_dif_unlimited minimizing target using nlp ;
  else
    solve sol_dif minimizing target using nlp ;
  );
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
    resFert(pattern,e)          'Residual fertilizer (MT)'
    xveg_resLand(pattern)       'Maximum cropping area with residual land  (1000ha)'
    xveg_resLabor(pattern)      'Maximum cropping area with residual labor (1000ha)'
    xveg_resFert(pattern)       'Maximum cropping area with the scarsiest element (1000ha)'
    xveg(pattern)               'Post-calculation cropping area (1000ha)'
    dietxveg(pattern)           'Netfood supply (grams/day-capita)'
    nutxveg(pattern,nn)         'Nutrition supply (grams or kcal/day-capita)';
    
scalar
    laborVeg                    'Labor demand of vegetable per month (bil. hour /1000ha)';
    laborVeg = ldemand_c("veges")/(10**9);
    
* Residual land per month (croppable in "paddy_dry" or "field_irr" or "field_rain" and other region than "Hokkaido") 
    resLand(pattern,r,l,t)
    $((sameas(l,'paddy_dry') or sameas(l,'field_irr') or sameas(l,'field_rain')) and (sameas(r,'Kanto_West') or sameas(r,'Okinawa'))) =
                             land_endw(r,l) - sum(c, pxrlcrop(pattern,c,r,l)*CRT(c,r,t));
* Residual labor (annual)
    resLabor(pattern)      = sval("lsupply") - sum(c, pxcrop(pattern,c) * ldemand_c(c))/(10**9)
                                             - sum(ls, pxlive(pattern,ls)* ldemand_l(ls))/(10**9);
* Residual fertilizer
    resFert(pattern,e)     = esupply("prod",e) + ncfcoef*esupply("import",e) + esupply("organic",e)
                                             - sum(c, pxcrop(pattern,c) * edemand(c,e)
$ifi %lienig%==1                                                        * pfert(pattern,c,e)/edemand(c,e)                                          
                                                  );
* Non-negativity check
    resLand(pattern,r,l,t) = max(0, resLand(pattern,r,l,t));
    resLabor(pattern)      = max(0, resLabor(pattern));
    resFert(pattern,e)     = max(0, resFert(pattern,e));
* Maximum cropping area with either residual input
    xveg_resLand(pattern)  = smax(t, sum((r,l),resLand(pattern,r,l,t)));
    xveg_resLabor(pattern) = resLabor(pattern)/laborVeg;
    xveg_resFert(pattern)  = smin(e, resFert(pattern,e)/edemand("veges",e)
$ifi %liebig%==1                                        *edemand("veges",e)/fertcoef("veges",e,"max")
                                  );
* Joint constraint on cropping area of "veges"
    xveg(pattern)        = min( xveg_resLand(pattern),
$ifi %fbal%==1                  xveg_resFert(pattern),
$ifi %liebig%==1                xveg_resFert(pattern),
                                xveg_resLabor(pattern) );
* Assign maximum area over t
    dietxveg(pattern)    = xveg(pattern)*x2n("veges")    /(tpop*(10**6)*365);
    nutxveg(pattern,nn)  = xveg(pattern)*x2nn("veges",nn)/(tpop*(10**6)*365);

display resLand, resLabor, resFert, xveg_resLand, xveg_resLabor, xveg_resFert, xveg;

*Assign "veges" values by post-calculation
    pxcrop(pattern,"veges")              = pxcrop(pattern,"veges")+xveg(pattern);
    pxdpotential_c(pattern,"veges")      = pxdpotential_c(pattern,"veges")+dietxveg(pattern);
    pxnnpotential_c(pattern,"veges",nn)  = pxnnpotential_c(pattern,"veges",nn)+nutxveg(pattern,nn);

    pcroprep(pattern,c,"current_cal")    = nnpcvalue(c,"calorie")$edible(c);
    pcroprep(pattern,c,"potential_cal")  = pxnnpotential_c(pattern,c,"calorie")*npecoef(c) $edible(c);                                           
    pcroprep(pattern,c,"current_diet")   = nnpc(c)$edible(c);
    pcroprep(pattern,c,"potential_diet") = pxdpotential_c(pattern,c)*npecoef(c) $edible(c);
    pcroprep(pattern,c,"import_diet")    = impc(c)$edible(c);
    pcroprep(pattern,c,"change_diet")    = pcroprep(pattern,c,"potential_diet")+pcroprep(pattern,c,"import_diet")-pcroprep(pattern,c,"current_diet");
    pcroprep(pattern,"total",frep)       = sum(c, pcroprep(pattern,c,frep));
                                                 
    pfoodrep(pattern,c,"current_cal")    = nnpcvalue(c,"calorie") $processed(c);
    pfoodrep(pattern,c,"potential_cal")  = pxnnpotential_f(pattern,c,"calorie")*npecoef(c) $processed(c);
    pfoodrep(pattern,c,"current_diet")   = nnpc(c) $processed(c);
    pfoodrep(pattern,c,"potential_diet") = pxdpotential_f(pattern,c)*npecoef(c) $processed(c);
    pfoodrep(pattern,c,"import_diet")    = impc(c)$processed(c);
    pfoodrep(pattern,c,"change_diet")    = pfoodrep(pattern,c,"potential_diet")+pfoodrep(pattern,c,"import_diet")-pfoodrep(pattern,c,"current_diet");
    pfoodrep(pattern,"total",frep)       = sum(c, pfoodrep(pattern,c,frep));

    pliverep(pattern,ap,"current_cal")   = nnpcvalue(ap,"calorie");
    pliverep(pattern,ap,"potential_cal") = pxnnpotential_l(pattern,ap,"calorie");
    pliverep(pattern,ap,"current_diet")  = nnpc(ap);
    pliverep(pattern,ap,"potential_diet")= pxdpotential_l(pattern,ap);
    pliverep(pattern,ap,"import_diet")   = impc(ap);
    pliverep(pattern,ap,"change_diet")   = pliverep(pattern,ap,"potential_diet")+pliverep(pattern,ap,"import_diet")-pliverep(pattern,ap,"current_diet");
    pliverep(pattern,"total",frep)       = sum(ap, pliverep(pattern,ap,frep));

    pdietrep(pattern,nn,"required")      = nreq(nn);
    pdietrep(pattern,nn,"current")       = sum(g, nnpcvalue(g,nn));
    pdietrep(pattern,nn,"potential")     = sum(c, pxnnpotential_c(pattern,c,nn)+pxnnpotential_f(pattern,c,nn))
                                           + sum(ap, pxnnpotential_l(pattern,ap,nn))
                                           + sum(c,  data(c,"net")*nnvalue(c,nn)*(10**9) $marine(c))/(tpop*(10**6)*365)
                                           - sum(c,  pxnnpotential_c(pattern,c,nn)*(1-npecoef(c)) $edible(c))
                                           - sum(c,  pxnnpotential_f(pattern,c,nn)*(1-npecoef(c)) $processed(c));
    pdietrep(pattern,nn,"import")        = imnn(nn);                            
    pdietrep(pattern,nn,"shortage")      = pdietrep(pattern,nn,"potential")+pdietrep(pattern,nn,"import")-pdietrep(pattern,nn,"required");
    pdietrep(pattern,nn,"srate")         = 100*(pdietrep(pattern,nn,"potential")+pdietrep(pattern,nn,"import"))/pdietrep(pattern,nn,"required");

    pradar(pattern,cg,"current")         = sum(c $cmap(cg,c), nnpc(c));
    pradar(pattern,cg,"potential")       = sum(c $cmap(cg,c), pcroprep(pattern,c,"potential_diet")+pfoodrep(pattern,c,"potential_diet"));
    pradar(pattern,cg,"import")          = sum(c $cmap(cg,c), impc(c));
    pradar(pattern,cg,"change")          = pradar(pattern,cg,"potential") + pradar(pattern,cg,"import") - pradar(pattern,cg,"current");
    pradar(pattern,cg,"srate")           = 100*(pradar(pattern,cg,"potential")+pradar(pattern,cg,"import"))/pradar(pattern,cg,"current");
    paradar(pattern,ag,"current")        = sum(ap $amap(ag,ap), nnpc(ap));
    paradar(pattern,ag,"potential")      = sum(ap $amap(ag,ap), pliverep(pattern,ap,"potential_diet"));
    paradar(pattern,ag,"import")         = sum(ap $amap(ag,ap), impc(ap));
    paradar(pattern,ag,"change")         = paradar(pattern,ag,"potential") + paradar(pattern,ag,"import") - paradar(pattern,ag,"current");
    paradar(pattern,ag,"srate")          = 100*(paradar(pattern,ag,"potential")+paradar(pattern,ag,"import")) / paradar(pattern,ag,"current");
    
    plandrep_region("current","total",c) = data(c,"area");
    plandrep_region(pattern,r,c)         = sum(l, pxrlcrop(pattern,c,r,l));
    plandrep_region(pattern,"total",c)   = sum(r, plandrep_region(pattern,r,c));
    plandrep_region(pattern,r,"total")   = sum(c, plandrep_region(pattern,r,c));
    plandrep_month(pattern,t,l,c)        = sum(r, pxrlcrop(pattern,c,r,l)*CRT(c,r,t));
    plandrep_month(pattern,t,l,"total")  = sum(c, plandrep_month(pattern,t,l,c));
*Assign "veges" values by post-calculation
    plandrep_region(pattern,"total","veges") = xveg(pattern);

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
    pyieldrep(pattern,c,"change")$(pzyield(pattern,c)<>0) = pyieldrep(pattern,c,"current")-pyieldrep(pattern,c,"potential");
$endif



$sTitle Grain stockpile release scenario
    stock("grossfood",c)      = stockpile(c); 
    stock("netfood",c)        = stockpile(c)*g2n(c);
    stock("netfood","total")  = sum(c,stock("netfood",c));
    stock("netfoodpc",c)      = stock("netfood",c)*(10**9)/(tpop*(10**6)*365);
    stock("netfoodpc","total")= sum(c,stock("netfoodpc",c));
    stock("calorie",c)        = stock("netfood",c)*nnvalue(c,"calorie")*(10**9)/(tpop*(10**6)*365);
    stock("calorie","total")  = sum(c,stock("calorie",c));

    xcbal("mean")             = (-1)*sum(t,mdietrep(t,"calorie","shortage"))/12;
    xcbal("max")              = (-1)*smax(t,mdietrep(t,"calorie","shortage"));
    xcbal("min")              = (-1)*smin(t,mdietrep(t,"calorie","shortage"));

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
    execute 'gdxxrw %gdx_results% o=%excel_results% par=wfertrep rng=wfertrep!A1 rdim=2 cdim=1'
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
    execute 'gdxxrw %gdx_results% o=%excel_results% par=lfertrep rng=lfertrep!A1 rdim=2 cdim=1'
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
execute 'gdxxrw %gdx_results% o=%excel_results% par=paradar  rng=pradar!A27  rdim=2 cdim=1'
$iftheni %landrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=plandrep_region rng=plandrep!A1 rdim=2 cdim=1'
    execute 'gdxxrw %gdx_results% o=%excel_results% par=plandrep_month  rng=plandrep!A19 rdim=2 cdim=2'
$endif
$iftheni %laborrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=plaborrep rng=plaborrep!A1 rdim=1 cdim=1'
$endif
$iftheni %fertrep%==1
    execute 'gdxxrw %gdx_results% o=%excel_results% par=pfertrep rng=pfertrep!A1 rdim=2 cdim=1'
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