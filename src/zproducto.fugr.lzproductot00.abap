*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPRODUCTO.......................................*
DATA:  BEGIN OF STATUS_ZPRODUCTO                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPRODUCTO                     .
CONTROLS: TCTRL_ZPRODUCTO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPRODUCTO                     .
TABLES: ZPRODUCTO                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
