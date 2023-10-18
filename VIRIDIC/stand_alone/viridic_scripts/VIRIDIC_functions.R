###get params simple function

get_params_simple_fun <- function(input0, param_name, type="text")
{
  param_pat <- paste0("^", param_name, "=")
  param_pos <- str_which(input0, param_pat)
  param_value <- str_remove(input0[param_pos], param_pat)
  
  if(type == "numeric")
  {
    param_value <- as.numeric(param_value)
  }
  
  if(type == "Int")
  {
    param_value <- as.integer(param_value)
  }
  
  return(param_value)
}


###get params function
get_params_fun <- function(input0, param_name, type, default_val="", min_val=0, max_val = 100, allowed = "", status_path = "")
{
  param_n <- str_which(input0, paste0("^", param_name, "="))
  
  #duplicated param names
  if(length(param_n) > 1)
  {
    print(paste0("The ", param_name, " parameter was given more than once. Aborting VirClust."))
    quit()
  }
  
  #default param values
  if(length(param_n) == 0)
  {
    #cpu param
    if(param_name == "cpu")
    {
      param_value <- parallel::detectCores()/2
    }else
    {
      #params without default
      if(param_name == "projdir")
      {
        print(paste0("Missing ", param_name, " parameter. Aborting VirClust."))
        quit()
      }
      
      if(param_name == "infile" & shiny == "no")
      {
        print(paste0("Missing ", param_name, " parameter. Aborting VirClust."))
        quit()
      }
      
      #params with default
      param_value <- default_val
      
      if(type == "Int")
      {param_value <- as.integer(param_value)}
      
      if(type == "Num")
      {param_value <- as.numeric(param_value)}
    }
  }
  
  #specified params
  if(length(param_n) == 1)
  {
    param_value <- str_remove(input0[param_n], paste0("^", param_name, "="))
    
    if(type == "Int")
    {
      param_value <- as.integer(param_value)
      
      if(is.na(param_value) | param_value < min_val)
      {
        print(paste0("Non-numeric / invalid ", param_name, " parameter. Aborting VirClust."))
        quit()
      }
    }
    
    if(type == "Num")
    {
      param_value <- as.numeric(param_value)
      
      if(is.na(param_value) | param_value < min_val)
      {
        print(paste0("Non-numeric / invalid ", param_name, " parameter. Aborting VirClust."))
        quit()
      }
      
      if(str_detect(param_name, "clust_dist_"))
      {
        if(param_value > max_val)
        {
          print(paste0("Non-numeric / invalid ", param_name, " parameter. Aborting VirClust."))
          quit()
        }
      }
    }
    
    if(type == "Text")
    {
      if(!param_name %in% c("projdir", "infile"))
      {
        if(!param_value %in% allowed)
        {
          print(paste0("Invalid ", param_name, " parameter value: ", param_value, ". Aborting VirClust."))
          quit()
        }
      }
      
      
      if(param_name == "continue" & param_value == "yes")
      {
        if(file.exists(status_path) == FALSE)
        {
          print(paste0("Cannot continue, previous project doesn't seem to exit. Aborting VirClust."))
          quit()
        }
      }
    }
  }
  rm(param_n)
  
  return(param_value)
}
