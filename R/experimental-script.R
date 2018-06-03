################################################################################
#                                                    
# Demographic Research 2018-05-30
# Geofacet example: Premature male mortality (15-49), Mexican states, 1990-2015
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jose Manuel Aburto, jmaburto@health.sdu.dk 
#                                                  
################################################################################


# Package instalation (uncoimment and run the next line -- if needed)
# source("preparation.R")

# load required packages (pre-install if needed)
library(tidyverse)      # data manipulation and viz
library(lubridate)      # easy manipulations with dates
library(viridis)        # the best color palette
library(forcats)        # good for dealing with factors
library(stringr)        # good for dealing with text strings
library(magrittr)       # convinient %<>% operator
library(RColorBrewer)   # colors
library(geofacet)       # the magic -- part 1
library(extrafont)
library(hrbrthemes)
# get Roboto Consensed font -- called later as font_rc
import_roboto_condensed()




# Authors
auth <- "\nIlya Kashnitsky and Jose Manuel Aburto, 2018; replicate: https://github.com/ikashnitsky/demres-2018-geofacet"

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





################################################################################
# Geofaceting with real data
# note that "mx_state_grid1" is part of `geofacet` from v. 0.1.5

# select from ten causes
df_ten <- df %>% 
        group_by(code, year, age) %>% 
        filter(gap == gap %>% max()) %>% 
        ungroup() %>% 
        mutate(causename = causename %>% 
                       str_replace("Amenable to medical service", 
                                   "Amenable to\nmedical service")) 


# create colors
gr <- brewer.pal(9, "Greens")[c(3,5,7,9)]
set <-  brewer.pal(9, "Set1")
colors <- c(set[7], gr[4], gr[3], gr[1], set[1], gr[2], set[9], set[2], set[4])


# geofaceting 10 causes
df_ten %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = causename))+
        facet_geo(~ code, grid = "mx_state_grid1", label = "name", move_axes = T) +
        # facet_wrap(~ code, ncol = 8)+
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                           labels = c(1990, 2000, "'10"))+
        scale_fill_manual("Causes\nof death\n", 
                          values = colors)+
        labs(x = NULL, y = NULL, 
             title = "Gap between observed and best-practice life expectancy for Mexican states",
             subtitle = "Cause of death contributing the most by age (15-49) and time (1990-2015)\n",
             caption = auth)+
        guides(fill = guide_legend(keywidth = 3, keyheight = 2))+
        theme_minimal(base_size = 12, base_family = font_rc)+
        # theme_few(base_size = 12)+
        theme(legend.position = c(1,1),
              panel.border = element_rect(color = 'black',
                                          size=.5, fill = NA),
              panel.spacing = unit(1, "lines"),
              # legend.key = element_rect(size = 7, colour = NULL),
              legend.key.size = unit(2, 'lines'),
              legend.text = element_text(size = 15),
              legend.title = element_text(size = 20),
              legend.justification = c(1, 1),
              strip.text = element_text(face = 2, size = 10),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24))

gg_ten <- last_plot()

ggsave("figures/gg-ten.png", gg_ten, width = 16, height = 12)




################################################################################
# geofaceted stacked bars


df_five <-
        df %>%
        mutate(cause_recode = causename %>% 
                       as_factor() %>% 
                       fct_collapse("Homicide" = "Homicide",
                                    "Other" = "Other",
                                    "Road traffic + Suicide" = c("Road traffic",
                                                            "Suicide"),
                                    "Natural + HIV" = c("Diabetes", 
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

# create labels with the total years lost data
label <- df_five %>% 
        mutate(cause_recode = cause_recode %>% paste()) %>% 
        group_by(cause_recode) %>% 
        summarise(cause_total = gap %>% sum()) %>% 
        ungroup() %>% 
        arrange(cause_total %>%  desc()) %>% 
        mutate(label = paste0(cause_recode, " [",
                             cause_total %>% round(), "]")) %>% 
        pull(label)

levels(df_five$cause) <- label

col5 <- colors[c(5,7,6,1,3)]
mixblue <- colorRampPalette(colors[c(8,9)])
col5[3] <- mixblue(3)[2]



ggplot(df_five) +
        geom_col(aes(year, gap, fill = cause)) +
        coord_cartesian(ylim = c(0, 2), expand = c(0,0))+
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        scale_fill_manual(name = "Causes [Total years lost]\n", values = col5) +
        facet_geo(~ code, grid = "mx_state_grid1", label = "name")+
        labs(x = NULL, y = NULL, 
             title = "Gap between observed and best-practice life expectancy for Mexican states",
             subtitle = "Years of life lost by cause of death across time (1990-2015)",
             caption = auth)+
        theme_few(base_size = 12)+
        theme(legend.position = c(1,1),
              panel.border = element_rect(color = 'black',
                                          size=.5, fill = NA),
              panel.spacing = unit(1, "lines"),
              legend.key = element_rect(size = 7),
              legend.key.size = unit(2, 'lines'),
              legend.text = element_text(size = 15),
              legend.title = element_text(size = 20),
              legend.justification = c(1,1),
              strip.text = element_text(face = 2),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24))


gg_five <- last_plot()

ggsave("gg-five.png", gg_five, width = 16, height = 12)




# tricolor ----------------------------------------------------------------

library(ggtern)         # plot ternary compositions
library(tricolore)      # the magic -- part 2

df_three <-
        df %>%
        mutate(cause_recode = causename %>% 
                       as_factor() %>% 
                       fct_collapse(
                               "Homicide" = "Homicide",
                               "Road traffic + Suicide" = c("Road traffic",
                                                            "Suicide")
                       ) %>% 
                       fct_other(keep = c("Homicide", "Road traffic + Suicide"))
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
        


# calculate TRUE scaling factor for colors, i.e. the factor of proportionality
# from big tern to zoomed tern
mins <- apply(df_tern %>% select(4:6), 2, min)
zommed_side <- (1 - (mins[2] + mins[3])) - mins[1]
true_scale <- 1 / zommed_side

tern <- Tricolore(
        df_tern, p1 = "Homicide", p2 = "Road traffic + Suicide", p3 = "Other",
        center = center, spread = true_scale, show_data = T,
        contrast = .5, lightness = 1, chroma = 1, hue = 10/12
)

tern$legend

df_tern$color <- tern$hexsrgb

df_tern %>% 
        # filter(age==35) %>% 
        ggtern(
                aes(
                        x = Homicide,
                        y = `Road traffic + Suicide`,
                        z = Other,
                        color = color,
                        group = age
                )
        )+
        geom_path()+
        scale_color_identity()+
        facet_wrap(~code)+
        theme(legend.position = "none")


library(viridis)

df_tern %>% 
        # filter(age==35) %>% 
        ggtern(
                aes(
                        x = Homicide,
                        y = `Road traffic + Suicide`,
                        z = Other,
                        color = year,
                        group = age
                )
        )+
        geom_path()+
        scale_color_viridis(option = "B", begin = .1, end = .8, discrete = T)+
        facet_wrap(~code)+
        theme(legend.position = "none")
        





# geofaceting 10 causes
ggplot(df_tern)+
        coord_cartesian(expand = c(0,0))+
        geom_tile(aes(year, age, fill = color))+
        # facet_wrap(~code)+
        geofacet::facet_geo(~ code, grid = "mx_state_grid1", label = "name") +
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        scale_fill_identity()+
        labs(x = NULL, y = NULL, 
             title = "Gap between observed and best-practice life expectancy for Mexican states",
             subtitle = "Colorcoded ternary compositions of the three leading causes of death by age (15-49) and time (1990-2015)",
             caption = auth)+
        theme_minimal(base_size = 12, base_family = font_rc)+
        # theme_few(base_size = 12)+
        theme(legend.position = c(1,1),
              panel.border = element_rect(color = 'black',
                                          size=.5, fill = NA),
              panel.spacing = unit(1, "lines"),
              legend.key = element_rect(size = 7),
              legend.key.size = unit(2, 'lines'),
              legend.text = element_text(size = 15),
              legend.title = element_text(size = 20),
              legend.justification = c(1,1),
              strip.text = element_text(face = 2),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24))

ggsave("gg-tree.png", gg_tree, width = 16, height = 12)

