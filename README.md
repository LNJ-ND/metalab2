# MetaVoice

MetaVoice provides tools for community-augmented meta-analysis (CAMA; Christia, Tsuji, & Bergmann, 2020; Tsuji, Bergmann & Christia, 2014) and power analysis for research on voice patterns across neuropsychiatric disorders. These tools are shiny applications (i.e. apps), implemented on the [MetaVoice] (LINK) website. Besides these shiny apps, the website also contains static content, which is hosted through GithubPages. The shiny apps are hosted through shinyapps.io, but are embedded in the static content by using their urls. Thereby, both static pages and dynamic shiny apps are brought together into a single website, MetaVoice.

Overall, the website is built based on a similar website called MetaLab. This website has been updated, but the version on which this website is built on can be reproduced locally using the [GitHub repository](https://github.com/langcog/metalab2). 

In the following you can find information about: 

- Overview of the GitHub Repository 
- Building MetaVoice locally
- Contributing to MetaVoice 


## Overview of the GitHub Repository 

The MetaVoice GitHub Repository consists of multiple different directories and subdirectories. In the paragraphs below are descriptions of what can be found within each subdirectory. This repository and its files are licensed under a MIT license and can be used accordingly (see [LICENSE](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/LICENSE) file).

### .github/workflows

The workflows folder includes a yaml file specifying the automated workflow of the website. Meaning that it defines events which cause a series of commands to run, when the certain events have occurred. More specifically, the yaml specifies actions to run automatically, everytime a push or a pull request is created, e.g. installing dependencies, and deploying the static sites (htmls) to the gh-pages branch.

### metadata

The [metadata](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/metadata) directory contains multiple yaml files, which are used throughout most of the website. It includes metadata in relation to the datasets, the domains, the field specifications, the shiny applications, the documentation tab, and persons in the about page. Thus, the particular yaml file should be edited when there are changes in relation to its content. If changes are made to the yaml files, the website will be updated when it has been rendered.

Further information on the specific files is provided in the README.md file in the directory. 

### pages

The [pages](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages) directory contains .Rmd files for the pages and subpages of the website. Further information on the specific files is provided in the README.md file in the directory.

### scripts

The [scripts](com/LNJ-ND/MetaVoice_Website/tree/master/scripts) directory contains a script necessary to build the website. More specifically, it loads the necessary data from Google Sheets and metadata from GitHub. Further, it renders the [pages](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages) and serves the website locally.

### shinyapps 

The [shinyapps](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/shinyapps) directory contains scripts for the shiny apps (meta-analytic visualisations, power analysis). 
In addition, it contains the data necessary to run the shiny apps. By either following instructions provided above, or in the README.md file in the directory, you can run the shiny apps locally.

### mv_functions.R

The [mv_functions.R](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/mv_functions.R) file contains functions necessary to run/reproduce the website. Therefore, it is sourced throughout the website. The functions in here are based on functions included in the [metalabr package](https://rdrr.io/github/langcog/metalabr/), and adjusted for the MetaVoice website.

### renv.lock

The [renv.lock](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/renv.lock) file defines the R version and packages including their paths and versions, under which the most recent version of the Website has been built. Therefore, it defines a personal library, which can be easily reproduced when aiming to run the website locally. For further instructions see **Building MetaVoice Locally**, below.


## Building MetaVoice Locally

Building MetaVoice locally can be used simply for reproduction, but also for development purposes. Instructions on how to contribute to MetaVoice are presented below. 

To reproduce MetaVoice (datasets, website pages, shiny apps) locally, follow the steps below: 

**Additional instructions for Windows Users:** If you are planning to reproduce MetaVoice on Windows, you should install the appropriate version of [Rtools](https://cran.r-project.org/bin/windows/Rtools/). Rtools will install the toolchain (compilers and links) necessary to build R packages from source code in the Windows environment.

#### 1. Cloning the Repository

Cloning the repository will store a copy of the entire repository locally on your copy. You can do this manually by following these [instructions](https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository) or by running the following in your terminal (substituting YOUR/DIRECTORY with the directory where you would like to store the repository on your computer):  

```
## specify directory on your computer for the storing the repository 
cd YOUR/DIRECTORY

## clone the MetaVoice_Website repository to the current directory
git clone https://github.com/LNJ-ND/MetaVoice_Website.git

```

#### 2. Opening the Project

Open the local copy of the repository in RStudio.

#### 3. Installing Package Dependencies

The R version and packages required to reproduce MetaVoice are stored in the [renv.lock](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/renv.lock) file, using the R package [renv](https://github.com/rstudio/renv). If you are running MetaVoice locally for the first time after cloning, or package dependencies have been changed, you can install the required R packages using: 

```
## if this is the first time you are using renv
install.packages(renv)
library(renv)

## install MetaVoice package dependencies
renv::restore()

```

#### 4. Buildig the website (pages) locally

To reproduce the pages of the website, you can run the following code in your R console:  

```
## build and serve the MetaVoice website on http://localhost:4321
source(here::here("scripts", "main_builder.R"))
```

#### 5. Buildig the shiny apps locally

To run the shiny apps locally you can run the following code, depending on the app you are interested in: 

```
## build and run the meta-analytic visualisation app
options(shiny.autoreload = TRUE)
shiny::runApp(here::here("shinyapps", "visualization")) 

## build and run the power analysis app
options(shiny.autoreload = TRUE)
shiny::runApp(here::here("shinyapps", "power_analysis")) 

````


## Contributing to MetaVoice

Thank you for considering contributing to MetaVoice! 

### Reporting Problems

If you have encountered a problem or have a question, you are welcome to create an issue on Github. 

To edit specific contents of the website, you may take into account the following directions. Note that currently it is only possible for members of the organisation to fully implement these changes. However, if you have suggestions you can clone the repository, make the changes and create a pull request, specifying the purpose of your suggestion. This puts your suggestion to the staging environment. We will thankfully consider your suggestion and potentially decide to implement it by merging your pull request and deploying it to the production environment. If you wish to become a member of the team, you can contact us through our contact information on the [MetaVoice] (LINK).

### Adding or editing Documentation/Publications/FAQ pages and tabs

If you wish to add or edit one of the tabs on the Documentation, Publication or FAQ page, you can find the corresponding .Rmd file in the [pages](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages) directory. Here, you can edit existing content or add a new tab by following the structure of previous tabs in the particular .Rmd file. 

### Adding or editing other pages

If you wish to add or edit another page, you can do this through the [pages](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages) directory. Find the .Rmd file corresponding to the page you wish to edit, or add a new .Rmd file to add a new page. If which to display the page on the website, you need to either edit the main navigation bar in the [pages/assets/helpers.R](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/pages/assets/helpers.R) file, or link to it on an existing page. 

### Adding or editing shiny apps 

If you wish to add or edit a shiny app, you can find scripts for both published and unpublished shiny apps in the [shinyapps](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/shinyapps) directory. All shiny apps use a common file shinyapps/common/global.R. Furthermore, all apps rely on data loaded and stored in [shinyapps/site_data](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/shinyapps/site_data)

If you would like to edit a shiny app, you can find the server.R and ui.R script in the directory for each shiny app. 

If you would like to create a new app, or publish an app, which is not embedded on the website yet, remember to also edit the [shinyapps.yaml](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/metadata/shinyapps.yaml) metadata file and potentially the [analyses page](https://github.com/LNJ-ND/MetaVoice_Website/blob/master/pages/analyses.Rmd).  

### Adding or editing images

All images used on the website are stored in the [pages/images](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages/images) directory. You can change an image or add a new one in the relevant subdirectory. You can implement the image on the website, using the path in the relevant .yaml file or .Rmd page. 



#### References

Cristia, A., Tsuji, S., & Bergmann, C. (2020). Theory evaluation in the age of cumulative science.

Tsuji, S., Bergmann, C., & Cristia, A. (2014). Community-augmented meta-analyses: Toward
cumulative data assessment. Perspectives on Psychological Science, 9(6), 661-665.
