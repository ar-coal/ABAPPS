*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZORDER_ITEM.....................................*
DATA:  BEGIN OF STATUS_ZORDER_ITEM                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZORDER_ITEM                   .
CONTROLS: TCTRL_ZORDER_ITEM
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZORDER_ITEM                   .
TABLES: ZORDER_ITEM                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
