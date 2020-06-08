## Building the Network




### Encoding variables based on occurence
```
local varList "tesla rocket alien robot falcon dragon car science computer ai love tech technology engine energy"
foreach i of local varList {
gen `i' = 0
replace `i' = 1 if regexm(tweet_clean, ["`i'"])
}

```
### Define and names empty n x n Matrix B
```
mat B =J(15,15,0)
local y = 1
foreach i of local varList{
tokenize `varList'
local  varList1 = regexr("`varList'","`y'","")
mat rownames B = `varList1'
mat colnames B = `varList1'
loc y = `y' + 1
}
```
### Populates Matrix B with frequency of words
```
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
```
### Creates Adjacency Matrix A
```
mat A =J(15,15,0)
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
```
### Saves matrix A and obtains freq from matrix B (diagonal) and merges it to output
```
mat C = vecdiag(B)
mat D = C'
	
svmat A 
svmat D
	
keep A1-D1
export delimited "adjmat.csv", replace
	
*VI sets the network
import delimited "adjmat.csv", delimiter(comma) clear
nwimport "adjmat.csv", type(matrix)

local varList "tesla rocket alien robot falcon dragon car science computer ai love tech technology engine energy"
local y = 1
foreach i of local varList{
	replace _nodelab = "`i'" in `y'
	loc y = `y' + 1
}

	nwplot adjmat_1, label(_nodelab) size(d1) title(Elon Musk Tweets, color(black) size(large)) scatteropt(mfcolor(red))

```

### Words of interest
`local varList "tesla rocket alien robot falcon dragon car"`

### Adjacency Matrix Weights
```
mat B =J(7,7,.)
mat colnames B = "tesla" "rocket" "alien" "robot" "falcon" "dragon" "car"
mat rownames B = "tesla" "rocket" "alien" "robot" "falcon" "dragon" "car"

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
```
### Adjacency Matrix
###### Note symmetry in the matrix. (There is no respect to order of occurence, just purely occurence)

```
local y = 1
foreach i of local varList {
	local x = 1
	foreach j of local varList {
		summ freq_`i'_`j'
			if r(max) > 0 {
				mat A[`x', `y']= 1
			}
			else {
				mat A[`x',`y']= 0	
			}
		loc x = `x' + 1
		}
	loc y = `y' + 1
	}
	
	svmat A 
	keep A1 A2 A3 A4 A5 A6 A7

export delimited "adjmat.csv", replace
```

## Visualizing the Network
```
find it nwcommands

import delimited "adjmat.csv", delimiter(comma) clear
nwimport "adjmat.csv", type(matrix)
	replace _nodelab = "tesla" in 1
	replace _nodelab  = "rocket" in 2
	replace _nodelab  = "alien" in 3
	replace _nodelab  = "robot" in 4
	replace _nodelab  = "falcon" in 5
	replace _nodelab  = "dragon" in 6
	replace _nodelab  = "car" in 7
nwplot adjmat, label(_nodelab)
```
