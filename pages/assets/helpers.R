# server address should be defined here if shiny apps are moved to a server
# serverAddress <- "http://52.24.141.166:3838/"

menuNavbar <- function(relativePath="", isIndex=FALSE) {
  fluidRow(
    column(id = "maxim-width",
      width = 12,
      tags$ul(id = "navb",
        tags$li(class = "navb-header", a(href = paste0(relativePath, "index.html"), "MetaVoice")),
        if (!isIndex) {tags$li(a("Home", href = paste0(relativePath, "index.html")))},
        tags$li(a("Analyses", href = paste0(relativePath, "analyses.html"))),
        tags$li(a("Documentation", href = paste0(relativePath, "documentation.html"))),
        tags$li(a("Publications", href = paste0(relativePath, "publications.html"))),
        tags$li(a("FAQ", href = paste0(relativePath, "faq.html"))),
        tags$li(a("About", href = paste0(relativePath, "about.html")))
        )
      )
    )
}

iconWrap <- function(x) {
  shiny::tags$i(class = paste0("fa fa-", x))
}

valueBoxes <- function(values, descriptions=c("Meta-analyses", "Papers", "Effect sizes", "Participants"), icons=c("cubes", "file-text-o", "list", "users")) {
  fluidRow(class = "value-box",
    map(1:4,
      ~ shinydashboard::valueBox(
        format(values[.], big.mark = ","),
        descriptions[.],
        width = 3,
        color = "light-blue",
        icon = iconWrap(icons[.]))
      )
    )
  }

includeRmd <- function(path, shiny_data = NULL) {
  output_file <-
    rmarkdown::render(path,
                      quiet = TRUE,
                      output_dir =
                        dirname(gsub("pages", "rendered", path)))
  htmltools::includeHTML(output_file)
}

metricsCounter <- function(database) {
 c(nrow(database),
   sum(select(database, num_papers), na.rm = TRUE),
   sum(select(database, num_effectsize), na.rm = TRUE),
   (sum(select(database, num_subjects), na.rm = TRUE) - database$num_n2[database$short_name == "voice_lhd_weed_2020"])
   ) %>% as.integer()
}

responsiveIFrame <- function() {
  iFrameAttribute <- "var navb_h = $('#navb').height() + 5
    $('.parent-cont').css('top', navb_h)"

  tagList(
    tags$script(paste0("$(document).ready(function() {",
                       iFrameAttribute,
                       "});")),
    tags$script(paste0("$(window).on('resize', function () {",
                       iFrameAttribute,
                       "});"))
    )
}

fullWidthPanelBox <- function(header, content) {
  fluidRow(
    column(width = 2),
    column(width = 8,
           fluidRow(class = "panel panel-primary",
                    div(class = "panel-heading", h3(class = "panel-title", header)),
                    div(class = "panel-body", content)
           )
    ),
    column(width = 2)
  )
}
