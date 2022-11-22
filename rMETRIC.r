install.packages("devtools", repos = "https://cran.dcc.uchile.cl")
library(devtools)
install_github("midraed/water")
library(water)
install.packages("RColorBrewer", repos = "https://cran.dcc.uchile.cl")
library(RColorBrewer)

#AOI 50km2
aoi <- createAoi(
	topleft = c(246419.3, 6081628),
	bottomright = c(253965, 6074972) ,
	EPSG = 32719
)

#AOI 1km2
#aoi<-createAoi(topleft = c(253065,6081481 ),
#               bottomright =c( 254053, 6080446) , EPSG = 32719)

#plot(aoi)

image.DN <- loadImage(path = getwd(), sat = "L7", aoi = aoi)

csvfile <- ("Quepu_06012010.csv")
MTLfile <- ("LE07_L1TP_233085_20100106_20161217_01_T1_MTL.txt")

WeatherStation <- read.WSdata(
	WSdata = csvfile,
	lat = -35.38255,
	long = -71.713367,
	elev = 104,
	height = 5.6,
	columns = c("date", "time", "radiation", "wind", "RH", "temp"),
	time.format = "%H:%M:%S",
	date.format = "%d/%m/%Y",
	MTL = MTLfile
)

print(WeatherStation)
plot(WeatherStation, hourly = TRUE)

dem <- prepareSRTMdata(extent = image.DN)


surface.model <- METRICtopo(dem)
solar.angles.r <- solarAngles(surface.model = surface.model,
							  WeatherStation = WeatherStation,
							  MTL = MTLfile)

#plot(solar.angles.r)
Rs.inc <-
	incSWradiation(
		surface.model = surface.model,
		solar.angles = solar.angles.r,
		WeatherStation = WeatherStation
	)

image.TOAr <- calcTOAr(
	image.DN = image.DN,
	sat = "L7",
	MTL = MTLfile,
	incidence.rel = solar.angles.r$incidence.rel
)

#plot(image.TOAr)
image.SR <- calcSR(
	image.TOAr = image.TOAr,
	sat = "L7",
	surface.model = surface.model,
	incidence.hor = solar.angles.r$incidence.hor,
	WeatherStation = WeatherStation
)
#plot(image.SR)
albedo <- albedo(image.SR = image.SR,
				 coeff = "Liang",
				 sat = "L7")
plot(albedo)

LAI <- LAI(method = "metric2010", image = image.TOAr, L = 0.1)
#plot(LAI)
#summary(LAI)
Ts <- surfaceTemperature(
	image.DN = image.DN,
	LAI = LAI,
	sat = "L7",
	WeatherStation = WeatherStation
)
Rl.out <- outLWradiation(LAI = LAI, Ts = Ts)

Rl.inc <- incLWradiation(
	WeatherStation,
	DEM = surface.model$DEM,
	solar.angles = solar.angles.r,
	Ts = Ts
)
Rn <- netRadiation(LAI, albedo, Rs.inc, Rl.inc, Rl.out)
#plot(Rn)
G <- soilHeatFlux(
	image = image.SR,
	Ts = Ts,
	albedo = albedo,
	Rn = Rn,
	LAI = LAI
)
plot(G)
Z.om <- momentumRoughnessLength(
	LAI = LAI,
	mountainous = TRUE,
	method = "short.crops",
	surface.model = surface.model
)


hot.and.cold <-
	calcAnchors(
		image = image.TOAr,
		Ts = Ts,
		LAI = LAI,
		plots = F,
		albedo = albedo,
		Z.om = Z.om,
		n = 2,
		anchors.method = "CITRA-MCBbc",
		deltaTemp = 5,
		WeatherStation = WeatherStation,
		verbose = FALSE
	)

H <- calcH(
	anchors = hot.and.cold,
	Ts = Ts,
	Z.om = Z.om,
	WeatherStation = WeatherStation,
	ETp.coef = 0.5,
	Z.om.ws = 0.3,
	DEM = dem,
	Rn = Rn,
	G = G,
	verbose = FALSE
)

ET_WS <- dailyET(WeatherStation = WeatherStation, MTL = MTLfile)
summary(ET_WS)

ET.24 <-
	ET24h(Rn, G, H$H, Ts, WeatherStation = WeatherStation, ETr.daily = ET_WS)
plot(
	ET.24,
	xlab = "Easting",
	ylab = "Northing",
	main = "24 Hour Evapotranspiration",
	col = rainbow(255)
)
summary(ET.24)

writeRaster(ET.24,
			filename = "ET24h_06_Ene2010_50km2_KcCal.tif",
			datatype = 'FLT4S',
			overwrite = T)
