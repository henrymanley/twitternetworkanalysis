local newslist "cnn fox atlantic msnbc nyt washingtonpost wsj bloomberg breitbart economist"
foreach i of local newslist {
	import delimited "`i'tweets.csv"
	keep created_at text favorite_count is_retweet retweet_count screen_name
	drop if text ==""
	save "`i'tweets.dta", replace
	clear
}

use "cnntweets.dta"	
local newslist "fox atlantic msnbc nyt washingtonpost wsj bloomberg breitbart economist"
foreach i of local newslist {
	append using "`i'tweets.dta", force
}
replace text = lower(text)
save "tweets.dta", replace
split text, parse("") gen(tokens_)


local punctuation = ". ~ ? ) , ] ! [ : + $ ; - & # % ( * 1 2 3 4 5 6 7 8 9 0"
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

save "mostusedwords.dta", replace

drop if substr(tokens_,1, 4) == "http"
drop if strlen(tokens_)< 3
replace id = _n
keep if _n<=40
summ id 
scalar dim = r(max)
drop id

keep tokens_ count
append using "tweets.dta"

keep in 1/40
foreach i in `c(alpha)'{
	gen `i' = 0
	replace `i' = 1 if regexm(tokens_, ["`i'"])
}

sort tokens_
drop words
gen words = _n

xpose, clear
drop in 1

export delimited using "tocharvec", replace
