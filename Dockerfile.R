FROM rocker/r-ver:4.5.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages
RUN R -e "install.packages(c('ggplot2', 'dplyr', 'data.table'))"

# Set the working directory
WORKDIR /app

# Copy the R scripts into the container
COPY . /app
