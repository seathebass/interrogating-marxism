# interrogating-marxism
Github Repository for the Interrogating Marx(ism) Project. Interrogating Marx(ism) is a CUNY Graduate Center Digital Humanities project which applies text mining to a corpus of Marxist texts. To apply the text mining techniques to the corpus, we used a tidytext approach (Silge and Robinson, 2017) in order to analyze the corpus. The functions of each application follow as well as brief descriptions of the code in eachs.


## Context Search
The Context search app uses tidytext and tidyverse approaches to generate paragraphs or sentences containing a keyword. The app can be found at (https://marxism.shinyapps.io/marx-search/). Using R with tidytext mining as as well as a modification of str_view_all from the stringr package, the app generates HTML output whose output is then generated through the UI output function.
