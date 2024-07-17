# Number of Packages on CRAN depending on, importing, or suggesting {ggplot2} #

# Inspiration ----

# Georgios Karamanis shared their recent Tidy Tuesday visualization on LinkedIn:
# https://www.linkedin.com/posts/georgios-karamanis-a54926153_tidytuesday-rstats-dataviz-activity-7111680233430224896-EdtA/

# Here's a link to the GitHub repo:
# https://github.com/gkaramanis/tidytuesday/tree/master/2023/2023-week_38

# The thing is, Georgios' original graph shows the years for the LATEST release of the ggplot2-related
# packages on CRAN. While that is an interesting question, I've been trying to find out a good data
# source for another question: what are the years for the initial releases of those packages. That
# question led me down a rabbit hole and I eventually found {pkgsearch}.

# So what I did was take Georgios' original code (with their blessing) and
# 1) change the data source (using {pkgsearch})
# 2) use {purrr} to easily get all the ggplot2-related packages' metadata
# 3) bring in a third type/category
# 4) make the stream chart less 'wavy'
# 5) change the color scheme
# 6) change the fonts to Roboto Mono (using {showtext})
# 7) annotate all the major ggplot2 releases
# 8) other, smaller changes

# I'm thankful to Georgios for their support and continuing inspiration. If you're interested in data
# visualization, they are one of the people to follow.

# One more thing, this visualization is part of the background work I'm doing for my upcoming book
# about ggplot2 extension packages called 'ggplot2 extended' (working title). If you are interested in
# seeing how that project advances, you can start by following me on LinkedIn. I'm also happy to have
# conversations about the different ggplot2 extensions, if you have strong opinions and/or knowledge
# about them. So, don't hesitate to DM me on LinkedIn! Do mention it's about ggplot2 and the response
# rate will be significantly higher...

# Packages ----
library(colorspace) # A Toolbox for Manipulating and Assessing Colors and Palettes
library(conflicted) # An Alternative Conflict Resolution Strategy
    conflicts_prefer(dplyr::filter)
library(ggrepel)    # Automatically Position Non-Overlapping Text Labels with 'ggplot2'
library(ggstream)   # Create Streamplots in 'ggplot2'
library(ggtext)     # Improved Text Rendering Support for 'ggplot2'
library(pkgsearch)  # Search and Query CRAN R Packages
library(showtext)   # Using Fonts More Easily in R Graphs
library(tidyverse)  # Easily Install and Load the 'Tidyverse'

# Data ----

## Vector of ggplot2 related packages ----
ggplot2_pkg_names <- pkg_search("ggplot2", size = 6000) %>%
    as_tibble() %>%
    arrange(package, .locale = "en") %>% # alphabetical order, ignore case
    filter(package != "irtplay") %>%     # irtplay was removed from CRAN and was causing an error
    pull(package)

ggplot2_pkg_names

## Fetch the package history information for the ggplot2 related packages ----

# Note: This might take a while!
ggplot2_history <- map_dfr(
    ggplot2_pkg_names, function(pkg) {
        cran_package_history(pkg) %>%
            as_tibble()
    }
)

ggplot2_history

## Fetch initial release dates for the packages ----
initial_release_dates <- ggplot2_history %>%
    summarize(
        initial_release_date = min(date) %>% as_date(),
        .by                  = Package
    ) %>%
    mutate(year = year(initial_release_date))

initial_release_dates

## Fetch dependencies for the latest version of the packages ----
ggplot2_dependencies <- ggplot2_history %>%
    
    # Have to unnest dependencies first. The nested column contains 'type', which is the type of
    # dependency (depends/enhances/imports/suggests) and 'package', which is the package towards
    # which there is that dependency. The confusing part is that we already have the column Package.
    # But we're only using package to filter in only the ones that mention ggplot2 as a dependency.
    
    unnest(dependencies) %>%
    filter(package == "ggplot2") %>%
    filter(
        date == max(date) %>% as_date(),
        .by  = Package
    ) %>%
    distinct(Package, type)

ggplot2_dependencies

## Create the final tibble ----
current_year <- Sys.Date() %>%
    year()

ggplot2_years_and_dependencies <- ggplot2_dependencies %>%
    inner_join(initial_release_dates) %>%
    count(year, type) %>%
    filter(
        
        # Get rid of this type, because there are only 4 packages of its kind
        type != "Enhances",
        
        # There are 32 packages that were released before 2007, which is possible
        # due to the fact that the dependency could have appeared after the initial
        # release. I decided to leave them out for the sake of clarity.
        between(year, 2007, current_year)
    )

ggplot2_years_and_dependencies

# Colors ----
color_1 <- "#F36523"
color_2 <- "#125184"
color_3 <- "#2E8B57"
colors  <- c(color_1, color_2, color_3)

# Annotation ----
annotation_numbers <- ggplot2_years_and_dependencies %>%
    summarize(n = sum(n), .by = type) %>%
    arrange(type) %>%
    mutate(y = c(290, 50, -245)) %>% 
    mutate(
        label = case_when(
            type == "Depends"  ~ str_glue("**<span style='color:{color_1}'>{n}</span>**"),
            type == "Imports"  ~ str_glue("**<span style='color:{color_2}'>{n}</span>**"),
            type == "Suggests" ~ str_glue("**<span style='color:{color_3}'>{n}</span>**")
        )
    )

annotation_numbers

# Fonts ----
font_add_google("Roboto Mono", "Roboto")
showtext_auto()
font_family <- "Roboto"

# Plot ----
ggplot2_years_and_dependencies %>%
    ggplot() +
    
    ## ggplot2 releases ----
geom_point(
    aes(x = 2007, y = 0),
    data = NULL,
    size  = 1.5,
    stat  = "unique",
) +  
    geom_label_repel(
        aes(x = 2007, y = 0, label = "{ggplot2}\nver 0.5"),
        data          = NULL,
        stat          = "unique",
        nudge_y       = 75,
        label.size    = NA,
        lineheight    = 0.9,
        family        = font_family
    ) +
    geom_label_repel(
        aes(x = 2014, y = 50, label = "{ggplot2}\nver 1.0"),
        data          = NULL,
        stat          = "unique",
        nudge_y       = 115,
        label.size    = NA,
        lineheight    = 0.9,
        family        = font_family
    ) +
    geom_label_repel(
        aes(x = 2015, y = 125, label = "{ggplot2}\nver 2.0"),
        data          = NULL,
        stat          = "unique",
        nudge_y       = 100,
        label.size    = NA,
        lineheight    = 0.9,
        family        = font_family
    ) +
    geom_label_repel(
        aes(x = 2018, y = 100, label = "{ggplot2}\nver 3.0"),
        data          = NULL,
        stat          = "unique",
        nudge_y       = 200,
        label.size    = NA,
        lineheight    = 0.9,
        family        = font_family
    ) +
    geom_label_repel(
        aes(x = 2024, y = 225, label = "{ggplot2}\nver 3.5"),
        data          = NULL,
        stat          = "unique",
        nudge_y       = 200,
        label.size    = NA,
        lineheight    = 0.9,
        family        = font_family
    ) +
    
    ## Stream ----
geom_stream(
    aes(
        x     = year,
        y     = n,
        fill  = type,
        color = after_scale(darken(fill))
    ),
    bw        = 1,
    linewidth = 0.1
) +
    
    ## Labels ----

# Text
geom_richtext(
    aes(
        x     = current_year + 0.1,
        y     = 350,
        label = "Total # of<br>packages<br>currently:"
    ),
    data       = NULL,
    stat       = "unique",
    hjust      = 0,
    lineheight = 0.9,
    label.size = NA,
    family     = font_family
) +
    
    # Numbers
    geom_richtext(
        data = annotation_numbers,
        aes(
            x     = current_year + 0.2,
            y     = y,
            label = label
        ),
        hjust      = 0,
        lineheight = 0.9,
        label.size = NA,
        size       = 5,
        family     = font_family
    ) +
    
    ## Scales ----
scale_x_continuous(
    breaks       = seq(2008, current_year, 4),
    minor_breaks = 2007:current_year
) +
    scale_fill_manual(
        values = colors
    ) +
    
    ## Coord ----
coord_cartesian(clip = "off") +
    
    ## Labels ----
labs(
    title    = str_glue("Number of packages on CRAN <span style='color:{color_1}'>depending on</span>, <span style='color:{color_2}'>importing</span>, or <span style='color:{color_3}'>suggesting</span> {{ggplot2}"),
    subtitle = "Aggregated by the initial package release years. Categories may change from one version to another and were taken from the latest versions.",
    caption  = "Data: CRAN via {pkgsearch} | Visualization: Antti Rask | Updated: 2024-07-18"
) +
    
    ## Theme ----
theme_minimal(base_family = font_family) +
    theme(
        axis.text.x = element_text(
            size   = 14,
            face   = "bold",
            margin = margin(10, 0, 0, 0)
        ),
        axis.text.y           = element_blank(),
        axis.title            = element_blank(),
        legend.position       = "none",
        panel.grid.major.y    = element_blank(),
        panel.grid.minor.y    = element_blank(),
        plot.margin           = margin(10, 50, 10, 10),
        plot.title            = element_markdown(
            face  = "bold",
            size  = 20,
            hjust = 0.5 
        ),
        plot.subtitle = element_text(
            hjust  = 0.5,
            margin = margin(0, 0, 20, 0)
        ),
        plot.caption = element_text(
            size   = 10,
            color  = darken("darkgrey", 0.4),
            hjust  = 0.5,
            margin = margin(20, 0, 0, 0)
        )
    )
