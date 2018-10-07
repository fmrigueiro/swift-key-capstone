load("unigram.Rda")
load("bigram.Rda")
load("trigram.Rda")
load("quadgram.Rda")
library(stringr)
library(stringi)
library(tm)
library(NLP)

wordproc <- function(sentence){
  found=c()
  sentence = gsub("[[:blank:]]+$","",sentence)
  sentence <- removeNumbers(sentence)
  sentence <- removePunctuation(sentence)
  sentence <- tolower(sentence)
  sentence = stripWhitespace(sentence)
  
  
  wordPred=function(nword,ngram){
    last.words=word(sentence,-nword,-1)
    foundlist = ngram[grep(paste("^",last.words," ",sep=""),ngram$word),]
    found=foundlist[word(foundlist$word,2,-1)!=last.words,]
    if(nrow(foundlist)!=0){
      if(length(found$word)<4){
        result=word(found$word,-1)
      }else{result=head(word(found$word,-1),4)}
    }else{
      result=c()
    }
    return(as.vector(result))
  }
  
  ## N grams check
  if(stri_count_words(sentence)>=3){
    found=wordPred(3,quadgram)
    mess="Next word is predicted using quadragram."
  }
  if(length(found)==0||stri_count_words(sentence)==2){
    found=wordPred(2,trigram)
    mess="Next word is predicted using trigram."
  } 
  if(length(found)==0||stri_count_words(sentence)==1){
    found=wordPred(1,bigram)
    mess="Next word is predicted using bigram."
  } 
  if(length(found)==0){
    found=head(unigram$word,4)
    mess="No match found, most common word is returned"
  }
 
  
  return(c(found,mess))
}
