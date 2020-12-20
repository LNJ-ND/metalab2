shinyUI(dashboardPage(
  dashboardHeader(disable = TRUE),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
  includeCSS("../common/www/custom.css"),
  tags$style(type = "text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"),
  fluidRow(
    column(
      width = 5,
      box(width = NULL, #status = "danger",
          solidHeader = TRUE,
          title = strong("Power Analysis for Experiment Planning"),
          p("Select a meta-analysis (dataset), voice featue and a set of moderators to see statistical
             power estimates using the estimated effect size (Cohen's d)."),
          uiOutput("domain_selector"),
          bsPopover("domain_selector", title = NULL,
                    content = HTML("<small>Select a domain<small>"),
                    placement = "right"),
          uiOutput("dataset_name"),
          bsPopover("dataset_name", title = NULL,
                    content = HTML("<small>Select a disorder/meta-analysis<small>"),
                    placement = "right"),
          uiOutput("feature_selector"),
          bsPopover("feature_selector", title = NULL,
                    content = HTML("<small>Select a feature</small>"),
                    placement = "right"),
          uiOutput("feature_help_text"),
          br(),
          fluidRow(
            column(
              width = 6,
              uiOutput("pwr_moderator_input"),
              bsPopover("pwr_moderator_input", title = NULL,
                        content = HTML("<small>Explore the impact of continuous and categorical moderator variables</small>"),
                        placement = "right")
            ),
            column(
              width = 6,
              uiOutput("pwr_moderator_choices"),
              bsPopover("pwr_moderator_choices", title = NULL,
                        content = HTML("<small>Choose a value of the chosen moderator</small>"),
                        placement = "right")
            )
          ),
          br(),
          uiOutput("link_to_dataset"),
          br(),
          strong("Dataset Citation:", style="display:inline"), textOutput("data_citation"),
          br(),
          strong("Statistical Model:", style="display:inline"), uiOutput("ma_model_blurb"),
          br()
        )),
    column(width = 7,
      uiOutput("conditional_results")
    )))))
