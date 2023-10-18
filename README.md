# VIRIDIC
VIRIDIC (Virus Intergenomic Distance Calculator) computes pairwise intergenomic distances/similarities amongst viral genomes. 

This repository contains:
- the source code for the stand-alone VIRIDIC, written in R
- the source code for the shiny-app, which provides a graphical user interface for the standa-lone VIRIDIC


## How to install

* copy to your profile the VIRIDIC scripts found here: /VIRIDIC/stand_alone/viridic_scripts/

* create and activate the VIRIDIC conda env

	- use the yml file from /VIRIDIC/stand_alone/user-install/VIRIDIC.yml to create the VIRIDIC conda env
	- install the specific R libraries
	
  ```bash
	conda env create -f VIRIDIC.yml
	conda activate VIRIDIC
	```
  ### install R libraries from within R
  ```bash
	R  #this command starts R
  ```
  
  ```R
	options(repos = c(CRAN = "https://cloud.r-project.org/"))

	install.packages("stringr")
	install.packages("magrittr")
	install.packages("dplyr")
	install.packages("tibble")
	install.packages("purrr")
	install.packages("tidyr")
	install.packages("ggplot2")

	install.packages("DT")
	install.packages("shiny")
	install.packages("shinyjs")
	install.packages("shinyWidgets")
	install.packages("seqinr")

	#install.packages("IRanges")
		if (!require("BiocManager", quietly = TRUE))
		install.packages("BiocManager")
		BiocManager::install("IRanges")

	install.packages("reshape2")
	install.packages("pheatmap")
	install.packages("fastcluster")
	install.packages("parallelDist")
  	install.packages("furrr")
	install.packages("future")

	#install.packages("ComplexHeatmap")
		if (!require("BiocManager", quietly = TRUE))
		install.packages("BiocManager")
		BiocManager::install("ComplexHeatmap")
 ```

## How to run VIRIDIC

go to your folder with the VIRIDIC scripts
use command "Rscript 00_viridic_master.R [...options]"
for options, see manual, either by running "Rscript 00_viridic_master.R help" or by checking the PDF file here: /VIRIDIC/stand_alone/download/viridic_manual_v1.1.pdf
 
```R
# example of how to run one VIRIDIC analysis
	Rscript 00_viridic_master.R projdir=/home/cmoraru/TEST_CLM/testVIridic in=/home/cmoraru/TEST_CLM/Ebeline_rel.fna cpu=10
```
