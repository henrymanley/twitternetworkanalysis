
## Packages to install
```
findit nwcommands
ssc install txttool
```
## Data
- See [tweets.dta](tweets.dta) for raw data collected using [tweetaccess.R](tweetaccess.R)
- See [tokenlist.dta](tokenlist.dta) for most frequent tokens in [tweets.dta](tweets.dta).

## Text preprocessing
See [preprocessing.do](preprocessing.do) for cleaning, tokenization, and sorting. Output is an array of the n most frequent words.

## Setting the network
See [networksetting.do](networksetting.do) for the computation of adjacency and frequency matrices using the n most frequent words. Similarly, the creation and visualization of the text network.
