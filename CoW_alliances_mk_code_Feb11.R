#R script for creating alliance networks from Correlates of War alliance data

#set working directory

#setwd('C:/Users/mgolitko/Documents/RData/CoW')

# initialize necessary libraries

library(network)
library(NetComp)
library(sna)
library(statnet.common)
library(igraph)
library(scales)
library(plyr)
library(reshape)
library(tidyverse)
library(ggplot2)
library(GGally)
library(RColorBrewer)

#input CoW alliance data, relabel alliance partner headings, create single binarized alliance measure

CoWal=read.csv(file='./CoWal.csv', header=T)
CoWal=na.omit(CoWal)
CoWal$weight=CoWal$defense+CoWal$neutrality+CoWal$nonaggression+CoWal$entente 
colnames(CoWal)[colnames(CoWal)=="state_name1"]="from" 
colnames(CoWal)[colnames(CoWal)=="state_name2"]="to"


#want to find a way to use the graph.data.frame on each year
#below will get igraph for each year.
#but i loose the year variable

CoWal <- CoWal %>% mutate(year2 = year) #backup year. probably don't need
nested <- CoWal %>% group_by(year) %>% nest() #create a nested dataframe of CoWal data. first group by year and then nest the rest of the data (get a list of lists)
new <- nested$data %>% map(~select(.x, c(to, from, weight, year2))) #select only the data we need
gdf <- map(new, graph.data.frame) #gdf

###make a network plot to see if it is working...
gdf[[1]] %>% plot(layout=layout.fruchterman.reingold, main="1816")
#or
gdf1816 <- gdf[[1]]
gdf1816 %>%plot(layout=layout.fruchterman.reingold, main="1816")

#####adding names to the gdf list to make it easier to work with
#####need to compare to original code to make sure it is the same
a <- c(1816:2012) #assuming we have every year from 1816-2012
names(gdf) <- a
#gdf[["1816"]] %>% plot(layout=layout.fruchterman.reingold, main="1816")
#gdf[["2008"]] %>% edge_density(loops=F)
#gdf[["1913"]] %>% transitivity(type ="global", isolates = "zero")


#ok, so now i want to add some info to each list?


#map(gdf, edge_density, loops =F)
#map(gdf, transitivity, type="global", isolates = "zero")
#map(gdf, average.path.length, directed = T, unconnected =T )
#map(gdf, centr_eigen, directed=T, scale=T, normalized=T)


#save the calcs we need
a <- map(gdf, edge_density, loops =F)
b <- map(gdf, transitivity, type="global", isolates = "zero")
c <- map(gdf, average.path.length, directed = T, unconnected =T )
d <- map(gdf, centr_eigen, directed=T, scale=T, normalized=T )
d1 <- map_chr(d, 4) #this gets just the centralization cal from the centr_eigen function 

#make them into a dataframe and rename
Netmeasures1=as.data.frame(cbind(a,b,c,d1))
Netmeasures1 <- Netmeasures1 %>% as.tibble() %>% rename("edge_density" = "a", "transitivity" = "b", "average_path_length" = "c", "eigenvector_centrality" = "d1"  )


#to do
#1. make plots?