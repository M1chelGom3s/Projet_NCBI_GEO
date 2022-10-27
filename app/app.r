# if (!require("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# 
# BiocManager::install("GEOquery")

library(GEOquery)
library(tidyverse)

options(timeout = max(300, getOption("timeout")))
options(download.file.method.GEOquery = "wget")

mac_table = read.table(file = 'macBrain.tsv', sep = '\t', header = TRUE)
nb_row = mac_table %>% nrow()
i = 0

while (i < nb_row){
  i = i+1
  accrssion = mac_table[i,2]
  
  gset = getGEO(accrssion, GSEMatrix =TRUE, getGPL=FALSE)
  for (gse in gset){
    autor = gse@experimentData@name
    title = gsub(" ", "_", gse@experimentData@title)
    description = mac_table[i,4] 
    acc = gse@experimentData@other[["geo_accession"]]
    file_name = paste(autor, acc ,title, sep = "-")
    file_description = paste(file_name,"description.txt", sep = "/")
    file_dataCount= paste(file_name,"dataCount.tsv", sep = "/")
    file_Meta = paste(file_name,"metaData.tsv", sep = "/")
    data_count = exprs(gse)
    meta = pData(gse)
    if (!file.exists(file_name)){
      dir.create(file_name)
      print(paste("creat",file_name, "directory"))
      write.table(description, file = file_description, sep = "")
      if (data_count %>% nrow() == 0){
        
        getGEOSuppFiles(accrssion, baseDir = file_name, makeDirectory = FALSE)
        print(paste("creat","table count", "file"))
      }else{
        write.table(data_count, file=file_dataCount, sep='\t')
        print(paste("creat",file_dataCount, "file"))
      }
      write.table(meta, file=file_Meta, sep='\t')
      print(paste("creat",file_Meta, "file"))
      
      rm(gset,data_count,meta)
      
    }
    
  }
  
}

# gse = getGEO(filename="dowloads/GSE113370_family.soft.gz",GSEMatrix=TRUE)
# if (length(gse) > 1) idx = grep("GPL11180", attr(gse, "names")) else idx = 1
# gse = gse[[1]]


# ex = exprs(gse)
# for (accrssion in acc$accessions){
#   gset = getGEO(accrssion, GSEMatrix =TRUE, getGPL=FALSE)
#   gset = gset[[1]]
#   data_count = exprs(gset)
#   meta = pData(gset)
# }
# gset = getGEO("GSE129178", GSEMatrix =TRUE, getGPL=FALSE)
# gset = gset[[1]]
# exprs(gset) %>% nrow()
# gset = getGEOSuppFiles("GSE129178")

# pData(gset)
# Table(GSMList(gse)[[1]])[1:5,]
# get the probeset ordering
# probesets = Table(GPLList(gse)[[1]])$ID
# make the data matrix from the VALUE columns from each GSM
# being careful to match the order of the probesets in the platform
# with those in the GSMs
# data.matrix = do.call('cbind',lapply(GSMList(gse),function(x)
# {tab = Table(x)
# mymatch = match(probesets,tab$ID_REF)
# return(tab$VALUE[mymatch])
# }))
# data.matrix = apply(data.matrix,2,function(x) {as.numeric(as.character(x))})
# data.matrix = log2(data.matrix)
# data.matrix[1:5,]
# rm(gse)
