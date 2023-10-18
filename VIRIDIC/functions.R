proj_dir_fun <- function(prefix, User_name, Project_name)
{
    sufi1 <- paste0(as.character(prefix+1), "___", User_name, "___",  Project_name, "___") %>% 
        str_replace_all(">", "_") %>%
        str_replace_all("<", "_") %>%
        str_replace_all("/", "_") %>%
        str_replace_all("'\'", "_") %>%
        str_replace_all(":", "_") %>%
        str_replace_all("\\.", "_") %>%
        str_replace_all("'", "_") %>%
        str_replace_all("´", "_") %>%
        str_replace_all("`", "_") %>%
        #str_replace_all("-", "") %>%
        str_replace_all(" ", "_")
    
    sufi2 <- as.character(Sys.time()) %>%
        str_replace_all( "-", "") %>%
        str_replace_all(":", "") %>%
        str_replace_all(" ", "")
    
    sufi <- paste0(sufi1, sufi2)
    
    path<-paste0("data/", "P", sufi)
    return(path)
}

load_table_fun <- function(path)
{
    path_table <- paste0(path, "/sim_MA_genCol.csv")
    table <- read.csv(file = path_table, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
    return(table)
}

load_clusttable_fun <- function(path)
{
    path_table <- paste0(path, "/clusters.csv")
    table <- read.csv(file = path_table, header = TRUE, sep = "\t", stringsAsFactors = FALSE)
    return(table)
}


##send email function
send_email <- function(to, body)
{
    from <- "liliana.cristina.moraru@uni-oldenburg.de"
    subject <- "VIRIDIC"
    SMTP= list(smtpServer ="smtp.uni-oldenburg.de")
    sendmailR::sendmail(from = from, to = to, subject = subject, msg = body, control = SMTP)
}