*----------------------------------------------------------------------*
***INCLUDE LZORDER_HEADERF01.
*----------------------------------------------------------------------*
FORM SET_CREATOR.
  ZORDER_HEADER-created_by = sy-uname.
  ZORDER_HEADER-created_on = sy-datum.
  ZORDER_HEADER-mandt = sy-mandt.
ENDFORM.

FORM DELETE_ADVICE.
   DATA: ls_fila TYPE zorder_header.
   ls_fila = zorder_header.

  MESSAGE 'Al eliminar la orden tambien eliminaras su registro en la tabla zorder_item' type 'I'.
  delete from zorder_item where order_no  = ls_fila-order_no.

ENDFORM.
