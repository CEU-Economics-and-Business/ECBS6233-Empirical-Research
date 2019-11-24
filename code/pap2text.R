library(RCurl)
library(XML)
library(xml2)

file<-read_html("pap.htm")
doc = htmlParse(file, asText=TRUE)

plain_text <- xpathSApply(doc, "//p", xmlValue)
#cat_text=cat(paste(plain.text, collapse = "\n"))

text_write=write.csv(plain_text,file="pap.txt")


