# ## 6.5 Raster maps
# 
# There was a problem with the {bomrang} package and it has been archived. So, the example code for the 3rd
# edition doesn't work as it is.
# 
# I opened an issue about it (https://github.com/hadley/ggplot2-book/issues/338#issuecomment-1422203499) and Adam H. Sparks, the creator (you can correct me if I'm wrong) of the {bomrang} package was kind enough to
# provide a function that does what the get_available_imagery() function did in the original example.
# 
# ```{r}
# library(curl)
# library(tidyverse)
# 
# get_available_imagery <- function(product_id = "all") {
#     
#     ftp_base <- "ftp://ftp.bom.gov.au/anon/gen/gms/"
#     
#     .ftp_images <- function(product_id, bom_server) {
#         
#         list_files <- new_handle()
#         
#         handle_setopt(
#             handle         = list_files,
#             CONNECTTIMEOUT = 60L,
#             TIMEOUT        = 120L,
#             ftp_use_epsv   = TRUE,
#             dirlistonly    = TRUE
#         )
#         
#         # get file list from FTP server
#         con <- curl(
#             url    = ftp_base,
#             open   = "r",
#             handle = list_files
#         )
#         
#         tif_files <- readLines(con)
#         
#         close(con)
#         
#         # filter only the GeoTIFF files
#         tif_files <- tif_files %>%
#             as_tibble() %>%
#             filter(str_detect(value, "^.*\\.tif")) %>%
#             pull()
#         
#         # check if the Product ID requested provides any files on the server
#         if (length(tif_files) == 0 | tif_files[1] == ftp_base) {
#             stop(
#                 str_c(
#                     "\nSorry, no files are currently available for ",
#                     product_id
#                 )
#             )
#         }
#         return(tif_files)
#     }
#     
#     tif_list <- .ftp_images(product_id, bom_server = ftp_base)
#     
#     write_lines(tif_list, file = file.path(tempdir(), "tif_list"))
#     
#     cat("\nThe following files are currently available for download:\n")
#     
#     print(tif_list)
#     
# }
# ```
# 
# 
# ```{r}
# library(lubridate)
# 
# yesterday_10pm <-
#     as.character(floor_date(now() - ddays(1), "day") + dhours(22)) %>% 
#     str_replace_all("-", "") %>% 
#     str_replace_all(":", "") %>% 
#     str_replace_all(" ", "") %>%
#     str_sub(1, 12)
# 
# yesterday_10pm
# ```
# 
# ```{r}
# files <- get_available_imagery() %>% 
#     str_subset(yesterday_10pm)
# ```
# 
# ```{r}
# walk2(
#     .x = str_c("ftp://ftp.bom.gov.au/anon/gen/gms/", files),
#     .y = file.path("raster", files),
#     .f = ~ download.file(url = .x, destfile = .y)
# )
# ```
# 
# ```{r}
# dir("raster")
# ```
# 
# ```{r}
# img_vis <- file.path("raster", "IDE00420.202302122200.tif")
# img_inf <- file.path("raster", "IDE00421.202302122200.tif")
# ```
# 
# ```{r}
# library(stars)
# 
# sat_vis <- read_stars(
#     img_vis,
#     RasterIO = list(nBufXSize = 600, nBufYSize = 600),
#     proxy    = TRUE
# )
# 
# sat_inf <- read_stars(
#     img_inf,
#     RasterIO = list(nBufXSize = 600, nBufYSize = 600),
#     proxy    = TRUE
# )
# ```
# 
# ```{r}
# sat_vis
# ```
# 
# ```{r}
# ggplot() + 
#     geom_stars(data = sat_vis) + 
#     coord_equal()
# ```
# 
# ```{r}
# ggplot() + 
#     geom_stars(data = sat_vis, show.legend = FALSE) +
#     facet_wrap(vars(band)) + 
#     coord_equal() + 
#     scale_fill_gradient(low = "black", high = "white")
# ```
# 
# ```{r}
# oz_states <- st_transform(oz_states, crs = st_crs(sat_vis))
# ```
# 
# ```{r}
# ggplot() + 
#     geom_stars(data = sat_vis, show.legend = FALSE) +
#     geom_sf(data = oz_states, fill = NA, color = "white") + 
#     coord_sf() + 
#     theme_void() + 
#     scale_fill_gradient(low = "black", high = "white")
# ```
# 
# ```{r}
# cities <- oz_capitals %>% 
#     st_as_sf(coords = c("lon", "lat"), crs = 4326, remove = FALSE)
# ```
# 
# ```{r}
# cities <- st_transform(cities, st_crs(sat_vis))
# ```
# 
# ```{r}
# ggplot() + 
#     geom_stars(data = sat_vis, show.legend = FALSE) +
#     geom_sf(data = oz_states, fill = NA, color = "white") + 
#     geom_sf(data = cities, color = "red") + 
#     coord_sf() + 
#     theme_void() + 
#     scale_fill_gradient(low = "black", high = "white")
# ```
# 
# ```{r}
# geom_sf_text(data = cities, mapping = aes(label = city)) 
# ```
# 
# 
# 
# 
# 
# 
# 

library(tiff)

# Read in the large tif file
img <- read_tif("ggplot2_3rd_ed/raster/IDE00420.202302122200.tif")

# Convert the image to a matrix
img_matrix <- as.matrix(img[1])

# Convert the matrix to a data frame
img_df <- as.data.frame(img_matrix)

# Visualize the image using ggplot2
library(ggplot2)

ggplot(data = img_df, aes(x = 1:nrow(img_df), y = 1:ncol(img_df))) +
    geom_raster(aes(fill = value))