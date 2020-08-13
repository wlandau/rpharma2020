library(targets)
source("R/functions.R")
tar_option_set(packages = c("coda", "spBayesSurv", "tidyverse", "truncnorm"))
options(clustermq.scheduler = "sge", clustermq.template = "sge.tmpl")
tar_pipeline(
  tar_target(sim, seq_len(10), deployment = "local"),
  tar_target(mean_treatment, c(10, 15, 20), deployment = "local"),
  tar_target(
    patients,
    simulate_trial(
      mean_control = 20,
      mean_treatment = mean_treatment,
      patients_per_arm = 100,
      censor = 30
    ),
    pattern = cross(sim, mean_treatment),
    format = "fst_tbl"
  ),
  tar_target(
    models,
    model_hazard(patients, 20),
    pattern = map(patients),
    format = "fst_tbl"
  ),
  tar_target(
    summaries,
    summarize_models(models),
    format = "fst_tbl"
  ),
  tar_target(
    results,
    summaries,
    format = "fst_tbl",
    deployment = "local"
  )
)
