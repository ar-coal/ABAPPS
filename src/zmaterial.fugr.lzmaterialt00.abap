*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMATERIAL.......................................*
DATA:  BEGIN OF STATUS_ZMATERIAL                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMATERIAL                     .
CONTROLS: TCTRL_ZMATERIAL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZMATERIAL                     .
TABLES: ZMATERIAL                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
