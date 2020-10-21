################################################################################
## CONSTANTS

pwrmu <- 10
pwrsd <- 5

################################################################################
## HELPER FUNCTIONS

# standard error of the mean
sem <- function(x) {
  sd(x) / sqrt(length(x))
}

# margin of error
ci95.t <- function(x) {
  qt(.975, length(x) - 1) * sem(x)
}

# rounding to three digits
pretty.p <- function(x) {
  as.character(signif(x, digits = 3))
}

shinyServer(function(input, output, session) {
  # conds <- reactive({
  #   groups <- factor(c("Patients","Healthy Controls",
  #                        levels = c("Patients", "Healthy Controls")))
  #   expand.grid(group = groups,
  #               condition = factor(c("Longer looking predicted",
  #                                    "Shorter looking predicted"))) %>%
  #     group_by(group, condition)
  # })
  conds <- reactive({
    groups <- factor(c("Patients","Healthy Controls"),
                         levels = c("Patients", "Healthy Controls"))
    expand.grid(group = groups) %>%
      group_by(group, condition)
  })

  # ########### GENERATE DATA #############
  pwr_sim_data <- reactive({
    if(input$go | input$go){
      conds() %>%
        do(data.frame(
          pitch.variability = ifelse(
            rep(.$group == "Patients", input$N),
            rnorm(n = input$N,
                  mean = pwrmu + (input$d_pwr * pwrsd) / 2,
                  sd = pwrsd),
            rnorm(n = input$N,
                  mean = pwrmu - (input$d_pwr * pwrsd) / 2,
                  sd = pwrsd)
          )

        ))
    }
  })

  pwr_sim_data <- reactive({
    if (input$go | !input$go) {
      conds() %>%
        do(data.frame(
          looking.time = ifelse(
            rep(.$group == "Patients" &
                  .$condition == "Longer looking predicted", input$N),
            rnorm(n = input$N,
                  mean = pwrmu + (input$d_pwr * pwrsd) / 2,
                  sd = pwrsd),
            rnorm(n = input$N,
                  mean = pwrmu - (input$d_pwr * pwrsd) / 2,
                  sd = pwrsd)
          ),
          stringsAsFactors = FALSE
        )
        )
    }
  })

  # ########### MEANS FOR PLOTTING #############
  pwr_ms <- reactive({
    pwr_sim_data() %>%
      group_by(group, condition) %>%
      summarise(mean = mean(looking.time),
                ci = ci95.t(looking.time),
                sem = sem(looking.time)) %>%
      rename_("interval" = input$interval)
  })

  # ########### POWER ANALYSIS - BAR GRAPH #############
  output$pwr_bar <- renderPlot({
    req(input$d_pwr)

    pos <- position_dodge(width = .25)

    ggplot(pwr_ms(), aes(x = group, y = mean, fill = condition,
                         colour = condition)) +
      geom_bar(position = pos,
               stat = "identity",
               width = .25) +
      geom_linerange(data = pwr_ms(),
                     aes(x = group, y = mean,
                         fill = condition,
                         ymin = mean - interval,
                         ymax = mean + interval),
                     position = pos,
                     colour = "black") +
      xlab("Group") +
      ylab("Simulated Looking Time") +
      ylim(c(0,20)) +
      scale_fill_solarized(name = "",
                           labels = setNames(paste(pwr_ms()$condition, "  "),
                                             pwr_ms()$condition)) +
      scale_colour_solarized(name = "",
                             labels = setNames(paste(pwr_ms()$condition, "  "),
                                               pwr_ms()$condition))
  })

  # ########### POWER ANALYSIS - SCATTER PLOT #############
  output$pwr_scatter <- renderPlot({
    req(input$d_pwr)

    pos <- position_jitterdodge(jitter.width = .1,
                                dodge.width = .25)

    ggplot(pwr_sim_data(),
           aes(x = group, y = looking.time, fill = condition,
               colour = condition)) +
      geom_point(position = pos) +
      geom_linerange(data = pwr_ms(),
                     aes(x = group, y = mean,
                         fill = condition,
                         ymin = mean - interval,
                         ymax = mean + interval),
                     position = pos,
                     size = 2,
                     colour = "black") +
      xlab("Group") +
      ylab("Looking Time") +
      ylim(c(0, ceiling(max(pwr_sim_data()$looking.time) / 5) * 5))
  })

  # ########### STATISTICAL TEST OUTPUTS #############
  output$stat <- renderText({

    longer_exp <- filter(pwr_sim_data(),
                         condition == "Longer looking predicted",
                         group == "Patients")$looking.time
    shorter_exp <- filter(pwr_sim_data(),
                          condition == "Shorter looking predicted",
                          group == "Patients")$looking.time
    p.e <- t.test(longer_exp, shorter_exp, paired = TRUE)$p.value

    stat.text <- paste("A t test of the experimental condition is ",
                       ifelse(p.e > .05, "non", ""),
                       "significant at p = ",
                       pretty.p(p.e),
                       ". ",
                       sep = "")

    if (input$control) {

      longer_ctl <- filter(pwr_sim_data(),
                           condition == "Longer looking predicted",
                           group == "Healthy Controls")$looking.time
      shorter_ctl <- filter(pwr_sim_data(),
                            condition == "Shorter looking predicted",
                            group == "Healthy Controls")$looking.time
      p.c <- t.test(longer_ctl, shorter_ctl, paired = TRUE)$p.value

      a <- anova(lm(looking.time ~ group * condition, data = pwr_sim_data()))

      return(paste(stat.text,
                   "A t test of the control condition is ",
                   ifelse(p.c > .05, "non", ""),
                   "significant at p = ",
                   pretty.p(p.c),
                   ". An ANOVA ",
                   ifelse(a$"Pr(>F)"[3] < .05,
                          "shows a", "does not show a"),
                   " significant interaction at p = ",
                   pretty.p(a$"Pr(>F)"[3]),
                   ".",
                   sep = ""))
    }

    return(stat.text)
  })
})
