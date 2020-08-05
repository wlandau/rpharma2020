library(targets)
tar_options(packages = c("tidyverse", "gapminder"))
options(crayon.enabled = FALSE, tidyverse.quiet = TRUE)
tar_pipeline(tar_target(gap, gapminder %>% group_by(continent) %>% 
    tar_group(), iteration = "group", format = "fst_tbl"), tar_target(means, 
    mean(gap$lifeExp), pattern = map(gap)), tar_target(combined, 
    gap %>% distinct(continent) %>% mutate(means)))
