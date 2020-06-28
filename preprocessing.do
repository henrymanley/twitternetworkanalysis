use "formatrix.dta", clear

split tweet_clean, parse("") gen(tokens_)
local punctuation = ". ~ ? ) , ] ! [ : + $ ; - & # % ( * 1 2 3 4 5 6 7 8 9 0"

drop id-tag
local y = 1
foreach i of local punctuation {
	describe
	forval j = 1/`r(k)'{
		replace tokens_`j' = subinstr(tokens_`j', "`i'", "",.)
		replace tokens_`j' = subinstr(tokens_`j',`"""',"",.)
		replace tokens_`j' = subinstr(tokens_`j',`"'"',"",.)
		replace tokens_`j' = "" if strpos(tokens_`j', "@")!=0
		replace tokens_`j' = "" if strpos(tokens_`j', "/")!=0
		replace tokens_`j' = "" if strpos(tokens_`j', "\")!=0
		replace tokens_`j' = "" if strlen(tokens_`j')< 3
	loc j = `j' + 1		
	}
}
gen id = _n
reshape long tokens_, i(id)
drop if tokens_ ==""
sort tokens_
quiet by tokens_ : gen count = _N
quiet by tokens_ : keep if _n == 1

txttool tokens_, replace stopwords("stopwords.txt") 
drop if tokens_ ==""
gsort - count
gen words = tokens_ if _n <100
keep words
