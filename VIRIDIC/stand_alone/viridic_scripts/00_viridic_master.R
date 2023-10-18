library(stringr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)

input0 <- as.character(commandArgs(trailingOnly = TRUE))

#manual run
#input0 <- ""
# input0[1] <- "projdir=/bioinf/shiny-server/VIRIDIC/stand_alone/Checker_data/manual_tst"
# input0[2] <- "in=/bioinf/shiny-server/VIRIDIC/stand_alone/Checker_data/all_zobellviridae_genomes_input.fasta"

viridic_path <- getwd()  ## this assumes I'm in the VIRIDIC folder

#shiny flag ---
shiny_n <- str_which(input0, "^shiny=")                                         ## this is not accessible for the users, only for me from Shiny
if(length(shiny_n) == 1)
{
  shiny <- str_remove(input0[shiny_n], "shiny=")
  if(shiny == "yes")
  {
    viridic_path <- paste0(viridic_path, "/stand_alone/viridic_scripts/")
  }
}else
{
  shiny <- "no"
}
rm(shiny_n)


#functions file path
functions_path <- paste0(viridic_path, "/VIRIDIC_functions.R")
source(functions_path)

#help path
help_path <- paste0(viridic_path, "/viridic_manual_v1.1.txt")



#input0 <- "Rscript 00_viridic_master.R help"
#print(input0)
if(length(input0) ==1)
{
    if(input0[1] == "help")
    {
        cat_cmd <- paste0("cat ", help_path)
        system(cat_cmd)
    }
    
    if(input0[1] == "version")
    {
        print("VIRIDIC version 1.1")
    }
} else
{
    library(magrittr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
    library(stringr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
    library(dplyr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
    
    ## mandatory parameters--------
    projdir_n <- str_which(input0, "^projdir=")
    projdir <- str_remove(input0[projdir_n], "^projdir=")
    
    infile_n <- str_which(input0, "^in=")
    infile <- str_remove(input0[infile_n], "^in=")
    
    
    ## optional parameters all steps ---------
    
    ram_max <- get_params_fun(input0, param_name = "ram_max", type = "Num", 
                              default_val="2000", min_val=0, max_val = 100000, allowed = "", status_path = "")*(1024^2)
    
    
    #
    res_n  <- str_which(input0, "^res=")
    print(res_n)
    if(length(res_n) == 0)
    {
        res <- "similarity"
    }else
    { 
        res <- str_remove(input0[res_n], "^res=")
        
        res_t <- c("distance", "similarity")
        if(!res %in% res_t)
        {
            print(paste0("res=", res, " is a not a valid parameters"))
            quit()
        }
    }
    
    steps_n <- str_which(input0, "^steps=")
    if(length(steps_n) == 0)
    {
        steps <- "ALL"
    }else
    { 
        steps <- str_remove(input0[steps_n], "^steps=")
        steps_t <- c("ALL", "clust_heatmap", "sim_clust", "heatmap") 
        if(!steps %in% steps_t)
        {
            print(paste0("steps=", steps, " is a not a valid parameters"))
            quit()
        }
    }
    
    if(steps == "ALL")
    {    dir.create(projdir, showWarnings = FALSE)}
    
    ## optional parameters step1 ------------------  
    bln_n <- str_which(input0, "^bln=")
    if(length(bln_n) == 0)
    {
        bln <- "'-word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2'"
    }else
    {
        bln <- str_remove(input0[bln_n], "^bln=")
        bln <- paste0("'", bln, "'")
        
        bln_t <- c("'-word_size 20 -reward 1 -penalty -2'", "'-word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2'", 
                   "'-word_size 11 -reward 2 -penalty -3 -gapopen 5 -gapextend 2'", "'-word_size 28 -reward 1 -penalty -2'")
        
        if(!bln %in% bln_t)
        {
            print(paste0("bln=", bln, " is a not a valid parameters"))
            quit()
        }
    }
    
    ncor_n <- str_which(input0, "^ncor=")
    if(length(ncor_n) == 0)
    {
        ncor <- "10"
    }else
    {
        ncor <- str_remove(input0[ncor_n], "^ncor=")
    }
    
    
    ## optional parameters step2 ------------------   
    clust_n <- str_which(input0, "^clust=")
    if(length(clust_n) == 0)
    {
        clust <- "complete"
    }else
    {
        clust <- str_remove(input0[clust_n], "^clust=")
        
        clust_t <- c("complete", "ward.D", "ward.D2", "single", "complete",  "average", "mcquitty")
        if(!clust %in% clust_t)
        {
            print(paste0("clust=", clust, " is not a valid parameter"))
            quit()
        }
    }
    
    thsp_n <- str_which(input0, "^thsp=")
    if(length(thsp_n) == 0)
    {
        thsp <- "95"
    }else
    {
        thsp <- str_remove(input0[thsp_n], "^thsp=") %>%
            as.integer()
        if(is.integer(thsp) == TRUE)
        {
            if(thsp <=50 & thsp >=100)
            {
                print(paste0("thsp=", thsp, " is not a valid parameter"))
                quit()
            }
        }else
        {
            print(paste0("thsp=", thsp, " is not a valid parameter"))
            quit()
        }
    }
    
    thgen_n <- str_which(input0, "^thgen=")
    if(length(thgen_n) == 0)
    {
        thgen <- "70"
    }else
    {
        thgen <- str_remove(input0[thgen_n], "^thgen=") %>%
            as.integer()
        if(is.integer(thgen) == TRUE)
        {
            if(thgen <=50 & thgen >=100)
            {
                print(paste0("thgen=", thgen, " is not a valid parameter"))
                quit()
            }
        }else
        {
            print(paste0("thgen=", thgen, " is not a valid parameter"))
            quit()
        }
    }
    
    ##optional parameters for step3 ----
    #if they are not given at command line, than default values are chosen instead
    
    sim_cols_n <- str_which(input0, "^sim_cols=")
    if(length(sim_cols_n) == 0)
    {
        sim_cols <- "PuBuGn"
    }else
    { 
        sim_cols <- str_remove(input0[sim_cols_n], "^sim_cols=")
        
        sim_cols_t <- c("Blues", "BuGn", "BuPu", "GnBu","Greens", "Greys", "Oranges", "OrRd", "PuBu", "PuBuGn", "PuRd",
                        "Purples", "RdPu", "Reds", "YlGn", "YlGnBu", "YlOrBr", "YlOrRd")
        
        if(!sim_cols %in% sim_cols_t)
        {
            print(paste0("sim_cols=", sim_cols, " is not a valid parameter"))
            quit()
        }
        
        #sim_cols <- RColorBrewer::brewer.pal(n = 9, name = palet)
    }
    
    cols_Alig_n <- str_which(input0, "^cols_Alig=")
    if(length(cols_Alig_n) == 0)
    {
        cols_Alig <- "peachpuff"
    }else
    { 
        cols_Alig <- str_remove(input0[cols_Alig_n], "^cols_Alig=")
        cols_Alig_t <- c("steelblue1", "slategray2", "skyblue1", "lightsteelblue", "thistle1", "wheat1", "peachpuff", "moccasin", "sandybrown",
                         "khaki1", "antiquewhite", "plum2", "palegreen", "seagreen1")
            
            
        if(!cols_Alig %in% cols_Alig_t)
        {
            print(paste0("cols_Alig=", cols_Alig, " is not a valid parameter"))
            quit()
        }
    }
    
    cols_Frac_n <- str_which(input0, "^cols_Frac=")
    if(length(cols_Frac_n) == 0)
    {
        cols_Frac <- "black"
    }else
    { 
        cols_Frac <- str_remove(input0[cols_Frac_n], "^cols_Frac=")
        cols_Frac_t <- c("black", "blue", "darkblue", "cadetblue", "darkgreen", "chartreuse4", "chartreuse", "blueviolet", 
                         "darkmagenta",  "coral4", "firebrick4")
        
        if(!cols_Frac %in% cols_Frac_t)
        {
            print(paste0("cols_Frac=", cols_Frac, " is not a valid parameter"))
            quit()
        }
    }
    
    col_border_sim_n <- str_which(input0, "^col_border_sim=")
    if(length(col_border_sim_n) == 0)
    {
        col_border_sim <- "none"
    }else
    { 
        col_border_sim <- str_remove(input0[col_border_sim_n], "^col_border_sim=")
        col_border_sim_t <- c("none", "white", "gray98", "gray95", "gray90", "gray80", "gray70", "gray60", "gray50", "gray40", "gray30", "gray20", "gray10", "black")
            
        if(!col_border_sim %in% col_border_sim_t)
        {
            print(paste0("col_border_sim=", col_border_sim, " is not a valid parameter"))
            quit()
        }
    }
    
    col_border_frac_n <- str_which(input0, "^col_border_frac=")
    if(length(col_border_frac_n) == 0)
    {
        col_border_frac <- "none"
    }else
    { 
        col_border_frac <- str_remove(input0[col_border_frac_n], "^col_border_frac=")
        col_border_frac_t <- c("none", "white", "gray98", "gray95", "gray90", "gray80", "gray70", "gray60", "gray50", "gray40", "gray30", "gray20", "gray10", "black")
        
        if(!col_border_frac %in% col_border_frac)
        {
            print(paste0("col_border_frac=", col_border_frac, " is not a valid parameter"))
            quit()
        }
    }
    
    show_sim_n <- str_which(input0, "^show_sim=")
    if(length(show_sim_n) == 0)
    {
        show_sim <- TRUE
    }else
    { 
        show_sim <- str_remove(input0[show_sim_n], "^show_sim=")
        show_sim_t <- c("TRUE", "FALSE")
        if(!show_sim %in% show_sim_t)
        {
            print(paste0("show_sim=", show_sim, " is not a valid parameter"))
            quit()
        }
    }
    
    show_sqLenFrac_n <- str_which(input0, "^show_sqLenFrac=")
    if(length(show_sqLenFrac_n) == 0)
    {
        show_sqLenFrac <- TRUE
    }else
    { 
        show_sqLenFrac <- str_remove(input0[show_sqLenFrac_n], "^show_sqLenFrac=")
        show_sqLenFrac_t <- c("TRUE", "FALSE")
        if(!show_sqLenFrac %in% show_sqLenFrac_t)
        {
            print(paste0("show_sqLenFrac=", show_sqLenFrac, " is not a valid parameter"))
            quit()
        }
    }
    
    show_qAligFrac_n <- str_which(input0, "^show_qAligFrac=")
    if(length(show_qAligFrac_n) == 0)
    {
        show_qAligFrac <- TRUE
    }else
    { 
        show_qAligFrac <- str_remove(input0[show_qAligFrac_n], "^show_qAligFrac=")
        show_qAligFrac_t <- c("TRUE", "FALSE")
        
        if(!show_qAligFrac %in% show_qAligFrac_t)
        {
            print(paste0("show_qAligFrac=", show_qAligFrac, " is not a valid parameter"))
            quit()
        }
    }
    
    show_sAligFrac_n <- str_which(input0, "^show_sAligFrac=")
    if(length(show_sAligFrac_n) == 0)
    {
        show_sAligFrac <- TRUE
    }else
    { 
        show_sAligFrac <- str_remove(input0[show_sAligFrac_n], "^show_sAligFrac=")
        show_sAligFrac_t <- c("TRUE", "FALSE")
        if(!show_sAligFrac %in% show_sAligFrac_t)
        {
            print(paste0("show_sAligFrac=", show_sAligFrac, " is not a valid parameter"))
            quit()
        }
    }
    
    font_sim_n <- str_which(input0, "^font_sim=")
    if(length(font_sim_n) == 0)
    {
        font_sim <- 8
    }else
    { 
        font_sim <- str_remove(input0[font_sim_n], "^font_sim=") %>%
            as.integer()
        if(is.integer(font_sim) != TRUE & font_sim > 0)
        {
            print(paste0("font_sim=", font_sim, " is not a valid parameter"))
            quit()
        }
    }
    
    font_sqLenFrac_n <- str_which(input0, "^font_sqLenFrac=")
    if(length(font_sqLenFrac_n) == 0)
    {
        font_sqLenFrac <- 4
    }else
    { 
        font_sqLenFrac <- str_remove(input0[font_sqLenFrac_n], "^font_sqLenFrac=") %>%
            as.integer()
        
        if(is.integer(font_sqLenFrac) != TRUE & font_sqLenFrac > 0)
        {
            print(paste0("font_sqLenFrac=", font_sqLenFrac, " is not a valid parameter"))
            quit()
        }
    }
    
    font_qAligFrac_n <- str_which(input0, "^font_qAligFrac=")
    if(length(font_qAligFrac_n) == 0)
    {
        font_qAligFrac <- 4
    }else
    { 
        font_qAligFrac <- str_remove(input0[font_qAligFrac_n], "^font_qAligFrac=") %>%
            as.integer()
        
        if(is.integer(font_qAligFrac) != TRUE & font_qAligFrac > 0)
        {
            print(paste0("font_qAligFrac=", font_qAligFrac, " is not a valid parameter"))
            quit()
        }
    }
    
    font_sAligFrac_n <- str_which(input0, "^font_sAligFrac=")
    if(length(font_sAligFrac_n) == 0)
    {
        font_sAligFrac <- 4
    }else
    { 
        font_sAligFrac <- str_remove(input0[font_sAligFrac_n], "^font_sAligFrac=") %>%
            as.integer()
        
        if(is.integer(font_sAligFrac) != TRUE & font_sAligFrac > 0)
        {
            print(paste0("font_sAligFrac=", font_sAligFrac, " is not a valid parameter"))
            quit()
        }
    }
    
    font_row_n <- str_which(input0, "^font_row=")
    if(length(font_row_n) == 0)
    {
        font_row <- 12
    }else
    { 
        font_row <- str_remove(input0[font_row_n], "^font_row=") %>%
            as.integer()
        
        if(is.integer(font_row) != TRUE & font_row > 0)
        {
            print(paste0("font_row=", font_row, " is not a valid parameter"))
            quit()
        }
    }
    
    font_col_n <- str_which(input0, "^font_col=")
    if(length(font_col_n) == 0)
    {
        font_col <- 12
    }else
    { 
        font_col <- str_remove(input0[font_col_n], "^font_col=") %>%
            as.integer()
        
        if(is.integer(font_col) != TRUE & font_col > 0)
        {
            print(paste0("font_col=", font_col, " is not a valid parameter"))
            quit()
        }
    }
    
    annot_height_n <- str_which(input0, "^annot_height=")
    if(length(annot_height_n) == 0)
    {
        annot_height <- 0.01
    }else
    { 
        annot_height <- str_remove(input0[annot_height_n], "^annot_height=") %>%
            as.integer()
        
        
        if(is.integer(annot_height) != TRUE & annot_height >= 1 & annot_height <= 100)
        {
            print(paste0("annot_height=", annot_height, " is not a valid parameter"))
            quit()
        }
        
        annot_height <- annot_height/100
    }
    
    annot_font_n <- str_which(input0, "^annot_font=")
    if(length(annot_font_n) == 0)
    {
        annot_font <- 0.5
    }else
    { 
        annot_font <- str_remove(input0[annot_font_n], "^annot_font=") %>%
            as.integer()
        
        
        if(is.integer(annot_font) != TRUE & annot_font >= 1 & annot_font <= 300)
        {
            print(paste0("annot_font=", annot_font, " is not a valid parameter"))
            quit()
        }
        
        annot_font <- annot_font/100
    }
    
    annot_rot_n <- str_which(input0, "^annot_rot=")
    if(length(annot_rot_n) == 0)
    {
        annot_rot <- 270
    }else
    { 
        annot_rot <- str_remove(input0[annot_rot_n], "^annot_rot=")
        annot_rot_t <- c("0", "90", "180", "270")
        
        if(!annot_rot %in% annot_rot_t)
        {
            print(paste0("annot_rot=", annot_rot, " is not a valid parameter"))
            quit() 
        }
    }
    
    lgd_width_n <- str_which(input0, "^lgd_width=")
    if(length(lgd_width_n) == 0)
    {
        lgd_width <- 1
    }else
    { 
        lgd_width <- str_remove(input0[lgd_width_n], "^lgd_width=") %>%
            as.integer()
        
        if(is.integer(lgd_width) != TRUE & lgd_width >= 1 & lgd_width <= 100)
        {
            print(paste0("lgd_width=", lgd_width, " is not a valid parameter"))
            quit()
        }
        
        lgd_width <- lgd_width/100
    }
    
    lgd_font_n <- str_which(input0, "^lgd_font=")
    if(length(lgd_font_n) == 0)
    {
        lgd_font <- 0.1
    }else
    { 
        lgd_font <- str_remove(input0[lgd_font_n], "^lgd_font=") %>%
            as.integer()
        
        if(is.integer(lgd_font) != TRUE & lgd_font >= 1 & lgd_font <= 100)
        {
            print(paste0("lgd_font=", lgd_font, " is not a valid parameter"))
            quit()
        }
        
        lgd_font <- lgd_font/100
    }
    
    lgd_pos_n <- str_which(input0, "^lgd_pos=")
    if(length(lgd_pos_n) == 0)
    {
        lgd_pos <- "topleft"
    }else
    { 
        lgd_pos <- str_remove(input0[lgd_pos_n], "^lgd_pos=")
        
        lgd_pos_t <- c("topleft", "topcenter", "leftcenter", "lefttop")
        
        if(!lgd_pos %in% lgd_pos_t)
        {
            print(paste0("lgd_pos=", lgd_pos, " is not a valid parameter"))
            quit()
        }
    }
    
    lgd_lab_font_n <- str_which(input0, "^lgd_lab_font=")
    if(length(lgd_lab_font_n) == 0)
    {
        lgd_lab_font <- 0.05
    }else
    { 
        lgd_lab_font <- str_remove(input0[lgd_lab_font_n], "^lgd_lab_font=") %>%
            as.integer()
        
        if(is.integer(lgd_lab_font) != TRUE & lgd_lab_font >= 1 & lgd_lab_font <= 100)
        {
            print(paste0("lgd_lab_font=", lgd_lab_font, " is not a valid parameter"))
            quit()
        }
        
        lgd_lab_font <- lgd_lab_font/100
    }
    
    sim_for_frac_n <- str_which(input0, "^sim_for_frac=")
    if(length(sim_for_frac_n) == 0)
    {
        sim_for_frac <- 0
    }else
    {
        sim_for_frac <- str_remove(input0[sim_for_frac_n], "^sim_for_frac=") %>%
            as.integer()
        
        if(is.integer(sim_for_frac) != TRUE & sim_for_frac < 0 & sim_for_frac > 100)
        {
            print(paste0("sim_for_frac=", sim_for_frac, " is not a valid parameter"))
            quit()
        }
    }
    
    sim_for_sim_n <- str_which(input0, "^sim_for_sim=")
    if(length(sim_for_sim_n) == 0)
    {
        sim_for_sim <- 0
    }else
    {
        sim_for_sim <- str_remove(input0[sim_for_sim_n], "^sim_for_sim=") %>%
            as.integer()
        
        if(is.integer(sim_for_sim) != TRUE & sim_for_sim < 0 & sim_for_sim > 100)
        {
            print(paste0("sim_for_sim=", sim_for_sim, " is not a valid parameter"))
            quit()
        }
    }
    
    lgd_height_n <- str_which(input0, "^lgd_height=")
    if(length(lgd_height_n) == 0)
    {
        lgd_height <- 0.1
    }else
    {
        lgd_height <- str_remove(input0[lgd_height_n], "^lgd_height=") %>%
            as.integer()
        
        if(is.integer(lgd_height) != TRUE & lgd_height >= 1 & lgd_height <= 100)
        {
            print(paste0("lgd_height=", lgd_height, " is not a valid parameter"))
            quit()
        }
        
        lgd_height <- lgd_height/100
    }
    
    ########### Run VIRIDIC---------------------------
    
    if(steps == "ALL")
    {
        VIRIDIC1_cmd <- paste0("Rscript ", viridic_path, "/01_VIRIDIC_sim_calc.R projdir=", projdir, " in=", infile, " res=", res,
                               " bln=", bln, " ncor=", ncor, " functions_path=", functions_path, " ram_max=", ram_max)
        print("Running VIRIDIC step1: calculation of intergenomic similarities")
        system(VIRIDIC1_cmd)
        
        
        
        VIRIDIC2_cmd <- paste0("Rscript ", viridic_path, "/02_viridic_cluster.R projdir=", projdir, " clust=", clust, 
                               " res=", res, " thsp=", thsp, " thgen=", thgen, " functions_path=", functions_path, " ram_max=", ram_max)
        
        print("Running VIRIDIC step2: clustering")
        system(VIRIDIC2_cmd)
        
        VIRIDIC3_cmd <- paste0("Rscript ", viridic_path, "/03_viridic_heatmap.R projdir=", projdir, " res=", res, " sim_cols=", sim_cols, 
                               " cols_Alig=", cols_Alig, " cols_Frac=", cols_Frac, " col_border_sim=", col_border_sim, 
                               " col_border_frac=", col_border_frac, " show_sim=", show_sim, " show_sqLenFrac=", show_sqLenFrac, 
                               " show_qAligFrac=", show_qAligFrac, " show_sAligFrac=", show_sAligFrac, " font_sim=", font_sim, 
                               " font_sqLenFrac=", font_sqLenFrac, " font_qAligFrac=", font_qAligFrac, " font_sAligFrac=", font_sAligFrac, 
                               " font_row=", font_row, " font_col=", font_col, " annot_height=", annot_height, 
                               " annot_font=", annot_font, " annot_rot=", annot_rot, " lgd_width=", lgd_width, " lgd_font=", lgd_font,
                               " lgd_pos=", lgd_pos, " lgd_lab_font=", lgd_lab_font, " sim_for_frac=", sim_for_frac, " sim_for_sim=", sim_for_sim, 
                               " lgd_height=", lgd_height)
        
        print("Running VIRIDIC step3: heatmap")
	write(VIRIDIC3_cmd, stderr())
        system(VIRIDIC3_cmd)
        
        print("VIRIDIC has finished ALL steps.")
    } else
    {
        if(steps == "clust_heatmap")
        {
            VIRIDIC2_cmd <- paste0("Rscript ", viridic_path, "/02_viridic_cluster.R projdir=", projdir, " clust=", clust, 
                                   " res=", res, " thsp=", thsp, " thgen=", thgen, " functions_path=", functions_path, " ram_max=", ram_max)
            
            print("Running VIRIDIC step2: clustering")
            system(VIRIDIC2_cmd)
            
            VIRIDIC3_cmd <- paste0("Rscript ", viridic_path, "/03_viridic_heatmap.R projdir=", projdir, " res=", res, " sim_cols=", sim_cols, 
                                   " cols_Alig=", cols_Alig, " cols_Frac=", cols_Frac, " col_border_sim=", col_border_sim, 
                                   " col_border_frac=", col_border_frac, " show_sim=", show_sim, " show_sqLenFrac=", show_sqLenFrac, 
                                   " show_qAligFrac=", show_qAligFrac, " show_sAligFrac=", show_sAligFrac, " font_sim=", font_sim, 
                                   " font_sqLenFrac=", font_sqLenFrac, " font_qAligFrac=", font_qAligFrac, " font_sAligFrac=", font_sAligFrac, 
                                   " font_row=", font_row, " font_col=", font_col, " annot_height=", annot_height, 
                                   " annot_font=", annot_font, " annot_rot=", annot_rot, " lgd_width=", lgd_width, " lgd_font=", lgd_font,
                                   " lgd_pos=", lgd_pos, " lgd_lab_font=", lgd_lab_font, " sim_for_frac=", sim_for_frac, " sim_for_sim=", sim_for_sim, 
                                   " lgd_height=", lgd_height)
            
            print("Running VIRIDIC step3: heatmap")
            system(VIRIDIC3_cmd)
            print("VIRIDIC has finished the clustering and heatmap steps.")
            
        }else
        {
            if(steps == "sim_clust")
            {
                VIRIDIC1_cmd <- paste0("Rscript ", viridic_path, "/01_VIRIDIC_sim_calc.R projdir=", projdir, " in=", infile, " res=", res,
                                       " bln=", bln, " ncor=", ncor, " functions_path=", functions_path, " ram_max=", ram_max)
                print("Running VIRIDIC step1: calculation of intergenomic similarities")
                system(VIRIDIC1_cmd)
                
                
                
                VIRIDIC2_cmd <- paste0("Rscript ", viridic_path, "/02_viridic_cluster.R projdir=", projdir, " clust=", clust, 
                                       " res=", res, " thsp=", thsp, " thgen=", thgen, " functions_path=", functions_path, " ram_max=", ram_max)
                
                print("Running VIRIDIC step2: clustering")
                system(VIRIDIC2_cmd)
                
                print("VIRIDIC has finished the similarity calculations and clustering steps.")
                
            } else
            {
                if(steps == "heatmap")
                {
                    
                    VIRIDIC3_cmd <- paste0("Rscript ", viridic_path, "/03_viridic_heatmap.R projdir=", projdir, " res=", res, " sim_cols=", sim_cols, 
                                           " cols_Alig=", cols_Alig, " cols_Frac=", cols_Frac, " col_border_sim=", col_border_sim, 
                                           " col_border_frac=", col_border_frac, " show_sim=", show_sim, " show_sqLenFrac=", show_sqLenFrac, 
                                           " show_qAligFrac=", show_qAligFrac, " show_sAligFrac=", show_sAligFrac, " font_sim=", font_sim, 
                                           " font_sqLenFrac=", font_sqLenFrac, " font_qAligFrac=", font_qAligFrac, " font_sAligFrac=", font_sAligFrac, 
                                           " font_row=", font_row, " font_col=", font_col, " annot_height=", annot_height, 
                                           " annot_font=", annot_font, " annot_rot=", annot_rot, " lgd_width=", lgd_width, " lgd_font=", lgd_font,
                                           " lgd_pos=", lgd_pos, " lgd_lab_font=", lgd_lab_font, " sim_for_frac=", sim_for_frac, " sim_for_sim=", sim_for_sim, 
                                           " lgd_height=", lgd_height)
                    
                    print("Running VIRIDIC step3: heatmap")
                    system(VIRIDIC3_cmd)
                    print("VIRIDIC has finished the HEATMAP.")
                    
                } else
                {
                    print("VRIDIC has quit")
                }
            }
        }
    }
    
    
    
}
#}

