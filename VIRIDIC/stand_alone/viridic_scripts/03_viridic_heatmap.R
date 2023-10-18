suppressPackageStartupMessages(
    {
library(magrittr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(dplyr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(grid, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(ComplexHeatmap, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
library(stringr, quietly = TRUE, warn.conflicts = FALSE, verbose = FALSE)
})
#####Load paths and RDS ----
input0 <- as.character(commandArgs(trailingOnly = TRUE))
print(input0)
#only for manual run 
#input0 <- ""
#input0[1] <- "projdir=/bioinf/shiny-server/VIRIDIC/stand_alone/TEST/sing1" ##toward viridic project folder

#setting input folder ---
in1_n <- str_which(input0, "projdir=")
in1 <- str_remove(input0[in1_n], "projdir=")

### Loading data matrices (DFs) ----
step04_dir <- paste0(in1, "/04_VIRIDIC_out")

sim_matrix_p <- paste0(step04_dir, "/sim_MA.RDS")
qsLenFrac_p <- paste0(step04_dir, "/fractqslen_MA.RDS")
qFracAlig_p <- paste0(step04_dir, "/qFractAlign_MA.RDS")
sFracAlig_p <- paste0(step04_dir, "/sFractAlign_MA.RDS")
len_p <- paste0(step04_dir, "/len_DF.RDS")


sim_matrix_DF <- readRDS(sim_matrix_p)
qsLenFrac_DF <- readRDS(qsLenFrac_p)
qFracAlig_DF <- readRDS(qFracAlig_p)
sFracAlig_DF <- readRDS(sFracAlig_p)
len_DF <- readRDS(len_p) 

##setting the other parameters; ----
#if they are not given at command line, than default values are chosen instead
res_n  <- str_which(input0, "res=")
if(length(res_n) == 0)
{
    res <- "similarity"
}else
{ res <- str_remove(input0[res_n], "res=")}

sim_cols_n <- str_which(input0, "sim_cols=")
if(length(sim_cols_n) == 0)
{
    sim_cols <- RColorBrewer::brewer.pal(n = 9, name = "PuBuGn")
}else
{ 
    palet <- str_remove(input0[sim_cols_n], "sim_cols=")
    sim_cols <- RColorBrewer::brewer.pal(n = 9, name = palet)
}

cols_Alig_n <- str_which(input0, "cols_Alig=")
if(length(cols_Alig_n) == 0)
{
    cols_Alig <- "peachpuff"
}else
{ cols_Alig <- str_remove(input0[cols_Alig_n], "cols_Alig=")}

cols_Frac_n <- str_which(input0, "cols_Frac=")
if(length(cols_Frac_n) == 0)
{
    cols_Frac <- "black"
}else
{ cols_Frac <- str_remove(input0[cols_Frac_n], "cols_Frac=")}

col_border_sim_n <- str_which(input0, "col_border_sim=")
if(length(col_border_sim_n) == 0)
{
    col_border_sim <- "gray80"
}else
{ col_border_sim <- str_remove(input0[col_border_sim_n], "col_border_sim=")}

col_border_frac_n <- str_which(input0, "col_border_frac=")
if(length(col_border_frac_n) == 0)
{
    col_border_frac <- "gray80"
}else
{ col_border_frac <- str_remove(input0[col_border_frac_n], "col_border_frac=")}

show_sim_n <- str_which(input0, "show_sim=")
if(length(show_sim_n) == 0)
{
    show_sim <- FALSE
}else
{ show_sim <- str_remove(input0[show_sim_n], "show_sim=")}

show_sqLenFrac_n <- str_which(input0, "show_sqLenFrac=")
if(length(show_sqLenFrac_n) == 0)
{
    show_sqLenFrac <- FALSE
}else
{ show_sqLenFrac <- str_remove(input0[show_sqLenFrac_n], "show_sqLenFrac=")}

show_qAligFrac_n <- str_which(input0, "show_qAligFrac=")
if(length(show_qAligFrac_n) == 0)
{
    show_qAligFrac <- FALSE
}else
{ show_qAligFrac <- str_remove(input0[show_qAligFrac_n], "show_qAligFrac=")}

show_sAligFrac_n <- str_which(input0, "show_sAligFrac=")
if(length(show_sAligFrac_n) == 0)
{
    show_sAligFrac <- FALSE
}else
{ show_sAligFrac <- str_remove(input0[show_sAligFrac_n], "show_sAligFrac=")}

font_sim_n <- str_which(input0, "font_sim=")
if(length(font_sim_n) == 0)
{
    font_sim <- 8
}else
{ 
    font_sim <- str_remove(input0[font_sim_n], "font_sim=") %>%
        as.numeric()
}

font_sqLenFrac_n <- str_which(input0, "font_sqLenFrac=")
if(length(font_sqLenFrac_n) == 0)
{
    font_sqLenFrac <- 4
}else
{ 
    font_sqLenFrac <- str_remove(input0[font_sqLenFrac_n], "font_sqLenFrac=") %>%
        as.numeric()
}

font_qAligFrac_n <- str_which(input0, "font_qAligFrac=")
if(length(font_qAligFrac_n) == 0)
{
    font_qAligFrac <- 4
}else
{ 
    font_qAligFrac <- str_remove(input0[font_qAligFrac_n], "font_qAligFrac=") %>%
        as.numeric()
}

font_sAligFrac_n <- str_which(input0, "font_sAligFrac=")
if(length(font_sAligFrac_n) == 0)
{
    font_sAligFrac <- 4
}else
{ 
    font_sAligFrac <- str_remove(input0[font_sAligFrac_n], "font_sAligFrac=") %>%
        as.numeric()
}

font_row_n <- str_which(input0, "font_row=")
if(length(font_row_n) == 0)
{
    font_row <- 12
}else
{ 
    font_row <- str_remove(input0[font_row_n], "font_row=") %>%
        as.numeric()
}

font_col_n <- str_which(input0, "font_col=")
if(length(font_col_n) == 0)
{
    font_col <- 12
}else
{ 
    font_col <- str_remove(input0[font_col_n], "font_col=") %>%
        as.numeric()
}

annot_height_n <- str_which(input0, "annot_height=")
if(length(annot_height_n) == 0)
{
    annot_height <- 0.1
}else
{ 
    annot_height <- str_remove(input0[annot_height_n], "annot_height=") %>%
        as.numeric()
    #annot_height <- annot_height/100
}

annot_font_n <- str_which(input0, "annot_font=")
if(length(annot_font_n) == 0)
{
    annot_font <- 1
}else
{ 
    annot_font <- str_remove(input0[annot_font_n], "annot_font=") %>%
        as.numeric()
    #annot_font <- annot_font/100
}

annot_rot_n <- str_which(input0, "annot_rot=")
if(length(annot_rot_n) == 0)
{
    annot_rot <- 270
}else
{ 
    annot_rot <- str_remove(input0[annot_rot_n], "annot_rot=") %>%
        as.numeric()
}

lgd_width_n <- str_which(input0, "lgd_width=")
if(length(lgd_width_n) == 0)
{
    lgd_width <- 0.4
}else
{ 
    lgd_width <- str_remove(input0[lgd_width_n], "lgd_width=") %>%
        as.numeric()
    #lgd_width <- lgd_width/100
}

lgd_font_n <- str_which(input0, "lgd_font=")
if(length(lgd_font_n) == 0)
{
    lgd_font <- 0.03
}else
{ 
    lgd_font <- str_remove(input0[lgd_font_n], "lgd_font=") %>%
        as.numeric()
    #lgd_font <- lgd_font/100
}
print(lgd_font)

lgd_pos_n <- str_which(input0, "lgd_pos=")
if(length(lgd_pos_n) == 0)
{
    lgd_pos <- "topleft"
}else
{ lgd_pos <- str_remove(input0[lgd_pos_n], "lgd_pos=")}

lgd_lab_font_n <- str_which(input0, "lgd_lab_font=")
if(length(lgd_lab_font_n) == 0)
{
    lgd_lab_font <- 0.03
}else
{ 
    lgd_lab_font <- str_remove(input0[lgd_lab_font_n], "lgd_lab_font=") %>%
        as.numeric()
    #lgd_lab_font <- lgd_lab_font/100
}
print(lgd_lab_font)
sim_for_frac_n <- str_which(input0, "sim_for_frac=")
if(length(sim_for_frac_n) == 0)
{
    sim_for_frac <- 20
}else
{
    sim_for_frac <- str_remove(input0[sim_for_frac_n], "sim_for_frac=") %>%
        as.numeric()
}

sim_for_sim_n <- str_which(input0, "sim_for_sim=")
if(length(sim_for_sim_n) == 0)
{
    sim_for_sim <- 40
}else
{
    sim_for_sim <- str_remove(input0[sim_for_sim_n], "sim_for_sim=") %>%
        as.numeric()
}

lgd_height_n <- str_which(input0, "lgd_height=")
if(length(lgd_height_n) == 0)
{
    lgd_height <- 0.03
}else
{
    lgd_height <- str_remove(input0[lgd_height_n], "lgd_height=") %>%
        as.numeric()
    #lgd_height <- lgd_height/100
}



## setting param heatmap ---------
if(res == "similarity")
{
    colors <- c("#FFFFFF", sim_cols) #input$sim_palette
    breaks <- c(0, 19.9999, 39.9999, 49.9999, 59.9999, 69.9999, 79.9999, 89.9999, 94.9999, 100)
    ht_name <- "Intergenomic similarity"
    legend_breaks <- c(0, 20, 40, 50, 60, 70, 80, 90, 100)
} else
{
    colors <- c("#FFFFFF", sim_cols) #c(rev(sim_cols), "#FFFFFF")
    breaks <- c(100, 80.0001, 60.0001, 50.0001, 40.0001, 30.0001, 20.0001, 10.0001, 5.0001, 0)
    ht_name <- "Intergenomic distance"
    legend_breaks <- c(100, 80, 60, 50, 40, 30, 20, 10, 0)
    
    sim_for_frac <- 100 - sim_for_frac
    sim_for_sim <- 100 - sim_for_sim
}

col_sim_fun <- circlize::colorRamp2(breaks = breaks, colors = colors)
col_sqLenfrac_fun <- circlize::colorRamp2(c(0, 1), c(cols_Frac, "white"))
col_Aligfrac_fun <- circlize::colorRamp2(c(0, 1), c(cols_Alig, "white"))

if(col_border_sim == "none")
{
    col_border_sim <- NA
}

if(col_border_frac == "none")
{
    col_border_frac <- NA
}

inc_fact <- 0.3 # one cell has 0.3 inches or 0.76 cm (I think square)
pix_fact <- 0.014  # 

annot_height_abs <- max(0.5, annot_height * inc_fact*nrow(sim_matrix_DF))
annot_font_abs <- ceiling((annot_font*annot_height_abs)/(5*pix_fact))

ha <- HeatmapAnnotation(Genome_length= anno_barplot(x = len_DF$qlen, which = "col", border = FALSE, baseline = 0), 
                        which = "col", show_annotation_name = TRUE, annotation_name_rot = annot_rot, height = unit(annot_height_abs, "inches"),
                        annotation_name_gp = gpar(fontsize = annot_font_abs))

lgd_width_abs <- max(2, lgd_width*inc_fact*nrow(sim_matrix_DF))
lgd_height_abs <- max(0.3, lgd_height*inc_fact*nrow(sim_matrix_DF))
lgd_font_abs <- max(1, ceiling(lgd_font*inc_fact*nrow(sim_matrix_DF)/pix_fact))
lgd_lab_font_abs <- max(1, ceiling(lgd_lab_font*inc_fact*nrow(sim_matrix_DF)/pix_fact))

lgd_Alig <- Legend(col_fun = col_Aligfrac_fun, title = "Aligned genome fraction", at = c(0, 0.25, 0.5, 0.75, 1), 
                   direction = "horizontal", legend_width = unit(lgd_width_abs, "inches"), title_position = lgd_pos, 
                   title_gp = gpar(fontsize = lgd_font_abs), labels_gp = gpar(fontsize = lgd_lab_font_abs),  grid_height = unit(lgd_height_abs, "inches"))

lgd_LenFrac <- Legend(col_fun = col_sqLenfrac_fun, title = "Genome length ratio", at = c(0, 0.25, 0.5, 0.75, 1), 
                      direction = "horizontal", legend_width = unit(lgd_width_abs, "inches"), title_position = lgd_pos, 
                      title_gp = gpar(fontsize = lgd_font_abs), labels_gp = gpar(fontsize = lgd_lab_font_abs),  grid_height = unit(lgd_height_abs, "inches"))

ht_width <- inc_fact*nrow(sim_matrix_DF)
ht_height <- inc_fact*nrow(sim_matrix_DF)

sim_matrix_MA <- as.matrix(sim_matrix_DF)
#ht_opt(RESET = TRUE, HEATMAP_LEGEND_PADDING = unit(10, "inches"), ROW_ANNO_PADDING = unit(1, "inches"))

ht <- Heatmap(sim_matrix_MA, name = ht_name, col = col_sim_fun, rect_gp = gpar(type = "none"), 
              width = unit(ht_width, "inches"), height =  unit(ht_height, "inches"),
              #heatmap_width = ht_big_witdh,
              
              top_annotation = ha, 
              #top_annotation_height = unit(annot_height_abs, "mm"),
              
              heatmap_legend_param = list(legend_direction = "horizontal", at = legend_breaks,
                                          legend_width = unit(lgd_width_abs, "inches"), grid_height = unit(lgd_height_abs, "inches"),
                                          title_position = lgd_pos, 
                                          title_gp = gpar(fontsize = lgd_font_abs), labels_gp = gpar(fontsize = lgd_lab_font_abs)),
              
              cell_fun = function(j, i, x, y, width, height, fill) {
                  
                  if(i > j) 
                  {
                      grid.rect(x = x, y = y, width = width, height = height, 
                                gp = gpar(col = col_border_frac, fill = NA))
                      
                      
                      if(res == "similarity")
                      {
                          if(sim_matrix_MA[i,j] >= sim_for_frac)
                          {
                              #qAligFract
                              grid.rect(x = x, y = y+height*0.33, width = width, height = height*0.33, 
                                        gp = gpar(fill = col_Aligfrac_fun(qFracAlig_DF[i,j]), col = NA))
                              if(show_qAligFrac == TRUE)
                              {
                                  grid.text(sprintf("%.1f", qFracAlig_DF[i, j]), x, y = y+height*0.33, 
                                            gp = gpar(fontsize = font_qAligFrac))
                              }
                              
                              
                              #qsLenFract
                              grid.rect(x = x, y = y, width = width, height = height*0.33, 
                                        gp = gpar(fill = col_sqLenfrac_fun(qsLenFrac_DF[i,j]), col = NA))
                              if(show_sqLenFrac == TRUE)
                              {
                                  grid.text(sprintf("%.1f", qsLenFrac_DF[i, j]), x, y, 
                                            gp = gpar(fontsize = font_sqLenFrac))
                              }
                              
                              
                              #sAligFract
                              grid.rect(x = x, y = y-height*0.33, width = width, height = height*0.33, 
                                        gp = gpar(fill = col_Aligfrac_fun(sFracAlig_DF[i,j]), col = NA))
                              if(show_sAligFrac == TRUE)
                              {
                                  grid.text(sprintf("%.1f", sFracAlig_DF[i, j]), x, y = y-height*0.33, 
                                            gp = gpar(fontsize = font_sAligFrac)) 
                              }
                              
                          }   
                      }else
                      {
                          if(sim_matrix_MA[i,j] <= sim_for_frac)
                          {
                              #qAligFract
                              grid.rect(x = x, y = y+height*0.33, width = width, height = height*0.33, 
                                        gp = gpar(fill = col_Aligfrac_fun(qFracAlig_DF[i,j]), col = NA))
                              if(show_qAligFrac == TRUE)
                              {
                                  grid.text(sprintf("%.1f", qFracAlig_DF[i, j]), x, y = y+height*0.33, 
                                            gp = gpar(fontsize = font_qAligFrac))
                              }
                              
                              
                              #qsLenFract
                              grid.rect(x = x, y = y, width = width, height = height*0.33, 
                                        gp = gpar(fill = col_sqLenfrac_fun(qsLenFrac_DF[i,j]), col = NA))
                              if(show_sqLenFrac == TRUE)
                              {
                                  grid.text(sprintf("%.1f", qsLenFrac_DF[i, j]), x, y, 
                                            gp = gpar(fontsize = font_sqLenFrac))
                              }
                              
                              
                              #sAligFract
                              grid.rect(x = x, y = y-height*0.33, width = width, height = height*0.33, 
                                        gp = gpar(fill = col_Aligfrac_fun(sFracAlig_DF[i,j]), col = NA))
                              if(show_sAligFrac == TRUE)
                              {
                                  grid.text(sprintf("%.1f", sFracAlig_DF[i, j]), x, y = y-height*0.33, 
                                            gp = gpar(fontsize = font_sAligFrac)) 
                              }
                              
                          } 
                      }
                      
                  } else 
                  {
                      grid.rect(x = x, y = y, width = width, height = height, 
                                gp = gpar(fill = col_sim_fun(sim_matrix_MA[i,j]), col = col_border_sim))
                      
                      if(res == "similarity")
                      {
                          if(show_sim == TRUE & sim_matrix_MA[i,j] >= sim_for_sim)
                          {
                              grid.text(sprintf("%.1f", sim_matrix_MA[i, j]), x, y, 
                                        gp = gpar(fontsize = font_sim))
                          }
                      }else
                      {
                          if(show_sim == TRUE & sim_matrix_MA[i,j] <= sim_for_sim)
                          {
                              grid.text(sprintf("%.1f", sim_matrix_MA[i, j]), x, y, 
                                        gp = gpar(fontsize = font_sim))
                          }
                      }
                      
                      
                  }
                  
              }, cluster_rows = FALSE, cluster_columns = FALSE,
              show_row_names = TRUE, row_names_gp = gpar(fontsize = font_row),
              show_column_names = TRUE, column_names_gp = gpar(fontsize = font_col))



num_char <- names(sim_matrix_DF) %>%
    str_count() %>%
    max()

ht_big_witdh <- (1+ pix_fact*num_char*font_col + ht_height + annot_height_abs + 3*lgd_height_abs + 3*pix_fact*lgd_font_abs + 3*pix_fact*lgd_lab_font_abs)

#setwd(step04_dir)
# drawheatmap ----
write("Generate /Heatmap.PDF ", stderr())
write(step04_dir, stderr())
write(capture.output(sessionInfo()), stderr())

pdf(file = paste0(step04_dir, "/Heatmap.PDF"),
    width = (font_row*pix_fact*num_char + ht_width + 3*lgd_width), 
    height = (ht_big_witdh)
)

plot0 <- draw(ht, annotation_legend_list = list(lgd_Alig, lgd_LenFrac), 
              annotation_legend_side = "top", heatmap_legend_side = "top", merge_legends = FALSE)

dev.off()

