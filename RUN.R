# A simple wrapper for highcharter().
# Alejandro Verri averri@srk.com.ar
# SRK Consulting (Argentina)
#
setwd(dirname(rstudioapi::getSourceEditorContext()$path))
source("setup.R",local = TRUE)

## tidy data
SaRM <- readRDS("SaRM.Rds")
q <- qnorm(0.95)
myDataset <- SaRM[Tn==0 & Mw==7.0 ,.(Sa=round(exp(muLnSa+q*sdLnSa),4)),by=c("SID","Repi")]
setnames(myDataset,old=c("Repi","Sa","SID"),new=c("X","Y","ID"))


## Build HC object
HC <- buildHighcharterObject(
  DATA=myDataset,
  CAPTION=sprintf("Target Scenario: Tn=%3.1f s Mw=%2.1f NEHRP=%s p=%s",0.0,7.0,"C","95%"),
  YT="Sa(R) [g]",
  XT="R [km]",
  MID="C",
  # DATA[ID=="C"] will be plotted with solid lines. All other groups with dash dots.
  XLOG=TRUE, YLOG=TRUE, #logscale?
  FILE="myPlot.png",#default filename for export plot
  TITLE="Ground-Motion Intensities (Sa) by NEHRP",
  TIP="Site Class: {point.series.name}<br><br>Repi: {point.x} km<br><br>Sa(T): {point.y} g",
  # javascript string. Replace "Site Class", "Repi" and "Sa(T") for your by-names, X-names and Y-names
  ALIGN="right", #Horizontal Align c("left","right"),
  LAYOUT="proximate", #Legend Layout c("horizontal","proximate")
  LT="spline", # interpolation type: c("line","spline"),
  PALETTE = "Hawaii" , # hcl.pals() gives you the full list of palettes
  CR =  "© (2022) SRK Consulting", # Credits,
  THEME = hc_theme_smpl() # highchart theme.
)

## Plot the data
HC
