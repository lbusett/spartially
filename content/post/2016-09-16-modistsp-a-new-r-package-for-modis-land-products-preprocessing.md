---
title: 'MODIStsp: a new "R" package for MODIS Land Products preprocessing'
author: Lorenzo Busetto
date: '2016-09-16'
slug: modistsp-a-new-r-package-for-modis-land-products-preprocessing
categories:
  - MODIS
  - preprocessing
  - R
  - time series
  - download
tags: []
header:
  caption: ''
  image: ''
---

In this post, we are introducing **[MODIStsp](http://github.com/ropensci/MODIStsp)** 
a new "R" package allowing to automatize the creation of time series of rasters 
derived from Land Products data derived from MODIS satellite data (; [www.sciencedirect.com/science/article/pii/S0098300416303107](http://www.sciencedirect.com/science/article/pii/S0098300416303107)).

Development of `MODIStsp` started from modifications of the _ModisDownload_ "R" 
script by Thomas Hengl ([spatial-analyst.net/wiki/index.php?title=Download_and_resampling_of_MODIS_images](http://spatial-analyst.net/wiki/index.php?title=Download_and_resampling_of_MODIS_images)), and successive 
adaptations by Babak Naimi ([r-gis.net/?q=ModisDownload](http://r-gis.net/?q=ModisDownload)). 
Their functionalities were gradually incremented with the aim of:

  1. Developing a **standalone application** allowing to perform several preprocessing steps (e.g., download, mosaicking, reprojection and resize) on all available MODIS land products by exploiting a **powerful and user-friendly GUI front-end**;
  2. Allowing the **creation of time series of both MODIS original layers and additional Quality Indicators** (e.g., data acquisition quality, cloud/snow presence, algorithm used for data production, etc. ) extracted from the aggregated bit-field QA layers
  3. Allowing the **automatic calculation and creation of time series of several additional Spectral Indexes** starting form MODIS surface reflectance products

## Installation and usage

Detailed installation instructions and notes on use of the package, can be found
in the main github page of the package ([github.com/ropensci/MODIStsp](https://github.com/ropensci/MODIStsp))
and in the package's [vignette](https://github.com/ropensci/MODIStsp/blob/devel/inst/doc/MODIStsp.pdf).

## Basic interactive usage

After installing and loading the package, launching the `MODIStsp` function without 
additional parameters opens a user-friendly GUI for the selection of processing 
options required for the creation of the desired MODIS time series (e.g., start 
and end dates, geographic extent, type of product and parameters of interest, etc.).

![The main GUI of MODIStsp](https://spartially.000webhostapp.com/wp-content/uploads/2016/09/snapshot2.png)*The main GUI of MODIStsp*

After selecting the product, the user can select the MODIS original, QI and SI
layers to be processed by pressing the **Select Layers** button, which opens a 
separate layers' selection panel. Although some of the most common SIs available 
for computation by default users can add custom ones without modifying _**MODIStsp**_ 
source code by clicking on the _Add Custom Index_ button, which allows specifying 
the formula of the additional desired SI using a simple GUI interface.

![Example of the GUI for selection of the layers to be processed for product M*D13Q1](https://spartially.000webhostapp.com/wp-content/uploads/2016/09/snapshot3.png)

Upon clicking the "Start" button in the main GUI, required MODIS HDF files are
automatically downloaded from NASA  servers and resized, reprojected, resampled 
and processed according to  user's choices.

### Non-interactive execution and scheduled processing

Non-interactive execution exploiting a previously created Options File is also
possible, as well as stand-alone execution outside an "R" environment. This allows 
to use scheduled execution of MODIStsp to automatically update time series related 
to a MODIS product and extent whenever a new image is available. **For additional details see the main [github](http://github.com/ropensci/MODIStsp) page !**

### Output format

For each desired output layer, outputs are saved as **single-band rasters** 
corresponding to each acquisition date available for the selected MODIS product 
within the specified time period.

`R` _RasterStack_ objects with temporal information as well as Virtual  raster 
files (GDAL vrt and/or ENVI META files) facilitating access to the entire time 
series can be also created.

### Accessing and analyzing the processed time series from R

Preprocessed MODIS data can be retrieved within R scripts either by accessing the 
single-date raster files, or by loading the saved _RasterStack_ objects. This second
option allows accessing the complete data stack and analyzing it using the 
functionalities for raster/raster time series analysis, extraction and plotting
provided for example by the `raster` or `rasterVis` packages.

_**MODIStsp**_ provides however also an efficient function (`MODIStsp_extract()`) 
for extracting time series data at specific locations. The function takes as input
a `rasterStack` object with temporal information created by _**MODIStsp**_, the 
starting and ending dates for the extraction and a standard R `Sp*` object (or an
ESRI shapefile name) specifying the locations (points, lines or polygons) of interest, 
and provides as output a R _xts_ object or _data.frame_ containing time series for
those locations. As an example the following code:


``` r
#Set the input paths to raster and shape file
infile <- 'in_path/MOD13Q1_MYD13Q1_NDVI_49_2000_353_2015_RData.RData'
shp_name <- 'path_to_file/rois.shp'
#Set the start/end dates for extraction
start_date <- as.Date("2010-01-01")
end_date <- as.Date("2014-12-31")
#Load the RasterStack
inrts <- get(load(infile))

# Compute average and St.dev
dataavg <- MODIStsp_extract(inrts, shp_name, start_date, end_date, FUN = 'mean', na.rm = T)
datasd <- MODIStsp_extract(inrts, shp_name, start_date, end_date, FUN = 'sd', na.rm = T)
# Plot average time series for the polygons
plot.xts(dataavg)

```

, loads a `RasterStack` object containing 8-days 250 m resolution time series for 
the 2000-2015 period and extracts time series of average and standard deviation 
values over the different polygons of a user's selected shapefile on the 2010-2014 
period. The function exploits rasterization of the input `Sp*` object and fast 
summarization based on the use of _data.table _objects to greatly increase the 
speed of data extraction with respect to standard R functions.


### Authors

The package is developed and maintained by Lorenzo Busetto and Luigi Ranghetti (Institute for
Remote Sensing of Environment - National Research Council of Italy).

### Problems and issues

Any problems/issues can be reported at: [github.com/ropensci/MODIStsp/issues](https://github.com/ropensci/MODIStsp/issues)

### Publication and citation

A paper on MODIStsp was recently published in the "Computers & Geosciences" journal [www.sciencedirect.com/science/article/pii/S0098300416303107](http://www.sciencedirect.com/science/article/pii/S0098300416303107).To cite MODIStsp please use:

L. Busetto, L. Ranghetti (2016) MODIStsp: An R package for automatic preprocessing of MODIS
Land Products time series, Computers & Geosciences, Volume 97, Pages
40-48, ISSN 0098-3004, <http://dx.doi.org/10.1016/j.cageo.2016.08.020>.
