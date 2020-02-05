clear
capture log close
log using Logs/mean-comparison.log, replace
set seed 123
set obs 1000
generate x=rnormal(0.5,2)
generate epsilon=rnormal(0,0.2)


summarize x, d
generate t=(x>=`r(mean)')

generate y=0.5 + 0.7*t+ epsilon

ttest y, by(t)
regress y t


/*

summarize x, d
generate t1=(x>=`r(p75)')

generate y1=0.4 + 0.2*t1+ epsilon
*/
