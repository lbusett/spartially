---
title: MODIStsp 1.3.3 is out - Speeding things up and squashing some bugs !
author: Lorenzo Busetto
date: '2017-08-16'
slug: modistsp-1-3-3-is-out-speeding-things-up-and-squashing-some-bugs
categories:
  - MODIS
  - MODIStsp
  - R
  - time series
  - Vegetation Indexes
  - pkgdown
tags:
  - R
  - MODIStsp
header:
  caption: ''
  image: ''
---
A new version of [MODIStsp](http://ropensci.github.io/MODIStsp/) (1.3.3) is on [CRAN](https://cran.r-project.org/web/packages/MODIStsp/index.html) as of today ! 
Below, you can find a short description of the main improvements.

## Processing speed improvements

Processing of MODIS layers after download (i.e., scale and offset calibration, 
computation of Spectral Indexes and Quality Indicators) **is now much faster**.

![](/img/boxplots.png)

As you can see in the figure, **processing time was almost halved** on my (not so fast)
laptop. This was achieved by **modifying all computation functions so to use 
`raster::calc()` and `raster::overlay()`** (more on this in a later post).

Although speed is also limited by download speed and compression options, this
will allow to **save quite some time when working on large areas and with many 
MODIS layers**.

## Test mode

`MODIStsp 1.3.3` also introduces a **test mode**. Although it was mainly developed
to facilitate [unit testing](https://en.wikipedia.org/wiki/Unit_testing), it is
also available to the user. Running:

``` r
MODIStsp(test = X)  # with X equal to a number between 0 and 6
```

will run `MODIStsp` expoiting different sets of processing parameters (available 
as JSON files in the Test_files subfolder of `MODIStsp` installation). We hope this 
will help us in more easily pinpoint and solve eventual problems signalled by users.

### Bug fixes

Several bugs discovered after v1.3.2 release were fixed. We thank `MODIStsp` users 
[for their feedback](https://github.com/ropensci/MODIStsp/issues?q=is%3Aissue+is%3Aclosed)
and help in improving the package ! You can find a list of the main fixes in our
[NEWS](http://ropensci.github.io/MODIStsp/news/index.html) page.
