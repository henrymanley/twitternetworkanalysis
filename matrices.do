
local complist CNN MSNBC nytimes WSJ business BreitbartNews TheEconomist FoxNews TheAtlantic washingtonpost
foreach k of local complist {
	use "cleantweets.dta",clear
	keep if time == 2
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


mata
void reduce() {
	D = st_matrix("D")
	E = st_matrix("E")
	F = (D - E)^2
	st_numscalar("name", sqrt(sum(F))/2)
}

end

capture program drop runme 
program define runme 

// base matrix 
mat D = A_CNN 
local complist CNN MSNBC nytimes WSJ business BreitbartNews TheEconomist FoxNews TheAtlantic washingtonpost

foreach k of local complist {
	mat E = A_`k'
	mata: reduce()
	scalar `k' = name
	noi display "`k' = " `k'
}
end

runme
