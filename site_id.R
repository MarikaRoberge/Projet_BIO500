#create unique ID

library(dplyr)

creation_site_id <- function(df)
{
  site_id <- as.data.frame(seq(1:nrow(df)))
  df_site <- cbind(df, site_id)
  colnames(df_site)[ncol(df_site)] <- "site_id"
  return(df_site)
}



