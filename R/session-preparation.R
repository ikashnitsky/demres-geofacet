################################################################################
#                                                    
# Demographic Research 2018-06-03
# Geofacet example: Premature male mortality (15-49), Mexican states, 1990-2015
# R session preparation
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jose Manuel Aburto, jmaburto@health.sdu.dk 
#                                                  
################################################################################


# install pacman to streamline further package installation
if (!require("pacman", character.only = TRUE)){
        install.packages("pacman", dep = TRUE)
        if (!require("pacman", character.only = TRUE))
                stop("Package not found")
}


# these are the required packages
pkgs <- c(
        "tidyverse", 
        "janitor",
        "ggtern",
        "geofacet",
        "lubridate",
        "magrittr",
        "extrafont",
        "hrbrthemes",
        "tricolore",
        "RColorBrewer"
)


# install the missing packages
# only runs if at least one package is missing
if(!sum(!p_isinstalled(pkgs))==0){
        p_install(
                package = pkgs[!p_isinstalled(pkgs)], 
                character.only = TRUE
        )
}

# load the packages
p_load(pkgs, character.only = TRUE)


# get Roboto Consensed font -- called later as font_rc
import_roboto_condensed()