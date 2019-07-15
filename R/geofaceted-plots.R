################################################################################
#                                                    
# Demographic Research 2018-05-30
# Geofacet example: Premature male mortality (15-49), Mexican states, 1990-2015
# Produce the plots
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jose Manuel Aburto, jmaburto@health.sdu.dk 
#                                                  
################################################################################


# in order to use geofacet smoothly, we need to unload ggtern
# these tho ggplot addons conflict
library(pacman)
p_unload(ggtern, tricolore)

library(geofacet)



# prepare custom grid based on mx_state_grid3 -----------------------------

load("data/mx_state_grid3_update.rda")

mygrid <- mx3upd %>% 
        transmute(
                row, col, 
                code,
                name
        )

# stacked bar plot --------------------------------------------------------

# load the files for gg-five
load("data/for-gg-five.RData")


gg_five <- df_five %>% 
        ggplot() +
        geom_col(aes(year, gap, fill = cause), width = 1) +
        coord_cartesian(ylim = c(0, 2), expand = c(0,0))+
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        scale_fill_manual(name = "Causes of death", values = col5) +
        facet_geo(~ code, grid = mygrid, label = "name")+
        labs(x = NULL, y = NULL, title = title, 
             subtitle = sub_gg_five, caption = auth)+
        guides(fill = guide_legend(keywidth = 4, keyheight = 3, lineheight = .9))+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(
                panel.border = element_rect(color = 'black',
                                            size=.5, fill = NA),
                panel.spacing = unit(1, "lines"),
                legend.text = element_text(size = 18),
                legend.title = element_text(size = 24),
                legend.position = c(1,1),
                legend.justification = c(1,1),
                strip.text = element_text(face = 2),
                plot.title = element_text(size = 30),
                plot.subtitle = element_text(size = 24),
                plot.caption = element_text(size = 15),
                text = element_text(lineheight = .9),
                aspect.ratio = 1
        )


ggsave("figures/gg-five.png", gg_five, width = 16.5, height = 11.5)




# lexis surfaces with leading cause of death ------------------------------

# load the files for gg-nine
load("data/for-gg-nine.RData")

# geofaceting 9 causes
gg_nine <- df_nine %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = cause_name))+
        facet_geo(~ code, grid = mygrid, label = "name", move_axes = T) +
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                           labels = c(1990, 2000, "'10"))+
        scale_fill_manual("Causes of death", 
                          values = col9)+
        labs(x = NULL, y = NULL, title = title, 
             subtitle = sub_gg_nine, caption = auth)+
        guides(fill = guide_legend(keywidth = 4, keyheight = 3.5, ncol = 2))+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(
                panel.border = element_rect(color = 'black',
                                            size=.5, fill = NA),
                panel.spacing = unit(1, "lines"),
                legend.text = element_text(size = 18),
                legend.title = element_text(size = 24),
                legend.position = c(1,1),
                legend.justification = c(1,1),
                strip.text = element_text(face = 2),
                plot.title = element_text(size = 30),
                plot.subtitle = element_text(size = 24),
                plot.caption = element_text(size = 15),
                text = element_text(lineheight = .9),
                aspect.ratio = 1
        )


ggsave("figures/gg-nine.png", gg_nine, width = 16.5, height = 11.5)



# for fig 4 export 2 states

gg_nine_two <- df_nine %>% 
        filter(code %in% c(9, 20)) %>% 
        left_join(mygrid, "code") %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = hex))+
        facet_wrap(~ name, ncol = 2) +
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        # scale_fill_manual("Causes of death", 
        #                   values = col9)+
        scale_fill_identity("Causes of death")+
        labs(x = NULL, y = NULL)+
        guides(fill = guide_legend(keywidth = 4, keyheight = 3, ncol = 2))+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(
                panel.border = element_rect(color = 'black',
                                            size=.5, fill = NA),
                panel.spacing = unit(1, "lines"),
                legend.text = element_text(size = 18),
                legend.title = element_text(size = 24),
                legend.position = "left",
                legend.justification = c(1,1),
                strip.text = element_text(face = 2),
                plot.title = element_text(size = 30),
                plot.subtitle = element_text(size = 24),
                plot.caption = element_text(size = 15),
                text = element_text(lineheight = .9),
                aspect.ratio = 1
        )

ggsave(plot = gg_nine_two, "figures/ink-fig-4/gg-nine-two.pdf",  
       width =  3, height = 2, device = cairo_pdf)


# colorcoded --------------------------------------------------------------


# load the files for gg-three
load("data/for-gg-tern.RData")

# geofaceting 10 causes
gg_tern <- df_tern %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = color))+
        facet_geo(~ code, grid = mygrid, label = "name", move_axes = T) +
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        scale_fill_identity()+
        labs(x = NULL, y = NULL, title = title, 
             subtitle = sub_gg_tern, caption = auth)+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(legend.position = "none",
              panel.border = element_blank(),
              panel.grid = element_blank(),
              panel.spacing = unit(1, "lines"),
              strip.text = element_text(face = 2),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24),
              plot.caption = element_text(size = 15))


# 2019-02-10 decided to assamble manually for publication quiality
ggsave("figures/gg-tern.png", gg_tern, width = 16.5, height = 11.5)

ggsave("figures/gg-tern-legend.png", tern_legend, width = 4.5, height = 3.8)


# for fig 4 export 2 states

gg_tern_two <- df_tern %>% 
        filter(code %in% c(9, 20)) %>% 
        left_join(mygrid, "code") %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = color))+
        facet_wrap(~ name, ncol = 2) +
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        scale_fill_identity()+
        labs(x = NULL, y = NULL)+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(legend.position = "none",
              panel.border = element_blank(),
              panel.grid = element_blank(),
              panel.spacing = unit(1, "lines"),
              strip.text = element_text(face = 2),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24),
              plot.caption = element_text(size = 15),
              aspect.ratio = 1)


ggsave(plot = gg_tern_two, "figures/ink-fig-4/gg-tern-two.pdf",  
       width =  3, height = 2, device = cairo_pdf)




# save PDF for poster -----------------------------------------------------

ggsave(plot = gg_five, "figures/gg-five.pdf",  width = 16.5, height = 11.5, device = cairo_pdf)
ggsave(plot = gg_nine, "figures/gg-nine.pdf",  width = 16.5, height = 11.5, device = cairo_pdf)
ggsave(plot = gg_tern, "figures/gg-tern.pdf",  width = 16.5, height = 11.5, device = cairo_pdf)
ggsave(plot = tern_legend, "figures/gg-tern-legend.pdf",  width = 4.5, height = 3.8, device = cairo_pdf)

