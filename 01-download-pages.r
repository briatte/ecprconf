# ------------------------------------------------------------------------------
# Download raw data
# ------------------------------------------------------------------------------

library(tidyverse)
library(rvest)

# this requires panel lists, which we downloaded manually
for (i in fs::dir_ls(regexp = "panels-", recurse = TRUE)) {
  
  # create raw data subfolders
  b <- fs::path_dir(i)
  fs::dir_create(fs::path(b, "panels"))
  fs::dir_create(fs::path(b, "papers"))
  
  p <- read_html(i) %>% 
    html_nodes("tbody#panelContent tr td a") %>% 
    html_attr("href") %>% 
    str_subset("PanelID=\\d+") %>% 
    str_c("https://ecpr.eu", .) # or 'gc.ecpr.eu' for GC 2020 (2020-09-01)
  
  cat(i, ": downloading", length(p), "panels and their papers\n")

  # download each panel
  for (j in p) {
    
    cat(".")
    
    f <- str_extract(j, "PanelID=\\d+") %>% 
      str_replace("PanelID=", "panels/") %>% 
      str_c(., ".html") %>% 
      fs::path(b, .)
    
    if (!fs::file_exists(f)) {
      download.file(j, f, mode = "wb", quiet = TRUE)
    }
    
    u <- read_html(f) %>% 
      html_nodes("#MainContent_MainContent_PaperGrid_DXMainTable a") %>% 
      html_attr("href") %>% 
      str_subset("(Paper|Section)ID=\\d+") %>% 
      str_replace("^\\.\\.", "https://ecpr.eu")
    
    # download each paper
    for (k in u) {
      
      f <- str_extract(k, "PaperID=\\d+") %>% 
        str_replace("PaperID=", "papers/") %>% 
        str_c(., ".html") %>% 
        fs::path(b, .)
      
      if (!fs::file_exists(f)) {
        download.file(k, f, mode = "wb", quiet = TRUE)
      }
      
    }
    
    if (!(which(j == p) %% 50) | which(j == p) == length(p)) {
      cat("", which(j == p), "\n")
    }
    
  }
  
}

# check that year in page title matches that of the conference folder
fs::dir_ls(regexp = "panels-", recurse = TRUE) %>% 
  purrr::map_df(
    ~ tibble(
      folder = .x,
      title = read_html(.x) %>% 
        html_node("title") %>% 
        html_text()
    )
  ) %>% 
  mutate(
    folder_year = str_extract(folder, "\\d+"),
    title_year = str_extract(title, "\\d+")
  ) %>% 
  filter(folder_year != title_year) # should be empty

# kthxbye
