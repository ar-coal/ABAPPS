*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCLIENTE........................................*
DATA:  BEGIN OF STATUS_ZCLIENTE                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCLIENTE                      .
CONTROLS: TCTRL_ZCLIENTE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCLIENTE                      .
TABLES: ZCLIENTE                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
