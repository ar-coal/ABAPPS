*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDIVISAS........................................*
DATA:  BEGIN OF STATUS_ZDIVISAS                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDIVISAS                      .
CONTROLS: TCTRL_ZDIVISAS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDIVISAS                      .
TABLES: ZDIVISAS                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
