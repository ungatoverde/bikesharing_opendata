
# Load population data to get city names
population_data <-
  read.csv(file = "background_data/Población 2010_INE.csv",
           fileEncoding = "UTF-8",
           sep = ",",
           skip = 1)

provinces_cities <-
  population_data %>%
  dplyr::select(1:4)%>%
  setNames(., c("province_number", "province_name", "city_number", "city_name"))

# Regions (e.g. comunidades autónomas)
regions <-
  read.csv(file = "background_data/communities.csv",
           fileEncoding = "UTF-8",
           sep = ",")%>%
  setNames(., c("region_number", "region_name", "province_number", "province_name"))

# Join regions with provinces and cities
geo_dictionary <- 
  dplyr::left_join(regions, 
                   provinces_cities,
                   by = c("province_number", "province_name"))

# Export geo_dictionary
write.csv(geo_dictionary, 
          file = "background_data/own_output/geo_dictionary.csv")
