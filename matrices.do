import delimited "C:\Users\henry\OneDrive\Desktop\mostfrequent.csv"
drop in 1
keep v2
rename v2 words
save "words.dta", replace
append using "tweetss.dta"

levelsof words, local(wordlist)

*encodes (creates dummy) variables based on occurence
foreach i of local wordlist {
	gen x_`i' = 0
	replace x_`i' = 1 if regexm(text, ["`i'"])
}

*III
*counts frequency of words defined in (I) and populates nxn matrix
mat B =J(dim,dim,0)
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

*IV
*creates adjacency matrix (no respect for frequency)
mat A =J(dim,dim,0)
levelsof tokens_, local(wordlist)
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
	
	keep tokens_ A1-D1
	gen id = _n
	drop if id > dim
	export delimited adjmat.csv, replace

nwdrop
import delimited "adjmat.csv", delimiter(comma) clear
nwimport "adjmat.csv", type(matrix)

	nwplot adjmat, label(_nodelab) size(d1) title(News Tweets, color(black) size(large)) scatteropt(mfcolor(red))
	nwplotmatrix adjmat, label(_nodelab) title(News Tweets, color(black) size(large))
