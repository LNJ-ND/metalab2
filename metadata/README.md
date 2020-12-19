# Metadata

Each .yaml file lists available resources along with their metadata.

### datasets.yaml
This file contains information, which is used for both pages and shinyapps throughout the website about each dataset (meta-analysis) in the accumulated database. More specifically it contains the following information:
- name
- domain/disorder: e.g. Schizophrenia, Autism_Spectrum_Disorder
- short_name: i.e. domain_disorder_firstauthor_year
- key: key of google sheets document, on which the data is stored
- filename: name the dataset should have when saved to shinyapps/site_data
- citation: in-text citation in APA format
- internal_citation: in-text citation in APA format in “( )”
- link: link to the publication 
- full_citation: full citation in APA format
- doi
- systematic: yes/no 
- search strategy: citation of original publication describing the search strategy applied in the given meta-analysis, displayed on the dataset page
- reliability: currently not implemented, but possible to activate
- source: currently not implemented, but possible to activate
- last_update: date of last change of dataset in the format YYYY-MM-DD 
- short_desc: short description of the dataset
- description: more elaborate description of the dataset. Currently not implemented, but possible to activate
- curator: initials of responsible curators
- longitudinal: whether the study was longitudinal (important in shinyapps)
- moderators: possible moderator options for analysis in shinyapps
- voice_features: list of voice features included in the dataset
- subset: possible options to subset the data in the shinyapps; currently not implemented, but possible to activate
- comment: optional comment 

### documetation.yaml
This file contains the structure of the documentation page, i.e. which tabs it contains (do we need this?)

### domains.yaml
This file contains information about the possible domains: 
- id: id to refer to the domain throughout scripts for the website, corresponds to to domain in datasets.yaml
- title: name to display on the website and shiny apps
- image: image stored in pages/images, e.g. displayed on the index page, currently not implemented
- desc: short descriptions, e.g. displayed on the index page

### people.yaml
This file contains information about the members of the team to display on the [About page](https://metavoice.au.dk/about.html). More specific information includes:
- name: name of the member
- email
- website: e.g. github, own website
- affiliation
- image: refers to image stored in [pages/images/people](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages/images/people)

### reports.yaml
This file could be used to refer to reports displayed on the website. It is currently not used. 

### shinyapps.yaml
This file contains information about the published shiny apps on the website. Information includes:
- id: id to refer to throughout the website
- title: title of the shiny app displayed on the website 
- image: image stored in [pages/images/apps](https://github.com/LNJ-ND/MetaVoice_Website/tree/master/pages/images/apps), e.g. to display on the Index and Analyses page,
- url: link to shiny app (currently hosted through shinyapps.io) 

### spec.yaml
This file contains information about the required and optional columns in datasets included in the database. Information corresponds to the [MetaVoice dataset template](https://docs.google.com/spreadsheets/d/1RGemYuBDHG-xWClwralPGeMkqwknW7i4fHqKE-vnvfI/edit?usp=sharing). This information is also displayed on the [Documentation page](https://metavoice.au.dk/documentation.html) on the Website. Information includes: 
- field: column name 
- description: description of the content of the column
- type: e.g. numeric
- format: format of information in the column
- example: example format 
- required: yes/no depending on whether it is required or optional

### spec_derived.yaml
This file contains information about the columns added, when datasets are downloaded, based on information included in columns included in spec.yaml. More specifically it contains: 
- field: name of the column in the dataset, e.g. d_calc
- description: description of the field, e.g. Cohen’s d
