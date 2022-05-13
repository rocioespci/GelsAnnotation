# GelsAnnotation
Scripts for fast agarose gels annotations

## Dependencies

R

R packages: imager, pracma, optparse (availables in CRAN)

image magick  (https://imagemagick.org/script/download.php#windows)

## Installation
Once the dependencies are installed, you can directly use the code.

Copy it in your PATH, or in the folder you want to run it.

## Use

**Option I**
 In ubuntu: 
annotate_gel -f NAME -o NAME -n NUM -l "LABEL1,LABEL2,LABEL3..." 

In Windows
Rscript annotate_gel -f NAME -o NAME -n NUM -l "LABEL1,LABEL2,LABEL3..." 

An image will open for you to select the area to keep (remove margins).
The cut image will open for you to draw a line, indicating where the lanes' names will be. 
Be careful on the horizontal coordinates: the beggining of the line should match the middle of the first lane, and the end of the line the middle of the last lane. Don't worry too much on the vertical coordinates, it will only keep the lowest value. 

If there is an empty lane, just write nothing on it.


**Option II**


Rscript AG_findpeaks.R --file NAME -o NAME --n.lanes NUM --lanes.labels "LABEL1,LABEL2,LABEL3..." 

An image will open for you to select the area to keep (remove margins).

**Option III**

Rscript AG_lanesline.R --file NAME -o NAME --n.lanes NUM --lanes.labels "LABEL1,LABEL2,LABEL3..." 

An image will open for you to select the area to keep (remove margins).
The cut image will open for you to draw a line, indicating where the lanes' names will be. 
Be careful on the horizontal coordinates: the beggining of the line should match the middle of the first lane, and the end of the line the middle of the last lane. Don't worry too much on the vertical coordinates, it will only keep the lowest value. 

If there is an empty lane, just write nothing on it.




See Rscript AG_lanesline.R --help  or Rscript AG_findpeaks.R --help  for further details, specially on the control of aesthetics of annotations.

**Annotations added are:**
1. The labels on each lane (aestehetics controlled by *labels parameters)
2. The name of the input file on the side (aestehetics controlled by  *name parameters)

## Run example
Run by command line:

Rscript AG_lanesline.R -f "Example.Tif" --n.lanes 6 --lanes.labels "Ladder1KB, Sample 1, Sample 2, Sample 3,, Sample 5"

Rscript AG_findpeaks.R -f "Example.Tif" --n.lanes 6 --lanes.labels "Ladder1KB, Sample 1, Sample 2, Sample 3, Sample 4, Sample 5"


## Limitations

Both:
* Can't have a two lines gel.


AG_findpeaks:
* All consecutive lanes should have at least a band.
* At least three lanes (including ladder).

