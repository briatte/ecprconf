# ------------------------------------------------------------------------------
# Parse panels and papers
# ------------------------------------------------------------------------------

library(tidyverse)
library(rvest)

fs::dir_create("data")

# go through every paper on disk
for (j in fs::dir_ls(regexp = "papers", recurse = TRUE, type = "directory")) {

  f <- fs::dir_ls(j, regexp = ".*html$")
  d <- tibble::tibble()
  
  cat(j, ": parsing", length(f), "papers...\n")
  
  # [NOTE] RS 2013 does not list its papers, so skip it
  if (!length(f)) {
    next
  }
  
  p <- txtProgressBar(1, length(f), style = 3)
  
  for (i in f) {
    
    h <- read_html(i, encoding = "UTF-8")
    
    d <- bind_rows(
      tibble::tibble(
        panel_id = html_nodes(h, "a#MainContent_MainContent_PanelHyperLink") %>% 
          html_attr("href"),
        panel = html_nodes(h, "a#MainContent_MainContent_PanelHyperLink") %>% 
          html_text(trim = TRUE),
        paper_id = i,
        paper = html_nodes(h, "h1#MainContent_MainContent_PaperTitle") %>% 
          html_text(trim = TRUE),
        author = html_nodes(h, xpath = "//a[contains(@id, 'AuthorLink')]") %>% 
          html_text(trim = TRUE),
        affiliation = html_nodes(h, xpath = "//span[contains(@id, 'AuthorInstitution')]") %>% 
          html_text(trim = TRUE)
        #, abstract (not extracted to keep output small)
      ),
      d
    )
    
    setTxtProgressBar(p, which(f == i))
    
  }
  
  cat("\n")

  # ----------------------------------------------------------------------------
  # Basic post-processing
  # ----------------------------------------------------------------------------
  
  d <- d %>% 
    tibble::add_column(
      conference_id = str_replace(d$panel_id, ".*EventID=", ""),
      conference = fs::path_dir(j),
      .before = 1
    ) %>% 
    mutate(
      panel_id = str_extract(panel_id, "\\d+"), # first match is PanelID
      paper_id = str_extract(fs::path_file(paper_id), "\\d+"), # only match
      # basic cleanup of affiliations (some are missing entirely)
      affiliation = na_if(affiliation, "")
    ) %>% 
    arrange(panel_id, paper_id)
  
  # export full data to data/ folder, named after conference
  write_tsv(d, fs::path("data", str_c(fs::path_dir(j), "-papers.tsv")))
  
}

# kthxbye
