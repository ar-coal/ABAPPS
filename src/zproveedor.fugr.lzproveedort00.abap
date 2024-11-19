*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPROVEEDOR......................................*
DATA:  BEGIN OF STATUS_ZPROVEEDOR                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPROVEEDOR                    .
CONTROLS: TCTRL_ZPROVEEDOR
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPROVEEDOR                    .
TABLES: ZPROVEEDOR                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
