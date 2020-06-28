append using formatrix.dta
levelsof words, local(wordlist)

foreach i of local wordlist {
	gen x_`i' = 0
	replace x_`i' = 1 if regexm(tweet_clean, ["`i'"])
}

local y = 1
foreach i of local wordlist {
	local x = 1
	foreach j of local wordlist {
		gen freq_`i'_`j' = x_`i'*x_`j'
		summ freq_`i'_`j'
			mat B[`x',`y']=r(sum)
		loc x = `x' + 1
		}
	loc y = `y' + 1
	}

mat A =J(dim,dim,0)
levelsof words, local(wordlist)
local y = 1
foreach i of local wordlist {
	local x = 1
	foreach j of local wordlist {
		summ freq_`i'_`j'
			if r(max) > 0 {
				mat A[`x',`y']= 1
			}
			else {
				mat A[`x',`y']= 0	
			}
		loc x = `x' + 1
		}
	loc y = `y' + 1
}

	mat C = vecdiag(B)
	mat D = C'
	
	svmat A 
	svmat D
	
	keep words A1-D1
	export delimited adjmat.csv, replace
	
nwdrop
import delimited "adjmat.csv", delimiter(comma) clear
nwimport "adjmat.csv", type(matrix)

nwplot adjmat, label(words) size(d1) title(Elon Musk Tweets, color(black) size(large)) scatteropt(mfcolor(blue))
nwplotmatrix adjmat, label(words) title(Elon Musk Tweets, color(black) size(large))
