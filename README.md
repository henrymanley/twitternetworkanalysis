
## Packages to install
```
findit nwcommands
ssc install txttool
```
## Data
- See [elonmusk_tweets.csv](elonmusk_tweets.csv) for raw data.
- See [formatrix.dta](formatrix.dta) for baseline cleaned data.

## Text preprocessing
See [preprocessing.do](preprocessing.do) for generalized approach to token cleaning in Stata. Output is an array of the n most frequent words.

## Setting the network
See [matrices.do](matrices.do) for the computation of adjacency and frequency matrices. Similarly, the creation and visualization of the text network.
