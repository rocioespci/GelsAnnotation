# GelsAnnotation
Scripts for fast agarose gels annotations

## Dependencies

R

R packages: imager, pracma, optparse (availables in CRAN)

image magick  (https://imagemagick.org/script/download.php#windows)

## Instalation
Once the dependencies are installed, you can directly use the code.

Copy it in your PATH, or in the folder you want to run it.

## Use
Rscript AnnotateGel.R --file NAME -o NAME --n.lanes NUM --lanes.labels "LABEL1,LABEL2,LABEL3..." 

See Rscript AnnotateGel.R --help

**Annotations added are:**
1. The labels on each lane (aestehetics controlled by *labels parameters)
2. The name of the input file on the side (aestehetics controlled by  *name parameters)

## Run example
Run by command line:

Rscript AnnotateGel.R -f "Example.Tif" --n.lanes 6 --lanes.labels "Ladder1KB, Sample 1, Sample 2, Sample 3, Sample 4, Sample 5"

## Limitations
1. All consecutive lanes should have at least a band.
2. At least three lanes (including ladder).

