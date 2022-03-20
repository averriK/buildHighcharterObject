library(highcharter)
library(data.table)

## wrapper -----
buildHighcharterObject <- function(DATA=NULL,XT="X Values",YT="Y Values",MID=NULL,FILE=NULL,TITLE=NULL,TIP=NULL,LT="spline",PALETTE=NULL,THEME=NULL,CR=NULL,XLOG=TRUE,YLOG=FALSE,CAPTION=NULL,LAYOUT="horizontal",ALIGN="left",XMAX=NULL,YMAX=NULL){
  on.exit(expr={rm(list = ls())}, add = TRUE)
  stopifnot(!is.null(DATA),!is.null(MID))
  HC <- highchart() |>
    hc_yAxis(
      title= YT,
      minorTickInterval = "auto",
      minorGridLineDashStyle = "Dot",
      showFirstLabel = FALSE,
      showLastLabel = TRUE) |>

    hc_xAxis(
      title = XT,
      minorTickInterval = "auto",
      minorGridLineDashStyle = "Dot",
      showFirstLabel = TRUE,
      showLastLabel = TRUE) |>

    hc_add_series(
      DATA[ID==MID],# main curve
      type=LT,
      dashStyle = "Solid",
      hcaes(x=X,y=Y, group=ID)) |>

    hc_add_series(
      DATA[ ID != MID],# secondary curves
      type=LT,
      dashStyle = "ShortDashDotDot",
      hcaes(x=X,y=Y, group=ID)) |>

    hc_chart(style=list(fontFamily = "Helvetica")) |>

    hc_pane(size = "200%")


  if(!is.null(TIP)){
    HC <- HC |>  hc_tooltip(
      sort = FALSE, split=FALSE, crosshairs = TRUE, pointFormat = TIP)
  }

  if(!is.null(CAPTION)){
    HC <- HC |>   hc_caption(text = CAPTION, verticalAlign="top", align="left")
  }

  if(!is.null(CR)){
    HC <- HC |>    hc_credits(enabled = TRUE, text = CR)
  }

  if(!is.null(FILE)){
    HC <- HC |>    hc_exporting(
      enabled = TRUE, # always enabled
      filename = FILE)
  }

  if(!is.null(LAYOUT) & !is.null(ALIGN) ){
    XA <- ifelse(ALIGN=="left",+50,-50)
    YA <- ifelse(LAYOUT=="horizontal",50,0)
    HC <- HC |>
      hc_legend(
        layout = LAYOUT,
        align = ALIGN,
        verticalAlign="top",
        floating = TRUE,
        x=XA,y=YA)
  }

  if(!is.null(TITLE)){
    HC <- HC |>    hc_title(text = TITLE)
  }

  if(!is.null(THEME)){
    HC <- HC |>   hc_add_theme(hc_thm = THEME)
  }

  if(!is.null(PALETTE)){
    HC <- HC |>  hc_colors(colors = hcl.colors(10,palette = PALETTE))
  }

  if(!is.null(XMAX)){
    HC <- HC |> hc_xAxis(max = XMAX)
  }
  if(!is.null(YMAX)){
    HC <- HC |> hc_yAxis(max = YMAX)
  }
  if(XLOG==TRUE) {
    HC <- HC |> hc_xAxis(type = "logarithmic")
  }

  if(YLOG==TRUE) {
    HC <- HC |> hc_yAxis(type = "logarithmic")
  }
  return(HC)
}
