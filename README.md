## Builing the Network

### Words of interest
`local varList "tesla rocket alien robot falcon dragon car"`

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
	gen id = ""
		replace id = "tesla" in 1
		replace id = "rocket" in 2
		replace id = "alien" in 3
		replace id = "robot" in 4
		replace id = "falcon" in 5
		replace id = "dragon" in 6
		replace id = "car" in 7
	
export delimited "adjmat.csv", replace
```

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

## Visualizing the Network
```
import delimited "adjmat.csv", delimiter(comma) clear
nwimport "adjmat.csv", type(matrix)
nwplot adjmat, lab
```
