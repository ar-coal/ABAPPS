*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZGLOBAL_ITEMS...................................*
DATA:  BEGIN OF STATUS_ZGLOBAL_ITEMS                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGLOBAL_ITEMS                 .
CONTROLS: TCTRL_ZGLOBAL_ITEMS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZGLOBAL_ITEMS                 .
TABLES: ZGLOBAL_ITEMS                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
