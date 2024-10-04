*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEMP_MASTER.....................................*
DATA:  BEGIN OF STATUS_ZEMP_MASTER                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEMP_MASTER                   .
CONTROLS: TCTRL_ZEMP_MASTER
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZEMP_MASTER                   .
TABLES: ZEMP_MASTER                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
