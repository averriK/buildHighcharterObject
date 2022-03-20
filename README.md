## highcharter_example
A simple wrapper for highcharter()
Alejandro Verri Kozlowski. SRK Consulting (Argentina)


### Introduction
The `buildHighcharterObject()` function works as a `highcharter()` helper for typical plots of X,Y values grouped by ID groups, and also assigning parameters for axis names, scales, titles, subtitles, point identifiers, themes, colors and reference curves. 

This example uses the dataset `SaRM` that reports mean values (`muLnSa`) and standard deviations (`sdLnSa`) of ground seismic intensities `Sa` at different source-to-site distances (`Repi`), earthquake magnitudes (`Mw`), SDOF periods (`Tn`) and geotechnical site conditions (`SID`). 


### Example

```{ echo=TRUE}
source("setup.R")
## data wrangling
SaRM <- readRDS("SaRM.Rds")
q <- qnorm(0.95) # 95% percentile
myDataset <- SaRM[Tn==0 & Mw==7.0 ,.(Sa=exp(muLnSa+q*sdLnSa),by=c("SID","Repi")]
setnames(myDataset,old=c("Repi","Sa","SID"),new=c("X","Y","ID"))

HC <- buildHighcharterObject(
  DATA=myDataset,
  CAPTION=sprintf("Target Scenario: Tn=%3.1f s Mw=%2.1f NEHRP=%s p=%s",0.0,7.0,"C","95%"),
  YT="Sa(R) [g]",
  XT="R [km]",
  MID="C",
  # DATA[ID=="C"] will be plotted with solid lines. All other groups with dash dots.
  XLOG=TRUE, YLOG=TRUE, #logscale?
  FILE="myPlot.png",#default filename for export plot
  TITLE="Ground-Motion Intensities (Sa) for different site conditions ",
  TIP="Site Class: {point.series.name}<br><br>Repi: {point.x} km<br><br>Sa(T): {point.y} g"
  # javascript string. Replace "Site Class", "Repi" and "Sa(T") for your by-names, X-names and Y-names
  ALIGN="right", #Horizontal Align c("left","right"),
  LAYOUT="proximate", #Legend Layout c("horizontal","proximate")
  LT="spline", # interpolation type: c("line","spline"),
  PALETTE = "Hawaii" , # hcl.pals() gives you the full list of palettes
  CR =  "© (2022) SRK Consulting", # Credits,
  THEME = hc_theme_smpl() # highchart theme.
)

## Plot!
HC
```

