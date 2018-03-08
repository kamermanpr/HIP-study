---
title: "HIP demographics: Descriptive analyses"
author: "Peter Kamerman and Tory Madden"
date: "08 March 2018"
output: 
    html_document:
        theme: yeti
        keep_md: true
        highlight: pygments
        df_print: paged
        toc: true
        toc_float: true
        code_folding: show
---



----

# Import data


```r
# Get data
demo <- read_rds('./data/demographics.rds')
```

----

# Quick look


```r
glimpse(demo)
```

```
## Observations: 160
## Variables: 21
## $ ID                   <chr> "J1", "J3", "J4", "J5", "J6", "J7", "J9",...
## $ Group                <chr> "P", "T", "P", "P", "P", "T", "T", "T", "...
## $ Site                 <chr> "U1", "U1", "U1", "U1", "U1", "U1", "U1",...
## $ Sex                  <chr> "female", "female", "female", "female", "...
## $ DOB                  <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, ...
## $ Age                  <dbl> 37, 36, 36, 58, 33, 32, 37, 46, 31, 36, 4...
## $ DODx                 <dbl> 2006, 2008, 2011, 1982, 2007, 2012, 2008,...
## $ Years_on_ART         <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ CD4                  <dbl> 354, 186, 172, 214, NA, 86, 103, 205, 420...
## $ CD4_recent           <dbl> NA, 728, NA, 189, NA, NA, 667, NA, 325, N...
## $ HIV_stage            <dbl> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ HIV_mx               <chr> "first-line", "first-line", "first-line",...
## $ `Years of schooling` <dbl> 12, NA, 11, 2, 12, 12, 9, 12, 12, 11, 9, ...
## $ SOS_mnemonic         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N...
## $ Occupation           <chr> "employed", NA, "employed", "unemployed -...
## $ Adjuvant             <chr> "no", "no", "no", "no", "no", "no", "yes"...
## $ NSAID                <chr> "no", "no", "no", "no", "no", "no", "no",...
## $ Paracetamol          <chr> "yes", "no", "no", "no", "yes", "yes", "n...
## $ Mild_opioid          <chr> "no", "no", "no", "no", "no", "no", "no",...
## $ WHO_level            <dbl> 1, 0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0,...
## $ Years_education      <ord> 12, NA, 11, 2, 12, 12, 9, 12, 12, 11, 9, ...
```

```r
head(demo)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["ID"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Group"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Site"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Sex"],"name":[4],"type":["chr"],"align":["left"]},{"label":["DOB"],"name":[5],"type":["date"],"align":["right"]},{"label":["Age"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["DODx"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Years_on_ART"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["CD4"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["CD4_recent"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["HIV_stage"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["HIV_mx"],"name":[12],"type":["chr"],"align":["left"]},{"label":["Years of schooling"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["SOS_mnemonic"],"name":[14],"type":["chr"],"align":["left"]},{"label":["Occupation"],"name":[15],"type":["chr"],"align":["left"]},{"label":["Adjuvant"],"name":[16],"type":["chr"],"align":["left"]},{"label":["NSAID"],"name":[17],"type":["chr"],"align":["left"]},{"label":["Paracetamol"],"name":[18],"type":["chr"],"align":["left"]},{"label":["Mild_opioid"],"name":[19],"type":["chr"],"align":["left"]},{"label":["WHO_level"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["Years_education"],"name":[21],"type":["ord"],"align":["right"]}],"data":[{"1":"J1","2":"P","3":"U1","4":"female","5":"<NA>","6":"37","7":"2006","8":"NA","9":"354","10":"NA","11":"NA","12":"first-line","13":"12","14":"NA","15":"employed","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"12"},{"1":"J3","2":"T","3":"U1","4":"female","5":"<NA>","6":"36","7":"2008","8":"NA","9":"186","10":"728","11":"NA","12":"first-line","13":"NA","14":"NA","15":"NA","16":"no","17":"no","18":"no","19":"no","20":"0","21":"NA"},{"1":"J4","2":"P","3":"U1","4":"female","5":"<NA>","6":"36","7":"2011","8":"NA","9":"172","10":"NA","11":"NA","12":"first-line","13":"11","14":"NA","15":"employed","16":"no","17":"no","18":"no","19":"no","20":"0","21":"11"},{"1":"J5","2":"P","3":"U1","4":"female","5":"<NA>","6":"58","7":"1982","8":"NA","9":"214","10":"189","11":"NA","12":"second-line","13":"2","14":"NA","15":"unemployed - looking for work","16":"no","17":"no","18":"no","19":"no","20":"0","21":"2"},{"1":"J6","2":"P","3":"U1","4":"female","5":"<NA>","6":"33","7":"2007","8":"NA","9":"NA","10":"NA","11":"NA","12":"NA","13":"12","14":"NA","15":"unemployed - looking for work","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"12"},{"1":"J7","2":"T","3":"U1","4":"female","5":"<NA>","6":"32","7":"2012","8":"NA","9":"86","10":"NA","11":"NA","12":"first-line","13":"12","14":"NA","15":"unemployed - looking for work","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"12"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
tail(demo)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":["ID"],"name":[1],"type":["chr"],"align":["left"]},{"label":["Group"],"name":[2],"type":["chr"],"align":["left"]},{"label":["Site"],"name":[3],"type":["chr"],"align":["left"]},{"label":["Sex"],"name":[4],"type":["chr"],"align":["left"]},{"label":["DOB"],"name":[5],"type":["date"],"align":["right"]},{"label":["Age"],"name":[6],"type":["dbl"],"align":["right"]},{"label":["DODx"],"name":[7],"type":["dbl"],"align":["right"]},{"label":["Years_on_ART"],"name":[8],"type":["dbl"],"align":["right"]},{"label":["CD4"],"name":[9],"type":["dbl"],"align":["right"]},{"label":["CD4_recent"],"name":[10],"type":["dbl"],"align":["right"]},{"label":["HIV_stage"],"name":[11],"type":["dbl"],"align":["right"]},{"label":["HIV_mx"],"name":[12],"type":["chr"],"align":["left"]},{"label":["Years of schooling"],"name":[13],"type":["dbl"],"align":["right"]},{"label":["SOS_mnemonic"],"name":[14],"type":["chr"],"align":["left"]},{"label":["Occupation"],"name":[15],"type":["chr"],"align":["left"]},{"label":["Adjuvant"],"name":[16],"type":["chr"],"align":["left"]},{"label":["NSAID"],"name":[17],"type":["chr"],"align":["left"]},{"label":["Paracetamol"],"name":[18],"type":["chr"],"align":["left"]},{"label":["Mild_opioid"],"name":[19],"type":["chr"],"align":["left"]},{"label":["WHO_level"],"name":[20],"type":["dbl"],"align":["right"]},{"label":["Years_education"],"name":[21],"type":["ord"],"align":["right"]}],"data":[{"1":"R408","2":"T","3":"U2","4":"female","5":"1990-03-05","6":"26","7":"2014","8":"0.7500000","9":"757","10":"757","11":"1","12":"first-line","13":"10","14":"lhl","15":"unemployed - looking for work","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"10"},{"1":"R411","2":"T","3":"U2","4":"female","5":"1981-12-07","6":"34","7":"2012","8":"3.4166667","9":"78","10":"160","11":"1","12":"first-line","13":"7","14":"lhl","15":"unemployed - not looking for work","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"7"},{"1":"R427","2":"T","3":"U2","4":"female","5":"1985-09-30","6":"29","7":"2014","8":"2.0833333","9":"376","10":"376","11":"1","12":"first-line","13":"7","14":"lhl","15":"unemployed - not looking for work","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"7"},{"1":"R412","2":"T","3":"U2","4":"female","5":"1980-12-23","6":"34","7":"2011","8":"4.2500000","9":"274","10":"457","11":"2","12":"second-line","13":"0","14":"lhl","15":"unemployed - not looking for work","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"0"},{"1":"R436","2":"T","3":"U2","4":"female","5":"1981-09-17","6":"33","7":"2014","8":"0.8333333","9":"427","10":"427","11":"2","12":"first-line","13":"7","14":"hl","15":"employed","16":"no","17":"yes","18":"yes","19":"no","20":"1","21":"7"},{"1":"R443","2":"T","3":"U2","4":"female","5":"1981-06-21","6":"34","7":"2011","8":"3.6666667","9":"460","10":"763","11":"2","12":"first-line","13":"10","14":"hl","15":"employed","16":"no","17":"no","18":"yes","19":"no","20":"1","21":"10"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

```r
skim(demo)
```

<div data-pagedtable="false">
  <script data-pagedtable-source type="application/json">
{"columns":[{"label":[""],"name":["_rn_"],"type":[""],"align":["left"]},{"label":["variable"],"name":[1],"type":["chr"],"align":["left"]},{"label":["type"],"name":[2],"type":["chr"],"align":["left"]},{"label":["stat"],"name":[3],"type":["chr"],"align":["left"]},{"label":["level"],"name":[4],"type":["chr"],"align":["left"]},{"label":["value"],"name":[5],"type":["dbl"],"align":["right"]},{"label":["formatted"],"name":[6],"type":["chr"],"align":["left"]}],"data":[{"1":"ID","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"1"},{"1":"ID","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"2"},{"1":"ID","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"3"},{"1":"ID","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"4"},{"1":"ID","2":"character","3":"max","4":".all","5":"4.0000000","6":"4","_rn_":"5"},{"1":"ID","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"6"},{"1":"ID","2":"character","3":"n_unique","4":".all","5":"160.0000000","6":"160","_rn_":"7"},{"1":"Group","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"8"},{"1":"Group","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"9"},{"1":"Group","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"10"},{"1":"Group","2":"character","3":"min","4":".all","5":"1.0000000","6":"1","_rn_":"11"},{"1":"Group","2":"character","3":"max","4":".all","5":"1.0000000","6":"1","_rn_":"12"},{"1":"Group","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"13"},{"1":"Group","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"14"},{"1":"Site","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"15"},{"1":"Site","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"16"},{"1":"Site","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"17"},{"1":"Site","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"18"},{"1":"Site","2":"character","3":"max","4":".all","5":"2.0000000","6":"2","_rn_":"19"},{"1":"Site","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"20"},{"1":"Site","2":"character","3":"n_unique","4":".all","5":"4.0000000","6":"4","_rn_":"21"},{"1":"Sex","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"22"},{"1":"Sex","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"23"},{"1":"Sex","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"24"},{"1":"Sex","2":"character","3":"min","4":".all","5":"4.0000000","6":"4","_rn_":"25"},{"1":"Sex","2":"character","3":"max","4":".all","5":"6.0000000","6":"6","_rn_":"26"},{"1":"Sex","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"27"},{"1":"Sex","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"28"},{"1":"DOB","2":"Date","3":"missing","4":".all","5":"46.0000000","6":"46","_rn_":"29"},{"1":"DOB","2":"Date","3":"complete","4":".all","5":"114.0000000","6":"114","_rn_":"30"},{"1":"DOB","2":"Date","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"31"},{"1":"DOB","2":"Date","3":"min","4":".all","5":"266.0000000","6":"1970-09-24","_rn_":"32"},{"1":"DOB","2":"Date","3":"max","4":".all","5":"9781.0000000","6":"1996-10-12","_rn_":"33"},{"1":"DOB","2":"Date","3":"median","4":".all","5":"4012.0000000","6":"1980-12-26","_rn_":"34"},{"1":"DOB","2":"Date","3":"n_unique","4":".all","5":"112.0000000","6":"112","_rn_":"35"},{"1":"Age","2":"numeric","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"36"},{"1":"Age","2":"numeric","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"37"},{"1":"Age","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"38"},{"1":"Age","2":"numeric","3":"mean","4":".all","5":"35.2250000","6":"35.23","_rn_":"39"},{"1":"Age","2":"numeric","3":"sd","4":".all","5":"5.6467835","6":"5.65","_rn_":"40"},{"1":"Age","2":"numeric","3":"p0","4":".all","5":"18.0000000","6":"18","_rn_":"41"},{"1":"Age","2":"numeric","3":"p25","4":".all","5":"32.0000000","6":"32","_rn_":"42"},{"1":"Age","2":"numeric","3":"median","4":".all","5":"35.0000000","6":"35","_rn_":"43"},{"1":"Age","2":"numeric","3":"p75","4":".all","5":"38.0000000","6":"38","_rn_":"44"},{"1":"Age","2":"numeric","3":"p100","4":".all","5":"58.0000000","6":"58","_rn_":"45"},{"1":"Age","2":"numeric","3":"hist","4":".all","5":"NA","6":"▁▂▅▇▃▁▁▁","_rn_":"46"},{"1":"DODx","2":"numeric","3":"missing","4":".all","5":"52.0000000","6":"52","_rn_":"47"},{"1":"DODx","2":"numeric","3":"complete","4":".all","5":"108.0000000","6":"108","_rn_":"48"},{"1":"DODx","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"49"},{"1":"DODx","2":"numeric","3":"mean","4":".all","5":"2009.2685185","6":"2009.27","_rn_":"50"},{"1":"DODx","2":"numeric","3":"sd","4":".all","5":"4.6916240","6":"4.69","_rn_":"51"},{"1":"DODx","2":"numeric","3":"p0","4":".all","5":"1982.0000000","6":"1982","_rn_":"52"},{"1":"DODx","2":"numeric","3":"p25","4":".all","5":"2007.0000000","6":"2007","_rn_":"53"},{"1":"DODx","2":"numeric","3":"median","4":".all","5":"2010.0000000","6":"2010","_rn_":"54"},{"1":"DODx","2":"numeric","3":"p75","4":".all","5":"2012.0000000","6":"2012","_rn_":"55"},{"1":"DODx","2":"numeric","3":"p100","4":".all","5":"2015.0000000","6":"2015","_rn_":"56"},{"1":"DODx","2":"numeric","3":"hist","4":".all","5":"NA","6":"▁▁▁▁▁▃▆▇","_rn_":"57"},{"1":"Years_on_ART","2":"numeric","3":"missing","4":".all","5":"78.0000000","6":"78","_rn_":"58"},{"1":"Years_on_ART","2":"numeric","3":"complete","4":".all","5":"82.0000000","6":"82","_rn_":"59"},{"1":"Years_on_ART","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"60"},{"1":"Years_on_ART","2":"numeric","3":"mean","4":".all","5":"3.5648780","6":"3.56","_rn_":"61"},{"1":"Years_on_ART","2":"numeric","3":"sd","4":".all","5":"2.8349601","6":"2.83","_rn_":"62"},{"1":"Years_on_ART","2":"numeric","3":"p0","4":".all","5":"0.2500000","6":"0.25","_rn_":"63"},{"1":"Years_on_ART","2":"numeric","3":"p25","4":".all","5":"1.0000000","6":"1","_rn_":"64"},{"1":"Years_on_ART","2":"numeric","3":"median","4":".all","5":"3.0000000","6":"3","_rn_":"65"},{"1":"Years_on_ART","2":"numeric","3":"p75","4":".all","5":"5.0600000","6":"5.06","_rn_":"66"},{"1":"Years_on_ART","2":"numeric","3":"p100","4":".all","5":"13.0000000","6":"13","_rn_":"67"},{"1":"Years_on_ART","2":"numeric","3":"hist","4":".all","5":"NA","6":"▇▆▅▃▂▁▁▁","_rn_":"68"},{"1":"CD4","2":"numeric","3":"missing","4":".all","5":"67.0000000","6":"67","_rn_":"69"},{"1":"CD4","2":"numeric","3":"complete","4":".all","5":"93.0000000","6":"93","_rn_":"70"},{"1":"CD4","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"71"},{"1":"CD4","2":"numeric","3":"mean","4":".all","5":"251.5591398","6":"251.56","_rn_":"72"},{"1":"CD4","2":"numeric","3":"sd","4":".all","5":"179.1010440","6":"179.1","_rn_":"73"},{"1":"CD4","2":"numeric","3":"p0","4":".all","5":"3.0000000","6":"3","_rn_":"74"},{"1":"CD4","2":"numeric","3":"p25","4":".all","5":"153.0000000","6":"153","_rn_":"75"},{"1":"CD4","2":"numeric","3":"median","4":".all","5":"213.0000000","6":"213","_rn_":"76"},{"1":"CD4","2":"numeric","3":"p75","4":".all","5":"331.0000000","6":"331","_rn_":"77"},{"1":"CD4","2":"numeric","3":"p100","4":".all","5":"1186.0000000","6":"1186","_rn_":"78"},{"1":"CD4","2":"numeric","3":"hist","4":".all","5":"NA","6":"▅▇▃▁▁▁▁▁","_rn_":"79"},{"1":"CD4_recent","2":"numeric","3":"missing","4":".all","5":"33.0000000","6":"33","_rn_":"80"},{"1":"CD4_recent","2":"numeric","3":"complete","4":".all","5":"127.0000000","6":"127","_rn_":"81"},{"1":"CD4_recent","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"82"},{"1":"CD4_recent","2":"numeric","3":"mean","4":".all","5":"453.1811024","6":"453.18","_rn_":"83"},{"1":"CD4_recent","2":"numeric","3":"sd","4":".all","5":"239.2604816","6":"239.26","_rn_":"84"},{"1":"CD4_recent","2":"numeric","3":"p0","4":".all","5":"54.0000000","6":"54","_rn_":"85"},{"1":"CD4_recent","2":"numeric","3":"p25","4":".all","5":"275.0000000","6":"275","_rn_":"86"},{"1":"CD4_recent","2":"numeric","3":"median","4":".all","5":"424.0000000","6":"424","_rn_":"87"},{"1":"CD4_recent","2":"numeric","3":"p75","4":".all","5":"574.0000000","6":"574","_rn_":"88"},{"1":"CD4_recent","2":"numeric","3":"p100","4":".all","5":"1189.0000000","6":"1189","_rn_":"89"},{"1":"CD4_recent","2":"numeric","3":"hist","4":".all","5":"NA","6":"▃▇▇▇▃▁▁▁","_rn_":"90"},{"1":"HIV_stage","2":"numeric","3":"missing","4":".all","5":"96.0000000","6":"96","_rn_":"91"},{"1":"HIV_stage","2":"numeric","3":"complete","4":".all","5":"64.0000000","6":"64","_rn_":"92"},{"1":"HIV_stage","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"93"},{"1":"HIV_stage","2":"numeric","3":"mean","4":".all","5":"1.8125000","6":"1.81","_rn_":"94"},{"1":"HIV_stage","2":"numeric","3":"sd","4":".all","5":"0.9900297","6":"0.99","_rn_":"95"},{"1":"HIV_stage","2":"numeric","3":"p0","4":".all","5":"1.0000000","6":"1","_rn_":"96"},{"1":"HIV_stage","2":"numeric","3":"p25","4":".all","5":"1.0000000","6":"1","_rn_":"97"},{"1":"HIV_stage","2":"numeric","3":"median","4":".all","5":"1.0000000","6":"1","_rn_":"98"},{"1":"HIV_stage","2":"numeric","3":"p75","4":".all","5":"2.2500000","6":"2.25","_rn_":"99"},{"1":"HIV_stage","2":"numeric","3":"p100","4":".all","5":"4.0000000","6":"4","_rn_":"100"},{"1":"HIV_stage","2":"numeric","3":"hist","4":".all","5":"NA","6":"▇▁▃▁▁▂▁▁","_rn_":"101"},{"1":"HIV_mx","2":"character","3":"missing","4":".all","5":"4.0000000","6":"4","_rn_":"102"},{"1":"HIV_mx","2":"character","3":"complete","4":".all","5":"156.0000000","6":"156","_rn_":"103"},{"1":"HIV_mx","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"104"},{"1":"HIV_mx","2":"character","3":"min","4":".all","5":"10.0000000","6":"10","_rn_":"105"},{"1":"HIV_mx","2":"character","3":"max","4":".all","5":"11.0000000","6":"11","_rn_":"106"},{"1":"HIV_mx","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"107"},{"1":"HIV_mx","2":"character","3":"n_unique","4":".all","5":"3.0000000","6":"3","_rn_":"108"},{"1":"Years of schooling","2":"numeric","3":"missing","4":".all","5":"4.0000000","6":"4","_rn_":"109"},{"1":"Years of schooling","2":"numeric","3":"complete","4":".all","5":"156.0000000","6":"156","_rn_":"110"},{"1":"Years of schooling","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"111"},{"1":"Years of schooling","2":"numeric","3":"mean","4":".all","5":"8.6923077","6":"8.69","_rn_":"112"},{"1":"Years of schooling","2":"numeric","3":"sd","4":".all","5":"3.2261340","6":"3.23","_rn_":"113"},{"1":"Years of schooling","2":"numeric","3":"p0","4":".all","5":"0.0000000","6":"0","_rn_":"114"},{"1":"Years of schooling","2":"numeric","3":"p25","4":".all","5":"7.0000000","6":"7","_rn_":"115"},{"1":"Years of schooling","2":"numeric","3":"median","4":".all","5":"9.0000000","6":"9","_rn_":"116"},{"1":"Years of schooling","2":"numeric","3":"p75","4":".all","5":"11.0000000","6":"11","_rn_":"117"},{"1":"Years of schooling","2":"numeric","3":"p100","4":".all","5":"12.0000000","6":"12","_rn_":"118"},{"1":"Years of schooling","2":"numeric","3":"hist","4":".all","5":"NA","6":"▁▁▁▂▂▅▂▇","_rn_":"119"},{"1":"SOS_mnemonic","2":"character","3":"missing","4":".all","5":"47.0000000","6":"47","_rn_":"120"},{"1":"SOS_mnemonic","2":"character","3":"complete","4":".all","5":"113.0000000","6":"113","_rn_":"121"},{"1":"SOS_mnemonic","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"122"},{"1":"SOS_mnemonic","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"123"},{"1":"SOS_mnemonic","2":"character","3":"max","4":".all","5":"3.0000000","6":"3","_rn_":"124"},{"1":"SOS_mnemonic","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"125"},{"1":"SOS_mnemonic","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"126"},{"1":"Occupation","2":"character","3":"missing","4":".all","5":"3.0000000","6":"3","_rn_":"127"},{"1":"Occupation","2":"character","3":"complete","4":".all","5":"157.0000000","6":"157","_rn_":"128"},{"1":"Occupation","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"129"},{"1":"Occupation","2":"character","3":"min","4":".all","5":"8.0000000","6":"8","_rn_":"130"},{"1":"Occupation","2":"character","3":"max","4":".all","5":"33.0000000","6":"33","_rn_":"131"},{"1":"Occupation","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"132"},{"1":"Occupation","2":"character","3":"n_unique","4":".all","5":"5.0000000","6":"5","_rn_":"133"},{"1":"Adjuvant","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"134"},{"1":"Adjuvant","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"135"},{"1":"Adjuvant","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"136"},{"1":"Adjuvant","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"137"},{"1":"Adjuvant","2":"character","3":"max","4":".all","5":"3.0000000","6":"3","_rn_":"138"},{"1":"Adjuvant","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"139"},{"1":"Adjuvant","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"140"},{"1":"NSAID","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"141"},{"1":"NSAID","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"142"},{"1":"NSAID","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"143"},{"1":"NSAID","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"144"},{"1":"NSAID","2":"character","3":"max","4":".all","5":"3.0000000","6":"3","_rn_":"145"},{"1":"NSAID","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"146"},{"1":"NSAID","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"147"},{"1":"Paracetamol","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"148"},{"1":"Paracetamol","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"149"},{"1":"Paracetamol","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"150"},{"1":"Paracetamol","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"151"},{"1":"Paracetamol","2":"character","3":"max","4":".all","5":"3.0000000","6":"3","_rn_":"152"},{"1":"Paracetamol","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"153"},{"1":"Paracetamol","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"154"},{"1":"Mild_opioid","2":"character","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"155"},{"1":"Mild_opioid","2":"character","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"156"},{"1":"Mild_opioid","2":"character","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"157"},{"1":"Mild_opioid","2":"character","3":"min","4":".all","5":"2.0000000","6":"2","_rn_":"158"},{"1":"Mild_opioid","2":"character","3":"max","4":".all","5":"3.0000000","6":"3","_rn_":"159"},{"1":"Mild_opioid","2":"character","3":"empty","4":".all","5":"0.0000000","6":"0","_rn_":"160"},{"1":"Mild_opioid","2":"character","3":"n_unique","4":".all","5":"2.0000000","6":"2","_rn_":"161"},{"1":"WHO_level","2":"numeric","3":"missing","4":".all","5":"0.0000000","6":"0","_rn_":"162"},{"1":"WHO_level","2":"numeric","3":"complete","4":".all","5":"160.0000000","6":"160","_rn_":"163"},{"1":"WHO_level","2":"numeric","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"164"},{"1":"WHO_level","2":"numeric","3":"mean","4":".all","5":"0.3875000","6":"0.39","_rn_":"165"},{"1":"WHO_level","2":"numeric","3":"sd","4":".all","5":"0.5259014","6":"0.53","_rn_":"166"},{"1":"WHO_level","2":"numeric","3":"p0","4":".all","5":"0.0000000","6":"0","_rn_":"167"},{"1":"WHO_level","2":"numeric","3":"p25","4":".all","5":"0.0000000","6":"0","_rn_":"168"},{"1":"WHO_level","2":"numeric","3":"median","4":".all","5":"0.0000000","6":"0","_rn_":"169"},{"1":"WHO_level","2":"numeric","3":"p75","4":".all","5":"1.0000000","6":"1","_rn_":"170"},{"1":"WHO_level","2":"numeric","3":"p100","4":".all","5":"2.0000000","6":"2","_rn_":"171"},{"1":"WHO_level","2":"numeric","3":"hist","4":".all","5":"NA","6":"▇▁▁▅▁▁▁▁","_rn_":"172"},{"1":"Years_education","2":"factor","3":"missing","4":".all","5":"2.0000000","6":"2","_rn_":"173"},{"1":"Years_education","2":"factor","3":"complete","4":".all","5":"158.0000000","6":"158","_rn_":"174"},{"1":"Years_education","2":"factor","3":"n","4":".all","5":"160.0000000","6":"160","_rn_":"175"},{"1":"Years_education","2":"factor","3":"n_unique","4":".all","5":"13.0000000","6":"13","_rn_":"176"},{"1":"Years_education","2":"factor","3":"top_counts","4":"12","5":"37.0000000","6":"12: 37","_rn_":"177"},{"1":"Years_education","2":"factor","3":"top_counts","4":"9","5":"24.0000000","6":"9: 24","_rn_":"178"},{"1":"Years_education","2":"factor","3":"top_counts","4":"11","5":"20.0000000","6":"11: 20","_rn_":"179"},{"1":"Years_education","2":"factor","3":"top_counts","4":"10","5":"17.0000000","6":"10: 17","_rn_":"180"},{"1":"Years_education","2":"factor","3":"top_counts","4":"8","5":"14.0000000","6":"8: 14","_rn_":"181"},{"1":"Years_education","2":"factor","3":"top_counts","4":"7","5":"12.0000000","6":"7: 12","_rn_":"182"},{"1":"Years_education","2":"factor","3":"top_counts","4":"6","5":"8.0000000","6":"6: 8","_rn_":"183"},{"1":"Years_education","2":"factor","3":"top_counts","4":"0","5":"6.0000000","6":"0: 6","_rn_":"184"},{"1":"Years_education","2":"factor","3":"top_counts","4":"2","5":"5.0000000","6":"2: 5","_rn_":"185"},{"1":"Years_education","2":"factor","3":"top_counts","4":"4","5":"5.0000000","6":"4: 5","_rn_":"186"},{"1":"Years_education","2":"factor","3":"top_counts","4":"3","5":"4.0000000","6":"3: 4","_rn_":"187"},{"1":"Years_education","2":"factor","3":"top_counts","4":"5","5":"4.0000000","6":"5: 4","_rn_":"188"},{"1":"Years_education","2":"factor","3":"top_counts","4":"12+","5":"2.0000000","6":"12+: 2","_rn_":"189"},{"1":"Years_education","2":"factor","3":"top_counts","4":"NA","5":"2.0000000","6":"NA: 2","_rn_":"190"},{"1":"Years_education","2":"factor","3":"top_counts","4":"1","5":"0.0000000","6":"1: 0","_rn_":"191"},{"1":"Years_education","2":"factor","3":"ordered","4":".all","5":"1.0000000","6":"TRUE","_rn_":"192"}],"options":{"columns":{"min":{},"max":[10]},"rows":{"min":[10],"max":[10]},"pages":{}}}
  </script>
</div>

----

# Sample size


```r
# Sample size by study site
demo %>%
    group_by(Site) %>%
    summarise(count = n()) %>%
    knitr::kable(., 
                 caption = 'Sample size by study site', 
                 col.names = c('Site', 'Count'))
```



Table: Sample size by study site

Site    Count
-----  ------
R1         47
R2         49
U1         47
U2         17

```r
# Sample size by study site and intervention group
demo %>%
    group_by(Site, Group) %>%
    summarise(count = n()) %>%
    group_by(Site) %>%
    mutate(percent = round(count / sum(count) * 100, 1)) %>%
    knitr::kable(., 
                 caption = 'Sample size by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Count', 
                               'Percent (by site)'))
```



Table: Sample size by intervention group at each study site

Site   Group    Count   Percent (by site)
-----  ------  ------  ------------------
R1     P           28                59.6
R1     T           19                40.4
R2     P           26                53.1
R2     T           23                46.9
U1     P           24                51.1
U1     T           23                48.9
U2     P           10                58.8
U2     T            7                41.2

----

# Sex


```r
# Sex by study site
demo %>%
    group_by(Site, Sex) %>%
    summarise(count = sum(!is.na(Sex)),
              missing = sum(is.na(Sex))) %>%
    group_by(Site) %>%
    mutate(percent = round(count / sum(count) * 100, 1)) %>%
    knitr::kable(., 
                 caption = 'Self-identified sex by study site',
                 col.names = c('Site', 'Sex', 'Count', 'Missing', 
                               'Percent (by site)'))
```



Table: Self-identified sex by study site

Site   Sex       Count   Missing   Percent (by site)
-----  -------  ------  --------  ------------------
R1     male         47         0                 100
R2     female       49         0                 100
U1     female       31         0                  66
U1     male         16         0                  34
U2     female       17         0                 100

```r
# Plot 
ggplot(data = demo) +
    aes(x = Site,
        fill = Sex) +
    geom_bar(position = position_fill()) +
    labs(title = 'Participant sex (self-identified)',
         subtitle = 'Conditioned on study site',
         y = 'Proportion',
         x = 'Study site') +
    scale_fill_brewer(name = 'Sex: ',
                      type = 'qual',
                      palette = 'Dark2') +
    theme(legend.position = 'top')
```

<img src="figures/descriptive-demographics/sex-1.png" width="672" style="display: block; margin: auto;" />

```r
# Sex by study site and intervention group
demo %>%
    group_by(Site, Group, Sex) %>%
    summarise(count = sum(!is.na(Sex)),
              missing = sum(is.na(Sex))) %>%
    group_by(Site) %>%
    mutate(sum = sum(count)) %>%
    mutate(percent = round(count / sum(count) * 100, 1)) %>%
    select(-sum) %>%
    knitr::kable(., 
                 caption = 'Self-identified sex by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Sex', 'Count', 
                               'Missing', 'Percent (by site)'))
```



Table: Self-identified sex by intervention group at each study site

Site   Group   Sex       Count   Missing   Percent (by site)
-----  ------  -------  ------  --------  ------------------
R1     P       male         28         0                59.6
R1     T       male         19         0                40.4
R2     P       female       26         0                53.1
R2     T       female       23         0                46.9
U1     P       female       13         0                27.7
U1     P       male         11         0                23.4
U1     T       female       18         0                38.3
U1     T       male          5         0                10.6
U2     P       female       10         0                58.8
U2     T       female        7         0                41.2

```r
# Plot 
ggplot(data = demo) +
    aes(x = Group,
        fill = Sex) +
    geom_bar(position = position_fill()) +
    labs(title = 'Participant sex (self-identified)',
         subtitle = 'Conditioned on intervention group and study site',
         y = 'Proportion',
         x = 'Intervention group') +
    scale_fill_brewer(name = 'Sex: ',
                      type = 'qual',
                      palette = 'Dark2') +
    facet_wrap(~ Site, 
               ncol = 4, 
               labeller = label_both) +
    theme(legend.position = 'top')
```

<img src="figures/descriptive-demographics/sex-2.png" width="672" style="display: block; margin: auto;" />

----

# Age


```r
# Age by study site
demo %>%
    group_by(Site) %>%
    summarise(count = sum(!is.na(Age)),
              missing = sum(is.na(Age)),
              mean = round(mean(Age), 1),
              sd = round(sd(Age), 1),
              range = paste0(round(min(Age), 2), ' - ', 
                             round(max(Age), 2))) %>%
    knitr::kable(., 
                 caption = 'Age (years) by study site',
                 col.names = c('Site', 'Count', 'Missing', 'Mean', 
                               'SD', 'Range'),
                 align = 'lrrrrr')
```



Table: Age (years) by study site

Site    Count   Missing   Mean    SD     Range
-----  ------  --------  -----  ----  --------
R1         47         0   35.3   3.0   28 - 40
R2         49         0   32.9   4.6   18 - 40
U1         47         0   39.3   6.3   27 - 58
U2         17         0   30.4   4.8   23 - 37

```r
# Plot 
ggplot(data = demo) +
    aes(y = Age,
        x = Site) +
    geom_boxplot(fill = '#666666',
                 colour = '#000000') +
    labs(title = 'Participant age',
         subtitle = 'Conditioned on study site',
         y = 'Age (years)',
         x = 'Study site') +
    theme(legend.position = 'none')
```

<img src="figures/descriptive-demographics/age-1.png" width="672" style="display: block; margin: auto;" />

```r
# Age by study site and intervention group
demo %>%
    group_by(Site, Group) %>%
    summarise(count = sum(!is.na(Age)),
              missing = sum(is.na(Age)),
              mean = round(mean(Age), 1),
              sd = round(sd(Age), 1),
              range = paste0(round(min(Age), 2), ' - ', 
                             round(max(Age), 2))) %>%
    knitr::kable(., 
                 caption = 'Age (years) by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Count', 'Missing', 
                               'Mean', 'SD', 'Range'),
                 align = 'llrrrrr')
```



Table: Age (years) by intervention group at each study site

Site   Group    Count   Missing   Mean    SD     Range
-----  ------  ------  --------  -----  ----  --------
R1     P           28         0   35.6   2.7   31 - 40
R1     T           19         0   34.7   3.4   28 - 40
R2     P           26         0   33.3   5.0   18 - 40
R2     T           23         0   32.4   4.2   23 - 40
U1     P           24         0   39.1   7.1   27 - 58
U1     T           23         0   39.6   5.4   30 - 49
U2     P           10         0   29.1   5.3   23 - 37
U2     T            7         0   32.3   3.5   26 - 36

```r
# Plot 
ggplot(data = demo) +
    aes(y = Age,
        x = Group,
        fill = Group) +
    geom_boxplot(position = position_dodge(0)) +
    labs(title = 'Participant age',
         subtitle = 'Conditioned on intervention group and study site',
         y = 'Age (years)',
         x = 'Intervention group') +
    scale_fill_brewer(name = 'Intervention group: ',
                      type = 'qual',
                      palette = 'Dark2') +
    facet_wrap(~ Site, 
               ncol = 4, 
               labeller = label_both) +
    theme(legend.position = 'top')
```

<img src="figures/descriptive-demographics/age-2.png" width="672" style="display: block; margin: auto;" />

----

# CD4 T-cell count

### First recorded CD4


```r
# First CD4 by study site
demo %>%
    group_by(Site) %>%
    summarise(count = sum(!is.na(CD4)),
              missing = sum(is.na(CD4)),
              median = round(median(CD4, na.rm = TRUE)),
              IQR = paste0(round(quantile(CD4, prob = 0.25, na.rm = TRUE)), ' - ', 
                           round(quantile(CD4, prob = 0.75, na.rm = TRUE)))) %>%
    knitr::kable(., 
                 caption = 'First recorded CD4 (cells/ul) by study site',
                 col.names = c('Site', 'Count', 'Missing','Median', 'IQR'),
                 align = 'lrrrr')
```



Table: First recorded CD4 (cells/ul) by study site

Site    Count   Missing   Median         IQR
-----  ------  --------  -------  ----------
R1          0        47       NA     NA - NA
R2         39        10      220   180 - 284
U1         38         9      178   104 - 264
U2         16         1      420   194 - 524

```r
# Plot
ggplot(data = demo) +
    aes(y = CD4,
        x = Site) +
    geom_boxplot(fill = '#666666',
                 colour = '#000000') +
    labs(title = 'First recorded CD4 T-cell count',
         subtitle = 'Conditioned on study site',
         caption = '(Missing data: see table for details)',
         y = expression(CD4~count~(cells/mu*l)),
         x = 'Study site') +
    theme(legend.position = 'none')
```

<img src="figures/descriptive-demographics/first_cd4-1.png" width="672" style="display: block; margin: auto;" />

```r
# First CD4 by study site and intervention group
demo %>%
    group_by(Site, Group) %>%
    summarise(count = sum(!is.na(CD4)),
              missing = sum(is.na(CD4)),
              median = round(median(CD4, na.rm = TRUE)),
              IQR = paste0(round(quantile(CD4, prob = 0.25, na.rm = TRUE)), ' - ', 
                           round(quantile(CD4, prob = 0.75, na.rm = TRUE)))) %>%
    knitr::kable(., 
                 caption = 'First recorded CD4 (cells/ul) by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Count', 'Missing', 
                               'Median', 'IQR'),
                 align = 'llrrrr')
```



Table: First recorded CD4 (cells/ul) by intervention group at each study site

Site   Group    Count   Missing   Median         IQR
-----  ------  ------  --------  -------  ----------
R1     P            0        28       NA     NA - NA
R1     T            0        19       NA     NA - NA
R2     P           23         3      207   170 - 266
R2     T           16         7      232   213 - 332
U1     P           18         6      152    60 - 206
U1     T           20         3      206   115 - 330
U2     P           10         0      434   168 - 607
U2     T            6         1      402   300 - 452

```r
# Plot
ggplot(data = demo) +
    aes(y = CD4,
        x = Group,
        fill = Group) +
    geom_boxplot(position = position_dodge(0)) +
    labs(title = 'First recorded CD4 T-cell count',
         subtitle = 'Conditioned on intervention group and study site',
         caption = '(Missing data: see table for details)',
         y = expression(CD4~count~(cells/mu*l)),
         x = 'Group') +
    scale_fill_brewer(name = 'Intervention group: ',
                      type = 'qual',
                      palette = 'Dark2') +
    facet_wrap(~ Site, 
               ncol = 4, 
               labeller = label_both) +
    theme(legend.position = 'top')
```

<img src="figures/descriptive-demographics/first_cd4-2.png" width="672" style="display: block; margin: auto;" />

### Latest CD4 (baseline)


```r
# Latest CD4 by study site
demo %>%
    group_by(Site) %>%
    summarise(count = sum(!is.na(CD4_recent)),
              missing = sum(is.na(CD4_recent)),
              median = round(median(CD4_recent, na.rm = TRUE)),
              IQR = paste0(round(quantile(CD4_recent, prob = 0.25, na.rm = TRUE)), ' - ', 
                           round(quantile(CD4_recent, prob = 0.75, na.rm = TRUE)))) %>%
    knitr::kable(., 
                 caption = 'Latest recorded CD4 (cells/ul) by study site',
                 col.names = c('Site', 'Count','Missing', 'Median', 'IQR'),
                 align = 'lrrrr')
```



Table: Latest recorded CD4 (cells/ul) by study site

Site    Count   Missing   Median         IQR
-----  ------  --------  -------  ----------
R1         47         0      397   278 - 538
R2         46         3      414   273 - 566
U1         17        30      368   256 - 667
U2         17         0      471   414 - 648

```r
# Plot
ggplot(data = demo) +
    aes(y = CD4_recent,
        x = Site) +
    geom_boxplot(fill = '#666666',
                 colour = '#000000') +
    labs(title = 'Latest recorded CD4 T-cell count',
         subtitle = 'Conditioned on study site',
         caption = '(Missing data: see tables for details)',
         y = expression(CD4~count~(cells/mu*l)),
         x = 'Study site') +
    theme(legend.position = 'none')
```

<img src="figures/descriptive-demographics/latest_cd4-1.png" width="672" style="display: block; margin: auto;" />

```r
# Latest CD4 by study site and intervention group
demo %>%
    group_by(Site, Group) %>%
    summarise(count = sum(!is.na(CD4_recent)),
              missing = sum(is.na(CD4_recent)),
              median = round(median(CD4_recent, na.rm = TRUE)),
              IQR = paste0(round(quantile(CD4_recent, prob = 0.25, na.rm = TRUE)), ' - ', 
                           round(quantile(CD4_recent, prob = 0.75, na.rm = TRUE)))) %>%
    knitr::kable(., 
                 caption = 'Latest recorded CD4 (cells/ul) by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Count', 'Missing', 
                               'Median', 'IQR'),
                 align = 'llrrrr')
```



Table: Latest recorded CD4 (cells/ul) by intervention group at each study site

Site   Group    Count   Missing   Median         IQR
-----  ------  ------  --------  -------  ----------
R1     P           28         0      386   304 - 501
R1     T           19         0      424   262 - 593
R2     P           26         0      438   288 - 648
R2     T           20         3      406   265 - 516
U1     P            4        20      300   253 - 388
U1     T           13        10      445   256 - 728
U2     P           10         0      477   424 - 636
U2     T            7         0      457   402 - 630

```r
# Plot
ggplot(data = demo) +
    aes(y = CD4_recent,
        x = Group,
        fill = Group) +
    geom_boxplot(position = position_dodge(0)) +
    labs(title = 'Latest recorded CD4 T-cell count',
         subtitle = 'Conditioned on intervention group and study site',
         caption = '(Missing data: see tables for details)',
         y = expression(CD4~count~(cells/mu*l)),
         x = 'Group') +
    scale_fill_brewer(name = 'Intervention group: ',
                      type = 'qual',
                      palette = 'Dark2') +
    facet_wrap(~ Site, 
               ncol = 4, 
               labeller = label_both) +
    theme(legend.position = 'top') 
```

<img src="figures/descriptive-demographics/latest_cd4-2.png" width="672" style="display: block; margin: auto;" />

----

# Employment status


```r
# Occupation by study site
demo %>%
    group_by(Site, Occupation) %>%
    summarise(count = sum(!is.na(Occupation)),
              missing = sum(is.na(Occupation))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1)) %>%
    mutate(count = case_when(
        count > missing ~ count,
        TRUE ~ missing
        ),
        percent = case_when(
            percent > 0 ~ as.character(percent),
            TRUE ~ '-'
            ),
        Occupation = case_when(
        is.na(Occupation) ~ 'missing data',
        TRUE ~ Occupation
        )) %>% 
    select(-missing) %>% 
    knitr::kable(., 
                 caption = 'Employment status by study site',
                 col.names = c('Site', 'Employment status', 'Count', 'Percent'),
                 align = 'llrr')
```



Table: Employment status by study site

Site   Employment status                    Count   Percent
-----  ----------------------------------  ------  --------
R1     employed                                21      46.7
R1     unable to work - disability grant        4       8.9
R1     unemployed - looking for work           16      35.6
R1     unemployed - not looking for work        4       8.9
R1     missing data                             2         -
R2     employed                                 8      16.3
R2     unable to work - disability grant        1         2
R2     unemployed - looking for work           17      34.7
R2     unemployed - not looking for work       23      46.9
U1     employed                                19      41.3
U1     student/volunteer                        1       2.2
U1     unable to work - disability grant        1       2.2
U1     unemployed - looking for work           23        50
U1     unemployed - not looking for work        2       4.3
U1     missing data                             1         -
U2     employed                                 3      17.6
U2     student/volunteer                        1       5.9
U2     unable to work - disability grant        2      11.8
U2     unemployed - looking for work            8      47.1
U2     unemployed - not looking for work        3      17.6

```r
# Plot 
demo %>%
    filter(!is.na(Occupation)) %>%
    ggplot(data = .) +
    aes(x = Site,
        colour = Occupation,
        fill = Occupation) +
    geom_bar(position = position_fill()) +
    labs(title = 'Employment status',
         subtitle = 'Conditioned on study site',
         caption = '(Missing data: see table for details)',
         y = 'Proportion',
         x = 'Study site') +
    scale_fill_brewer(name = 'Employment status: ',
                      type = 'qual',
                      palette = 'Dark2') +
    scale_colour_brewer(name = 'Employment status: ',
                        type = 'qual',
                        palette = 'Dark2') 
```

<img src="figures/descriptive-demographics/occupation-1.png" width="960" style="display: block; margin: auto;" />

```r
# Occupation by study site and intervention group
demo %>%
    group_by(Site, Group, Occupation) %>%
    summarise(count = sum(!is.na(Occupation)),
              missing = sum(is.na(Occupation))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1)) %>%
    mutate(count = case_when(
        count > missing ~ count,
        TRUE ~ missing
        ),
        percent = case_when(
            percent > 0 ~ as.character(percent),
            TRUE ~ '-'
            ),
        Occupation = case_when(
        is.na(Occupation) ~ 'missing data',
        TRUE ~ Occupation
        )) %>% 
    select(-missing) %>% 
    knitr::kable(., 
                 caption = 'Employment status by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Employment status', 
                               'Count', 'Percent'),
                 align = 'lllrr')
```



Table: Employment status by intervention group at each study site

Site   Group   Employment status                    Count   Percent
-----  ------  ----------------------------------  ------  --------
R1     P       employed                                15      33.3
R1     P       unable to work - disability grant        3       6.7
R1     P       unemployed - looking for work            7      15.6
R1     P       unemployed - not looking for work        2       4.4
R1     P       missing data                             1         -
R1     T       employed                                 6      13.3
R1     T       unable to work - disability grant        1       2.2
R1     T       unemployed - looking for work            9        20
R1     T       unemployed - not looking for work        2       4.4
R1     T       missing data                             1         -
R2     P       employed                                 5      10.2
R2     P       unemployed - looking for work            9      18.4
R2     P       unemployed - not looking for work       12      24.5
R2     T       employed                                 3       6.1
R2     T       unable to work - disability grant        1         2
R2     T       unemployed - looking for work            8      16.3
R2     T       unemployed - not looking for work       11      22.4
U1     P       employed                                 8      17.4
U1     P       student/volunteer                        1       2.2
U1     P       unable to work - disability grant        1       2.2
U1     P       unemployed - looking for work           13      28.3
U1     P       unemployed - not looking for work        1       2.2
U1     T       employed                                11      23.9
U1     T       unemployed - looking for work           10      21.7
U1     T       unemployed - not looking for work        1       2.2
U1     T       missing data                             1         -
U2     P       employed                                 1       5.9
U2     P       student/volunteer                        1       5.9
U2     P       unable to work - disability grant        2      11.8
U2     P       unemployed - looking for work            6      35.3
U2     T       employed                                 2      11.8
U2     T       unemployed - looking for work            2      11.8
U2     T       unemployed - not looking for work        3      17.6

```r
# Plot
demo %>%
    filter(!is.na(Occupation)) %>%
    ggplot(data = .) +
    aes(x = Group,
        fill = Occupation) +
    geom_bar(position = position_fill()) +
    labs(title = 'Employment status',
         subtitle = 'Conditioned on intervention group and study site',
         caption = '(Missing data: see table for details)',
         y = 'Proportion',
         x = 'Group') +
    scale_fill_brewer(name = 'Employment status: ',
                      type = 'qual',
                      palette = 'Dark2') +
    facet_wrap(~ Site, 
               ncol = 4, 
               labeller = label_both)
```

<img src="figures/descriptive-demographics/occupation-2.png" width="960" style="display: block; margin: auto;" />

----

# Years of education


```r
# Education by study site
## R1
demo %>%
    filter(Site == 'R1') %>%
    group_by(Site, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), '12+'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'R1: Years of education by study site',
                 col.names = c('Years of education', 'Count', 'Percent'),
                 align = 'lrr')
```



Table: R1: Years of education by study site

Years of education    Count   Percent
-------------------  ------  --------
0                         1       2.1
2                         2       4.3
3                         2       4.3
4                         2       4.3
6                         3       6.4
7                         7      14.9
8                         3       6.4
9                         3       6.4
10                        5      10.6
11                        8      17.0
12                       11      23.4

```r
## R2
demo %>%
    filter(Site == 'R2') %>%
   group_by(Site, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), '12+'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'R2: Years of education by study site',
                 col.names = c('Years of education', 'Count', 'Percent'),
                 align = 'lrr')
```



Table: R2: Years of education by study site

Years of education    Count   Percent
-------------------  ------  --------
0                         4       8.2
3                         2       4.1
4                         3       6.1
5                         4       8.2
6                         4       8.2
7                         2       4.1
8                         4       8.2
9                        13      26.5
10                        2       4.1
11                        4       8.2
12                        7      14.3

```r
## U1
demo %>%
    filter(Site == 'U1') %>%
    group_by(Site, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), 
                                               '12+', 'Missing data'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'U1: Years of education by study site',
                 col.names = c('Years of education', 'Count', 'Percent'),
                 align = 'lrr')
```



Table: U1: Years of education by study site

Years of education    Count   Percent
-------------------  ------  --------
2                         1       2.2
6                         1       2.2
8                         5      11.1
9                         4       8.9
10                        6      13.3
11                        8      17.8
12                       18      40.0
12+                       2       4.4
Missing data              2         -

```r
## U2
demo %>%
    filter(Site == 'U2') %>%
    group_by(Site, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), 
                                               '12+', 'Missing data'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'U2: Years of education by study site',
                 col.names = c('Years of education', 'Count', 'Percent'),
                 align = 'lrr')
```



Table: U2: Years of education by study site

Years of education    Count   Percent
-------------------  ------  --------
0                         1       5.9
2                         2      11.8
7                         3      17.6
8                         2      11.8
9                         4      23.5
10                        4      23.5
12                        1       5.9

```r
# Plot
demo %>%
    filter(!is.na(Years_education)) %>%
    group_by(Site, Years_education) %>% 
    summarise(count = n()) %>%
    group_by(Site) %>% 
    mutate(proportion = count / sum(count)) %>% 
    ggplot(data = .) +
    aes(y = proportion,
        x = Years_education) +
    geom_bar(stat = 'identity') +
    labs(title = 'Years of education', 
         subtitle = 'Conditioned on study site',
         caption = '(Missing data: see tables for details)',
         x = 'Years of educations',
         y = 'Proportion') +
    facet_wrap(~ Site,
               ncol = 4,
               labeller = label_both)
```

<img src="figures/descriptive-demographics/education1-1.png" width="960" style="display: block; margin: auto;" />


```r
# Education by intervention group at each study site
## R1
demo %>%
    filter(Site == 'R1') %>%
    group_by(Site, Group, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), 
                                               '12+', 'Missing data'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'R1: Years of education by study site',
                 col.names = c('Years of education', 'Group', 'Count', 'Percent'),
                 align = 'llrr')
```



Table: R1: Years of education by study site

Years of education   Group    Count   Percent
-------------------  ------  ------  --------
P                    0            1       2.1
P                    2            1       2.1
P                    3            1       2.1
P                    4            1       2.1
P                    6            3       6.4
P                    7            4       8.5
P                    8            2       4.3
P                    9            2       4.3
P                    10           2       4.3
P                    11           4       8.5
P                    12           7      14.9
T                    2            1       2.1
T                    3            1       2.1
T                    4            1       2.1
T                    7            3       6.4
T                    8            1       2.1
T                    9            1       2.1
T                    10           3       6.4
T                    11           4       8.5
T                    12           4       8.5

```r
## R2
demo %>%
    filter(Site == 'R2') %>%
    group_by(Site, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), 
                                               '12+', 'Missing data'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'R2: Years of education by study site',
                 col.names = c('Years of education', 'Count', 'Percent'),
                 align = 'lrr')
```



Table: R2: Years of education by study site

Years of education    Count   Percent
-------------------  ------  --------
0                         4       8.2
3                         2       4.1
4                         3       6.1
5                         4       8.2
6                         4       8.2
7                         2       4.1
8                         4       8.2
9                        13      26.5
10                        2       4.1
11                        4       8.2
12                        7      14.3

```r
## U1
demo %>%
    filter(Site == 'U1') %>%
    group_by(Site, Group, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), 
                                               '12+', 'Missing data'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'U1: Years of education by study site',
                 col.names = c('Years of education', 'Group', 'Count', 'Percent'),
                 align = 'llrr')
```



Table: U1: Years of education by study site

Years of education   Group           Count   Percent
-------------------  -------------  ------  --------
P                    2                   1       2.2
P                    6                   1       2.2
P                    8                   4       8.9
P                    9                   1       2.2
P                    10                  2       4.4
P                    11                  4       8.9
P                    12                 10      22.2
P                    12+                 1       2.2
T                    8                   1       2.2
T                    9                   3       6.7
T                    10                  4       8.9
T                    11                  4       8.9
T                    12                  8      17.8
T                    12+                 1       2.2
T                    Missing data        2         -

```r
## U2
demo %>%
    filter(Site == 'U2') %>%
    group_by(Site, Group, Years_education) %>%
    summarise(count = sum(!is.na(Years_education)),
              missing = sum(is.na(Years_education))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(Years_education = as.character(Years_education),
           Years_education = case_when(
        is.na(Years_education) ~ 'Missing data',
        TRUE ~ Years_education
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == '0.0' ~ '-',
            TRUE ~ percent
        )) %>% 
    ungroup() %>% 
    select(-Site, -missing) %>% 
    mutate(Years_education = factor(Years_education,
                                    levels = c(as.character(0:12), 
                                               '12+', 'Missing data'),
                                    ordered = TRUE)) %>% 
    knitr::kable(., 
                 caption = 'U2: Years of education by study site',
                 col.names = c('Years of education', 'Group', 'Count', 'Percent'),
                 align = 'llrr')
```



Table: U2: Years of education by study site

Years of education   Group    Count   Percent
-------------------  ------  ------  --------
P                    2            1       5.9
P                    8            2      11.8
P                    9            4      23.5
P                    10           2      11.8
P                    12           1       5.9
T                    0            1       5.9
T                    2            1       5.9
T                    7            3      17.6
T                    10           2      11.8

```r
# Plot
demo %>%
    filter(!is.na(Years_education)) %>%
    group_by(Site, Group, Years_education) %>% 
    summarise(count = n()) %>%
    group_by(Site, Group) %>% 
    mutate(proportion = count / sum(count)) %>% 
    ggplot(data = .) +
    aes(y = proportion,
        x = Years_education,
        fill = Group) +
    geom_bar(stat = 'identity') +
    labs(title = 'Years of education', 
         subtitle = 'Conditioned on intervention group and study site',
         caption = '(Missing data: see tables for details)',
         x = 'Years of educations',
         y = 'Proportion') +
    scale_fill_brewer(type = 'qual',
                      palette = 'Dark2') +
    facet_grid(Group ~ Site,
               labeller = label_both) +
    theme(legend.position = 'none')
```

<img src="figures/descriptive-demographics/education2-1.png" width="960" style="display: block; margin: auto;" />

----

# SOS health literacy


```r
# Health literacy by study site
demo %>%
    group_by(Site, SOS_mnemonic) %>%
    summarise(count = sum(!is.na(SOS_mnemonic)),
              missing = sum(is.na(SOS_mnemonic))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(SOS_mnemonic = case_when(
        is.na(SOS_mnemonic) ~ 'Missing data',
        TRUE ~ SOS_mnemonic
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == 'NaN' ~ '-',
            TRUE ~ percent
        )) %>% 
    mutate(SOS_mnemonic = factor(SOS_mnemonic,
                                 levels = c('hl', 'lhl', 'Missing data')),
           SOS_mnemonic = fct_recode(SOS_mnemonic,
                                     'Health literate' = 'hl',
                                     'Low health literacy' = 'lhl')) %>%
    select(-missing) %>% 
    knitr::kable(., 
                 caption = 'SOS health literacy by study site',
                 col.names = c('Site', 'Literacy state', 'Count', 'Percent'),
                 align = 'llrr')
```



Table: SOS health literacy by study site

Site   Literacy state         Count   Percent
-----  --------------------  ------  --------
R1     Health literate           28      59.6
R1     Low health literacy       19      40.4
R2     Low health literacy       49     100.0
U1     Missing data              47         -
U2     Health literate            7      41.2
U2     Low health literacy       10      58.8

```r
# Plot 
demo %>%
    filter(!is.na(SOS_mnemonic)) %>%
    ggplot(data = .) +
    aes(x = Site,
        colour = SOS_mnemonic,
        fill = SOS_mnemonic) +
    geom_bar(position = position_fill()) +
    labs(title = 'Health literacy',
         subtitle = 'Conditioned on study site',
         caption = 'Missing data: see tables for details',
         y = 'Proportion',
         x = 'Study site') +
    scale_fill_brewer(name = 'Literacy status: ',
                      labels = c('Health literate', 'Low health literacy'),
                      type = 'qual',
                      palette = 'Dark2') +
    scale_colour_brewer(name = 'Literacy status: ',
                        labels = c('Health literate', 'Low health literacy'),
                        type = 'qual',
                        palette = 'Dark2') +
    theme(legend.position = 'top')
```

<img src="figures/descriptive-demographics/health_literacy-1.png" width="672" style="display: block; margin: auto;" />

```r
# Health literacy by study site and intervention group
demo %>%
    group_by(Site, Group, SOS_mnemonic) %>%
    summarise(count = sum(!is.na(SOS_mnemonic)),
              missing = sum(is.na(SOS_mnemonic))) %>%
    group_by(Site) %>%
    mutate(percent = round((count / sum(count)) * 100, 1),
           percent = sprintf('%.1f', percent)) %>%
    mutate(SOS_mnemonic = case_when(
        is.na(SOS_mnemonic) ~ 'Missing data',
        TRUE ~ SOS_mnemonic
        ),
        count = case_when(
            count > 0 ~ count,
            TRUE ~ missing
        ),
        percent = case_when(
            percent == 'NaN' ~ '-',
            TRUE ~ percent
        )) %>% 
    mutate(SOS_mnemonic = factor(SOS_mnemonic,
                                 levels = c('hl', 'lhl', 'Missing data')),
           SOS_mnemonic = fct_recode(SOS_mnemonic,
                                     'Health literate' = 'hl',
                                     'Low health literacy' = 'lhl')) %>%
    select(-missing) %>% 
    knitr::kable(., 
                 caption = 'SOS health literacy by intervention group at each study site',
                 col.names = c('Site', 'Group', 'Literacy state', 
                               'Count', 'Percent'),
                 align = 'lllrr')
```



Table: SOS health literacy by intervention group at each study site

Site   Group   Literacy state         Count   Percent
-----  ------  --------------------  ------  --------
R1     P       Health literate           16      34.0
R1     P       Low health literacy       12      25.5
R1     T       Health literate           12      25.5
R1     T       Low health literacy        7      14.9
R2     P       Low health literacy       26      53.1
R2     T       Low health literacy       23      46.9
U1     P       Missing data              24         -
U1     T       Missing data              23         -
U2     P       Health literate            5      29.4
U2     P       Low health literacy        5      29.4
U2     T       Health literate            2      11.8
U2     T       Low health literacy        5      29.4

```r
# Plot 
demo %>%
    filter(!is.na(SOS_mnemonic)) %>%
    ggplot(data = .) +
    aes(x = Group,
        colour = SOS_mnemonic,
        fill = SOS_mnemonic) +
    geom_bar(position = position_fill()) +
    labs(title = 'Health literacy',
         subtitle = 'Conditioned on intervention group and study site',
         caption = '(Missing data: see table for details)',
         y = 'Proportion',
         x = 'Group') +
    scale_fill_brewer(name = 'Literacy status: ',
                      labels = c('Health literate', 'Low health literacy'),
                      type = 'qual',
                      palette = 'Dark2') +
    scale_colour_brewer(name = 'Literacy status: ',
                        labels = c('Health literate', 'Low health literacy'),
                        type = 'qual',
                        palette = 'Dark2') +
    theme(legend.position = 'top') +
    facet_wrap(~ Site, 
               ncol = 4, 
               labeller = label_both)
```

<img src="figures/descriptive-demographics/health_literacy-2.png" width="672" style="display: block; margin: auto;" />

----

# Session information


```
## R version 3.4.3 (2017-11-30)
## Platform: x86_64-apple-darwin15.6.0 (64-bit)
## Running under: macOS High Sierra 10.13.3
## 
## Matrix products: default
## BLAS: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRblas.0.dylib
## LAPACK: /Library/Frameworks/R.framework/Versions/3.4/Resources/lib/libRlapack.dylib
## 
## locale:
## [1] en_GB.UTF-8/en_GB.UTF-8/en_GB.UTF-8/C/en_GB.UTF-8/en_GB.UTF-8
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
##  [1] bindrcpp_0.2       skimr_1.0.1        forcats_0.3.0     
##  [4] stringr_1.3.0      dplyr_0.7.4        purrr_0.2.4       
##  [7] readr_1.1.1        tidyr_0.8.0        tibble_1.4.2      
## [10] ggplot2_2.2.1.9000 tidyverse_1.2.1   
## 
## loaded via a namespace (and not attached):
##  [1] tidyselect_0.2.4   reshape2_1.4.3     pander_0.6.1      
##  [4] haven_1.1.1        lattice_0.20-35    colorspace_1.3-2  
##  [7] htmltools_0.3.6    yaml_2.1.17        rlang_0.2.0       
## [10] pillar_1.2.1       foreign_0.8-69     glue_1.2.0        
## [13] RColorBrewer_1.1-2 modelr_0.1.1       readxl_1.0.0      
## [16] bindr_0.1          plyr_1.8.4         munsell_0.4.3     
## [19] gtable_0.2.0       cellranger_1.1.0   rvest_0.3.2       
## [22] psych_1.7.8        evaluate_0.10.1    labeling_0.3      
## [25] knitr_1.20         parallel_3.4.3     highr_0.6         
## [28] broom_0.4.3        Rcpp_0.12.15       scales_0.5.0.9000 
## [31] backports_1.1.2    jsonlite_1.5       mnormt_1.5-5      
## [34] hms_0.4.1          digest_0.6.15      stringi_1.1.6     
## [37] grid_3.4.3         rprojroot_1.3-2    cli_1.0.0         
## [40] tools_3.4.3        magrittr_1.5       lazyeval_0.2.1    
## [43] crayon_1.3.4       pkgconfig_2.0.1    xml2_1.2.0        
## [46] lubridate_1.7.3    assertthat_0.2.0   rmarkdown_1.9     
## [49] httr_1.3.1         rstudioapi_0.7     R6_2.2.2          
## [52] nlme_3.1-131.1     compiler_3.4.3
```
