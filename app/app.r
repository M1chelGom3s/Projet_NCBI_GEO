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
    autor =  gsub(",,",",",gse@experimentData@name)
    title = gsub(".","-",gse@experimentData@title )
    description = gse@experimentData@abstract
    acc = gse@experimentData@other[["geo_accession"]]
    overall_design = strsplit(gset[[1]]@experimentData@other[["overall_design"]], split = "[.] ")[[1]][[1]]
    file_name = paste(overall_design, autor , sep = "-")
    description = paste(title, autor,acc, description, sep = "\n")
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
