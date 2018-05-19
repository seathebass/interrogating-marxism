# interrogating-marxism
Github Repository for the Interrogating Marx(ism) Project. Interrogating Marx(ism) is a CUNY Graduate Center Digital Humanities project which applies text mining to a corpus of Marxist texts. To apply the text mining techniques to the corpus, we used a tidytext approach (Silge and Robinson, 2017) in order to analyze the corpus. The functions of each application follow as well as brief descriptions of the code in eachs.

## Context Search:
The Context search app uses tidytext and tidyverse approaches to generate paragraphs or sentences containing a keyword. The app can be found at (https://marxism.shinyapps.io/marx-search/). Using R with tidytext mining as as well as a modification of str_view_all from the stringr package, the app generates HTML output whose output is then generated through the UI output function.

## Correlation Network:
The Correlation Network is a Shiny app which uses a slider to allow a user to filter the level of correlations between the term frequencies between different texts. Using the networkD3 package. The app first reads in the results of a pairwise text correlation  which have been transformed into a format readable into networkd3. Afterwards, the results are filtered in to be readable with the network D3 package.

## Alluvial app:
The alluvial application allows users to visualize potential similarities in topics across different works within the corpus. This app reads in the results of a Latent Dirichlet Allocation and uses them with the ggalluvial extension from ggplot2. Doing so allows the app to avoid running the model every time a user clicks the action button. This allows the app to focus on the plotting of different topic models for the different works rather than wait for the LDA to generate results. 
