FROM rocker/r-ver:4.5.1

# Install R packages
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'data.table'))"

# Set the working directory
WORKDIR /app

# Copy the R scripts into the container
COPY . /app
