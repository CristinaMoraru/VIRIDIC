library(DT)
library(shiny)
#library(shinyWidgets)
#library(shinythemes)
library(shinyjs)



shinyUI(
    tagList(
        tags$head(tags$script(type="text/javascript", src = "code.js"), 
                  tags$script(type="text/javascript", src = "analytics-viridic.js"),
                  tags$meta(name="description", content="VIRIDIC computes pairwise intergenomic distances or similarities for viral genomes, at nulceotide level."),
                  tags$meta(name="keywords", content="VIRIDIC, intergenomic similarity, intergenomic distance, viruses, phages, taxonomy, classification"),
                  tags$meta(name="author", content="Cristina Moraru"),
                  tags$meta(name="title", content="VIRIDIC - Virus Intergenomic Distance Calculator")
                  ),
        navbarPage(
            #### Top website ----
            title= #"Moraru", 
                a(h4("\u00A0The Moraru Phage Lab\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0\u00A0", style="color:#000000"),
                  href = "http://moraru-phage-lab.icbm.de", style="text-decoration: none"),
            #position="fixed-top",
            #collapsible = "TRUE",
            windowTitle="VIRIDIC - Virus Intergenomic Distance Calculator",
            theme = shinythemes::shinytheme("cerulean"),
            tabPanel("HOME",
                     fluidRow(h1(" ")),
                     fluidRow(
                       column(10, offset = 1,
                              shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 8px; text-align: justify",
                                              fluidRow(h1("")),
                                              fluidRow(
                                              column(10, offset = 1, h4("Whats is VIRIDIC and how to cite")
                                                 )),
                                              fluidRow(h1("")),
                                              fluidRow(
                                                column(10, offset = 1, p("VIRIDIC (Virus Intergenomic Distance Calculator) computes pairwise intergenomic distances/similarities amongst viral genomes. The algorithms used are presented in the paper:"))
                                              ),
                                              fluidRow(
                                                column(10, offset = 1, p("Moraru, C., Varsani, A., and Kropinski, A.M. (2020) VIRIDIC – a novel tool to calculate the intergenomic similarities of prokaryote-infecting viruses. Viruses 12(11).", 
                                                                         tags$a("https://doi.org/10.3390/v12111268", target="_blank" , href="https://doi.org/10.3390/v12111268"))
                                                )),
                                              h1(" "),
                                              h1(" "),
                                              fluidRow(
                                                column(10, offset = 1, h4("Important notes:"))
                                              ),
                                              fluidRow(column(10, offset = 1,
                                              shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px; text-align: justify;",  # #DAB1EE; 
                                                              
                                                              
                                                              fluidRow(
                                                                column(10, offset = 1, p("1. To run VIRIDIC web, upload a single fasta file with all phage genomes of interest, create a project and press run. Save the project ID that will be displayed when the project is created. You will need it to access the data if the calculations take a long time.")# If you provide an email address, the project ID will be sent to you.")
                                                                )),
                                                              fluidRow(
                                                                column(10, offset = 1, p("2. In the input fasta file, the identifier of each fasta record should be unique and it should have no spaces. Spaces can be replaced with '_'."))
                                                              ),
                                                              fluidRow(
                                                                column(10, offset = 1, p("3. VIRIDIC stand-alone is available now (see download tab). You can use it for jobs with high computational demand and/or for implementing it in your own pipelines. It is very easy to install on your own servers (it is wrapped as a Singularity). You can continue to use the VIRIDIC web-service for small to medium projects (e.g. up to 200 phages per project, no viromes please, they will crash our resources and the analysis will fail).")
                                                                ))
                                                              ))),
                                              h1(" "),
                                              h1(" "),
                                              fluidRow(
                                                column(10, offset = 1, h4("News"))
                                              ),
                                              fluidRow(column(10, offset = 1,
                                                              shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px; text-align: justify;",  # #DAB1EE; 
                                                                              
                                                                              
                                                                              fluidRow(
                                                                                column(10, offset = 1, p("VirClust, a tool for hierarchical clustering of viruses, core protein calculation and protein annotation, 
                                                                                                         is now available at ", tags$a("virclust.icbm.de .", target="_blank" , href="http://virclust.icbm.de/")
                                                                                )))
                                                              )))
                                              
                                              # fluidRow(
                                              #     column(10, offset = 1, h5("VIRIDIC was just updated significantly and it's code is fresh out of the oven.
                                              #                      Although I don't expect major flaws, eventually some glitches of the interface and in the heatmap,
                                              #                      I will continue testing it in the next days. Feel free to use it and please report any weird things
                                              #                      that you might see, so that I can fix them.")
                                              #     ))
                                              #shiny::tags$div(style = "background-color: #ff9999; width: 100%; border-radius: 5px;",
                                              #)
                              ))),
                     fluidRow(h1("")),
                     fluidRow(
                       column(10, offset = 1,
                              shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                              fluidRow(
                                                column(2, offset=1, shiny::tags$img(src = "https://www.uni-oldenburg.de/img/orga/f5icbm/kopflogo.png", width = "70px", height = "90px"), shiny::tags$img(src = "UniOld.png", width = "70px", height = "70px",  align = "center")),
                                                column(7, 
                                                       h1(" "),
                                                       h5(shiny::tags$b("    Developer - Cristina Moraru, PhD")),
                                                       p("Senior Scientist, Department of The Biology of Geological Processes"),
                                                       p("Institute for Chemistry and Biology of the Marine Environment"), 
                                                       p("Carl-von-Ossietzky –Str. 9 -11, D-26111 Oldenburg, Germany"),
                                                       p(shiny::tags$b("Email:"), "liliana.cristina.moraru(     at     )uni-oldenburg.de"),
                                                       h1(" ")
                                                )
                                              )
                              )
                       )
                     )
                     ),
            #### VIRIDIC ----
            tabPanel("VIRIDIC WEB",
                     #fluidPage(
                     useShinyjs(),
                     ##### Header ----
                     #shiny::tags$style(type="text/css", "body {padding-top: 70px;}"),
                     fluidRow(h1("")),
                     
                     ##### Calculate with VIRIDIC ----
                                     #fluidRow(h1("")),
                                     sidebarLayout(
                                         ##Sidebar ----  
                                         sidebarPanel(
                                             #fluidRow(column(12, offset = 4, h4("Control panel"))),
                                             #h1("   "),
                                             
                                             ##### Run new project -----
                                             shiny::tags$div(style = "background-color: #eaf2f8; width: 100%; border-radius: 5px;",
                                                             fluidRow(column(12, offset=1, h4("RUN NEW PROJECT"))),
                                                             fluidRow(
                                                                 column(5, offset = 1, textInput("User_name", label = "User name*", value = "minimum 6 characters")),
                                                                 column(5, offset = 0, textInput("Project_name", label = "Project name*", value = "minimum 6 characters"))
                                                             ),
                                                             #fluidRow(column(12, offset = 1, p("User and Project names - minimum 6 characters."))),
                                                             #fluidRow(h3(" ")),
                                                             # fluidRow(
                                                             #     column(10, offset = 1, textInput("User_email", label = "User email", value = ""))
                                                             # ),
                                                             #fluidRow(column(10, offset = 1, p("*NO gmail, VIRDIC will give an error!"))),
                                                             fluidRow(
                                                                 column(10, offset = 1, fileInput("Upload_genome", label = "Upload genomes (no spaces in phage names!)*"))
                                                             ),
                                                             fluidRow(),
                                                             
                                                             fluidRow(
                                                                 column(10, offset = 1, selectInput("Blastn_param", label = "BLASTN parameters", choices = c("'-word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2'", 
                                                                                                                                                             "'-word_size 11 -reward 2 -penalty -3 -gapopen 5 -gapextend 2'",
                                                                                                                                                             "'-word_size 20 -reward 1 -penalty -2'",
                                                                                                                                                             "'-word_size 28 -reward 1 -penalty -2'"), 
                                                                                                    selected = "-word_size 7 -reward 2 -penalty -3 -gapopen 5 -gapextend 2"))
                                                             ),
                                                             fluidRow(
                                                                 column(4, offset = 1, numericInput("SpTh", "Species threshold", value = 95, min = 50, max = 100)),
                                                                 column(4, offset = 1, numericInput("GenTh", "Genus threshold", value = 70, min = 50, max = 100)) 
                                                             ),
                                                             fluidRow(
                                                                 column(12, offset = 1, radioButtons("results", label = "Results as:", choices = c("similarity", "distance"), selected = "similarity", inline = TRUE))
                                                             ),
                                                             fluidRow(h1(" "), h1(" ")),
                                                             fluidRow(
                                                                 column(3, offset = 1, actionButton("Create", label = "Create project")),
                                                                 column(3, offset = 1, actionButton("Run", label = "Run VIRIDIC")),
                                                                 column(3, offset = 1, actionLink("Reset", label = shiny::a(h5("Reset Project"), target = "_top", href =paste0("http://viridic.icbm.de/?page=3&a=", Sys.time()))))
                                                             ),
                                                             fluidRow(
                                                                 column(10, offset = 1, p("* Mandatory for new projects"))
                                                             ),
                                                             fluidRow(h1(" "), h1(" "))
                                                             
                                             ),
                                             
                                             h1("   "),
                                             ##### Load project -----
                                             shiny::tags$div(style = "background-color: #eaf2f8; width: 100%; border-radius: 5px;",
                                                             fluidRow(column(12, offset=1, h4("LOAD EXISTING PROJECT"))),
                                                             fluidRow(column(10, offset = 1, textInput("Proj_ID", label = "Input a project ID", value = ""))),
                                                             fluidRow(column(10, offset = 1, actionButton("Load", "Load project"))),
                                                             fluidRow(h1(" "), h1(" "))
                                             )
                                         ),
                                         ## Main panel ----
                                         mainPanel(
                                             tabPanel("Plots",
                                                      
                                                      #shiny::tags$div(id="pageLOADING", h3("Content is loading, please be patient ...")),
                                                      ###Project header----
                                                      fluidRow(column(12, offset=0, h4(textOutput("VIRIDIC_status")))),
                                                      fluidRow(column(12, offset = 0, p(textOutput("fasta_validity")))),
                                                      fluidRow(column(12, offset=0, p(textOutput("message")))),
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(12, offset = 0,
                                                                 shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                                                                 fluidRow(p(" "))))),
                                                      
                                                      ###heatmap----
                                                      fluidRow(column(12, offset = 0, h4(textOutput("Heatmap_title")))),
                                                      #plotOutput("Heatmap"),#, height = "350px" ),
                                                      fluidRow(
                                                          column(12, offset = 0, textOutput("Heat_ready"))#)
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, downloadButton("Down_heat", "Download heatmap"))
                                                      ),
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(12, offset = 0, h5(textOutput("Heat_opt")))
                                                      ),
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(3, offset = 0, actionButton("Recalc_ht", "Recalculate heatmap"))
                                                      ),
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(3, offset = 0, selectInput("clust_meth", label = "Clustering method", 
                                                                                            choices = c("ward.D", "ward.D2", "single", "complete", "average",
                                                                                                        "mcquitty"), selected = "complete"))
                                                      ),
                                                      fluidRow(
                                                          column(12, offset = 0, textOutput("Show numeric values"))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, checkboxInput("Show_sim", "Similarity/Distance", value = TRUE)),
                                                          column(3, offset = 0, checkboxInput("Show_sqLenFrac", "Genome length ratio", value = TRUE)),
                                                          column(3, offset = 0, checkboxInput("Show_qAligFrac", "Aligned ratio 1", value = TRUE)),
                                                          column(3, offset = 0, checkboxInput("Show_sAligFrac", "Aligned ratio 2", value = TRUE))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, numericInput("sim_for_sim", "Similarity th for similarity", value = 0, min = 0)),
                                                          column(3, offset = 0, numericInput("sim_for_frac", "Similarity th for ratio info", value = 0, min = 0, max = 95))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, numericInput("Font_sim", "Size similarity/distance", value = 8, min=1)),
                                                          column(3, offset = 0, numericInput("Font_sqLenFrac", "Size genome length ratio", value = 4, min=1)),
                                                          column(3, offset = 0, numericInput("Font_qAligFrac", "Size aligned ratio 1", value = 4, min=1)),
                                                          column(3, offset = 0, numericInput("Font_sAligFrac", "Size aligned ratio 2", value = 4, min=1))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, selectInput("border_col_sim", label = "Color border for similarities", choices = 
                                                                                                c("none", "white", "gray98", "gray95", "gray90", "gray80", "gray70", "gray60", "gray50", "gray40", "gray30", "gray20", "gray10", "black"), 
                                                                                            selected = "none")),
                                                          column(3, offset = 0, selectInput("border_col_frac", label = "Color border for ratios", choices = 
                                                                                                c("none", "white", "gray98", "gray95", "gray90", "gray80", "gray70", "gray60", "gray50", "gray40", "gray30", "gray20", "gray10", "black"), 
                                                                                            selected = "none")),
                                                          column(3, offset = 0, selectInput("Frac_col", label = "Color for length ratio", choices = c("black", "blue", "darkblue", "cadetblue", "darkgreen", "chartreuse4", "chartreuse", "blueviolet", 
                                                                                                                                                      "darkmagenta",  "coral4", "firebrick4"), selected = "black")),
                                                          
                                                          column(3, offset = 0, selectInput("Alig_col", label = "Color for aligned ratios", choices = c("steelblue1", "slategray2", "skyblue1", "lightsteelblue", "thistle1", "wheat1", "peachpuff", "moccasin", "sandybrown",
                                                                                                                                                        "khaki1", "antiquewhite", "plum2", "palegreen", "seagreen1"), selected = "peachpuff"))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, selectInput("sim_palette", label = "Color fill similarities/distances", 
                                                                                            choices = c("Blues", "BuGn", "BuPu", "GnBu","Greens", "Greys", "Oranges", "OrRd", "PuBu", "PuBuGn", "PuRd",
                                                                                                        "Purples", "RdPu", "Reds", "YlGn", "YlGnBu", "YlOrBr", "YlOrRd"), 
                                                                                            selected = "PuBuGn")),
                                                          column(3, offset = 0, numericInput("font_size_row", "Size row names", value = 12, min=1)),
                                                          column(3, offset = 0, numericInput("font_size_col", "Size column names", value = 12, min=1))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, numericInput("annot_height", "Height annotation pannel", value = 10, min=1, max = 100)),
                                                          column(3, offset = 0, numericInput("annot_font", "Size annotation name", value = 100, min=1, max = 300)),
                                                          column(3, offset = 0, selectInput("annot_rot", "Angle annotation name", choices = c(0, 90, 180, 270), selected = 270)),
                                                          column(3, offset = 0, numericInput("lgd_height", "Legend Scale height", value = 3, min=1, max = 100))
                                                      ),
                                                      fluidRow(
                                                          column(3, offset = 0, numericInput("lgd_width", "Legend width", value = 40, min=1, max = 100)),
                                                          column(3, offset = 0, numericInput("lgd_lab_font", "Legend label size", value = 3, min=1, max = 100)),
                                                          column(3, offset = 0, numericInput("lgd_font", "Legend name size", value = 3, min=1, max = 100)),
                                                          column(3, offset = 0, selectInput("lgd_pos", "Legend name position", choices = c("topleft", "topcenter", "leftcenter", "lefttop"),
                                                                                            selected = "topleft"))
                                                      ),
                                                      
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(12, offset = 0,
                                                                 shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                                                                 fluidRow(p(" "))))),
                                                      ###Similarities table-----
                                                      fluidRow(column(12, offset = 0, h4(textOutput("Sim_table_title")))),
                                                      fluidRow(p(" ")),
                                                      fluidRow(column(12, offset=0, dataTableOutput("sim_table"))),
                                                      fluidRow(p(" ")),
                                                      fluidRow(column(12, offset = 0, selectInput("Sim_table_title_cols", label = "Table columns", choices = "", multiple = TRUE, width = "80%"))),
                                                      fluidRow(
                                                          column(3, offset = 0, downloadButton("Down_table", "Download sim/dist"))
                                                      ),
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(12, offset = 0,
                                                                 shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                                                                 fluidRow(p(" "))))),
                                                      ###Cluster table---
                                                      fluidRow(column(12, offset = 0, h4(textOutput("Cluster_table_title")))),
                                                      fluidRow(p(" ")),
                                                      fluidRow(column(12, offset=0, dataTableOutput("clust_table"))),
                                                      fluidRow(p(" ")),
                                                      fluidRow(
                                                          column(3, offset = 0, downloadButton("Down_clust_table", "Download clusters"))
                                                      ),
                                                      fluidRow(h1(" ")),
                                                      fluidRow(
                                                          column(12, offset = 0,
                                                                 shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                                                                 fluidRow(p(" ")))))
                                                      
                                             )
                                             #position = "right"
                                         )
                                     ),
                                     h1(" "), #),
                     ##### Bottom ----
                     fluidRow(
                         column(12, offset = 0,
                                shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                                fluidRow(
                                                    column(2, offset=1, shiny::tags$img(src = "https://www.uni-oldenburg.de/img/orga/f5icbm/kopflogo.png", width = "70px", height = "90px"), shiny::tags$img(src = "UniOld.png", width = "70px", height = "70px",  align = "center")),
                                                    column(7, 
                                                           h1(" "),
                                                           h5(shiny::tags$b("    Developer - Cristina Moraru, PhD")),
                                                           p("Senior Scientist, Department of The Biology of Geological Processes"),
                                                           p("Institute for Chemistry and Biology of the Marine Environment"), 
                                                           p("Carl-von-Ossietzky –Str. 9 -11, D-26111 Oldenburg, Germany"),
                                                           p(shiny::tags$b("Email:"), "liliana.cristina.moraru(     at     )uni-oldenburg.de"),
                                                           h1(" ")
                                                    )
                                                )
                                )
                         )
                     )
            ),
            ### download ###
            tabPanel("DOWNLOAD",
                     fluidRow(
                         column(10, offset = 1,
                                shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 8px;",
                                                fluidRow(
                                                    column(10, offset = 1, h4("Algorithms used by VIRIDIC and how to cite")
                                                    )),
                                                fluidRow(
                                                    column(10, offset = 1, p("VIRIDIC (Virus Intergenomic Distance Calculator) computes pairwise intergenomic distances/similarities amongst viral genomes. The algorithms used are presented in the paper 
                                                                             “VIRIDIC – a novel tool to calculate the intergenomic similarities of prokaryote-infecting viruses”, co-authored by Cristina Moraru, Arvind Varsani and Andrew Kropinski. 
                                                                             You can access this paper here: ", tags$a("doi: 10.3390/v12111268", target="_blank" , href="https://www.mdpi.com/1999-4915/12/11/1268"))
                                                    )),
                                                fluidRow(
                                                    column(10, offset = 1, h4("NEW: Download VIRIDIC v1.1 stand-alone"))
                                                ),
                                                fluidRow(h1(" ")),
                                                fluidRow(column(10, offset = 1, p("VIRIDIC v1.1 has a new parameter, named ram_max. 
                                                                                 This allows the user to set the maximum amount of RAM used (controls basically the future_globals_max_size_default 
                                                                                 option in R.)"))),
                                                fluidRow(
                                                    column(2, offset = 1, downloadButton("Down_standAlone", "Download VIRIDIC")),
                                                    column(2, offset = 0, downloadButton("Down_manual", "Download manual"))#,
                                                    #column(2, offset = 0, downloadButton("Down_code", "Download manual"))
                                                ),
                                                fluidRow(h1("")),
                                                fluidRow(
                                                  column(10, offset = 1, h4("Download VIRIDIC source code"))
                                                ),
                                                fluidRow(
                                                  column(10, offset = 1, p("You can download the VIRIDIC source code, including that of the shiny app from the GitHub Repo: ", tags$a("VIRIDIC repo", target = "_blank", href="https://github.com/CristinaMoraru/VIRIDIC/")))
                                                )
                                                    ))),
                     ##### Bottom ----
                     fluidRow(h1("")),
                     fluidRow(
                         column(10, offset = 1,
                                shiny::tags$div(style = "background-color: #e8f3fd; width: 100%; border-radius: 5px;",
                                                fluidRow(
                                                    column(2, offset=1, shiny::tags$img(src = "https://www.uni-oldenburg.de/img/orga/f5icbm/kopflogo.png", width = "70px", height = "90px"), shiny::tags$img(src = "UniOld.png", width = "70px", height = "70px",  align = "center")),
                                                    column(7, 
                                                           h1(" "),
                                                           h5(shiny::tags$b("    Developer - Cristina Moraru, PhD")),
                                                           p("Senior Scientist, Department of The Biology of Geological Processes"),
                                                           p("Institute for Chemistry and Biology of the Marine Environment"), 
                                                           p("Carl-von-Ossietzky –Str. 9 -11, D-26111 Oldenburg, Germany"),
                                                           p(shiny::tags$b("Email:"), "liliana.cristina.moraru(     at     )uni-oldenburg.de"),
                                                           h1(" ")
                                                    )
                                                )
                                )
                         )
                     )
                     )
        )
    )
)

