# GelsAnnotation
Scripts for fast agarose gels annotations

## Dependencies

R

R packages: imager, pracma, optparse

image magick

## Instalation
Once the dependencies are installed, you can directly use the code.

Copy it in your PATH, or in the folder you want to run it.

## Use
Rscript AnnotateGel.R --file NAME -o NAME --n.lanes NUM --lanes.labels "LABEL1,LABEL2,LABEL3..." 

See Rscript AnnotateGel.R --help

**Annotations added are:**
1. The labels on each lane (aestehetics controlled by *labels parameters)
2. The name of the input file on the side (aestehetics controlled by  *name parameters)

## Limitations
1. All consecutive lanes should have at least a band.
2. At least three lanes (including ladder).

