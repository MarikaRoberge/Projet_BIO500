formattage_dates <- function(df) {

    df$dwc_event_date <- as.Date(gsub("T.*", "", df$dwc_event_date)) #converti les char en type DATE pour dwc_event_date

    return(df)
  }