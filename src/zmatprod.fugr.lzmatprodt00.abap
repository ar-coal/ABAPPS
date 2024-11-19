*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZMATPROD........................................*
DATA:  BEGIN OF STATUS_ZMATPROD                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMATPROD                      .
CONTROLS: TCTRL_ZMATPROD
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZMATPROD                      .
TABLES: ZMATPROD                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
