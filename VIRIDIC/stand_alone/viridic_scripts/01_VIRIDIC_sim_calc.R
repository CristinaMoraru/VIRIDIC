
## Librarries----------------------------------------------------------------
suppressPackageStartupMessages(
    {
library(magrittr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(tibble, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(purrr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(seqinr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(stringr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(tidyr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(IRanges, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(reshape2, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(pheatmap, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(ggplot2, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(fastcluster, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(parallelDist, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(furrr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(future, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
    })

## Initialize project-------------------------------------------------------
input0 <- as.character(commandArgs(trailingOnly = TRUE))
print(input0)
#only for manual run
# input0 <- ""
# input0[1] <- "projdir=/bioinf/shiny-server/VIRIDIC/stand_alone/TEST/checker2/"
# input0[2] <- "in=/bioinf/shiny-server/VIRIDIC/stand_alone/TEST/all_zobellviridae_genomes_input.fasta"
# input0[3] <- "res=similarity"
# input0[4] <- "bln='-word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2'"
# input0[5] <- "ncor="
# input0[8] <- "future=multisession"

###functions file
functions_path_c <- str_which(input0, "^functions_path=")
functions_path <- str_remove(input0[functions_path_c], "^functions_path=")
source(functions_path)
rm(functions_path, functions_path_c)

ram_max <- get_params_simple_fun(input0, param_name= "ram_max", type="numeric")
options(future.globals.maxSize = ram_max)
print(paste0("future.globals.maxSize is ", getOption("future.globals.maxSize")))

#get params old way
in1 <- str_which(input0, "^projdir=")
in2 <- str_which(input0, "^in=")
in3 <- str_which(input0, "^res=")
in4 <- str_which(input0, "^bln=")
in5 <- str_which(input0, "^ncor=")
#in8 <- str_which(input0, "future=multisession")

input <- ""
input[1] <- str_remove(input0[in1], "^projdir=")
input[2] <- str_remove(input0[in2], "^in=")

if(length(in3) == 0)
{
  input[3] <- "similarity"
}else
{
  input[3] <- str_remove(input0[in3], "res=")
}

if(length(in4) == 0)
{
  input[4] <- "-word_size 20 -reward 1 -penalty -2" # -gapopen 5 -gapextend 2"
}else
{
  input[4] <- str_remove(input0[in4], "bln=")
}

if(length(in5) == 0)
{
  input[5] <- "10"
}else
{
  input[5] <- str_remove(input0[in5], "ncor=")
}

#input[8] <- str_remove(input0[in8], "future=")

rm(input0, in1, in2, in3, in4)#, in8)


ProjDir  <- input[1] ###this is the project folder created by shiny
if(dir.exists(ProjDir)==FALSE)
{dir.create(ProjDir)}

all_genomes_path <- input[2] ###it copies the input file from shiny in the user folder


## Make BlastDB ----------------------------------------------------------
step01_dir <- paste0(ProjDir, "/01_BlastDB")
if(dir.exists(step01_dir)==TRUE){unlink(step01_dir, recursive = TRUE)}
dir.create(step01_dir)

makeBlastDB_log_path <- paste0(step01_dir, "/makeBlastDB_log.txt")
DNA_blastDB_path <- paste0(step01_dir, "/All_genomes_BlastDB")
makeBlastDB_cmd <- paste0("makeblastdb -in ", all_genomes_path, " -input_type fasta -dbtype 'nucl' -out ", DNA_blastDB_path, " -title ", DNA_blastDB_path, " > ", makeBlastDB_log_path)

system(makeBlastDB_cmd)

rm(step01_dir, makeBlastDB_log_path, makeBlastDB_cmd)

## BLASTN--------------------------------------------------------------
step02_dir <- paste0(ProjDir, "/02_BlastN_out")
if(dir.exists(step02_dir)==TRUE){unlink(step02_dir, recursive = TRUE)}
dir.create(step02_dir)

blastn_log <- paste0(step02_dir, "/blastn_log.txt")
blastn_out_path <- paste0(step02_dir, "/ALL_genomes_blastn_out.txt")
outfmt<- ' -outfmt "6 qseqid sseqid evalue bitscore qlen slen qstart qend sstart send qseq sseq nident gaps"'

blastn_cmd <- paste0("blastn -db ", DNA_blastDB_path, " -query ",  all_genomes_path, " -out ", blastn_out_path,  outfmt, " -evalue 1 -max_target_seqs 10000 -num_threads ", input[5], 
                     " ", input[4], " 2>", blastn_log)
system(blastn_cmd)

rm(outfmt, blastn_log, blastn_cmd, DNA_blastDB_path, all_genomes_path, step02_dir)


## functions  -------------------------------------------------------
nident_fun <- function(DF, gen_len)
{
  if(nrow(DF)== 1)
  {
    dfs <- DF%>%
      mutate(nident_recalc = nident)%>%
      mutate(alig_q = abs(qstart-qend)+1)
  }else
  {
    dfs <- DF %>%
      filter(qstart == 1, qend == gen_len)
    
    if(nrow(dfs) == 1)
    {
      dfs <- dfs%>%
        mutate(nident_recalc = nident)%>%
        mutate(alig_q = abs(qstart-qend)+1)
    } else
    {
      if(nrow(dfs) == 0)
      {
        rm(dfs)
        ir <- IRanges(start = as.numeric(DF$qstart), end = as.numeric(DF$qend), names = seq(from = 1, to = nrow(DF)))
        cov <- coverage(ir) %>%
          as.vector()
        cov2 <- cov[cov >1]
        
        if(length(cov2) == 0)
        {
          dfs <- DF %>%
            mutate(nident_recalc = nident)%>%
            mutate(alig_q = abs(qstart-qend)+1)
        }else
        {
          rm(ir, cov, cov2)
          
          dfs <- DF %>%
            mutate(alig_q = abs(qstart-qend)+1) %>%
            arrange(desc(alig_q))
          
          ##remove all hits incuded in another hit (can I maybe use the code below with the cov? because then I get rid of 2 for loops)
          for(a in nrow(dfs):2)
          {
            for(b in 1:(a-1))
            {
              if(dfs$qstart[b] <= dfs$qstart[a] & dfs$qend[a] <= dfs$qend[b])
              {
                dfs <- dfs[-a, ]
                break()
              }
            }
            rm(b)
          }
          rm(a)
          
          
          ir <- IRanges(start = dfs$qstart, end = dfs$qend, names = seq(from = 1, to = nrow(dfs)))
          cov <- coverage(ir) %>%
            as.vector()
          cov2 <- cov[cov >1]
          
          if(length(cov2) > 0)
          {
            #remove hits that are completely overlapping two other ranges
            for(i in nrow(dfs):1)
            {
              cov_r <- cov[dfs$qstart[i]:dfs$qend[i]] %>%
                min()
              if(cov_r > 1)
              {
                dfs <- dfs[-i, ]
                ir <- IRanges(start = dfs$qstart, end = dfs$qend, names = seq(from = 1, to = nrow(dfs)))
                cov <- coverage(ir) %>%
                  as.vector()
              }
              rm(cov_r)
            }
            rm(i)
            
            cov2 <- cov[cov >1]   
            if(length(cov2) == 0)
            {
              dfs <- dfs %>%
                mutate(nident_recalc = nident)
            }else
            {
              dfs <- dfs %>%
                arrange(dplyr::desc(qstart)) %>%
                mutate(nident_recalc = nident) %>%
                mutate(qstart_recalc = qstart) %>%
                mutate(qend_recalc = qend)
              
              for(a in nrow(dfs):2)
              {
                for(b in (a-1):1)
                {
                  if((dfs$qend_recalc[a] >= dfs$qstart_recalc[b]) & (dfs$qstart_recalc[a] < dfs$qstart_recalc[b]))
                  {
                    overlap <- dfs$qend_recalc[a] - dfs$qstart_recalc[b] + 1
                    
                    q_over_a <- dfs$qseq[a] %>%
                      str_replace_all("-", "") %>%
                      str_sub(start = -overlap, end = -1) %>%
                      s2c %>%
                      paste0("-*") %>%
                      c2s()
                    
                    q_over_a_ext <- dfs$qseq[a] %>%
                      str_extract(q_over_a) %>%
                      s2c()
                    
                    s_over_a <- dfs$sseq[a] %>%
                      str_sub(start = -length(q_over_a_ext), end = -1) %>%
                      s2c()
                    
                    diffe_a <- str_match(q_over_a_ext, s_over_a) %>%
                      is.na() %>%
                      sum()
                    
                    dfs[a,"nident_recalc"] <- dfs$nident[a] - (length(q_over_a_ext) - diffe_a)
                    dfs[a, "qend_recalc"] <- dfs$qstart_recalc[b]-1
                    rm(overlap, q_over_a, q_over_a_ext, s_over_a, diffe_a)
                  }
                }
              }
              
            }
          }else
          {
            dfs <- dfs %>%
              mutate(nident_recalc = nident)
          }
          
        }
      }else
      {
        dfs <- dfs%>%
          mutate(nident_recalc = 100000)%>%
          mutate(alig_q = abs(qstart-qend)+1)
      }
    }
    
    
  }
  
  nident_o <- sum(dfs$nident_recalc)
  align_q_o <- sum(dfs$alig_q)
  
  outp <- c(nident_o, align_q_o)
  return(outp)
}

s_nident_fun <- function(q, s, DF)
{
  DF2 <- DF %>%
    filter(sseqid == q, qseqid == s)
  if(nrow(DF2) == 1)
  { 
    ret <- c(DF2$q_nident, DF2$q_fract_aligned)
  }else
  {
    if(nrow(DF2) == 0)
    {
      ret <- c(0, 0)
    }else
    {ret <- c(-100, -100)}
    
  }
  
  return(ret)
}

det_dist_fun <- function(simDF, th, sim_dist) ##th = 95 or 70
{
  simDF_ma <- as.matrix(simDF)
  th <- as.numeric(th)
  
  if(sim_dist == "distance")
  {
    th <- 100 - th
    elems <- base::which(simDF <= th)
    intergenome <- simDF_ma[elems] %>%
      max()
  }else
  {
    elems <- base::which(simDF >= th)
    intergenome <- simDF_ma[elems] %>%
      min()
  }
  
  sel_elem <- which(simDF == intergenome) 
  return(sel_elem)
}

## -CALCULATE Intergenomic similarities/distances-------------------------------------------------
blastn_DF <- data.table::fread(blastn_out_path, sep = "\t", header = FALSE, stringsAsFactors = FALSE, drop = c(3, 4))
colnames(blastn_DF) <- c("qseqid", "sseqid", "qlen", "slen", "qstart", "qend", "sstart", "send", "qseq", "sseq", "nident", "gaps")

blastn_DF_g <- blastn_DF %>%
  group_by(qseqid, sseqid, qlen, slen) %>%
  nest()

rm(blastn_DF)

plan(multisession)

outp_ls <- future_map2(.x = blastn_DF_g$data, .y = blastn_DF_g$qlen, .f = nident_fun)
blastn_DF_g[, "q_nident"] <- lapply(outp_ls, "[[", 1) %>%
  unlist()
blastn_DF_g[, "q_aligned"] <- lapply(outp_ls, "[[", 2) %>%
  unlist()
blastn_DF_g <- blastn_DF_g %>%
  mutate(q_fract_aligned = round(q_aligned/qlen, digits = 2))
rm(outp_ls)


ret_ls <- future_map2(.x = blastn_DF_g$qseqid, .y = blastn_DF_g$sseqid, .f = s_nident_fun, DF = blastn_DF_g)
blastn_DF_g[, "s_nident"] <- lapply(ret_ls, "[", 1) %>%
  unlist
blastn_DF_g[, "s_fract_aligned"] <- lapply(ret_ls, "[", 2) %>%
  unlist
rm(ret_ls)

blastn_DF_gbkp <- blastn_DF_g

blastn_DF_g <- blastn_DF_gbkp %>%
  select(-data) %>%
  ungroup() %>%
  mutate(qs_nident = (as.numeric(q_nident) + as.numeric(s_nident))) %>%
  mutate(qs_len = (qlen + slen)) %>%
  mutate(interg_sim = (qs_nident/qs_len)*100) %>%
  mutate(interg_sim = round(interg_sim, digits =3)) %>%
  mutate(fract_qslen = (pmin(qlen, slen)/pmax(qlen,slen))) %>%
  mutate(fract_qslen = round(fract_qslen, digits = 1)) %>%
  select(qseqid, sseqid, qlen, slen, q_nident, q_aligned, s_nident, qs_nident, qs_len, interg_sim, fract_qslen, q_fract_aligned, s_fract_aligned)


if(input[3] == "distance")
{
  blastn_DF_g <- blastn_DF_g %>%
    mutate(interg_sim = (100 - interg_sim))
}

blastn_DF_g <- blastn_DF_g %>%
  as.data.frame(stringsAsFactors = FALSE)

## SAVE outputs ---------------------------------------------------
step03_dir <- paste0(ProjDir, "/03_calculations_out")
if(dir.exists(step03_dir)==TRUE){unlink(step03_dir, recursive = TRUE)}
dir.create(step03_dir)

#save calculated BlastDF as RDS and as csv
saveRDS(blastn_DF_g, paste0(step03_dir, "/blast_sim_DF.RDS"))
write.table(x = blastn_DF_g, file = paste0(step03_dir, "/blast_sim_DF.csv"), sep = "\t", row.names = FALSE, col.names = TRUE)


