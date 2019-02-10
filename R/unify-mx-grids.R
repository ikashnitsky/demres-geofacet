#===============================================================================
# 2019-02-09 -- geofacet Mexico
# Unify Mexico grid codes
# Ilya Kashnitsky, ilya.kashnitsky@gmail.com
#===============================================================================



# grid 1 -- ikashnitsky ---------------------------------------------------

mx1 <- tibble::tribble(
               ~"row", ~"col",   ~"code",                   ~"name",
                    4,      5, "AGS",      "Aguascalientes",
                    1,      1, "BCN",     "Baja California",
                    2,      1, "BCS", "Baja California Sur",
                    3,      5, "CDZ",            "Coahuila",
                    2,      3, "CHH",           "Chihuahua",
                    7,     10, "CHP",             "Chiapas",
                    6,     11, "CMP",            "Campeche",
                    6,      4, "COL",              "Colima",
                    3,      4, "DRN",             "Durango",
                    6,      7, "DTD",    "Distrito Federal",
                    5,      5, "GNJ",          "Guanajuato",
                    7,      7, "GRR",            "Guerrero",
                    5,      7, "HDL",             "Hidalgo",
                    5,      4, "JLS",             "Jalisco",
                    6,      5, "MDO",           "Michoacan",
                    6,      6, "MEX",              "Mexico",
                    6,      8, "MRL",             "Morelos",
                    3,      6, "NLE",          "Nuevo Leon",
                    4,      4, "NYR",             "Nayarit",
                    7,      8, "OAX",              "Oaxaca",
                    6,      9, "PUE",              "Puebla",
                    5,      6, "QDA",           "Queretaro",
                    7,     12, "QRO",        "Quintana Roo",
                    3,      3, "SIN",             "Sinaloa",
                    4,      7, "SLP",     "San Luis Potosi",
                    1,      2, "SON",              "Sonora",
                    7,     11, "TBS",             "Tabasco",
                    5,      8, "TLX",            "Tlaxcala",
                    3,      7, "TML",          "Tamaulipas",
                    7,      9, "VLL",            "Veracruz",
                    6,     12, "YCT",             "Yucatan",
                    4,      6, "ZCT",           "Zacatecas"
               )



# grid 2 -- diegovalle ----------------------------------------------------

mx2 <- tibble::tribble(
        ~"code",                   ~"name",                      ~"name_official", ~"name_abbr", ~"name_abbr_iso", ~"name_abbr_official", ~"col", ~"row",
              2,     "Baja California",                 "Baja California",     "BC",        "BCN",              "BC",      1,      1,
              8,           "Chihuahua",                       "Chihuahua",   "CHIH",        "CHH",           "Chih.",      3,      1,
             26,              "Sonora",                          "Sonora",    "SON",        "SON",            "Son.",      2,      1,
              3, "Baja California Sur",             "Baja California Sur",    "BCS",        "BCS",             "BCS",      1,      2,
              5,            "Coahuila",            "Coahuila de Zaragoza",   "COAH",        "COA",           "Coah.",      4,      2,
             10,             "Durango",                         "Durango",    "DGO",        "DUR",            "Dgo.",      3,      2,
             19,          "Nuevo León",                      "Nuevo León",     "NL",        "NLE",              "NL",      5,      2,
             25,             "Sinaloa",                         "Sinaloa",    "SIN",        "SIN",            "Sin.",      2,      2,
             28,          "Tamaulipas",                      "Tamaulipas",    "TAM",        "TAM",          "Tamps.",      6,      2,
              1,      "Aguascalientes",                  "Aguascalientes",    "AGS",        "AGU",            "Ags.",      5,      3,
             18,             "Nayarit",                         "Nayarit",    "NAY",        "NAY",            "Nay.",      3,      3,
             24,     "San Luis Potosí",                 "San Luis Potosí",    "SLP",        "SLP",             "SLP",      6,      3,
             32,           "Zacatecas",                       "Zacatecas",    "ZAC",        "ZAC",            "Zac.",      4,      3,
             11,          "Guanajuato",                      "Guanajuato",    "GTO",        "GUA",            "Gto.",      4,      4,
             13,             "Hidalgo",                         "Hidalgo",    "HGO",        "HID",            "Hgo.",      6,      4,
             14,             "Jalisco",                         "Jalisco",    "JAL",        "JAL",            "Jal.",      3,      4,
             22,           "Querétaro",                       "Querétaro",    "QRO",        "QUE",            "Qro.",      5,      4,
             30,            "Veracruz", "Veracruz de Ignacio de la Llave",    "VER",        "VER",            "Ver.",      7,      4,
              6,              "Colima",                          "Colima",    "COL",        "COL",            "Col.",      4,      5,
             15,              "México",                          "México",    "MEX",        "MEX",            "Mex.",      5,      5,
             29,            "Tlaxcala",                        "Tlaxcala",   "TLAX",        "TLA",           "Tlax.",      6,      5,
              9,    "Ciudad de México",                "Ciudad de México",   "CDMX",        "CMX",            "CDMX",      5,      6,
             17,             "Morelos",                         "Morelos",    "MOR",        "MOR",            "Mor.",      4,      6,
             21,              "Puebla",                          "Puebla",    "PUE",        "PUE",            "Pue.",      6,      6,
             31,             "Yucatán",                         "Yucatán",    "YUC",        "YUC",            "Yuc.",      9,      6,
              4,            "Campeche",                        "Campeche",   "CAMP",        "CAM",           "Camp.",      8,      7,
             12,            "Guerrero",                        "Guerrero",    "GRO",        "GRO",            "Gro.",      5,      7,
             16,           "Michoacán",             "Michoacán de Ocampo",   "MICH",        "MIC",           "Mich.",      4,      7,
             20,              "Oaxaca",                          "Oaxaca",    "OAX",        "OAX",            "Oax.",      6,      7,
             23,        "Quintana Roo",                    "Quintana Roo",   "QROO",        "ROO",          "Q. Roo",      9,      7,
             27,             "Tabasco",                         "Tabasco",    "TAB",        "TAB",            "Tab.",      7,      7,
              7,             "Chiapas",                         "Chiapas",   "CHPS",        "CHP",           "Chis.",      7,      8
        )



# grid 3 -- fazepher -------------------------------------------------------

mx3 <- tibble::tribble(
                          ~"row", ~"col",    ~"code",                   ~"name", ~"code_edo",
                               1,      1,   "BC",     "Baja California",    "02",
                               1,      2,  "SON",              "Sonora",    "26",
                               1,      3, "CHIH",           "Chihuahua",    "08",
                               1,      4, "COAH",            "Coahuila",    "05",
                               1,      5,   "NL",          "Nuevo León",    "19",
                               1,      6,  "TAM",          "Tamaulipas",    "28",
                               2,      1,  "BCS", "Baja California Sur",    "03",
                               2,      3,  "SIN",             "Sinaloa",    "25",
                               2,      4,  "DGO",             "Durango",    "10",
                               2,      5,  "ZAC",           "Zacatecas",    "32",
                               2,      6,  "SLP",     "San Luis Potosí",    "24",
                               3,      4,  "NAY",             "Nayarit",    "18",
                               3,      5,  "AGS",      "Aguascalientes",    "01",
                               3,      6,  "GTO",          "Guanajuato",    "11",
                               3,      7,  "HGO",             "Hidalgo",    "13",
                               4,      4,  "COL",              "Colima",    "06",
                               4,      5,  "JAL",             "Jalisco",    "14",
                               4,      6,  "QRO",           "Querétaro",    "22",
                               4,      7, "CDMX",    "Ciudad de México",    "09",
                               4,      8,  "PUE",              "Puebla",    "21",
                               4,     11,  "YUC",             "Yucatan",    "31",
                               4,     12, "QROO",        "Quintana Roo",    "23",
                               5,      5, "MICH",           "Michoacán",    "16",
                               5,      6,  "MEX",    "Estado de México",    "15",
                               5,      7,  "MOR",             "Morelos",    "17",
                               5,      8, "TLAX",            "Tlaxcala",    "29",
                               5,      9,  "VER",            "Veracruz",    "30",
                               5,     10,  "TAB",             "Tabasco",    "27",
                               5,     11, "CAMP",            "Campeche",    "04",
                               6,      7,  "GRO",            "Guerrero",    "12",
                               6,      8,  "OAX",              "Oaxaca",    "20",
                               6,      9, "CHPS",             "Chiapas",    "07"
                          )



# update grid3 with codes -------------------------------------------------

mx3upd <- mx3 %>% 
        transmute(row, col,
                  code = code_edo %>% as.numeric()
        ) %>% 
        left_join(
                mx2 %>% 
                        transmute(
                                code, name, name_official,
                                abbr_iso = name_abbr_iso,
                                abbr = name_abbr,
                                abbr_official = name_abbr_official
                        ),
                by = "code"
        )


save(mx3upd, file = "data/mx_state_grid3_update.rda")
