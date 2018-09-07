# Steps To Take for the Classification Task=====

## Import Woolwich dataset
## Divide the woolich dataset into training and test samples (70%-30%)
## Preprocessing for the training sample
### lowercase
### use snowball stemmer to stem words
### remove stop-words ()
### remove numbers
### remove punctuation
### do POS and keep nouns, verbs, adjectives and adverbs

## Feature extraction
## Build an SVM model from Woolwich datasets using training sample
## Calculate F measure using test sample
## If over 70% we're good.
## Export the model to classify new tweets
## Parallelise classification process across machines