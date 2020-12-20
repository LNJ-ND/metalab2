# Shiny Apps

This directory contains separate directories for the shiny apps. Some of these apps are still under development and not included on the website. These directories contain both server.R and ui.R files. The server.R file mostly defines the contents/functions of a shiny app. The ui.R file is responsible for the layout of these contents/functions and possibly some styling. 
Besides this, the directory contains a directory for scripts sourced throughout the shinyapps (common) and one for the data used in the shiny apps (site_data).

Here you can find short description of each of the directories in this shinyapps directory: 

## common 
This directory contains a global.R script, sourced throughout the shinyapps. It loads the necessary libraries, and data from the site_data folder and metadata from github. In addition, it contains a .css script for additional styling.  

## site_data 
This directory contains the data used for the shiny apps. This data is loaded from Google Sheets in the main_builder.R file. Thus, the site_data is updated every time the main_builder.R script is run (every time the master is updated) and the files in site_data are updated. 

## data_validation 
This app is still under development. It may be used as a tool to validate datasets which might be added to the MetaVoice database.
If you are interested, [MetaLab](http://metalab.stanford.edu/app/data-validation/) has implemented this tool on their website within the field of cognitive development and early language acquisition. 

## power_analysis 
This app is published on the [Metavoice website](https://metavoice.au.dk/app.html?id=power_analysis). It allows users to calculate power for experiment planning. Users can select a meta-analysis (dataset), voice feature and a set of moderators to see statistical power estimates using the estimated effect size based on data available in the database. 

## power_simulation 
This app is still under development. It may be used to simulate data for experiment planning. 
If you are interested, [MetaLab](http://metalab.stanford.edu/app/power-simulation/) has implemented this tool on their website within the field of cognitive development and early language acquisition. 

## visualization 
This app is published on the [Metavoice website](https://metavoice.au.dk/app.html?id=visualisation). It presents meta-analytic visualisations of meta-analysis conducted based on the input of the user in relation to a specific disorder, voice feature and optional moderator. 
