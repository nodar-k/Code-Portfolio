###Meta-Analysis on PrEP Acceptability
###August 14, 2022
##Nodar Kipshidze, MPH
##Not for public distribution

library(tidyverse)
library(meta)

PREP_DATA = read.csv("PREP_YES.csv", header=TRUE);    ##Read dataset into R
PREP_DATA$PREP_YES_PROP = PREP_DATA$PREP_YES/PREP_DATA$SAMPLE_SIZE    #Calculating the proportion of prep yes for each study
PREP_DATA$PREP_KNOW_YES_PROP = PREP_DATA$PREP_KNOWLEDGE_YES/PREP_DATA$SAMPLE_SIZE    #Calculating the proportion of prep yes for each study


#CALCULATE 95% CI for each study, using normal approximation
PREP_DATA$PREP_PROP_95_L = (PREP_DATA$PREP_PROP - 1.96*(sqrt(PREP_DATA$PREP_PROP*(1-PREP_DATA$PREP_PROP)/PREP_DATA$SAMPLE_SIZE)))
PREP_DATA$PREP_PROP_95_U = (PREP_DATA$PREP_PROP + 1.96*(sqrt(PREP_DATA$PREP_PROP*(1-PREP_DATA$PREP_PROP)/PREP_DATA$SAMPLE_SIZE)))

#Calculte SE
PREP_DATA$PREP_YES_PROP_SE = (sqrt(PREP_DATA$PREP_YES_PROP*(1-PREP_DATA$PREP_YES_PROP)/PREP_DATA$SAMPLE_SIZE))
PREP_DATA$PREP_KNOW_YES_PROP_SE = (sqrt(PREP_DATA$PREP_KNOW_YES_PROP*(1-PREP_DATA$PREP_KNOW_YES_PROP)/PREP_DATA$SAMPLE_SIZE))

#Create subset of data and filter out the missing values
meta_PREP_KNOW_f = PREP_DATA %>% 
  filter(PREP_KNOW_YES_PROP != "NA");

meta_PREP_YES_f = PREP_DATA %>% 
  filter(PREP_YES_PROP != "NA");

meta_PREP_YES = metagen(TE = PREP_YES_PROP, seTE = PREP_YES_PROP_SE, studlab = AUTHORS, data=meta_PREP_YES_f)
meta_PREP_KNOW = metagen(TE = PREP_KNOW_YES_PROP, seTE = PREP_KNOW_YES_PROP_SE, studlab = AUTHORS, data=meta_PREP_KNOW_f)

summary(meta_PREP_YES)
summary(meta_PREP_KNOW)

#FIGURES
png(file = "forestplot_YES_PREP.png", width = 2400, height = 1200, res = 300)

forest.meta(meta_PREP_YES, sortvar = TE, col.study="Navy blue", col.square="Navy blue", xlim = c(0.00, 1.00), 
            just.addcols="l", colgap.left="0.5 cm",
            leftcols = c("studlab", "YEAR", "SAMPLE_SIZE", "effect", "ci"),
            leftlabs = c("Author", "Year", "N", "(%)", "95% CI"),
            rightcols = FALSE,
            xlab = "Proportion (%) willing to take PrEP"
)

dev.off()

png(file = "forestplot_KNOW_PREP.png", width = 2400, height = 1000, res = 300)

forest.meta(meta_PREP_KNOW, sortvar = TE, col.study="Navy blue", col.square="Navy blue", xlim = c(0.00, 1.00), 
            just.addcols="l", colgap.left="0.5 cm",
            leftcols = c("studlab", "YEAR", "SAMPLE_SIZE", "effect", "ci"),
            leftlabs = c("Author", "Year", "N", "(%)", "95% CI"),
            rightcols = FALSE,
            xlab = "Proportion (%) know about PrEP"
)

dev.off()


png(file = "funnel_KNOW_PREP.png", width = 2800, height = 2400, res = 300)

funnel.meta(meta_PREP_KNOW,
            xlim = c(-0.5, 2),
            studlab = TRUE)

dev.off()


png(file = "funnel_YES_PREP.png", width = 2800, height = 2400, res = 300)

funnel.meta(meta_PREP_YES,
            xlim = c(-0.5, 2),
            studlab = TRUE)

dev.off()
