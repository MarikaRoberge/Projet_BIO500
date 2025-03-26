formatage_date <- function(df) {

    df$dwc_event_date <- as.Date(gsub("T.*", "", df$dwc_event_date)) #converti les char en type DATE pour dwc_event_date

    return(df)
}

#Dans ce script, serait-il possible de formater différemment la colonne dwc_event_date car 
#elle semble distorde l'information et retourner la donnée en nombre négatif...