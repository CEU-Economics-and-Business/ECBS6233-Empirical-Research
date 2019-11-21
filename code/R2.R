library(tidyverse)
library(dplyr)
library(gridExtra)
library(ggplot2)
#Random.org 1 to 10000
set.seed(2776)

df <- tibble(x = runif(20)) %>%
  mutate(y = 1 + x + runif(20)) %>%
  mutate(w = x + y + runif(20))

basem <- lm(y~x, data = df)
noint <- lm(y~x - 1, data = df)
conw <- lm(y~x+w, data = df)
lim <- lm(y~x, data = filter(df, x > .85))
quad <- lm(y~poly(x, 4), data = df)
perf <- lm(y~factor(x), data =df)

origin <- ggplot(df, aes(x = x, y = y))+ geom_point()+
  labs(x = "X", y = "Y") + 
  theme_light()

base <- origin + 
  stat_function(fun = function(x) coef(basem)[1] + coef(basem)[2]*x,
                color = 'red', size = 1.5, linetype = 'dashed') +
  ggtitle(NULL, subtitle = paste("True Model. R2 =", round(summary(basem)$r.squared,3),
                                 "Adj. R2 =", round(summary(basem)$adj.r.squared,3)))

nointg <- origin + 
  stat_function(fun = function(x) coef(basem)[1] + coef(basem)[2]*x,
                color = 'red', size = 1, linetype = 'dashed') + 
  stat_function(fun = function(x) coef(noint)[1]*x,
                color = 'blue', size = 1.5) +
  ggtitle(NULL, subtitle = paste("No Constant. R2 =", round(summary(noint)$r.squared,3),
                                 "Adj. R2 =", round(summary(noint)$adj.r.squared,3)))

conwg <- origin + 
  stat_function(fun = function(x) coef(basem)[1] + coef(basem)[2]*x,
                color = 'red', size = 1, linetype = 'dashed') + 
  stat_function(fun = function(x) coef(conw)[1] + coef(conw)[2]*x + coef(conw)[3]*mean(df$w),
                color = 'blue', size = 1.5) +
  ggtitle(NULL, subtitle = paste("Bad Control Added. R2 =", round(summary(conw)$r.squared,3),
                                 "Adj. R2 =", round(summary(conw)$adj.r.squared,3)))


quadg <- origin +
  stat_function(fun = function(x) coef(basem)[1] + coef(basem)[2]*x,
                color = 'red', size = 1, linetype = 'dashed') + 
  stat_smooth(formula = y ~ poly(x, 4),
              color = 'blue', size = 1.5, se = FALSE, method = 'lm') +
  ggtitle(NULL, subtitle = paste("Four-Term Polynomial. R2 =", round(summary(lim)$r.squared,3),
                                 "Adj. R2 =", round(summary(lim)$adj.r.squared,3)))


limg <- ggplot(filter(df, x > .85), aes(x = x, y = y)) + geom_point()+
  labs(x = "X", y = "Y") + 
  theme_light() +
  stat_smooth(method = 'lm', formula = y~x, se=FALSE, color = 'blue', size = 1.5) +
  ggtitle(NULL, subtitle = paste("Cherrypicking Data. R2 =", round(summary(lim)$r.squared,3),
                                 "Adj. R2 =", round(summary(lim)$adj.r.squared,3))) +
  geom_point(data = df, aes(x = x, y = y), alpha = .3) +
  stat_function(fun = function(x) coef(basem)[1] + coef(basem)[2]*x,
                color = 'red', size = 1, linetype = 'dashed')

perfg <- origin +
  stat_function(fun = function(x) coef(basem)[1] + coef(basem)[2]*x,
                color = 'red', size = 1, linetype = 'dashed') + 
  geom_line(color = 'blue', size = 1.5) + 
  ggtitle(NULL, subtitle = "Perfect Fit. R2 = 1, Adj. R2 = NA")


grid.arrange(base, nointg, conwg, limg, quadg, perfg, ncol = 2,
             top = 'Don\'t use R2 to Pick Your Model! \n A higher R2 doesn\'t mean \'better model\' and can actually be worse.',
             bottom = "This assumes you want to get a true/unbiased estimate. But even if you only \n want to predict the outcome, R2 isn't a perfect measure of model fit. But that's another graph.")