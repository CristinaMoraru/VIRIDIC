# VIRIDIC
VIRIDIC (Virus Intergenomic Distance Calculator) computes pairwise intergenomic distances/similarities amongst viral genomes. VIRIDIC is available at www.viridic.icbm.de as a web-service or a singularity package. In addition, the R language source code can be accessed from this repository.  
If you use VIRIDIC, please cite: Moraru, C., Varsani, A., and Kropinski, A.M. (2020) VIRIDIC – a novel tool to calculate the intergenomic similarities of prokaryote-infecting viruses. Viruses 12(11). https://doi.org/10.3390/v12111268

This repository contains:
- the source code for the stand-alone VIRIDIC, written in R
- the source code for the shiny-app, which provides a graphical user interface for the standa-alone VIRIDIC


## How to install VIRIDIC

* copy to your profile the content of the VIRIDIC folder

* create and activate the VIRIDIC conda env

	- use the yml file from /VIRIDIC/stand_alone/user-install/VIRIDIC.yml to create the VIRIDIC conda env
	- install the specific R libraries
	
  ```bash
	conda env create -f VIRIDIC.yml
	conda activate VIRIDIC
	```
  ### Install R libraries from within R
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
  	install.packages("shinythemes")
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
## How to run VIRIDIC shiny-app
* Open RStudio, create a new project for the folder VIRIDIC (directly in this folder there are the files of the shiny-app)
* open either ui.R or server.R files in RStudio, press button "Run App"
* this will start the VIRIDIC GUI, which then runs the VIRIDIC stand-alone code

* In addition, if you install the shiny-server, you can run VIRIDIC as an independent web-app.
  
## How to run VIRIDIC stand-alone

* go to your folder with the VIRIDIC scripts
* use the command "Rscript 00_viridic_master.R [...options]"
* for options, see manual, either by running "Rscript 00_viridic_master.R help" or by checking the PDF file here: /VIRIDIC/stand_alone/download/viridic_manual_v1.1.pdf
 
```R
# example of how to run one VIRIDIC analysis
	Rscript 00_viridic_master.R projdir=/home/cmoraru/TEST_CLM/testVIridic in=/home/cmoraru/TEST_CLM/Ebeline_rel.fna ncor=10
	```


