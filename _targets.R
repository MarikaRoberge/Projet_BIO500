library(targets)
list(Brute <- grosse_tab("lepidopteres"), tar_target(name = data_no_na, 
    command = clean_na(Brute)), tar_target(name = data_colonne_correction, 
    command = type_colonne(data_no_na)), tar_target(name = data_uniform_dec, 
    command = uniformisation_decimales(data_no_na)), tar_target(name = data_brute_ULTIME, 
    command = verif(data_uniform_dec)), tar_target(name = tab_prim_sans_id, 
    command = tab_primaire(data_brute_ULTIME)), tar_target(name = tab_prim, 
    command = create_unique_id(tab_prim_sans_id)), tar_target(name = tab_site, 
    command = create_site_table(tab_prim_vide, data_brute_ULTIME)), 
    tar_target(name = tab_date, command = create_table_date(tab_prim, 
        data_brute_ULTIME)))
