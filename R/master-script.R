################################################################################
#
# Demographic Research 2019-07-31
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
# Feel free to explore "R/data-preparation.R"
# Ready dataset are shipped in "data"
# The reason for not replicating this step is buggy comminucation between
# {geofacet} and {tricolore}, to be fixed

# Step 2. Draw the figures
source("R/geofaceted-plots.R")

# Find the plots in "figures" sub-directory.
# Feel free to explore each script in detail, find them in "R" sub-directory.
