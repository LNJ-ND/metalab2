
### SCRIPT TO DEPLOY SHINY APPS TO SHINYAPPS.IO AFTER CHANGES ###

library(dplyr)
library(purrr)
library(here)
library(rsconnect)

## CONNECT COMPUTER TO SHINYAPPS.IO ACCOUNT
# replace secret with token and secret
rsconnect::setAccountInfo(name='', token='', secret='')

## CREATE DIRECTORY FOR DEPLOYAPPS
deploy_dir <- here("shinyapps/deploy_apps")
if (!dir.exists(deploy_dir)) {dir.create(deploy_dir)}


########### VISUALISATION ##################

# DIRECTORY FOR VISUALISATION
deploy_vis_dir <- here("shinyapps/deploy_apps/visualization")
if (!dir.exists(deploy_vis_dir)) {dir.create(deploy_vis_dir)}

# DIRECTORY FOR SHINYAPPS FILES
## data
sa_vis_dir <- here("shinyapps/deploy_apps/visualization/shinyapps")
if (!dir.exists(sa_vis_dir)) {dir.create(sa_vis_dir)}

# COPY FILES
## copy common folder
file.copy(from = here("shinyapps/common"), to = here("shinyapps/deploy_apps/visualization/shinyapps"), recursive = TRUE, overwrite = T)
## copy site data folder
file.copy(from = here("shinyapps/site_data"), to = here("shinyapps/deploy_apps/visualization/shinyapps"), recursive = TRUE, overwrite = T)

## copy visualization files
### global.R
file.copy(from = here("shinyapps/visualization/global.R"), to = here("shinyapps/deploy_apps/visualization/"), overwrite = T)
### server.R
file.copy(from = here("shinyapps/visualization/server.R"), to = here("shinyapps/deploy_apps/visualization/"), overwrite = T)
### ui.RR
file.copy(from = here("shinyapps/visualization/ui.R"), to = here("shinyapps/deploy_apps/visualization/"), overwrite = T)
### restart.txt
file.copy(from = here("shinyapps/visualization/restart.txt"), to = here("shinyapps/deploy_apps/visualization/"), overwrite = T)

## copy mv_functions
file.copy(from = here("mv_functions.R"), to = here("shinyapps/deploy_apps/visualization/"), overwrite = T)

# DEPLOY TO SHINYAPPS.io
rsconnect::deployApp(here("shinyapps/deploy_apps/visualization"))



########### POWER ANALYSIS ##################

# DIRECTORY FOR POWER ANALYSIS
deploy_pa_dir <- here("shinyapps/deploy_apps/power_analysis")
if (!dir.exists(deploy_pa_dir)) {dir.create(deploy_pa_dir)}

# DIRECTORY FOR SHINYAPPS FILES
## data
sa_pa_dir <- here("shinyapps/deploy_apps/power_analysis/shinyapps")
if (!dir.exists(sa_pa_dir)) {dir.create(sa_pa_dir)}

# COPY FILES
## copy common folder
file.copy(from = here("shinyapps/common"), to = here("shinyapps/deploy_apps/power_analysis/shinyapps"), recursive = TRUE, overwrite = T)
## copy site data folder
file.copy(from = here("shinyapps/site_data"), to = here("shinyapps/deploy_apps/power_analysis/shinyapps"), recursive = TRUE, overwrite = T)

## copy power_analysis files
### global.R
file.copy(from = here("shinyapps/power_analysis/global.R"), to = here("shinyapps/deploy_apps/power_analysis/"), overwrite = T)
### server.R
file.copy(from = here("shinyapps/power_analysis/server.R"), to = here("shinyapps/deploy_apps/power_analysis/"), overwrite = T)
### ui.RR
file.copy(from = here("shinyapps/power_analysis/ui.R"), to = here("shinyapps/deploy_apps/power_analysis/"), overwrite = T)
### restart.txt
file.copy(from = here("shinyapps/power_analysis/restart.txt"), to = here("shinyapps/deploy_apps/power_analysis/"), overwrite = T)

## copy mv_functions
file.copy(from = here("mv_functions.R"), to = here("shinyapps/deploy_apps/power_analysis/"), overwrite = T)

# DEPLOY TO SHINYAPPS.io
rsconnect::deployApp(here("shinyapps/deploy_apps/power_analysis"))
