use "formatrix.dta", clear

*I 
*encodes (creates dummy) variables based on occurence
foreach i of local varList {
gen `i' = 0
replace `i' = 1 if regexm(tweet_clean, ["`i'"])
}

*II
*sets and names matrix col/rows

mat B =J(dim[1],dim[1],0)
local y = 1
foreach i of local varList{
tokenize `varList'
local  varList1 = regexr("`varList'","`y'","")
mat rownames B = `varList1'
mat colnames B = `varList1'
loc y = `y' + 1
}

*III
*counts frequency of words defined in (I) and populations nxn matrix
local y = 1
foreach i of local varList {
	local x = 1
	foreach j of local varList {
		gen freq_`i'_`j' = `i'*`j'
		summ freq_`i'_`j'
			mat B[`x',`y']=r(sum)
		loc x = `x' + 1
		}
	loc y = `y' + 1
	}

*IV
*creates adjacency matrix (no respect for frequency)
mat A =J(dim[1],dim[1],0)
local y = 1
foreach i of local varList{
tokenize `varList'
local  varList1 = regexr("`varList'","`y'","")
mat rownames A = `varList1'
mat colnames A = `varList1'
loc y = `y' + 1
}

local y = 1
foreach i of local varList {
	local x = 1
	foreach j of local varList {
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

*V
*saves matrix A and obtains freq from matrix B (diagonal) and merges it to output
	mat C = vecdiag(B)
	mat D = C'
	
	svmat A 
	svmat D
	
	keep A1-D1
	export delimited adjmat.csv, replace


*VI sets the network
import delimited "adjmat.csv", delimiter(comma) clear
nwimport "adjmat.csv", type(matrix)

local varList "tesla rocket alien robot falcon dragon car science computer ai love tech technology engine energy earth great spacex hyperloop first life model orbit nasa world station mars project rate machine solar system transport planet colonize" 
local y = 1
foreach i of local varList{
	replace _nodelab = "`i'" in `y'
	loc y = `y' + 1
}

	nwplot adjmat, label(_nodelab) size(d1) title(Elon Musk Tweets, color(black) size(large)) scatteropt(mfcolor(blue))
