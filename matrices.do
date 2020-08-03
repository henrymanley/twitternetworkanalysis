local complist CNN MSNBC nytimes WSJ business BreitbartNews TheEconomist FoxNews
foreach k of local complist {
	use "tweets.dta",clear
	scalar dim = 40
	keep if screen_name == "`k'"
	append using "words.dta"
	
//encoding
levelsof words, local(wordlist)
foreach i of local wordlist {
	gen x_`i' = 0
	replace x_`i' = 1 if regexm(text, ["`i'"])
}

//freq matrix
mat B_`k' =J(dim,dim,0)
local y = 1
foreach i of local wordlist {
	local x = 1
	foreach j of local wordlist {
		gen freq_`i'_`j' = x_`i'*x_`j'
		summ freq_`i'_`j'
			mat B_`k'[`x',`y']=r(sum)
		loc x = `x' + 1
		}
	loc y = `y' + 1
	}

//adj matrix
mat A_`k' =J(dim,dim,0)
levelsof words, local(wordlist)
local y = 1
foreach i of local wordlist {
	local x = 1
	foreach j of local wordlist {
		summ freq_`i'_`j'
			if r(max) > 0 {
				mat A_`k'[`x',`y']= 1
			}
			else {
				mat A_`k'[`x',`y']= 0	
			}
		loc x = `x' + 1
		}
	loc y = `y' + 1
}
	mat C = vecdiag(B_`k')
	mat D = C'
	
	svmat A_`k' 
	svmat D
	
	keep words A_`k'1-D1
	gen id = _n
	drop if id > dim
	drop words
	append using "words.dta"
	export delimited `k'.csv, replace
	
	clear
}


nwdrop
import delimited "".csv, delimiter(comma) clear
nwimport "".csv, type(matrix)

	nwplot adjmat, label(_nodelab) size(d1) title(News Tweets, color(black) size(large)) scatteropt(mfcolor(red))
	nwplotmatrix adjmat, label(_nodelab) title(News Tweets, color(black) size(large))
