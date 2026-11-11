#install.packages("tidyverse")
#install.packages("ggplot2")

library(dplyr)
library(ggplot2)
library(patchwork)

##################### MISSING DATA PER SITE ###################### 

miss_site_stats <- function(df){
  nsnps <- nrow(df)
  nsnps_pct5 <- sum(df$F_MISS > 0.05)
  nsnps_pct10 <- sum(df$F_MISS > 0.10)
  nsnps_pct25 <- sum(df$F_MISS > 0.25)

  mean_miss <- mean(df$F_MISS)
  median_miss <- median(df$F_MISS)
  
  plot <- ggplot(df, aes(x=F_MISS)) +
    geom_density(fill = "dodgerblue1", color="black", alpha=0.3) +
    geom_vline(xintercept = mean_miss, color="Red") +
    geom_vline(xintercept = median_miss, color = "Green") +
    labs(y="Density", x="% missing data",
         title = "Missing data per site",
         subtitle=paste0(nsnps, " SNPs\n",
                         nsnps_pct5," > 5% of missing data\n",
                         nsnps_pct10," > 10% of missing data\n",
                         nsnps_pct25," > 25% of missing data")) +
    theme_bw() +
    theme(panel.grid = element_blank(),
          plot.title = element_text(size=10),
          plot.subtitle = element_text(size = 7))
  
  plot
  
}


##################### MISSING DATA PER SAMPLE ###################### 

miss_sample_stats <- function(df){
  nsamples <- nrow(df)
  samples_pct5 <- sum(df$F_MISS > 0.05)
  samples_pct10 <- sum(df$F_MISS > 0.1)
  samples_pct25 <- sum(df$F_MISS > 0.25)
  
  plot <- ggplot(df, aes(F_MISS)) +
    geom_histogram(bins = 20,fill="dodgerblue1", color="black", alpha=0.3) +
    labs(x="% of missing data",
         y= "N Samples",
         title = "Missing data per sample",
         subtitle = paste0(nsamples," samples\n",
                           samples_pct5," samples with > 5% of missing data\n",
                           samples_pct10," samples with > 10% of missing data\n",
                           samples_pct25," samples with > 25% of missing data")) +
    theme_bw() +
    theme(panel.grid = element_blank(), 
          plot.title = element_text(size=10),
          plot.subtitle = element_text(size=7))
  plot
  
}


##################### ALLELE FREQUENCY DISTRIBUTION ###################### 

allele_freq_dist <- function(df){
  nsnps <- nrow(df)
  maf10 <- sum(df$MAF >= 0.1, na.rm = T)
  maf05 <- sum(df$MAF >= 0.05, na.rm = T)
  maf01 <- sum(df$MAF >= 0.01, na.rm = T)
  
  plot <- ggplot(df, aes(MAF)) +
    geom_density(fill="dodgerblue1", color="black", alpha=0.3) +
    labs(x="MAF",
         y="Density",
         title ="MAF density",
         subtitle = paste0(nsnps," Biallelic SNPs\n",
                           paste0(maf10," SNPS with MAF ", "\u2265 10%\n"),
                           paste0(maf05," SNPS with MAF ", "\u2265 5%\n"),
                           paste0(maf01," SNPS with MAF ", "\u2265 1%\n")))+
    scale_x_continuous(limits = c(0,0.5)) +
    theme_bw() +
    theme(panel.grid = element_blank(),
          plot.title = element_text(size=10),
          plot.subtitle = element_text(size=7))
  plot
  
}


##################### DEPTH BY SITE ###################### 

depth_site <- function(df){
  nsnps <- nrow(df)
  nsnps_dp5 <- sum(df$MEAN_DEPTH >= 5,na.rm=T)
  nsnps_dp15 <- sum(df$MEAN_DEPTH >= 15,na.rm=T)
  nsnps_dp30 <- sum(df$MEAN_DEPTH >= 30,na.rm=T)
  
  plot <- ggplot(df, aes(x=MEAN_DEPTH)) +
    geom_density(fill = "dodgerblue1", color="black", alpha=0.3) +
    theme_bw()+
    theme(panel.grid = element_blank(), plot.subtitle = element_text(size=7)) +
    labs(y="Density", x="Average depth by site",
         title = "Average depth by site",
         subtitle = paste0(nsnps," SNPs\n",
                           paste0(nsnps_dp5," SNPS with average depth ", "\u2265 5X\n"),
                           paste0(nsnps_dp15," SNPS with average depth ", "\u2265 15X\n"),
                           paste0(nsnps_dp30," SNPS with average depth ", "\u2265 30X"))) +
    coord_cartesian(xlim = c(0,100))
  ## the plot will only show a range from 0 to 100 depth
  plot
  
}


###################### DEPTH PER SAMPLE ###################### 

depth_sample <- function(df){
  nind <- nrow(df)
  ind_dp5 <- sum(df$MEAN_DEPTH >= 5,na.rm=T)
  ind_dp10 <- sum(df$MEAN_DEPTH >= 10,na.rm=T)
  ind_dp15 <- sum(df$MEAN_DEPTH >= 15,na.rm=T)
  max_x <- max(df$MEAN_DEPTH,na.rm=T)
  
  plot <- ggplot(df, aes(MEAN_DEPTH)) +
    geom_histogram(fill="dodgerblue1", color = "black", alpha=0.3, bins = 20) +
    scale_x_continuous(breaks = seq(0,max_x,10)) +
    labs(x="Depth",
         y="Number of samples",
         title = "Depth per Sample",
         subtitle=paste0(nind, " samples\n",
                         paste0(ind_dp5," samples with depth ", "\u2265 5X\n"),
                         paste0(ind_dp10," samples with depth ", "\u2265 10X\n"),
                         paste0(ind_dp15," samples with depth ", "\u2265 15X"))) +
    theme_bw() +
    theme(panel.grid = element_blank(),plot.subtitle = element_text(size = 7))
  
  plot
  
}


###################### QUALITY PER SITE ###################### 

qual_site <- function(df){
  
  minq <- min(df$QUAL) 
  
  plot <- ggplot(df, aes(x=QUAL)) +
    geom_density(fill="dodgerblue1", color="black", alpha=0.3) +
    coord_cartesian(xlim = c(0,10000)) +
    labs(y="Density", x="Quality",
         title = "Quality per site",
         subtitle = paste0("Min quality ",minq)) +
    theme_bw() +
    theme(panel.grid = element_blank(), plot.subtitle = element_text(size = 7))
  
  plot
  
}





