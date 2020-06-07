## Words of interest
`local varList "tesla rocket alien robot falcon dragon car"`

## Adjacency Matrix
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
```

## Adjacency Matrix Weights
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
