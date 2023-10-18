suppressPackageStartupMessages(
    {
library(magrittr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(tibble, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(purrr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(seqinr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(stringr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(tidyr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
#library(IRanges, quietly = TRUE, warn.conflicts = FALSE)
library(reshape2, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(fastcluster, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
#library(parallelDist)
library(furrr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(future, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
    })
#####Load paths and RDS ----
input0 <- as.character(commandArgs(trailingOnly = TRUE))

#only for manual run 
# input0 <- ""
# input0[1] <- "projdir=/bioinf/shared/cristinam_students/Phage_Group_DBs/NCBI_Genomes/GenBankViral/ssDNA-petitvirales/assem/fna_viridic/" ##toward viridic out folder
# #input0[1] <- "projdir=/bioinf/shiny-server/VIRIDIC/stand_alone/TEST/test19"
# input0[2] <- "clust=complete"
# input0[3] <- "res=similarity"
# input0[4] <- "thsp=95"         #threshold for species
# input0[5] <- "thgen=70"

print(input0)

###functions file
functions_path_c <- str_which(input0, "^functions_path=")
functions_path <- str_remove(input0[functions_path_c], "^functions_path=")
source(functions_path)
rm(functions_path, functions_path_c)

ram_max <- get_params_simple_fun(input0, param_name= "ram_max", type="Num")
options(future.globals.maxSize = ram_max)
print(paste0("future.globals.maxSize is ", getOption("future.globals.maxSize")))


#get params old way

in1 <- str_which(input0, "projdir=")
in2 <- str_which(input0, "clust=")
in3 <- str_which(input0, "res=")
in4 <- str_which(input0, "thsp=")
in5 <- str_which(input0, "thgen=")

input <- ""
input[1] <- str_remove(input0[in1], "projdir=")

if(length(in2) == 0)
{
  input[2] <- "complete"
}else
{
  input[2] <- str_remove(input0[in2], "clust=")
}

if(length(in3) == 0)
{
  input[3] <- "similarity"
}else
{
  input[3] <- str_remove(input0[in3], "res=")
}

if(length(in4) == 0)
{
  input[4] <- "95"
}else
{
  input[4] <- str_remove(input0[in4], "thsp=")
}

if(length(in5) == 0)
{
  input[5] <- "70"
}else
{
  input[5] <- str_remove(input0[in5], "thgen=")
}

rm(input0, in1, in2, in3, in4, in5)

ProjDir  <- input[1]
blastn_DF_g <- readRDS(paste0(ProjDir, "/03_calculations_out/blast_sim_DF.RDS"))


## Prepare matrices (as DFs)---------------
sim_matrix_DF <- blastn_DF_g %>%
  dplyr::rename(genome = qseqid) %>%
  select(genome, sseqid, interg_sim)%>%
  spread(sseqid, interg_sim) 

if(input[3]=="similarity")
{
  sim_matrix_DF <- sim_matrix_DF%>%
    replace(is.na(.), 0)  
}else
{
  sim_matrix_DF <- sim_matrix_DF%>%
    replace(is.na(.), 100)  
}


row.names(sim_matrix_DF) <- sim_matrix_DF$genome

sim_matrix_DF2 <- sim_matrix_DF %>%               ##### I need a DF without the genome column, for makign euclidian distances and determining the clusters
  select(-genome)

fractqslen_matrix_DF <- blastn_DF_g %>%
  dplyr::rename(genome = qseqid) %>%
  select(genome, sseqid, fract_qslen)%>%
  spread(sseqid, fract_qslen) #%>%
  #replace(is.na(.), 0)
row.names(fractqslen_matrix_DF) <- fractqslen_matrix_DF$genome
fractqslen_matrix_DF <- fractqslen_matrix_DF %>%
  select(-genome)

qFractAlign_matrix_DF <- blastn_DF_g %>%
  dplyr::rename(genome = qseqid) %>%
  select(genome, sseqid, q_fract_aligned)%>%
  spread(sseqid, q_fract_aligned) %>%
  replace(is.na(.), 0)
row.names(qFractAlign_matrix_DF) <- qFractAlign_matrix_DF$genome
qFractAlign_matrix_DF <- qFractAlign_matrix_DF %>%
  select(-genome)

sFractAlign_matrix_DF <- blastn_DF_g %>%
  dplyr::rename(genome = qseqid) %>%
  select(genome, sseqid, s_fract_aligned)%>%
  spread(sseqid, s_fract_aligned) %>%
  replace(is.na(.), 0)
row.names(sFractAlign_matrix_DF) <- sFractAlign_matrix_DF$genome
sFractAlign_matrix_DF <- sFractAlign_matrix_DF %>%
  select(-genome)



############ hclust and clustering ----------
if(input[3] == "similarity")
{
  dist_DF <- as.matrix(100-sim_matrix_DF2)
}else
{
  dist_DF <- as.matrix(sim_matrix_DF2)
}

dist_obj <- dist_DF %>%
  as.dist()

hclust_obj <- hclust(d = dist_obj, method = input[2])


cutree_obj_sp <- cutree(hclust_obj, h = (100- as.numeric(input[4]))) %>%
  as.data.frame()
colnames(cutree_obj_sp) <- "species_cluster"
cutree_obj_sp$genome <- row.names(cutree_obj_sp)

cutree_obj_gen <- cutree(hclust_obj, h = (100 - as.numeric(input[5]))) %>%
  as.data.frame()
colnames(cutree_obj_gen) <- "genus_cluster"
cutree_obj_gen$genome <- row.names(cutree_obj_gen)

clusters_DF <- full_join(cutree_obj_sp, cutree_obj_gen) %>%
  select(genome, species_cluster, genus_cluster)

rm(dist_obj, cutree_obj_sp, cutree_obj_gen)

#create ordered DFs ------
order_obj <- hclust_obj$order
order_obj2 <- order_obj + 1 

row.names(clusters_DF) <- clusters_DF$genome
clusters_DF <- clusters_DF[order_obj,]

sim_matrix_DF <- sim_matrix_DF[order_obj, c(1, order_obj2)]
order_genomes <- sim_matrix_DF$genome %>%
  str_remove("\\.$")                                                            # removes the . at the end of the phage names, because they are removed from the column name. I should do this step in the very begining, or, better yet, I should warn the user not to have points at the end of their genome names.

sim_matrix_DF2 <- sim_matrix_DF2[order_genomes, order_genomes]
fractqslen_matrix_DF <- fractqslen_matrix_DF[order_genomes, order_genomes]
qFractAlign_matrix_DF <- qFractAlign_matrix_DF[order_genomes, order_genomes]
sFractAlign_matrix_DF <- sFractAlign_matrix_DF[order_genomes, order_genomes]

len_DF <- blastn_DF_g %>%
  select(genome=qseqid, qlen) %>%
  distinct() %>%
  as.data.frame()
row.names(len_DF) <- len_DF$genome
len_DF <- len_DF[order_genomes,]

rm(hclust_obj, order_obj, order_obj2, order_genomes)


## SAVE outputs ---------------------------------------------------
step04_dir <- paste0(ProjDir, "/04_VIRIDIC_out")
if(dir.exists(step04_dir)==TRUE){unlink(step04_dir, recursive = TRUE)}
dir.create(step04_dir)

sim_matrix_DF2_p <- paste0(step04_dir, "/sim_MA.RDS")
fractqslen_matrix_p <- paste0(step04_dir, "/fractqslen_MA.RDS")
qFractAlign_matrix_p <- paste0(step04_dir, "/qFractAlign_MA.RDS")
sFractAlign_matrix_p <- paste0(step04_dir, "/sFractAlign_MA.RDS")
len_p <- paste0(step04_dir, "/len_DF.RDS")
sim_matrix_DF_p <- paste0(step04_dir, "/sim_MA_genCol.RDS")
sim_matrix_DF_csvp <- paste0(step04_dir, "/sim_MA_genCol.csv")
clusters_p <- paste0(step04_dir, "/clusters.csv")


#save as RDS the ordered DFs, without the genome column, but with row names  --> to be used for heatmap
saveRDS(sim_matrix_DF2, sim_matrix_DF2_p)
saveRDS(fractqslen_matrix_DF, fractqslen_matrix_p)
saveRDS(qFractAlign_matrix_DF, qFractAlign_matrix_p)
saveRDS(sFractAlign_matrix_DF, sFractAlign_matrix_p)
saveRDS(len_DF, len_p)

#save as csv the ordered simDF with genome column  --> to be used for sim/dist table
saveRDS(sim_matrix_DF, sim_matrix_DF_p)
write.table(x = sim_matrix_DF, file = sim_matrix_DF_csvp, sep = "\t", row.names = FALSE, col.names = TRUE)

#save as csv the ordered DF with genome names, and species and genus clusters --> to be used for cluster table
write.table(x= clusters_DF, file = clusters_p, sep = "\t", row.names = FALSE, col.names = TRUE)

