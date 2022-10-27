# download GSE 

This program searches from a query in NCBI (The National Center for Biotechnology Information) and extracts the search results from the search result page.

First, the program retrieves the following search results:

- Title 
- Id
- Accession
- Organism
- Description

Then in a second time for each accession a directory will be created.

So the associated metadata as well as the counting matrices which will be saved in two separate files.

## Setup development environment and use case

The development environment of this project can be encapsulated in a Docker container.
To avoid any library dependency problem, it is preferable to follow the following instructions and launch the application in a container

1. Install Docker. Follow the instructions on [https://docs.docker.com/install/](https://docs.docker.com/install/)
2. Open a console (or a terminal on a Mac). On Windows you can use Bash which comes with the installation of Git. Clone the GIT repository:
    ```shell
    git clone https://github.com/M1chelGom3s/project_getGEO.git
    ```

3. Setup development Docker container:
    ```shell
    cd project_getGEO | chmod +x bin/*
    bin/setup-environment.sh
    ```
    You should see lots of container build messages. Building the container might take a few minutes.
4. On Linux or Mac spin up the container using:
    ```shell
    bin/start_rstudio.sh
    # then
    bin/start_python_app.sh
    ```
5. On Docker terminal using by default:
    ```
    python3 getDataGEO.py
    ```
    Here by default we request are NGS data of brain macrophage at post natal stage day 0.
    And this by the following NCBI query:
    "mouse"[Organism] OR "mus musculus"[Organism]) AND "macrophages"[Description] AND ("brain"[Description] OR "neurogenesis"[Description] OR "hippocampus"[Description]) AND ("postnatal day 0"[Description] OR "P0"[Description]))

6. we can also set the keywords we want to search in NCBI GEO.
```shell
# usage: -q <String>     NCBI query
python3 getDataGEO.py -q [query]
```

## Setup development without Docker and use case

1. Make sure all dependencies is installed:
```shell
# dependencies python
pip install biopython
pip install pandas
pip install subprocess.run

# dependencies R
Rscript -e 'install.packages("BiocManager")'
Rscript -e 'BiocManager::install("GEOquery")'
Rscript -e 'install.packages("tidyverse")'

```
2. On terminal using by default:
    ```
    python3 getDataGEO.py
    ```
    Here by default we request are NGS data of brain macrophage at post natal stage day 0.
    And this by the following NCBI query:
    "mouse"[Organism] OR "mus musculus"[Organism]) AND "macrophages"[Description] AND ("brain"[Description] OR "neurogenesis"[Description] OR "hippocampus"[Description]) AND ("postnatal day 0"[Description] OR "P0"[Description]))

3. we can also set the keywords we want to search in NCBI GEO.
```shell
# usage: -q <String>     NCBI query
python3 getDataGEO.py -q [query]
```

