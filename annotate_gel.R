#!/usr/bin/Rscript

require(imager)
require(pracma)
require(optparse)

## Collect arguments
option_list = list(
  make_option(c("-f", "--file"),     type="character",   default=NULL,help="dataset file name", metavar="character"),
  make_option(c("-o", "--out"),      type="character",   default=NULL,help="output file name [default= %default]", metavar="character"),
  make_option(c("-n", "--n.lanes"),       type="numeric",     default=NULL,help="number of lanes in the gel", metavar="numeric"),
  make_option(c("-l","--lanes.labels"),  type="character",   default=NULL,help="labels for the lanes, separated by commas, quoted", metavar="character"),
  make_option(c("-N", "--n.bottom.lanes"),      type="numeric",     default=NULL,help="number of lanes in the gel", metavar="numeric"),
  make_option(c("-L","--bottom.lane.labels"),  type="character",   default=NULL,help="labels for the lanes, separated by commas, quoted", metavar="character"),
  make_option(c("--height.mm"),     type="numeric",     default=80,  help="height of output in mm", metavar="numeric"),
  make_option(c("--text.pt"),       type="numeric",     default=8,   help="text size in pt", metavar="numeric"),
  make_option(c("--text.color"),    type="character",   default="red", help="text color", metavar="character"),
  make_option(c("--labels.position"), type="character", default="top",help="top or bottom", metavar="numeric"),
  make_option(c("--labels.angle"),  type="numeric",     default=90,  help="degrees", metavar="numeric"),
  make_option(c("--labels.adj.x"),  type="numeric",     default=NULL,  help="labels position adjustment in writting direction", metavar="numeric"),
  make_option(c("--labels.adj.y"),  type="numeric",     default=NULL,  help="labels position adjustment in direction perpendicular to writting", metavar="numeric"),
  make_option(c("--labels.col"),    type="character",   default=NULL, help="color for labels (default text.color)", metavar="numeric"),
  make_option(c("--labels.pt"),     type="numeric",     default=NULL,help="labes size (default text.pt)", metavar="numeric"),
  make_option(c("--name.position"), type="character",     default="bottomright",help="bottomleft/bottomright/topright/topleft", metavar="numeric"),
  make_option(c("--name.offset"),   type="numeric",     default=10,help="offset for name position", metavar="numeric"),
  make_option(c("--name.col"),      type="character",     default=NULL,help="color for name (default text.color)", metavar="numeric"),
  make_option(c("--name.pt"),       type="numeric",     default=NULL,help="name for labels (default text.color)", metavar="numeric")
);

opt_parser = OptionParser(option_list=option_list);
opt = parse_args(opt_parser);

if(is.null(opt$file)){stop('missing argument: file')}
if(is.null(opt$n.lanes)){stop('missing argument: n.lanes')}
if(is.null(opt$lanes.labels)){stop('missing argument: lanes.labels')}

file         <- opt$file
out          <- if(is.null(opt$out)){sub(".Tif", "_annotated.png", file)}else{opt$out}
n.lanes      <- opt$n.lanes
lanes.labels <- unlist(strsplit(opt$lanes.labels, split = ",", fixed=T))

height.mm    <- opt$height.mm

text.pt      <- opt$text.pt
text.color   <- opt$text.color

labels.position <- opt$labels.position
labels.angle    <- opt$labels.angle
labels.col      <- if(is.null(opt$labels.col)){text.color}else{opt$labels.col}
labels.pt       <- if(is.null(opt$labels.pt)){text.pt}else{opt$labels.pt}

name.position <- opt$name.position
name.offset   <- opt$name.offset
name.col      <- if(is.null(opt$name.col)){text.color}else{opt$name.col}
name.pt       <- if(is.null(opt$name.pt)){text.pt}else{opt$name.pt}

# Check inputs
if(labels.angle!=0 & labels.angle!=90 & is.null(opt$labels.adj.x)){
  stop('You must specify labels.adj.x if labels angle is not 0 or 90')
}
if(labels.angle!=0 & labels.angle!=90 & is.null(opt$labels.adj.y)){
  stop('You must specify labels.adj.y if labels angle is not 0 or 90')
}
if(length(lanes.labels)!=n.lanes){stop('length(length.labels) must be n.lanes')}
if(!is.null(opt$n.bottom.lanes)){
  n.bottom.lanes <- opt$n.bottom.lanes
  bottom.lane.labels <- unlist(strsplit(opt$bottom.lane.labels, split = ",", fixed=T))
  if(length(bottom.lane.labels)!=n.bottom.lanes){stop('length(bottom.lane.labels) must be n.bottom.lanes', length(bottom.lane.labels)," ",n.bottom.lanes)}
}

####################################

## Load file
img.input <- load.image(file)

## Cut manually
coord <- grabRect(img.input, output = "coord")
img <- img.input
img <- imsub(img, x < coord["x1"])
img <- imsub(img, y < coord["y1"])
img <- imsub(img, x>coord["x0"])
img <- imsub(img, y>coord["y0"])

## Detect lanes
coord_lanes <- grabLine(img, output = "coord")
y_lanes <- min(coord_lanes[c("y0","y1")])
x_lanes <- seq(coord_lanes["x0"], coord_lanes["x1"], length.out = n.lanes)

if(!is.null(opt$n.bottom.lanes)){
  coord_bottom_lanes <- grabLine(img, output = "coord")
  y_bottom_lanes <- min(coord_bottom_lanes[c("y0","y1")])
  x_bottom_lanes <- seq(coord_bottom_lanes["x0"], coord_bottom_lanes["x1"], length.out = n.bottom.lanes)
}

#Invert colors
img <- max(img)-img

##### Plot
if(labels.angle==0){
  adj.x <- 0.5
  adj.y <- 1  
}
if(labels.angle==90 & labels.position=="top"){
  adj.x <- 0
  adj.y <- 0.5  
}
if(labels.angle==90 & labels.position=="bottom"){
  adj.x <- 1
  adj.y <- 0.5  
}
if(!is.null(opt$labels.adj.x)){
  adj.x <- opt$labels.adj.x
}
if(!is.null(opt$labels.adj.y)){
  adj.y <- opt$labels.adj.y
}


png(out, width = nrow(img)/ncol(img)*height.mm, height = height.mm, units = "mm", res = 500)
  par(mar=c(0,0,0,0), ps=labels.pt)
  
  # Plot image
  plot(img, axes = F)
  
  # Print labels
  text(x=x_lanes,y=rep(y_lanes, n.lanes), labels = lanes.labels,
       col=labels.col, srt=labels.angle,adj = c(adj.x,adj.y))
  if(!is.null(opt$n.bottom.lanes)){
    text(x=x_bottom_lanes,y=rep(y_bottom_lanes, n.bottom.lanes), 
         labels = bottom.lane.labels, col=labels.col, srt=labels.angle,adj = c(adj.x,adj.y))
  }
  
  # Print name of the file
  if(name.position=="bottomright"){x.name=dim(img)[1]-name.offset; y.name=dim(img)[2]-name.offset;   adj.name = c(0,0) }
  if(name.position=="topright"){   x.name=dim(img)[1]-name.offset; y.name=0+name.offset;             adj.name = c(1,0)  }
  if(name.position=="topleft"){    x.name=name.offset;             y.name=0+name.offset;             adj.name = c(1,1) }
  if(name.position=="bottomleft"){ x.name=name.offset;             y.name=dim(img)[2]-name.offset;   adj.name = c(0,1) }
  par(ps=name.pt)
  text(x=x.name, y=y.name, labels = file, col=name.col, srt=90, adj=adj.name)
dev.off()



