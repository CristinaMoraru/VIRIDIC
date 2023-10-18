options(shiny.maxRequestSize=300*1024^2)
max_plots <- 5

library(DT)
library(shinyjs)
#library(Gviz)
library(stringr)
library(shinyWidgets)
library(shiny)
#library(grid)
#library(ComplexHeatmap)
#library(dplyr)
#library(magrittr)


source("functions.R")
data_VIRIDIC_path <- "data/"

shinyServer(function(input, output, session)
{
  
  ##### declare ALL reactive values ---- OLD
  rval_upload <- reactiveValues(data = "NULL")
  rval_proj_dir <- reactiveValues(data = "NULL")
  rval_proj_name <- reactiveValues(data = NULL)
  rval_table <- reactiveValues(data = NULL)
  rval_status_mes <- reactiveValues(data = NULL)
  rval_clusttable <- reactiveValues(data = NULL)
  rval_heatmap <- reactiveValues(data = NULL)
  
  observe({
    if(is.null(rval_table$data) == TRUE)
    {
      hideElement(id = "Sim_table_title_cols")
      hideElement("Down_table")
      hideElement("Cluster_table_title")
      hideElement("Down_clust_table")
      hideElement("clust_meth")
      
    }else
    {
      showElement(id = "Sim_table_title_cols")
      showElement("Down_table")
      showElement("Cluster_table_title")
      showElement("clust_table")
      showElement("Down_clust_table")
      showElement("clust_meth")
    }
    
    if(is.null(rval_heatmap$data) == TRUE)
    {
      hideElement("Show_sim")
      hideElement("Show_sqLenFrac")
      hideElement("Show_qAligFrac")
      hideElement("Show_sAligFrac")
      hideElement("sim_for_frac")
      hideElement("sim_for_sim")
      hideElement("Font_sim")
      hideElement("Font_sqLenFrac")
      hideElement("Font_qAligFrac")
      hideElement("Font_sAligFrac")
      hideElement("border_col_sim")
      hideElement("border_col_frac")
      hideElement("Frac_col")
      hideElement("Alig_col")
      hideElement("sim_palette")
      hideElement("clust_meth")
      hideElement("font_size_row")
      hideElement("font_size_col")
      hideElement("annot_height")
      hideElement("annot_font")
      hideElement("annot_rot")
      hideElement("lgd_height")
      hideElement("lgd_width")
      hideElement("lgd_lab_font")
      hideElement("lgd_font")
      hideElement("lgd_pos")
      hideElement("Recalc_ht")
      hideElement(id = "Down_heat")
      
    }else
    {
      showElement("Show_sim")
      showElement("Show_sqLenFrac")
      showElement("Show_qAligFrac")
      showElement("Show_sAligFrac")
      showElement("sim_for_frac")
      showElement("sim_for_sim")
      showElement("Font_sim")
      showElement("Font_sqLenFrac")
      showElement("Font_qAligFrac")
      showElement("Font_sAligFrac")
      showElement("border_col_sim")
      showElement("border_col_frac")
      showElement("Frac_col")
      showElement("Alig_col")
      showElement("sim_palette")
      showElement("clust_meth")
      showElement("font_size_row")
      showElement("font_size_col")
      showElement("annot_height")
      showElement("annot_font")
      showElement("annot_rot")
      showElement("lgd_height")
      showElement("lgd_width")
      showElement("lgd_lab_font")
      showElement("lgd_font")
      showElement("lgd_pos")
      showElement("Recalc_ht")
      showElement(id = "Down_heat")
    }
    
    if(rval_upload$data == "uploaded" & str_detect(input$User_name, "minimum 6 characters") != TRUE & str_count(input$User_name) >= 6 & str_detect(input$Project_name, "minimum 6 characters") != TRUE & str_count(input$Project_name) >= 6) 
    {
      enable("Create")
      enable("Blastn_param")
      enable("results")
      enable("SpTh")
      enable("GenTh")
      #enable("clust_meth")
    }else
    {
      disable("Create")
      disable("Run")
      disable("Blastn_param")
      disable("results")
      disable("SpTh")
      disable("GenTh")
      #disable("clust_meth")
    }
    
    
    if(input$Proj_ID == "") 
    {
      disable("Load")
    }else
    {
      enable("Load")
    }
  })
  
  observeEvent(input$Create, 
               {
                 enable("Run")
               })
  observeEvent(input$Run, {
    updateTextInput(session, inputId = "User_name", label = "User name*", value = "minimum 6 characters")
    updateTextInput(session, inputId = "Project_name", label = "User name*", value = "minimum 6 characters")
    disable("Blastn_param")
    disable("results")
    disable("Spth")
    disable("GenTh")
    #disable("clust_meth")
  })
  
  ##### NEW PROJECT -----
  
  ##### Reset outputs at run -----
  #load upload state
  
  observeEvent(input$Upload_genome, 
               {rval_upload$data <- "uploaded"})  
  
  observeEvent(input$Create, {
    rval_upload$data <- "NULL"
    rval_proj_dir$data <- "NULL"
    rval_proj_name$data <- NULL
    rval_table$data <- NULL
    rval_status_mes$data <- NULL
    rval_clusttable$data <- NULL
    rval_heatmap$data <- NULL
  })
  
  observeEvent(input$Run, {
    rval_proj_dir$data <- "NULL"
    rval_table$data <- NULL
    rval_status_mes$data <- NULL
    rval_clusttable$data <- NULL
    rval_heatmap$data <- NULL
  })
  
  
  
  #### RUN VIRIDIC ----
  
  
  validate_fasta <- eventReactive(eventExpr = input$Create,
                                  {
                                    validate(
                                      need(str_count(input$User_name) >= 6, ""),
                                      need(str_count(input$Project_name) >= 6, ""),
                                      need(rval_upload$data <- "uploaded", "")
                                    )
                                    
                                    in_df <- input$Upload_genome
                                    test_type <- typeof
                                    test_obj <- (try(seqinr::read.fasta(in_df$datapath, seqtype = "DNA", as.string = TRUE),
                                                     silent = TRUE))
                                    
                                    test_type <- typeof(test_obj)
                                    if(test_type == "character")
                                    {out_text <- "Invalid fasta file!"
                                    }else{
                                      if(test_type == "list")
                                      {out_text <- "Valid fasta file."
                                      }else
                                      {out_text  <- "unknown"}
                                    }
                                    
                                    return(out_text)
                                  })
  
  dir_path <- eventReactive(eventExpr = input$Create, 
                            {
                              validate(
                                need(str_count(input$User_name) >= 6, ""),
                                need(str_count(input$Project_name) >= 6, ""),
                                need(rval_upload$data <- "uploaded", ""),
                                need(validate_fasta() == "Valid fasta file.", "")
                              )
                              
                              pref <- list.dirs(data_VIRIDIC_path, recursive = FALSE)%>%
                                length()
                              
                              dir_path <- proj_dir_fun(prefix = pref, User_name = input$User_name, Project_name = input$Project_name)
                              dir.create(dir_path)
                              
                              log_name <- paste0(dir_path, "_LOG.txt")
                              write(x = "running\n", file = log_name)
                              
                              in_df <- input$Upload_genome
                              in_path <- paste0(dir_path, "/input_genomes.fasta")
                              
                              file.copy(from = in_df$datapath, to = in_path)
                              
                              # if(str_detect(input$User_email, ".+@.+") == TRUE)
                              # {
                              #   send_email(to = input$User_email, body = paste0("You are running VIRIDIC with user name ", input$User_name, " and project name ", input$Project_name,
                              #                                                   ".The unique ID of this project is ", str_remove(dir_path, "data/"), ".Please save the ID and use it to reload the project if your browser is disconnecting from our server."))
                              # }
                              
                              return(dir_path)
                            })
  
  observeEvent(input$Create,{
    rval_proj_name$data <- dir_path()
  })
  
  run_VIRIDIC <- eventReactive(eventExpr = input$Run, 
                               {
                                 validate(
                                   need(is.null(rval_proj_name$data) == FALSE, ""),
                                   need(validate_fasta() == "Valid fasta file.", "")
                                 )
                                 
                                 withProgress(expr = {
                                   VIRIDIC_cmd <- paste0("Rscript stand_alone/viridic_scripts/00_viridic_master.R projdir=", dir_path(), 
                                                         " in=", dir_path(), "/input_genomes.fasta",
                                                         " bln=", input$Blastn_param, 
                                                         " clust=", input$clust_meth, 
                                                         " res=", input$results, 
                                                         " thsp=", as.character(input$SpTh), 
                                                         " thgen=", as.character(input$GenTh),
                                                         " sim_cols=", input$sim_palette, 
                                                         " cols_Alig=", input$Alig_col, " cols_Frac=", input$Frac_col, " col_border_sim=", input$border_col_sim, 
                                                         " col_border_frac=", input$border_col_frac, " show_sim=", input$Show_sim, " show_sqLenFrac=", input$Show_sqLenFrac, 
                                                         " show_qAligFrac=", input$Show_qAligFrac, " show_sAligFrac=", input$Show_sAligFrac, " font_sim=", input$Font_sim, 
                                                         " font_sqLenFrac=", input$Font_sqLenFrac, " font_qAligFrac=", input$Font_qAligFrac, " font_sAligFrac=", input$Font_sAligFrac, 
                                                         " font_row=", input$font_size_row, " font_col=", input$font_size_col, " annot_height=", input$annot_height, 
                                                         " annot_font=", input$annot_font, " annot_rot=", input$annot_rot, " lgd_width=", input$lgd_width, " lgd_font=", input$lgd_font,
                                                         " lgd_pos=", input$lgd_pos, " lgd_lab_font=", input$lgd_lab_font, " sim_for_frac=", input$sim_for_frac, " sim_for_sim=", input$sim_for_sim, 
                                                         " lgd_height=", input$lgd_height,
                                                         " shiny=yes"
                                   )
                                   
                                   
                                   system(VIRIDIC_cmd)
                                   
                                   #I'm writting a file on the HDD to know when VIRIDIC has finished
                                   log_name <- paste0(dir_path(), "_LOG.txt")
                                   write(x = "done\n", file = log_name)
                                   
                                   #I'm writting a file on the HDD to know if similarity or distance was chosen
                                   method_path <- paste0(dir_path(), "_method.txt")
                                   if(input$results == "similarity")
                                   {
                                     write(x = "similarity\n", file = method_path)
                                   }else
                                   {
                                     write(x = "distance\n", file = method_path)
                                   }
                                   
                                   
                                   out_path <- paste0(dir_path(), "/04_VIRIDIC_out")
                                   
                                   return(out_path)
                                 }, message = "Calculating Intergenomic similarities/distances. Please be patient! Don't press any other buttons in this page until calculations have finished, or you will have to reload."
                                 
                                 )
                                 
                                 
                               })
  observeEvent(input$Run,{
    rval_proj_dir$data <- run_VIRIDIC()
  })
  
  #### Load output after running -----
  
  stat_mes_run <- eventReactive(eventExpr = input$Run,
                                {
                                  log_name <- paste0(rval_proj_name$data, "_LOG.txt")
                                  if(file.exists(log_name) == TRUE)
                                  {
                                    logul <- read.csv(log_name, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
                                    status_mes <- logul[1,1]
                                  }else
                                  {status_mes <- "inexistent"}
                                  
                                  return(status_mes)})
  
  observeEvent(input$Run, {
    rval_status_mes$data <- stat_mes_run()
  }) 
  
  
  heatmap_run <- eventReactive(input$Run,
                               {
                                 heatmap_p <- paste0(rval_proj_dir$data, "/Heatmap.PDF")
                                 
                                 validate(
                                   need(file.exists(heatmap_p) == TRUE, ""))
                                 
                                 return("heatmap_true")
                               })
  
  observeEvent(input$Run,{
    rval_heatmap$data <- heatmap_run()
  })
  
  table_Run <- eventReactive(input$Run,{
    validate(need(dir.exists(rval_proj_dir$data) == TRUE, ""))
    table <- load_table_fun(rval_proj_dir$data) 
    return(table)})
  
  observeEvent(input$Run, 
               {rval_table$data <- table_Run()
               })
  
  clusttable_Run <- eventReactive(input$Run,{
    validate(need(dir.exists(rval_proj_dir$data) == TRUE, ""))
    table <- load_clusttable_fun(rval_proj_dir$data) 
    return(table)})
  
  observeEvent(input$Run, 
               {rval_clusttable$data <- clusttable_Run()
               })
  
  ##### LOAD PROJECT ----
  ##### Reset outputs at load -----
  observeEvent(input$Load, {
    rval_upload$data <- "NULL"
    rval_proj_dir$data <- "NULL"
    rval_proj_name$data <- NULL
    rval_table$data <- NULL
    rval_clusttable$data <- NULL
    rval_heatmap$data <- NULL
  })
  
  
  ##### Load project ------
  observeEvent(input$Load, {
    proj_dir <- paste0("data/", input$Proj_ID)
    validate(need(dir.exists(proj_dir) == TRUE, ""))
    rval_proj_name$data <- proj_dir
    rval_proj_dir$data <- paste0(proj_dir, "/04_VIRIDIC_out")
    
    
    method_path <- paste0(rval_proj_name$data, "_method.txt")
    if(file.exists(method_path))
    {
      method <- read.csv(file = method_path, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
      updateRadioButtons(session, "results", label = "Results as:", choices = c("similarity", "distance"), selected = method[1,1], inline = TRUE)
    }
    #disable("results")
    
  })
  
  stat_mes_load <- eventReactive(input$Load,
                                 {
                                   log_name <- paste0(rval_proj_name$data, "_LOG.txt")
                                   if(file.exists(log_name) == TRUE)
                                   {
                                     logul <- read.csv(log_name, header = FALSE, sep = "\t", stringsAsFactors = FALSE)
                                     status_mes <- logul[1,1]
                                   }else
                                   {status_mes <- "inexistent"}
                                   
                                   return(status_mes)
                                 })
  
  observeEvent(input$Load, {
    rval_status_mes$data <- stat_mes_load()
  })
  
  
  table_Load <- eventReactive(input$Load,{
    validate(need(dir.exists(rval_proj_dir$data) == TRUE, ""))
    table <- load_table_fun(rval_proj_dir$data)
    return(table)})
  
  observeEvent(input$Load, 
               {rval_table$data <- table_Load()})
  
  clusttable_Load <- eventReactive(input$Load,{
    validate(need(dir.exists(rval_proj_dir$data) == TRUE, ""))
    table <- load_clusttable_fun(rval_proj_dir$data)
    return(table)})
  
  observeEvent(input$Load, 
               {rval_clusttable$data <- clusttable_Load()})
  
  
  heatmap_load <- eventReactive(input$Load,
                                {
                                  heatmap_p <- paste0(rval_proj_dir$data, "/sim_MA.RDS")
                                  validate(need(file.exists(heatmap_p) == TRUE, ""))
                                  return("heatmap_true")
                                })
  
  observeEvent(input$Load,{
    rval_heatmap$data <- heatmap_load()
  })
  
  
  ###### Recalculate Heatmap -----------
  ##### Reset outputs at load -----
  observeEvent(input$Recalc_ht, {
    rval_heatmap$data <- NULL
    rval_clusttable$data <- NULL
    rval_table$data <- NULL
  })
  
  new_heatmap <- eventReactive(input$Recalc_ht, 
                               {
                                 heatmap_p <- paste0(rval_proj_dir$data, "/sim_MA.RDS")
                                 validate(need(file.exists(heatmap_p) == TRUE, ""))
                                 withProgress({
                                   VIRIDIC2_cmd <- paste0("Rscript stand_alone/viridic_scripts/00_viridic_master.R projdir=", rval_proj_name$data, " steps=clust_heatmap", " shiny=yes",
                                                          " clust=", input$clust_meth, " thsp=", as.character(input$SpTh), " thgen=", as.character(input$GenTh), " res=", input$results, 
                                                          " sim_cols=", input$sim_palette, 
                                                          " cols_Alig=", input$Alig_col, " cols_Frac=", input$Frac_col, " col_border_sim=", input$border_col_sim, 
                                                          " col_border_frac=", input$border_col_frac, " show_sim=", input$Show_sim, " show_sqLenFrac=", input$Show_sqLenFrac, 
                                                          " show_qAligFrac=", input$Show_qAligFrac, " show_sAligFrac=", input$Show_sAligFrac, " font_sim=", input$Font_sim, 
                                                          " font_sqLenFrac=", input$Font_sqLenFrac, " font_qAligFrac=", input$Font_qAligFrac, " font_sAligFrac=", input$Font_sAligFrac, 
                                                          " font_row=", input$font_size_row, " font_col=", input$font_size_col, " annot_height=", input$annot_height, 
                                                          " annot_font=", input$annot_font, " annot_rot=", input$annot_rot, " lgd_width=", input$lgd_width, " lgd_font=", input$lgd_font,
                                                          " lgd_pos=", input$lgd_pos, " lgd_lab_font=", input$lgd_lab_font, " sim_for_frac=", input$sim_for_frac, " sim_for_sim=", input$sim_for_sim,
                                                          " lgd_height=", input$lgd_height)
                                   system(VIRIDIC2_cmd)
                                   
                                   
                                   return("recalculated")
                                 }, 
                                 message = "Re-calculating heatmap. Please be patient! Don't press any other buttons in this page until calculations have finished, or you will have to reload."
                                 )
                               })
  
  observeEvent(input$Recalc_ht,{
    rval_heatmap$data <- new_heatmap()
    print(rval_heatmap$data)
  }) 
  
  table_recalc <- eventReactive(input$Recalc_ht,{
    validate(need(dir.exists(rval_proj_dir$data) == TRUE, ""))
    table <- load_table_fun(rval_proj_dir$data)
    return(table)})
  
  observeEvent(input$Recalc_ht, 
               {rval_table$data <- table_recalc()})
  
  clusttable_recalc <- eventReactive(input$Recalc_ht,{
    validate(need(dir.exists(rval_proj_dir$data) == TRUE, ""))
    table <- load_clusttable_fun(rval_proj_dir$data)
    return(table)})
  
  observeEvent(input$Recalc_ht, 
               {rval_clusttable$data <- clusttable_recalc()})
  
  
  
  ###### VIRIDIC results messages -------
  
  output$VIRIDIC_status <- renderText(expr = {
    validate(need(is.null(rval_proj_name$data) != TRUE, ""))
    proj_name <- str_remove( rval_proj_name$data, "data/")
    text <- paste0("Current project ID: ", proj_name)
    return(text)
  })
  
  output$fasta_validity <- renderText(expr = validate_fasta())
  
  output$message <- renderText({
    validate(need(is.null(rval_status_mes$data) != TRUE, ""))
    
    if(rval_status_mes$data == "done" & is.null(rval_table$data) == TRUE)
    {text <- paste0("VIRIDIC has finished the project. Unfortunately, the calculations have failed. Please check your input data and try again.")}
    
    if(rval_status_mes$data == "done" & is.null(rval_table$data) != TRUE)
    {text <- paste0("VIRIDIC has finished the project. You can download the results (heatmap, similarity/distance table and cluster table) below.")}
    
    if(rval_status_mes$data == "running")
    {text <- paste0("VIRIDIC is running the project. You need the project ID to access later the results. This is the project ID: ",  str_remove(rval_proj_name$data, "data/"))}
    
    if(rval_status_mes$data == "inexistent")
    {
      text <- paste0("Project with ID '", str_remove(rval_proj_name$data, "data/"), 
                     "' was not found on the VIRIDIC server. There could be a typo in the project ID. Check it and try again.
                     Note: projects older than two weeks are automatically removed from the server.")
    }
    
    return(text)})
  
  ###### Download data -----
  
  output$Down_heat <- downloadHandler(
    filename = "VIRIDIC_heatmap.pdf",
    content = function(file){
      heatmap_p <- paste0(rval_proj_dir$data, "/Heatmap.PDF")
      file.copy(from = heatmap_p, to = file)
    }
  )
  
  output$Down_table <- downloadHandler(
    filename = "VIRIDIC_sim-dist_table.tsv",
    content = function(file){
      file.copy(from = paste0(rval_proj_dir$data, "/sim_MA_genCol.csv"), to = file)
    }
  )
  
  output$Down_clust_table <- downloadHandler(
    filename = "VIRIDIC_cluster_table.tsv",
    content = function(file){
      file.copy(from = paste0(rval_proj_dir$data, "/clusters.csv"), to = file)
    }
  )
  
  output$Down_standAlone <- downloadHandler(
    filename = "viridic_singularity_v1.1.tar.gz",
    content = function(file){
      standalone_p <- "stand_alone/download/viridic_singularity_v1.1.tar.gz"
      file.copy(from = standalone_p, to = file)
    }
  )
  
  output$Down_manual <- downloadHandler(
    filename = "VIRIDIC_manual.PDF",
    content = function(file){
      man_p <- "stand_alone/download/viridic_manual_v1.1.pdf"
      file.copy(from = man_p, to = file)
    }
  )
  
  
  ###Heatmap-----
  output$Heatmap_title <- renderText({
    validate(need(is.null(rval_table$data) != TRUE, ""))
    text <- "Intergenomic similarities heatmap" 
    return(text)})
  
  output$Heat_ready <- renderText({
    validate(
      need(is.null(rval_table$data) != TRUE, ""),
      need(is.null(rval_heatmap$data) != TRUE, ""))
    
    text <- "The heatmap is ready for download." 
    return(text)})
  
  output$Heat_opt <- renderText({
    validate(
      need(is.null(rval_table$data) != TRUE, ""),
      need(is.null(rval_heatmap$data) != TRUE, ""))
    
    text <- "If you want to modify the appearance of the heatmap, adjust the options below and press “Recalculate heatmap”, before downloading again the PDF file. " 
    return(text)})
  
  
  ###### Sim/dist Table -----
  
  output$Sim_table_title <- renderText({
    validate(need(is.null(rval_table$data) != TRUE, ""))
    text <- "Intergenomic similarities table" 
    return(text)})
  
  output$sim_table <- DT::renderDataTable({
    validate(need(is.null(rval_table$data) != TRUE, ""))
    table <- rval_table$data 
    table1 <- DT::datatable(table[,input$Sim_table_title_cols, drop = FALSE], 
                            options = list(pageLength = 10), escape = FALSE, height =200, width = 200, #fillContainer = TRUE, 
                            autoHideNavigation = TRUE, editable = FALSE)
    return(table1)})
  
  observeEvent(input$Run, {
    if(is.null(rval_table$data) != TRUE)
    {
      updateSelectInput(session, "Sim_table_title_cols", label = "Select visble columns", choices = names(rval_table$data), 
                        selected = names(rval_table$data)[1:5] 
      )
    }else
    {
      hideElement("Sim_table_title_cols")
    }
  })
  
  
  observeEvent(input$Load, {
    if(is.null(rval_table$data) != TRUE)
    {
      updateSelectInput(session, "Sim_table_title_cols", label = "Select visble columns", choices = names(rval_table$data), 
                        selected = names(rval_table$data)[1:5] 
      )
    }else
    {
      hideElement("Sim_table_title_cols")
    }
  })
  
  observeEvent(input$Recalc_ht, {
    if(is.null(rval_table$data) != TRUE)
    {
      updateSelectInput(session, "Sim_table_title_cols", label = "Select visble columns", choices = names(rval_table$data), 
                        selected = names(rval_table$data)[1:5] 
      )
    }else
    {
      hideElement("Sim_table_title_cols")
    }
  })
  
  ###### Cluster Table -----
  
  output$Cluster_table_title <- renderText({
    validate(need(is.null(rval_table$data) != TRUE, ""))
    text <- "Species and genus clusters table" 
    return(text)})
  
  output$clust_table <- DT::renderDataTable({
    validate(need(is.null(rval_table$data) != TRUE, ""))
    table <- rval_clusttable$data 
    table1 <- DT::datatable(table[,, drop = FALSE], 
                            options = list(pageLength = 10), escape = FALSE, height =200, width = 200, #fillContainer = TRUE, 
                            autoHideNavigation = TRUE, editable = FALSE)
    return(table1)})
  
})

