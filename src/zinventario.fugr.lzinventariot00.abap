*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZINVENTARIO.....................................*
DATA:  BEGIN OF STATUS_ZINVENTARIO                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZINVENTARIO                   .
CONTROLS: TCTRL_ZINVENTARIO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZINVENTARIO                   .
TABLES: ZINVENTARIO                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
