FROM ubuntu:latest

# install additional system dependencies
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest python3.6 python3-pip python3-setuptools python3-dev
RUN apt-get update && apt-get install -y libxml2-dev zlib1g-dev libgit2-dev libcurl4-openssl-dev  wget

WORKDIR /project_GEO
COPY app/ .

# install packages
RUN pip install biopython
RUN pip install pandas
RUN pip install subprocess.run


RUN Rscript -e 'install.packages("BiocManager")'
RUN Rscript -e 'BiocManager::install("GEOquery")'
RUN Rscript -e 'install.packages("tidyverse")'

#RUN chmod -R +x *
#CMD ["python3","./getDataGEO.py"]
