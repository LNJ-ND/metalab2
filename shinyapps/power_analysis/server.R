shinyServer(function(input, output, session) {

  #############################################################################
  # DOWNLOAD HANDLERS

  # plot_download_handler <- function(plot_name, plot_fun) {
  #   downloadHandler(
  #     filename = function() {
  #       sprintf("%s [%s].pdf", input$dataset_name, plot_name)
  #     },
  #     content = function(file) {
  #       cairo_pdf(file, width = 10, height = 7)
  #       print(plot_fun())
  #       dev.off()
  #     }
  #   )
  # }
  #
  # output$download_power <- plot_download_handler("power", power)

  ########## DATA ##########

  # subset of data used for calculation based on user input
  pwrdata <- reactive({
    req(input$dataset_name_pwr)
    req(input$feature_option)
    result <- metavoice_data %>%
      filter(dataset == input$dataset_name_pwr) %>%
      filter(feature == input$feature_option)
  })

  # names of datasets included in database to for input
  dataset_names <- reactive({
    req(input$domain)
    dataset_info %>%
      filter(domain == input$domain) %>%
      pull(name)
  })

  # possible features in chosen dataset
  feature_options <- reactive({
    req(input$dataset_name_pwr)
    dataset_info %>%
      filter(name == input$dataset_name_pwr) %>%
      .$voice_features %>%
      unlist()

  })

  ########### PWR MODEL ###########

  # power model if no moderator is chosen, without random effects
  # pwr_no_mod_model <- reactive({
  #   metafor::rma(yi = d_calc, vi = d_var_calc, slab = as.character(expt_unique),
  #                method = "REML",
  #                data = pwrdata())
  # })

  # power model if no moderator is chosen, with random effects
  pwr_no_mod_model <- reactive({
    metafor::rma.mv(yi = d_calc, V = d_var_calc,
                    random = ~ 1 | same_sample / short_cite / unique_row,
                    slab = expt_unique,
                    data = pwrdata(),
                    method = "REML")
  })


  # power model if moderator is chosen, without random effects
  # pwrmodel <- reactive({
  #   if (length(input$pwr_moderators) == 0) {
  #     pwr_no_mod_model()
  #   } else {
  #     mods <- paste(input$pwr_moderators, collapse = "+")
  #     metafor::rma(as.formula(paste("d_calc ~", mods)), vi = d_var_calc,
  #                  slab = as.character(expt_unique), data = pwrdata(),
  #                  method = "REML")
  #   }
  # })

  # power model if moderator is chosen, with random effects
  pwrmodel <- reactive({
    if (length(input$pwr_moderators) == 0) {
      pwr_no_mod_model()
    } else {
      mods <- paste(input$pwr_moderators, collapse = "+")
      metafor::rma.mv(as.formula(paste("d_calc ~", mods)), V = d_var_calc,
                      random = ~ 1 | same_sample / short_cite / unique_row,
                      slab = expt_unique,
                      data = pwrdata(),
                      method = "REML")
    }
  })


  ########### RENDER UI FOR MODERATOR CHOICES #############

  # UI output of moderator options
  ## if an additional moderator is added, this moderator needs to be added in possible_mods
  output$pwr_moderator_input <- renderUI({
    req(input$dataset_name_pwr)
    possible_mods <- list("Task type" = "task_type",
                          "Native language" = "native_language",
                          "Prosody type" = "prosody_type",
                          "Mean age (years)" = "mean_age",
                          "Diagnosis specification" = "diagnosis_specification")
    custom_mods <- dataset_info %>%
      filter(name == input$dataset_name_pwr) %>%
      .$moderators %>%
      unlist()
    print(custom_mods)
    mod_choices <- keep(possible_mods, ~ any(custom_mods %in% .x))
    valid_mod_choices <- mod_choices %>%
      set_names(display_name(.)) %>%
      keep(~length(unique(pwrdata()[[.x]])) > 1)

    checkboxGroupInput("pwr_moderators", label = "Moderators",
                       valid_mod_choices,
                       inline = FALSE)
  })

  # UI output of moderator choices based on moderator input
  ## if an additional moderator is added, this moderator needs to be added here
  output$pwr_moderator_choices <- renderUI({
    uis <- list()

    if (any(input$pwr_moderators == "mean_age")) {
      uis <- c(uis, list(
        sliderInput("pwr_age_months",
                    "Age of participants (years)",
                    min = 0, max = ceiling(max(pwrdata()$mean_age)),
                    value = round(mean(pwrdata()$mean_age)),
                    step = 1)
      ))
    }

    if (any(input$pwr_moderators == "task_type")) {
      uis <- c(uis, list(
        selectInput("pwr_task_type",
                    "Task type",
                    choices = unique(pwrdata()$task_type))
      ))
    }

    if (any(input$pwr_moderators == "native_language")) {
      uis <- c(uis, list(
        selectInput("pwr_native_language",
                    "Native language",
                    choices = unique(pwrdata()$native_language))
      ))
    }

    if (any(input$pwr_moderators == "prosody_type")) {
      uis <- c(uis, list(
        selectInput("pwr_prosody_type",
                    "Prosody type",
                    choices = unique(pwrdata()$prosody_type))
      ))
    }

    if (any(input$pwr_moderators == "diagnosis_specification")) {
      uis <- c(uis, list(
        selectInput("pwr_diagnosis_specification",
                    "Diagnosis specification",
                    choices = unique(pwrdata()$diagnosis_specification))
      ))
    }

    return(uis)
  })

  ########### POWER COMPUTATIONS #############

  ## this is awful because RMA makes factors and dummy-codes them, so newpred needs to have this structure
  ### if an additional moderator is added, this moderator needs to be added here
  d_pwr <- reactive({
    if (length(input$pwr_moderators > 0)) {
      newpred_mat <- matrix(nrow = 0, ncol = 0)

      if (any(input$pwr_moderators == "mean_age")) {
        req(input$pwr_age_months)
        newpred_mat <- c(newpred_mat, input$pwr_age_months)
      }

      if (any(input$pwr_moderators == "task_type")) {
        req(input$pwr_task_type)

        f_task_type <- factor(pwrdata()$task_type)
        n <- length(levels(f_task_type))

        task_type_pred <- rep(0, n)
        pred_seq <- seq(1:n)[levels(f_task_type) == input$pwr_task_type]
        task_type_pred[pred_seq] <- 1

        # remove intercept
        task_type_pred <- task_type_pred[-1]

        newpred_mat <- c(newpred_mat, task_type_pred)
      }

      if (any(input$pwr_moderators == "native_language")) {
        req(input$pwr_native_language)

        f_native_language <- factor(pwrdata()$native_language)
        n <- length(levels(f_native_language))

        native_language_pred <- rep(0, n)
        native_language_pred[seq(1:n)[levels(f_native_language) == input$pwr_native_language]] <- 1

        # remove intercept
        native_language_pred <- native_language_pred[-1]

        newpred_mat <- c(newpred_mat, native_language_pred)
      }

      if (any(input$pwr_moderators == "prosody_type")) {
        req(input$pwr_prosody_type)

        f_prosody_type <- factor(pwrdata()$prosody_type)
        n <- length(levels(f_prosody_type))

        prosody_type_pred <- rep(0, n)
        prosody_type_pred[seq(1:n)[levels(f_prosody_type) == input$pwr_prosody_type]] <- 1

        # remove intercept
        prosody_type_pred <- prosody_type_pred[-1]

        newpred_mat <- c(newpred_mat, prosody_type_pred)
      }

      if (any(input$pwr_moderators == "diagnosis_specification")) {
        req(input$pwr_diagnosis_specification)

        f_diagnosis_specification <- factor(pwrdata()$diagnosis_specification)
        n <- length(levels(f_diagnosis_specification))

        diagnosis_specification_pred <- rep(0, n)
        diagnosis_specification_pred[seq(1:n)[levels(f_diagnosis_specification) == input$pwr_diagnosis_specification]] <- 1

        # remove intercept
        diagnosis_specification_pred <- diagnosis_specification_pred[-1]

        newpred_mat <- c(newpred_mat, diagnosis_specification_pred)
      }

      predict(pwrmodel(), newmods = newpred_mat)$pred

    } else {
      # special case when there are no predictors, predict doesn't work
      pwrmodel()$b[,1][["intrcpt"]]
    }
  })

  # calculate n per group for 80% power
  pwr_80 <- reactive({
    pwr::pwr.t.test(d = d_pwr(), sig.level = 0.05, power = .8)$n

  })

  ############ POWER CURVE ##############

  # plot output of power curve
  output$power <- renderPlot({

    ## maximum n is n at 90 power, but min 60 and max 200
    max_n <- min(max(60, pwr::pwr.t.test(d = d_pwr(), sig.level = .05, power = .9)$n), 200)

    ## power calculations in intervals
    pwrs <- data.frame(ns = seq(5, max_n, 5),
                       ps = pwr::pwr.t.test(d = d_pwr(), n = seq(5, max_n, 5), sig.level = .05)$power,
                       stringsAsFactors = FALSE)

    qplot(ns, ps, geom = c("point","line"),
          data = pwrs) +
      geom_hline(yintercept = .8, lty = 2) +
      geom_vline(xintercept = pwr_80(), lty = 3) +
      ylim(c(0,1)) +
      xlim(c(0,max_n)) +
      ylab("Power to reject the null hypothesis at p < .05") +
      xlab("Number of participants per group (patient, control)")
  })

  ############# UI ELEMENTS ###############

  # function to display names with capital first letter
  display_name <- function(fields) {
    sp <- gsub("_", " ", fields)
    paste0(toupper(substring(sp, 1, 1)), substring(sp, 2))
  }

  # UI ouput to select domain
  output$domain_selector <- renderUI({
    selectInput(inputId = "domain",
                label = "Domain",
                choices = dataset_info$domain %>%
                  unique %>%
                  set_names(display_name(.))
    )
  })

  # UI output to select dataset
  output$dataset_name <- renderUI({
    selectInput(inputId = "dataset_name_pwr",
                label = "Dataset",
                choices = dataset_names()
    )
  })

  # UI output to select feature
  output$feature_selector <- renderUI({
    selectInput(inputId = "feature_option",
                label = "Voice Feature",
                choices = feature_options() %>%
                  set_names(display_name(.))
    )
  })

  # UI output for help texts of features, texts can be found in shinyapps/common/global.R
  output$feature_help_text <- renderUI({
    req(input$feature_option)
    HTML(paste0("<i class=\"text-muted\">", feature_help_texts[input$feature_option], "</i>"))
  })

  # text output for citation of data set
  output$data_citation <- renderText({
    req(input$dataset_name_pwr)
    full_citation <- dataset_info %>%
      filter(name == input$dataset_name_pwr) %>%
      select(full_citation)
    paste(full_citation)})

  ## text output for model blurb
  output$ma_model_blurb <- renderUI({
    HTML(paste0("Effect Size (Cohen's d) is calculated using a random effects model, assuming studies within a paper share variance. For details, see
                <a href='https://metalab.stanford.edu/documentation.html#statistical_approach' target='_blank'>
                Statistical Approach</a>. Power is computet for a two-sample t-test, based on the computed effect size and significance level of 0.05."))
  })

  # text output for link to dataset
  output$link_to_dataset <- renderUI({
    req(input$dataset_name_pwr)
    base_url <- "https://langcog.github.io/metalab2/dataset/" # change to our website
    short_name <- dataset_info %>%
      filter(name == input$dataset_name_pwr) %>%
      select(short_name)
    HTML(paste0("<i class=\"text-muted\">For more information see
                <a href='https://langcog.github.io/metalab2/documentation.html#dataset_info' target='_blank'>
                Documentation</a> or <a href='", base_url, short_name, ".html', target='_blank'>
                View raw dataset</a>. Please cite the dataset_info that you use following <a href='https://langcog.github.io/metalab2/publications.html' target='_blank'> our citation policy.</a> </a></i>"))
  })

  # UI POWER BOXES
  ## effect size (Cohen's d)
  output$power_d <- renderValueBox({
    valueBox(
      round(d_pwr(), digits = 2), "Effect Size (Cohen's d)",
      icon = icon("record", lib = "glyphicon"),
      color = "light-blue"
    )
  })

  ## number of participants per group
  output$power_n <- renderValueBox({
    valueBox(
      if(pwr_80() < 200) {round(pwr_80(), digits = 2) } else { "> 200"}, "N per group for 80% power",
      icon = icon("users", lib = "glyphicon"),
      color = "light-blue"
    )
  })

  ## n of experiments included in analysis
  output$power_s <- renderValueBox({
    valueBox(
      nrow(pwrdata()), "Experiments",
      icon = icon("list", lib = "glyphicon"),
      color = "light-blue"
    )
    })

  # conditional text if there are < 3 studies
  output$fewstudies <- renderText({"There are less than 3 studies, which have investigated this feature. Please choose a different feature."})
  output$contribute <- renderText({"If you would like to contribute with a study, see CONTRIBUTELINK"})

  # conditional output: if there are < 3 studies display text, otherwise boxes and power curve
  output$conditional_results <- renderUI({

    ### if there > 2 studies
    if (nrow(pwrdata()) > 2){
      list(fluidRow(valueBoxOutput("power_d", width = 4),
                    valueBoxOutput("power_n", width = 4),
                    valueBoxOutput("power_s", width = 4)),
           box(width = NULL, #status = "danger",
               fluidRow(
                 column(width = 12,
                        p(strong("Power plot"), "of N necessary to achieve p < .05"),
                        plotOutput("power"),
                        br(),
                        p("Statistical power to detect a difference between groups at p < .05. Dashed line shows 80% power, dotted lineshows necessary sample size in each group to achieve that level of power.")
                 ))))}

    ### if there are < 3 studies
    else {
      box(width = NULL, fluidRow(column(width = 12, textOutput("fewstudies"), br(), textOutput("contribute"))))
    }
  })

  })
