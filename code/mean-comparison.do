clear
capture log close
log using "output/Logs/mean-comparison.log", replace
set seed 1
set obs 1000
generate x=rnormal(0.5,2)
generate x1=rnormal(0,1)
generate x2=rnormal(0,1.5)+0.5*x1

generate epsilon=rnormal(0,0.2)


summarize x, d
generate t=(x>=`r(mean)')

generate y1=0.5+ 0.7*t+ epsilon

generate y2=0.5+ 0.7*t+0.3*x1+ epsilon

generate y3=0.5+ 0.7*t+0.15*x2+ epsilon


label variable t "T"

forval i=1/3 {
	regress y`i' t
	eststo V`i'
	ttest y`i', by(t)

	estadd scalar mean_diff = r(mu_2)-r(mu_1), replace
	estadd scalar standard_error = r(se), replace

}


esttab V1 V2 V3 using "./output/tables/mean-comparison.tex", se(3) b(3)  s( mean_diff standard_error, label("Mean-Difference"  "Standard Error" ))  label  ///
nostar nonotes ///
nomtitles mgroups("", ///
pattern(1 0 0 ) prefix(\multicolumn{@span}{c}{) suffix(}) span )  ///
keep(t) replace


/*

summarize x, d
generate t1=(x>=`r(p75)')

generate y1=0.4 + 0.2*t1+ epsilon
*/
