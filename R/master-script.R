################################################################################
#
# Demographic Research 2018-06-03
# Geofacet example: Premature male mortality (15-49), Mexican states, 1990-2015
# MASTER SCRIPT
#
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
# Jose Manuel Aburto, jmaburto@health.sdu.dk 
#
################################################################################


# This is a master script that calls other scripts one-by-one to replicate all 
# the figures discussed in the paper. 

# Step 0. Prepare the R session
source("R/session-preparation.R")

# Step 1. Data preparation
source("R/data-preparation.R")

# Step 3. Draw the figures
source("R/geofaceted-plots.R")

# Find the plots in "figures" sub-directory.
# Feel free to explore each script in detail, find them in "R" sub-directory.
