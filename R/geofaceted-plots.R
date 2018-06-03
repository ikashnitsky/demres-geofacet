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
p_unload(ggtern, tricolore)



# stacked bar plot --------------------------------------------------------

# load the files for gg-five
load("data/for-gg-five.RData")


gg_five <- df_five %>% 
        ggplot() +
        geom_col(aes(year, gap, fill = cause)) +
        coord_cartesian(ylim = c(0, 2), expand = c(0,0))+
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                         labels = c(1990, 2000, "'10"))+
        scale_fill_manual(name = "Causes of death\n", values = col5) +
        facet_geo(~ code, grid = "mx_state_grid1", label = "name")+
        labs(x = NULL, y = NULL, title = title, 
             subtitle = sub_gg_five, caption = auth)+
        guides(fill = guide_legend(keywidth = 4, keyheight = 3, lineheight = .9))+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(legend.position = c(1,1),
              panel.border = element_rect(color = 'black',
                                          size=.5, fill = NA),
              panel.spacing = unit(1, "lines"),
              legend.text = element_text(size = 18),
              legend.title = element_text(size = 24),
              legend.justification = c(1,1),
              strip.text = element_text(face = 2),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24),
              plot.caption = element_text(size = 15),
              text = element_text(lineheight = .9))


ggsave("figures/gg-five.png", gg_five, width = 16, height = 12)




# lexis surfaces with leading cause of death ------------------------------

# load the files for gg-nine
load("data/for-gg-nine.RData")

# geofaceting 9 causes
gg_nine <- df_nine %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = causename))+
        facet_geo(~ code, grid = "mx_state_grid1", label = "name", move_axes = T) +
        scale_x_discrete(breaks = c(1990, 2000, 2010),
                           labels = c(1990, 2000, "'10"))+
        scale_fill_manual("Causes of death\n", 
                          values = col9)+
        labs(x = NULL, y = NULL, title = title, 
             subtitle = sub_gg_nine, caption = auth)+
        guides(fill = guide_legend(keywidth = 4, keyheight = 3))+
        theme_minimal(base_size = 12, base_family = font_rc)+
        theme(legend.position = c(1,1),
              panel.border = element_rect(color = 'black',
                                          size=.5, fill = NA),
              panel.spacing = unit(1, "lines"),
              legend.key.size = unit(2, 'lines'),
              legend.text = element_text(size = 18),
              legend.title = element_text(size = 24),
              legend.justification = c(1, 1),
              strip.text = element_text(face = 2, size = 10),
              plot.title = element_text(size = 30),
              plot.subtitle = element_text(size = 24),
              plot.caption = element_text(size = 15))

ggsave("figures/gg-nine.png", gg_nine, width = 16, height = 12)





# colorcoed ----------------------------------------------------------------


# load the files for gg-three
load("data/for-gg-tern.RData")

# geofaceting 10 causes
gg_tern <- df_tern %>% 
        ggplot()+
        coord_cartesian(expand = c(0,0))+
        geom_raster(aes(year, age, fill = color))+
        # facet_wrap(~code)+
        facet_geo(~ code, grid = "mx_state_grid1", label = "name", move_axes = T) +
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


gg_tern_assamble <- ggplot()+
        geom_blank()+
        theme_void()+
        annotation_custom(ggplotGrob(gg_tern), 
                          xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf)+
        annotation_custom(ggplotGrob(tern_legend), 
                          xmin = .65, xmax = 1, ymin = .55, ymax = .975)


ggsave("figures/gg-tern.png", gg_tern_assamble, width = 16, height = 12)





