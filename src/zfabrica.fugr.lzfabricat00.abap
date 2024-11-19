*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZFABRICA........................................*
DATA:  BEGIN OF STATUS_ZFABRICA                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZFABRICA                      .
CONTROLS: TCTRL_ZFABRICA
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZFABRICA                      .
TABLES: ZFABRICA                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
