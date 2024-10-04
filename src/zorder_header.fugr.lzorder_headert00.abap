*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZORDER_HEADER...................................*
DATA:  BEGIN OF STATUS_ZORDER_HEADER                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZORDER_HEADER                 .
CONTROLS: TCTRL_ZORDER_HEADER
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZORDER_HEADER                 .
TABLES: ZORDER_HEADER                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
