library(tidyverse)

check_D <- "/bioinf/shiny-server/VIRIDIC/stand_alone/viridic_scripts"
viridic_p <- "/bioinf/shiny-server/VIRIDIC/stand_alone/viridic_scripts/00_viridic_master.R"
projdir <- "/bioinf/shiny-server/VIRIDIC/stand_alone/Checker_data/test_projdir/"
if(dir.exists(projdir)){unlink(projdir, recursive = TRUE)}
in_p <- "/bioinf/shiny-server/VIRIDIC/stand_alone/Checker_data/all_zobellviridae_genomes_input.fasta"


status <- sys::exec_wait(cmd = "Rscript", 
                         args = c(viridic_p,
                                  paste0("projdir=", projdir),
                                  paste0("in=", in_p),
                                  "bln=-word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2", 
                                  "clust=complete",  
                                  "res=similarity", 
                                  "thsp=95", 
                                  "thgen=70",
                                  "sim_cols=PuBuGn", 
                                  "cols_Alig=peachpuff", 
                                  "cols_Frac=black", 
                                  "col_border_sim=none",  
                                  "col_border_frac=none",
                                  "show_sim=TRUE", 
                                  "show_sqLenFrac=TRUE",
                                  "show_qAligFrac=TRUE", 
                                  "show_sAligFrac=TRUE",
                                  "font_sim=8", 
                                  "font_sqLenFrac=4", 
                                  "font_qAligFrac=4", 
                                  "font_sAligFrac=4", 
                                  "font_row=12", 
                                  "font_col=12", 
                                  "annot_height=10", 
                                  "annot_font=100",
                                  "annot_rot=270", 
                                  "lgd_width=40", 
                                  "lgd_font=3",
                                  "lgd_pos=topleft", 
                                  "lgd_lab_font=3", 
                                  "sim_for_frac=0", 
                                  "sim_for_sim=0",  
                                  "lgd_height=3",
                                  "shiny=no"
                         ), 
                         std_out = paste0(check_D, "/viridic_checker_std_out.txt"), 
                         std_err = paste0(check_D, "/viridic_checker_std_err.txt"))


blastdb_vals <- paste0(projdir, "/01_BlastDB/All_genomes_BlastDB.", c("ndb", "nhr", "nin", "not", "nsq", "ntf", "nto"))


out_vals <- paste0(projdir, "/04_VIRIDIC_out/", c("sim_MA.RDS", "fractqslen_MA.RDS", "qFractAlign_MA.RDS", 
                                                  "sFractAlign_MA.RDS", "len_DF.RDS", "sim_MA_genCol.RDS", 
                                                  "sim_MA_genCol.csv", "clusters.csv", "Heatmap.PDF"))

check_TB <- tibble( 
  path_name = c(paste0(projdir, "/01_BlastDB"),
                blastdb_vals, 
                paste0(projdir, "/01_BlastDB/makeBlastDB_log.txt"),
                paste0(projdir, "/02_BlastN_out"),
                paste0(projdir, "/02_BlastN_out/ALL_genomes_blastn_out.txt"),
                paste0(projdir, "/02_BlastN_out/blastn_log.txt"),
                paste0(projdir, "/03_calculations_out"),
                paste0(projdir, "/03_calculations_out/blast_sim_DF.RDS"),
                paste0(projdir, "/03_calculations_out/blast_sim_DF.csv"),
                paste0(projdir, "/04_VIRIDIC_out"),
                out_vals),
  path_type = c("dir", 
                rep("file", 8),
                "dir", 
                rep("file", 2),
                "dir", 
                rep("file", 2),
                "dir",
                rep("file", 9)),
  path_exists = "")


for(i in 1:nrow(check_TB))
{
  
  if(check_TB$path_type[[i]] == "dir")
  {
    if(dir.exists(check_TB$path_name[[i]]))
    {
      check_TB[[i, "path_exists"]] <- "yes"
    }else
    {
      check_TB[[i, "path_exists"]] <- "no"
    }
  }
  
  if(check_TB$path_type[[i]] == "file")
  {
    if(file.exists(check_TB$path_name[[i]]))
    {
      check_TB[[i, "path_exists"]] <- "yes"
    }else
    {
      check_TB[[i, "path_exists"]] <- "no"
    }
  }
}
rm(i)


write.table(x = check_TB, file = "viridic_checker_results.tsv", sep = "\t", row.names = FALSE, col.names = TRUE)

## print diagnostics:
if(sum(str_detect(check_TB$path_exists, "no")) > 0)
{
  print("VIRIDIC did not produce all outputs. For details check file viridic_checker_results.tsv, viridic_checker_std_out.txt and viridic_checker_std_err.txt")
}else
{
  print("VIRIDIC has successfully passed this check.")
}




