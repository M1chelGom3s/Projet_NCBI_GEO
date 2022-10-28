#!/usr/bin/env python

from Bio import Entrez
import csv
import re
import subprocess
import pandas as pd
import os.path
import sys
import getopt


def usage():
    print ("Usage: ./getDataGEO.py -q [query] -d [data base] \n"
        "----------------------------------------------------------------\n"
        "-h                                 help (this message)\n"
        '-q <String>                        query NCBI(default : ("mouse"[Organism] OR "mus musculus"[Organism]) AND "macrophages"[Description] AND ("brain"[Description] OR "neurogenesis"[Description] OR "hippocampus"[Description]) AND ("postnatal day 0"[Description] OR "P0"[Description]))\n'
        "-d <String>                        Database name (default ; gds)\n"
        )
    exit(2)
#mouse"[Organism] OR "mus musculus"[Organism]) AND "macrophages"[Description] AND ("brain"[Description] OR "neurogenesis"[Description] OR "hippocampus"[Description])
try:
    opts, args = getopt.gnu_getopt(sys.argv[1:], "hq:d")
except getopt.GetoptError as err:
    print(err)  
    usage()
    sys.exit(2)
QUERY = '("mouse"[Organism] OR "mus musculus"[Organism]) AND "macrophages"[Description] AND ("brain"[Description] OR "neurogenesis"[Description] OR "hippocampus"[Description]) AND ("postnatal day 0"[Description] OR "P0"[Description])'
DB = 'gds'
input_query = False
for opts, args in opts:
    if opts in ('-h'):
        usage()
        sys.exit(2)
    elif opts in ('-q'):
        QUERY = str(args)
        input_query = True
    elif opts in ('-d'):
        DB = str(args)

if input_query:
    print("your query is the follow")
    print(QUERY)
    user_input = input('do you want to run this query (Y/n): ')

    yes_choices = ['yes', 'y']
    no_choices = ['no', 'n']

    if user_input.lower() in yes_choices:
        print('run the query')
    elif user_input.lower() in no_choices:
        QUERY = input('enter the query: \n')
    else:
        print('run the query')
Entrez.email = 'michel.Gomes.upmc@gmail.com'

handle = Entrez.esearch(db=DB, term=QUERY)
record = Entrez.read(handle)

count = record['Count']
if input_query:
    user_input = input('are you sure you want download '+str(count)+' accession ?(Y/n): ')

    yes_choices = ['yes', 'y']
    no_choices = ['no', 'n']

    if user_input.lower() in yes_choices:
        print('download of ',count,' accession ?')
    elif user_input.lower() in no_choices:
        exit(2)
    else:
        print('download of ',count,' accession ?')
handle = Entrez.esearch(db=DB, term=QUERY, retmax=count)
record = Entrez.read(handle)

id_list = record['IdList']
tsv_nameFile = 'macBrain.tsv'
update = False
if os.path.exists(tsv_nameFile):
    data1 = pd.read_csv(tsv_nameFile, sep='\t')
    update = True
else:
    data = []
    header = ['IDs', 'accessions', 'titles', 'descriptions', 'organisms']
    data.append(header)

nb_load = 0
for id in id_list:
    nb_load =+ 1
    handle = Entrez.efetch(db = DB, id = id)
    handle = (handle.read())
    handle = handle.split("\n")
    accession = re.split('\tAccession: |\tID:',handle[-2])[1]
    title = re.sub('1. ','',handle[1])
    
    
    if "GPL" not in accession:
        
        description = re.sub('(Submitter supplied) | more... ','',handle[2])
        organism = re.sub('Organism:|\t','',handle[3])
        type = handle[4]
    #else:
    #    organism = re.sub('Organism:|\t','',handle[2])
    #    description = ''
        row = [id, accession , title, description, organism]
        if "Expression profiling by SAGE" not in type:
            
            if update:
                if accession not in data1['accessions'].values:
                    print("update : ",organism,":",accession,";",title)
                    data1.loc[len(data1.index)] = row
            else:
                print(organism,":",accession,";",title)
                data.append(row)
        if nb_load == 15:
            nb_load = 0
            subprocess.run(timeout=45)

if update: 
    data1.to_csv(tsv_nameFile, sep="\t", index=False)

#print(data)
else:
    # writing to csv file 
    with open(tsv_nameFile, 'w') as csvfile: 
        # creating a csv writer object 
        csvwriter = csv.writer(csvfile, delimiter='\t')  
        # writing the data rows 
        csvwriter.writerows(data)

    
runR = "Rscript app.r"

subprocess.run(runR.split(), stderr=subprocess.PIPE, text=True)