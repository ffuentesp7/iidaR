# Install instructions for IidaR

## Install R

1. Download and install [R](https://cran.dcc.uchile.cl) with default settings.
2. Download and install [RStudio](https://posit.co/download/rstudio-desktop) with default settings.

## Install Git

1. Download and install [Git](https://git-scm.com/downloads) with default settings.

## Clone the source code

1. Open a terminal and execute the following command:

```bash
git clone https://github.com/ffuentesp7/iidaR.git
```

## Prepare your data

1. Inside the **repository's root folder**, paste your GeoTIFF satellite images and meteorological data CSV. The CSV file should have this structure:

| Date | Time | Rad | wind_dir | RH | temp |
|:----:|:----:|:----:|:----:|:----:|:----:|
| 06/01/2010 | 0:00:00 | -4 | 1.28 | 53.3 | 23.7 |
| 06/01/2010 | 0:30:00 | -3.1 | 1.42 | 51.2 | 23.1 |
| 06/01/2010 | 1:00:00 | -2.9 | 2.03 | 48.1 | 22.5 |

## *Manual run in RStudio*

1. In **RStudio**, set the repository's root folder as the *working directory*.
2. Open the R script.
3. Adapt the code to your needs.
4. Select all the code and click *Run*.
