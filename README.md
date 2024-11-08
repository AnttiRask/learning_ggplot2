![](ggplot2_2nd_ed/img/youcanbeapirate-wb-sparkline.jpg)

# Learning ggplot2

I'm learning __{ggplot2}__ by reading the book __ggplot2: Elegant Graphics for Data Analysis__ by __Hadley Wickham__.

I've read both the physical copy of the 2nd edition (published in 2016) and the [online version](https://ggplot2-book.org/) of the 3rd edition.

The idea of this repo is to collect the code for both versions of the book. There are sections that the two books share, but because the structures are different, I've included the same code for each version. While I understand that it isn't ideal, I'm willing to make the sacrifice. So that you don't have to jump from one version to another to follow if you're looking at the code, no matter which version of the book you're reading.

So why even have my own version of the code for something that is already available through that link I shared?

1. The 2nd edition has chapters that aren't included in the 3rd. While I understand the reasoning for leaving them out, I still found them useful. But they are from 2016 and some of the code is either deprecated or superseded ([the tidyverse lifecycle stages](https://lifecycle.r-lib.org/articles/stages.html)). And I wanted to see if I could update the code so that it still works.
2. While __{ggplot2}__ is part of the [__{tidyverse}__](https://www.tidyverse.org/), not all the code is written using the best that {tidyverse} has to offer. I've translated some of the base R code to a tidier format and have also paid a lot of attention to readability.
3. Part of what makes {ggplot2} great is the vast number of 3rd party [extensions](https://exts.ggplot2.tidyverse.org/) like the ones on this list (to give a few examples). I've tried to include some code for the ones that weren't featured in the book.
    * {cowplot}
    * {gganimate}
    * {ggdist}
    * {ggthemes}
    * {patchwork}

## Disclaimer!
This repo is not meant to replace the book in any way. You should definitely read the book (or even both versions). It will help you understand {ggplot2} and data visualization in general much better than looking at the code or playing with it.

Also, I would recommend you buy the book and support the R open-source community by doing so. Here's a direct [link](https://link.springer.com/book/10.1007/978-3-319-24277-4) to __Springer__'s (the publisher) website.
