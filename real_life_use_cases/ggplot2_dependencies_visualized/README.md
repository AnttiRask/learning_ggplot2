![](../../ggplot2_2nd_ed/img/youcanbeapirate-wb-sparkline.jpg)

# Number of Packages on CRAN depending on, importing, or suggesting {ggplot2}

__Georgios Karamanis__ shared their recent __Tidy Tuesday__ visualization on [LinkedIn](https://www.linkedin.com/posts/georgios-karamanis-a54926153_tidytuesday-rstats-dataviz-activity-7111680233430224896-EdtA/).

Here's a link to the [GitHub repo](https://github.com/gkaramanis/tidytuesday/tree/master/2023/2023-week_38).

The thing is, Georgios' original graph shows the years for the LATEST release of the ggplot2-related packages on CRAN. While that is an interesting question, I've been trying to find out a good data source for another question: what are the years for the initial releases of those packages. That question led me down a rabbit hole and I eventually found __{pkgsearch}__.

So what I did was take Georgios' original code (with their blessing) and

1. change the data source (using __{pkgsearch}__)
2. use __{purrr}__ to easily get all the ggplot2-related packages' metadata
3. bring in a third type/category
4. make the stream chart less 'wavy'
5. change the color scheme
6. change the fonts to _Roboto Mono_ (using __{showtext}__)
7. annotate all the major __{ggplot2}__ releases
8. other, smaller changes

I'm thankful to Georgios for their support and continuing inspiration. If you're interested in data visualization, they are one of the people to follow. Just follow those links I listed earlier.

One more thing, this visualization is part of the background work I'm doing for my upcoming book about ggplot2 extension packages called _'ggplot2 extended'_ (working title). If you are interested in seeing how that project advances, you can start by following me on LinkedIn. I'm also happy to have conversations about the different ggplot2 extensions, if you have strong opinions and/or knowledge about them. So, don't hesitate to DM me on LinkedIn! Do mention it's about ggplot2 and the response rate will be significantly higher...
