#Project 1 R program to crawl, parse and extract all articles published in a specific journal
#Group 6:Duyen Ngyen, Bicheng Xiao, Shubham Gulia
#2016 Fall

#Journal Name: BMC Medical Genetics
#Total article number: 1642
#Main page of the journal: https://bmcmedgenet.biomedcentral.com/

source(paste(getwd(),"/project/util.R",sep=""))
library(bitops)
library(RCurl)
library(XML)
library(stringr)

#load(readLines) main page & save to (.html) file
site.url = "https://bmcmedgenet.biomedcentral.com/"
site.url.clear = "https://bmcmedgenet.biomedcentral.com"
main.page = readLines(site.url)
options(warn=-1)
dir.create("HTMLs")
#write(main_page, file = "HTMLs/main_page.html")
#print("[I/O]: FILE: main_page.html created.")

#get the link of "Article List Page" URL from main page
page.list.url = paste(site.url,substr(main.page[grep("(<a class=.navbar__link.+href).+(>Articles<\\/a>)",main.page)],72,79),"/",sep="")
page.list = readLines(page.list.url)
write(page.list, file="HTMLs/article_list_page.html")
print("[I/O]: FILE: article_list_page.html created.")

#get the URL of all "Article list page" url, total 66 pages, each page has maximum 25 articles
#find max page numbers
page_index = str_extract_all(page.list[grep('<span class=\\"Control_name\\" data-test=\\"pagination-text\\">Page \\d+ of \\d+<\\/span>',page.list)][1],"\\d+")[[1]];
min.page.count = page_index[1];
max.page.count = page_index[2];
page.url = paste(site.url, str_extract(page.list[grep('<a class="Pager Pager--next".+',page.list)][1],"articles\\?.+page\\="),sep="")
page.url = xpathApply(htmlParse(page.url, asText=TRUE),"//body//text()", xmlValue)[[1]]

#generate article url list
page.url.list = ""
article.data = data.frame(DOI=c(),url=c())
for(i in min.page.count:max.page.count){
  percent = toString(as.integer((i/as.integer(max.page.count))*100))
  cat("\r",paste("[APP]: loading page number: ",i," [", percent, "%]"))
  full.url = paste(page.url,i,sep="")
  articleUrl_and_doi = loadArticleList(full.url)#function call: loadArticleList()
  articleUrl_and_doi$url = paste(site.url.clear, articleUrl_and_doi$url, sep="")#add site url, to fulfill the url of an article
  article.data = rbind(article.data, articleUrl_and_doi)#rown bind, store all article DOI, urls
  page.url.list = c(page.url.list, full.url)
}
page.url.list = page.url.list[-1]
write(page.url.list, "page.url.list.txt")
print("[I/O]: FILE: page.url.list.txt created.")
write.csv(article.data, "article.DOI.URL.list.csv")
print("[I/O]: FILE: article.DOI.URL.list.csv created.")


#circuly analysis the articles and extract required information, and form all information in a data.frame
extracted.data = data.frame(DOI=c(),Title=c(),Author=c(), "Author Affiliation"=c(), "Corresponding Author"=c(), "Corresponding_Author_email"=c(), 
                            "Publication Date"=c(), Abstract=c(), Keywords=c(), "Full Text"=c())
total.number = as.integer(length(article.data[,1]))
for(i in 1:total.number){
  extracted.data = rbind(extracted.data, analysisArticle(article.data[i,1], article.data[i,2]))#function call: analysisArticle
  cat("\r", paste("[I/O]: FILE:", toString(i), article.data[i,1], ".html created. [",toString(as.integer(i/total.number*100)), "%]"))
}

#Write the final result to BMC Medical Genetics.txt
options(warn=-1)
dir.create("output")
write.table(extracted.data,"output/BMC Medical Genetics.txt",sep="\t",row.names=FALSE,fileEncoding = "UTF-8")
print("[I/O]: FILE: output/BMC Medical Genetics.txt created.")