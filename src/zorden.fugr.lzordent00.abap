*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZORDEN..........................................*
DATA:  BEGIN OF STATUS_ZORDEN                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZORDEN                        .
CONTROLS: TCTRL_ZORDEN
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZORDEN                        .
TABLES: ZORDEN                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
