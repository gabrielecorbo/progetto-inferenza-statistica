library( car )
library( faraway )
library( leaps )
library(MASS)
library( GGally)
library(rgl)
library(dplyr)
library(data.table)
library(ggplot2)
library(corrplot)
library(RColorBrewer)


f <- file.choose()
scoliosi <- read.csv(f)

View(scoliosi)
# Dimensioni
dim(scoliosi)
# Overview delle prime righe
head(scoliosi)

print(sapply(scoliosi,function(x) any(is.na(x)))) 
print(sapply(scoliosi, typeof)) 

#Look at the main statistics for each covariate:
summary(scoliosi)

x11()
ggpairs(scoliosi)

g = lm( lumbar_lordosis_angle ~ .-class, data = scoliosi )

summary( g )   #sembra fico

plot(g,which=1)#NO OMOSCHEDASTICIT√, noto nadamento parabolico†
shapiro.test(g$residuals) 

qqnorm( g$res, ylab = "Raw Residuals", pch = 16 )
qqline( g$res )

#boxcox sul primo, con tutto dentro
# b = boxcox(g)
# best_lambda = b$x[ which.max( b$y ) ]
# best_lambda
# 
# gb = lm( (lumbar_lordosis_angle^best_lambda -1)/best_lambda ~ .-class, data=scoliosi )
# summary( gb )
# 
# plot(gb,which=1)#NO OMOSCHEDASTICIT√, noto nadamento parabolico†
# shapiro.test(gb$residuals) 
# 
# qqnorm( gb$res, ylab = "Raw Residuals", pch = 16 )
# qqline( gb$res )

res=g$residuals
watchout_points_norm = res[ which(abs(res) > 40 ) ]
watchout_ids_norm = seq_along( res )[ which( abs(res)>40 ) ]

points( g$fitted.values[ watchout_ids_norm ], watchout_points_norm, col = 'red', pch = 16 )

gl = lm( lumbar_lordosis_angle ~ .-class, scoliosi, subset = ( abs(res) < 40 ) )
summary( gl )

plot(gl,which=1)#NO OMOSCHEDASTICIT?, noto nadamento parabolico?
shapiro.test(gl$residuals) #OK

x11()
qqnorm( gl$res, ylab = "Raw Residuals", pch = 16 )
qqline( gl$res )
x11()
b = boxcox(gl)
best_lambdagl = b$x[ which.max( b$y ) ]
best_lambdagl

gb = lm( (lumbar_lordosis_angle^best_lambdagl -1)/best_lambdagl ~ .-class, data=scoliosi,subset = ( abs(res) < 40 ) )
summary( gb )

plot(gb,which=1)#NO OMOSCHEDASTICIT√, noto nadamento parabolico†
shapiro.test(gb$residuals) 

qqnorm( gb$res, ylab = "Raw Residuals", pch = 16 )
qqline( gb$res )