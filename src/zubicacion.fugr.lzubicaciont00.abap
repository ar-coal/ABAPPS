*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZUBICACION......................................*
DATA:  BEGIN OF STATUS_ZUBICACION                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZUBICACION                    .
CONTROLS: TCTRL_ZUBICACION
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZUBICACION                    .
TABLES: ZUBICACION                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
