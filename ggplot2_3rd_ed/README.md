![](img/youcanbeapirate-wb-sparkline.jpg)

# Wickham, Hadley - ggplot2: Elegant Graphics for Data Analysis (3rd ed.)

I've tried to comment on the changes I've made to the code, but there are some frequent changes that I'll comment on here so I don't have to repeat myself constantly.

* In general, I've tried to use a __tibble__ (tbl) instead of a __data frame__ (df). So instead of _as.dataframe()_, you will usually find _tibble()_, but not always. There are some situations where only a data frame will work.
* There have been some changes to ggplot2 since 2016:
    * __fun.y__ parameter has become __fun__
    * __size__ has become __linewidth__ (for all geoms that use lines)