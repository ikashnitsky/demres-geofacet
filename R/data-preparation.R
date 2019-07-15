################################################################################
#                                                    
# Demographic Research 2018-06-02
# Geofacet example: Premature male mortality (15-49), Mexican states, 1990-2015
# All data preparation
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jose Manuel Aburto, jmaburto@health.sdu.dk 
#                                                  
################################################################################

source("R/session-preparation.R")

# text objects ------------------------------------------------------------

# authors
auth <- "\nIlya Kashnitsky and Jose Manuel Aburto, 2018; replicate: https://github.com/ikashnitsky/demres-2018-geofacet"

# title
title <- "Gap between observed and best-practice temporary life expectancy for Mexican males (15-49)"

# subtitles
sub_gg_five <- "Years of life lost by cause of death across time (1990-2015)\n"
sub_gg_nine <- "Cause of death contributing the most by age (15-49) and time (1990-2015)\n"
sub_gg_tern <- "Colorcoded ternary compositions of the three leading causes of death by age (15-49) and time (1990-2015)\n"



# colors ------------------------------------------------------------------

# create colors for gg-nine
bl <- blues9[c(3,5,7,9)]
set <-  brewer.pal(9, "Set1")
col9 <- c(set[7], bl[4], bl[3], bl[1], bl[2], set[9], set[6], set[5], "magenta")

# create colors for gg-five
col5 <- col9[c(9,6,1,1,1)]
mix_orange <- colorRampPalette(col9[c(7,8)])
col5[3] <- mix_orange(3)[2]
col5[4] <- blues9[6]




# the main dataset --------------------------------------------------------


# to read in the R data.frame
df <- local(get(load("data/MexicoMalesMiddleAge.Rdata"))) %>% 
        clean_names() %>% 
        transmute(
                code = state %>% as.numeric(),
                year, age, cause_name, gap
        )




# dataset with 5 causes -- for stacked bar plot ---------------------------

df_five <-
        df %>%
        mutate(cause_recode = cause_name %>% 
                       as_factor() %>% 
                       fct_collapse("Homicide" = "Homicide",
                                    "Other" = "Other",
                                    "Road traffic + Suicide" = c("Road traffic",
                                                                 "Suicide"),
                                    "Amenable to\nhealth behaviour" = c("Diabetes", 
                                                        "IHD",
                                                        "Cirrhosis",
                                                        "Lung cancer",
                                                        "HIV"),
                                    "Amenable to\nmedical service" = 
                                            "Amenable to medical service")
        ) %>%
        group_by(code, year, cause_recode) %>%
        summarize(gap = gap %>% sum()) %>% 
        ungroup() %>% 
        group_by(cause_recode) %>%
        mutate(cause_gap = gap %>% sum()) %>% 
        ungroup() %>% 
        mutate(cause = cause_recode %>% 
                       fct_reorder(cause_gap) %>% 
                       fct_rev())


# save evetyrhing for gg-five
save(df_five, col5, title, sub_gg_five, auth, file = "data/for-gg-five.RData")


# a dataset with 9 causes ------------------------------------------------

# select from ten causes
df_nine <- df %>% 
        group_by(code, year, age) %>% 
        filter(gap == gap %>% max()) %>% 
        ungroup() %>% 
        mutate(
                cause_name = cause_name %>% 
                        str_replace("Amenable to medical service", 
                                    "Amenable to\nmedical service") %>% 
                        str_replace("IHD", "Ischaemic Heart\nDisease") %>% 
                        str_replace("HIV", "Human\nImmunodeficiency\nVirus") %>% 
                        factor() %>% 
                        # move homicides to the end of factor
                        fct_relevel("Homicide", after = Inf)
        ) %>% 
        mutate(hex = cause_name %>% lvls_revalue(col9))



# save evetyrhing for gg-ten
save(df_nine, col9, title, sub_gg_nine, auth, file = "data/for-gg-nine.RData")





# ternary composition dataset ---------------------------------------------

rstudioapi::restartSession()
p_unload(p_loaded(), character.only = T)
library(tidyverse)
library(gridExtra)
library(ggtern)
library(tricolore)
library(hrbrthemes)
import_roboto_condensed()

df_three <-
        df %>%
        mutate(cause_recode = cause_name %>% 
                       as_factor() %>% 
                       fct_collapse(
                               "hom" = "Homicide",
                               "sui" = c("Road traffic", "Suicide")
                       ) %>% 
                       fct_other(keep = c("hom", "sui"), other_level = "oth")
        ) %>%
        group_by(code, year, age, cause_recode) %>%
        summarize(gap = gap %>% sum()) %>% 
        ungroup() %>% 
        group_by(cause_recode) %>%
        mutate(cause_gap = gap %>% sum()) %>% 
        ungroup() %>% 
        mutate(cause = cause_recode %>% 
                       fct_reorder(cause_gap) %>% 
                       fct_rev())

df_tern <- df_three %>% 
        select(code, year, age, cause, gap) %>% 
        spread(cause, gap) 

# Whole data mean
center <- df_three %>% 
        select(cause, gap) %>% 
        group_by(cause) %>% 
        summarise(avg = mean(gap)) %>%
        ungroup() %>% 
        mutate(avg = avg / sum(avg),
               cause = cause %>% fct_shift(n = 1)) %>% 
        arrange(cause) %>% 
        pull(avg)


# sum gap over ages
df_tern_sum <- df_tern %>% 
        select(-age) %>% 
        group_by(code, year) %>% 
        summarise_all(.funs = funs(sum)) %>% 
        ungroup()



# calculate TRUE scaling factor for colors, i.e. the factor of proportionality
# from big tern to zoomed tern
mins <- apply(df_tern_sum %>% select(3:5), 2, min)
zommed_side <- (1 - (mins[2] + mins[3])) - mins[1]
true_spread <- 1 / zommed_side

tern <- Tricolore(
        df_tern, p1 = "hom", p2 = "sui", p3 = "oth",
        center = center, spread = true_spread, show_data = F,
        contrast = .5, lightness = 1, chroma = 1, hue = 10/12
)

df_tern$color <- tern$rgb



# produce ternary legend --------------------------------------------------

tern_legend <- tern$key+
        geom_point(data = df_tern_sum, aes(hom, sui, z = oth), 
                   shape = 46, color = "grey20", size = 3)+
        geom_point(data = tibble(hom = center[1], sui = center[2], oth = center[3]), 
                   aes(hom, sui, z = oth), 
                   shape = 43, color = "white", size = 5)+
        scale_L_continuous("Homicide") +
        scale_T_continuous("Road traffic and Suicide") +
        scale_R_continuous("Other") +
        theme_classic() +
        theme(plot.background = element_rect(fill = NA, colour = NA),
              tern.axis.arrow.show = FALSE, 
              tern.axis.ticks.length.major = unit(12, "pt"),
              tern.axis.text = element_text(size = 12, colour = "grey20"),
              tern.axis.title.T = element_text(hjust = -.1, vjust = -2, angle = -60),
              tern.axis.title.L = element_text(hjust = -1, vjust = -2.5, angle = 60),
              tern.axis.title.R = element_text(hjust = 1.5, vjust = 3),
              text = element_text(family = font_rc, face = 2, size = 14, color = "grey20"))+
        labs(x = NULL, y = NULL)

ggsave(plot = tern_legend, "figures/ink-fig-4/gg-tern-legend.pdf",  
       width =  4.5, height = 3.8, device = cairo_pdf)



# save evetyrhing for gg-three
save(df_tern, tern_legend, title, sub_gg_tern, auth, file = "data/for-gg-tern.RData")
