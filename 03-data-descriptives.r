# ------------------------------------------------------------------------------
# Descriptive statistics
# ------------------------------------------------------------------------------

library(tidyverse)

# read data from all conferences
d <- fs::dir_ls("data", regexp = "-papers\\.tsv$") %>% 
  purrr::map_df(read_tsv, col_types = "cccccccc")

# by conference
group_by(d, conference) %>% 
  summarise(
    n_panels = n_distinct(panel_id),
    n_papers = n_distinct(paper_id),
    n_authors = n_distinct(author),
    n_affiliations = n_distinct(affiliation),
    # NA_authors = sum(is.na(author)), # never missing
    NA_affiliations = sum(is.na(affiliation)),
    p_NA = round(100 * NA_affiliations / n(), 0) # > 10% for 2 events
  ) %>% 
  print(n = 100)

# overall
tibble::tibble(
  n_conferences = n_distinct(d$conference),
  n_panels = n_distinct(d$conference, d$panel_id),
  n_papers = n_distinct(d$conference, d$paper_id),
  n_authors = n_distinct(d$author),
  n_affiliations = n_distinct(d$affiliation)
) %>% 
  print()

# very little missing affiliation data overall
table(is.na(d$affiliation)) / nrow(d)

# top affiliations, [NOTE] before (much needed!) data cleaning
group_by(d, affiliation) %>% 
  count(sort = TRUE)

# [NOTE] one author ('Deleted UserAccount') needs to be discarded
group_by(d, author) %>% 
  count(sort = TRUE)

# top authors, assuming fixed affiliation
count(d, author, affiliation, sort = TRUE)

# kthxbye
