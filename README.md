# IidaR: Instalación y Ejecución

## Instalación de R

1. Descargar e instalar [R](https://cran.dcc.uchile.cl) con las configuraciones por defecto.
2. Descargar e instalar [RStudio](https://posit.co/download/rstudio-desktop) con las configuraciones por defecto.

## Instalación de Git

 1. Descargar e instalar [Git](https://git-scm.com/downloads) con las configuraciones por defecto.

## Obtención del código fuente

 1. Abrir una **terminal** y ejecutar el siguiente comando:

```bash
git clone https://github.com/ffuentesp7/iidaR.git
```

## Preparación de datos

1. Copiar y pegar dentro de la **carpeta del directorio**, las imágenes satelitales en formato GeoTIFF y los datos meteorológicos en formato CSV cuyo contenido contiene las siguientes columnas:

*Datos de ejemplo*

| Date | Time | Rad | wind_dir | RH | temp |
|:----:|:----:|:----:|:----:|:----:|:----:|
| 06/01/2010 | 0:00:00 | -4 | 1.28 | 53.3 | 23.7 |
| 06/01/2010 | 0:30:00 | -3.1 | 1.42 | 51.2 | 23.1 |
| 06/01/2010 | 1:00:00 | -2.9 | 2.03 | 48.1 | 22.5 |

## Ejecución

 1. En **RStudio**, abrir el directorio que contiene el script y establecerlo como *working directory*.
 2. Seleccionar todo el código y click en *Run*.
