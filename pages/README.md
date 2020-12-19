# Pages

Each .Rmd file defines the structure of the corresponding page.

### assets
Directory containing additional scripts which are sourced throughout the pages, containing e.g. functions (helpers.R), or styling specifications (custom.css), and libraries (setup.Rmd).

### images
Directory of images used throughout the pages, when specified through metadata files.

### output.yaml 
Specifies which files of the assets directory should be used for styling in the rendering of the .Rmd files into html. 

### about.Rmd 
Defines the structure of the [About](http://metavoice.au.dk/about.html) page on the website, containing information about the MetaVoice team.

### analyses.Rmd
Defines the structure of the [Analyses](http://metavoice.au.dk/analyses.html) page on the website. It displays shiny apps automatically based on the corresponding metadata file. 

### app.Rmd
Template used for each shiny app. This template embeds each shiny app by using its url (specified in metadata).

### dataset-template.Rmd
Defines the structure of the template for displaying datasets on the website which are available through the [Documentation](http://metavoice.au.dk/documentation.html) page, e.g. [here](http://metavoice.au.dk/dataset/voice_scz_parola_2020.html).

### documentation.Rmd
Defines the structure of the [Documentation](http://metavoice.au.dk/documentation.html) page, containing tabs related to Datasets, Contributing to MetaVoice, Statistical Approach, Field Specifications, Export Data and Tutorials.

### domain-template.Rmd
Defines the structure of the template for displaying the datasets of single domains, which are available through the [Index/Home](http://metavoice.au.dk) page, e.g. on the [Voice Analysis Domain](http://metavoice.au.dk/domain/Voice_Analysis.html) page.

### faq.Rmd
Defines the structure of the [FAQ](http://metavoice.au.dk/faq.html) page, which answers common questions in relation to the website. 

### footer.html
Defines the content of the footer on the website, i.e. license. 

### index.Rmd
Defines the structure of the [Index/Home](http://metavoice.au.dk) page of the MetaVoice website. 

### publications.Rmd 
Defines the structure of the [Publications](http://metavoice.au.dk/publications.html) page of the MetaVoice website, containing information about citation policy and publications related to MetaVoice. 

### report.Rmd
Currently not used on the website. This page could be added if dynamic reports are added to the MetaVoice Website.

