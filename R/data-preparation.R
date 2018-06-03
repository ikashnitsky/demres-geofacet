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
gr <- brewer.pal(9, "Greens")[c(3,5,7,9)]
set <-  brewer.pal(9, "Set1")
col9 <- c(set[7], gr[4], gr[3], gr[1], set[1], gr[2], set[9], set[2], set[4])

# create colors for gg-five
col5 <- col9[c(5,7,6,3,1)]
mixblue <- colorRampPalette(col9[c(8,9)])
col5[3] <- mixblue(3)[2]




# the main dataset --------------------------------------------------------


# to read in the R data.frame
df <- local(get(load("data/MexicoMalesMiddleAge.Rdata")))
names(df)  %<>%  tolower()


# fix names
df %<>% mutate(name = statename %>% 
                       str_replace("á", "a") %>% 
                       str_replace("í", "i") %>%
                       str_replace("é", "e") %>%
                       str_replace("ó", "o")) 



# load proper codes
load("data/codes.RData")


# fix names
codes %<>% mutate(name = name %>% 
                          str_replace("á", "a") %>% 
                          str_replace("í", "i") %>%
                          str_replace("é", "e") %>%
                          str_replace("ó", "o")) 


# attach codes
df %<>% select(-state, -statename, -sex, -cause) %>% 
        left_join(codes, "name")




# dataset with 5 causes -- for stacked bar plot ---------------------------

df_five <-
        df %>%
        mutate(cause_recode = causename %>% 
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
        group_by(code, year, age, cause_recode) %>%
        summarize(gap = gap %>% sum()) %>% 
        ungroup() %>% 
        group_by(cause_recode) %>%
        mutate(cause_gap = gap %>% sum()) %>% 
        ungroup() %>% 
        mutate(cause = cause_recode %>% 
                       fct_reorder(cause_gap) %>% 
                       fct_rev())


# save evetyrhing for gg-five
save(df_five, col5, title, sub_gg_five, file = "data/for-gg-five.RData")


# a dataset with 9 causes ------------------------------------------------

# select from ten causes
df_nine <- df %>% 
        group_by(code, year, age) %>% 
        filter(gap == gap %>% max()) %>% 
        ungroup() %>% 
        mutate(causename = causename %>% 
                       str_replace("Amenable to medical service", 
                                   "Amenable to\nmedical service")) 



# save evetyrhing for gg-ten
save(df_nine, col9, title, sub_gg_nine, file = "data/for-gg-nine.RData")





# ternary composition dataset ---------------------------------------------

library(tricolore)
library(ggtern)

df_three <-
        df %>%
        mutate(cause_recode = causename %>% 
                       as_factor() %>% 
                       fct_collapse(
                               "hom" = "Homicide",
                               "sui" = c("Road traffic",
                                                            "Suicide")
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


df_tern$color <- tern$hexsrgb



# produce ternary legend --------------------------------------------------

tern_legend <- tern$legend+
        geom_point(data = df_tern_sum, aes(hom, sui, z = oth), 
                   shape = 46, color = "grey20", size = 3)+
        geom_point(data = tibble(hom = center[1], sui = center[2], oth = center[3]), 
                   aes(hom, sui, z = oth), 
                   shape = 43, color = "white", size = 5)+
        scale_L_continuous("Homicide") +
        scale_T_continuous("Road traffic\n and Suicide") +
        scale_R_continuous("Other") +
        Larrowlab("% Homicide") +
        Tarrowlab("% Road traffic and Suicide") +
        Rarrowlab("% Other") +
        theme_classic() +
        theme(plot.background = element_rect(fill = NA, colour = NA),
              tern.axis.arrow.show = TRUE, 
              tern.axis.ticks.length.major = unit(12, "pt"),
              tern.axis.text = element_text(size = 12, colour = "grey20"),
              tern.axis.title.T = element_text(),
              tern.axis.title.L = element_text(hjust = 0.2, vjust = 0.7, angle = -60),
              tern.axis.title.R = element_text(hjust = 0.8, vjust = 0.6, angle = 60),
              text = element_text(family = font_rc, size = 14, color = "grey20"))+
        labs(x = NULL, y = NULL)


# save evetyrhing for gg-three
save(df_tern, tern_legend, title, sub_gg_tern, file = "data/for-gg-tern.RData")
