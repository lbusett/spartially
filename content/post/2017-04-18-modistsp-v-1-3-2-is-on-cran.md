---
title: MODIStsp (v 1.3.2) is on CRAN !
author: Lorenzo Busetto
date: '2017-04-18'
slug: modistsp-v-1-3-2-is-on-cran
categories:
  - download
  - MODIS
  - MODIStsp
  - preprocessing
  - R
  - time series
  - Vegetation Indexes
tags:
  - R
header:
  caption: ''
  image: ''
---
We are glad to report that **MODIStsp is now also available on** [CRAN](https://cran.r-project.org/web/packages/MODIStsp/index.html) ! From now on, 
you can therefore install it by simply using:

**`install.packages("MODIStsp")`**

In v 1.3.2 we also added the functionality to automatically **apply scale and offset** 
coefficients on MODIS original values according with the specifications of single
MODIS products. Setting the new _"Scale output values"_ option to "Yes", scale factors 
and offsets are applied (if existing).

![](/img/Figure_2_new_132.png)**The MODIStsp GUI**

In this case, for example, Land Surface Temperature values in the output rasters 
will be in °K, and spectral indices will be floating point values (e.g., NDVI will
be between -1 and 1 instead than between -10000 and 10000).

We also *corrected a few bugs*, affecting in particular _ftp_ download, and
**modified the names of some output layers** to reduce the length and homogenize 
output file names, and correct a few errors.

The changelog for v1.3.2 can be found [HERE](https://github.com/lbusett/MODIStsp/releases/tag/v1.3.2)

We hope you will find the new version useful and that we didn't introduce too
many bugs ! **Please report any problems in our 
[issues](https://github.com/lbusett/MODIStsp/issues) GitHub page.**

The _development_ version of `MODIStsp`, containing the latest updates and bug 
fixes, will still be available on GitHub. It can be installed using:

``` r
library(devtools)
install_github("lbusett/MODIStsp", ref = "master")
```

`MODIStsp`  is a R package allowing automatic download and preprocessing of MODIS  Land Products time series - you can find additional information [here](/post/modistsp-a-new-r-package-for-modis-land-products-preprocessing)
